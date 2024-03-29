"""The core executable for the Eta Dialogue Manager.

Running this module will read an agent and user config from eta.config and user_config,
respectively, before spawning the core multiprocess loops that handle interpretation, reasoning,
planning, and execution.

Note that the agent config is provided as a Python module that exports a 'config' function,
returning a dict of config parameters, since transducers and other objects may be created within
the config. On the other hand, the user config is supplied in JSON format.

Dialogue state is maintained entirely through a DialogueState class which is shared between each
core process using a ProcessManager, and using mutex locks to prevent data races on the underlying
dialogue state attributes.

Additionally, a set of buffers (i.e., priority queues) are used for the data being processed
over the dialogue session, which is necessary for:

  1. maintaining synchronicity between the processes in the relevant aspects (e.g., completing a
     series of modifications to the plan before attempting to execute a step).
  2. ensuring that transducers, which may incur some monetary cost to apply (e.g., in the case of
     GPT-based transduction), are only applied after a modification to the relevant data.
"""

import argparse
from importlib import import_module

from multiprocessing import Process
from multiprocessing import Lock
from multiprocessing.managers import BaseManager

from eta.constants import *
from eta.util.general import gentemp, clear_symtab, remove_duplicates, remove_nil, append, variablep, episode_name
import eta.util.file as file
import eta.util.time as time
import eta.util.buffer as buffer
from eta.lf import (equal_prop_p, not_prop_p, and_prop_p, or_prop_p, characterizes_prop_p, expectation_p,
                    from_lisp_dirs, list_to_s_expr)
from eta.discourse import get_prior_words
from eta.memory import MemoryStorage
from eta.schema import SchemaLibrary
from eta.plan import init_plan_from_eventualities

from eta.core.perception import perception_loop
from eta.core.reasoning import reasoning_loop
from eta.core.planning import planning_loop
from eta.core.execution import execution_loop


class DialogueState():
  """A representation of the current dialogue state.

  Parameters
  ----------
  config_agent : dict
    The config parameters for the agent.
  config_user : dict
    The config parameters for the user.

  Attributes
  ----------
  id : str
    A unique ID for this session.
  config_agent : dict
    The config parameters for the agent.
  config_user : dict
    The config parameters for the user.
  start_schema : str
    The schema predicate used to begin the dialogue session.
  start_time : TimePoint
    The starting time of this dialogue session.
  io_path : str
    The path used to read and write input/output for this session.
  me : str
    The name of the agent for this session.
  you : str
    The name of the user for this session.
  output_buffer : list[Utterance]
    A buffer of output utterances that are accumulated until the system is ready
    to write them and listen for user input.
  step_failure_timer : float
    A POSIX time record used to track time before failing an expected event.
  quit_conversation : bool
    Whether to quit the current session.
  transducers : dict[str, Transducer or list[Transducer]]
    A dict associating Transducer object(s) with named mapping functions (e.g., 'gist').
  embedder : Embedder
    An embedder object used to compute object embeddings and perform retrieval.
  schemas : SchemaLibrary
    A library of dialogue, episode, and object schemas that form the agent's generic knowledge.
  concept_aliases : None
    TODO
  concept_sets : None
    TODO
  init_knowledge : list[Eventuality]
    A list of initial facts in the agent's semantic memory.
  schema_instances : dict
    A dict containing all schema instances (keyed on their unique IDs).
  plan : PlanNode
    The "currently due" node in the agent's plan, initialized from the `start_schema`.
  buffers : dict[str, list]
    The named buffers (i.e., priority queues) for each type of processed data.
  reference_list : list
    TODO
  equality_sets : dict
    TODO
  conversation_log : list[DialogueTurn]
    A list of turns in the dialogue history.
  memory : MemoryStorage
    The episodic memory of the agent, initialized from `init_knowledge`.
  timegraph : None
    TODO
  """

  def __init__(self, config_agent, config_user):
    self._lock = Lock()

    # session variables
    self.id = gentemp('SESSION')
    self.config_agent = config_agent
    self.config_user = config_user
    self.start_schema = config_agent['start_schema'] if 'start_schema' in config_agent else DEFAULT_START
    self.start_time = time.TimePoint()
    self.io_path = IO_PATH + config_agent['agent'] + '/' + config_user['user_id'] + '/'
    self.log_path = LOG_PATH + self.start_time.format_date() + '/'
    self.me = config_agent['agent_name']
    self.you = config_user['user_name']
    self.output_buffer = []
    self.step_failure_timer = time.now()
    self.quit_conversation = False

    # internal mechanisms
    self.transducers = self.config_agent.pop('transducers')
    self.embedder = None
    if 'embedder' in config_agent:
      self.embedder = self.config_agent.pop('embedder')

    # static knowledge
    self.schemas = SchemaLibrary(self.embedder).from_lisp_dirs(config_agent['schema_dirs'])
    self.concept_aliases = None # TODO
    self.concept_sets = None # TODO
    self.init_knowledge = []
    if 'knowledge_dirs' in config_agent:
      self.init_knowledge = from_lisp_dirs(config_agent['knowledge_dirs'])

    # dialogue variables
    if not self.start_schema in self.schemas.dial:
      raise Exception('Start schema for session not found.')
    self.schema_instances = {}
    self.plan = self.init_plan_from_schema(self.start_schema)
    self.buffers = self._make_buffers()
    self.reference_list = []
    self.equality_sets = {}
    self.conversation_log = []
    importance_threshold = (config_agent['importance_threshold'] if 'importance_threshold' in config_agent 
                            else DEFAULT_IMPORTANCE_THRESHOLD)
    self.memory = MemoryStorage(self.embedder, importance_threshold=importance_threshold)
    self.add_to_memory(self.init_knowledge, importance=[1. for _ in self.init_knowledge])
    self.timegraph = self._make_timegraph()

    self._create_session_io_files()
    self._create_session_log_files()
  
  # -----------------
  # session functions
  # -----------------

  def get_io_path(self, fname=''):
    """Get the path for an IO file (if given) or the IO directory for this session."""
    return self.io_path + fname
  
  def get_log_path(self, fname=''):
    """Get the path for a log file (if given) or the log directory for this session."""
    return self.log_path + fname
  
  def get_perception_servers(self):
    """Get the registered perception servers for this session."""
    return self.config_agent['perception_servers']
  
  def get_specialist_servers(self):
    """Get the registered specialist servers for this session."""
    return self.config_agent['specialist_servers']
  
  def get_user_id(self):
    """Get the user ID for this session."""
    return self.config_user['id']

  def get_step_failure_timer(self):
    """Get the current value of the step failure timer."""
    with self._lock:
      return self.step_failure_timer

  def reset_step_failure_timer(self):
    """Reset the step failure timer to the current time."""
    with self._lock:
      self.step_failure_timer = time.now()

  def get_quit_conversation(self):
    """Check whether to quit the conversation."""
    with self._lock:
      return self.quit_conversation

  def set_quit_conversation(self, quit):
    """Set whether to quit the conversation."""
    with self._lock:
      self.quit_conversation = quit

  # ----------------
  # schema functions
  # ----------------

  def is_schema(self, predicate, type=None):
    """Check whether a given predicate exists in the agent's schema library."""
    with self._lock:
      return self.schemas.is_schema(predicate, type=type)

  # --------------
  # plan functions
  # --------------

  def has_plan(self):
    """Check whether the agent currently has a plan."""
    with self._lock:
      return self.plan is not None
    
  def get_plan(self):
    """Get the agent's plan."""
    with self._lock:
      return self.plan
    
  def set_plan(self, plan):
    """Set the agent's plan to a new plan node."""
    if plan is None:
      return
    with self._lock:
      self.plan = plan
    
  def do_continue(self):
    """Check whether to continue with the current dialogue."""
    return self.has_plan() and not self.get_quit_conversation()
    
  def init_plan_from_schema(self, predicate, args=[]):
    """Initialize a plan from a given schema predicate along with a list of arguments.
    
    This instantiates the generic schema as a schema instance, binding variables occurring in
    the header to the supplied arguments, if any. It then instantiates a plan structure from
    the episodes list of that schema.

    Notes
    -----
    TODO: the plan structure created when instantiating a schema is currently
    "flat" - in the future, we might want to add support for annotating abstraction
    hierarchies in the schema, in which case these would be added as supersteps to
    the steps of the plan-nodes that are created.

    TODO: by default, we assume that the episodes of the schema define sequential steps.
    However, the episode-relations in the schema should be used to impose a different
    ordering on the resulting plan.

    TODO: immediately following schema instantiation, we should also attempt to (a) bind
    variables in the schema occurring within the :types section to possible values in the
    dialogue context, as well as inferring the facts from the other schema sections, i.e.,
    adding them to the context.
    """
    with self._lock:
      if predicate not in self.schemas.dial:
        raise Exception(f'Attempting to instantiate a dialogue schema, {predicate}, that does not exist.')
      schema = self.schemas.dial[predicate]
      if not schema.get_section('episodes'):
        raise Exception(f'Attempting to initialize a plan from a schema, {predicate}, that has no episodes.')

      schema_instance = schema.instantiate(args)
      self.schema_instances[schema_instance.id] = schema_instance
      
      return init_plan_from_eventualities(schema_instance.get_section('episodes'), schema=schema_instance)
    
  def advance_plan(self):
    """Advance the plan to the next step (or signal to quit the conversation if none exists)."""
    with self._lock:
      if self.plan is not None and self.plan.next:
        self.plan = self.plan.next
      else:
        self.quit_conversation = True

  def instantiate_curr_step(self):
    """Instantiate the current plan step.

    This binds the episode variable for the current plan step with a newly created episode
    constant throughout the dialogue state. The event is also added to context, unless it is
    an expectation step, in which case it would have already been matched to an event in context.

    This process recurs for any superstep such that the current step "completes" that superstep.
    """
    def instantiate_step_recur(step):
      event = step.event
      ep_var = event.get_ep()
      if not variablep(ep_var):
        return []
      substeps = step.substeps

      # Only instantiate if no substeps, or all substeps have already been instantiated
      if all([not variablep(substep.event.get_ep()) for substep in substeps]):

        # If single substep, share same episode name
        if substeps and len(substeps) == 1:
          ep = substeps[0].event.get_ep()
          ep = episode_name() if variablep(ep) else ep
        else:
          ep = episode_name()

        event.bind(ep_var, ep)
        self.bind(ep_var, ep)
        if substeps or not expectation_p(event):
          self.add_to_context(event)

      # Recur for supersteps
      return [instantiate_step_recur(superstep) for superstep in step.supersteps]

    instantiate_step_recur(self.plan.step)
    return self.plan.step
    
  # ----------------
  # buffer functions
  # ----------------

  def add_to_buffer(self, x, type):
    """Add an element to the buffer of the given type."""
    if x is None:
      return
    with self._lock:
      buffer.enqueue(x, self.buffers[type])

  def add_to_buffer_if_empty(self, x, type):
    """Add an element to the buffer of the given type iff that buffer is currently empty."""
    if x is None:
      return
    with self._lock:
      if buffer.is_empty(self.buffers[type]):
        buffer.enqueue(x, self.buffers[type])

  def add_all_to_buffer(self, xs, type):
    """Add all elements in a list to the buffer of the given type."""
    with self._lock:
      buffer.enqueue_ordered(xs, self.buffers[type])

  def replace_buffer(self, x, type):
    """Replace the buffer of the given type with a single element."""
    if x is None:
      return
    with self._lock:
      buffer.pop_all(self.buffers[type])
      buffer.enqueue(x, self.buffers[type])

  def replace_all_buffer(self, xs, type):
    """Replace the buffer of the given type with a list of elements."""
    with self._lock:
      buffer.pop_all(self.buffers[type])
      buffer.enqueue_ordered(xs, self.buffers[type])

  def get_buffer(self, type):
    """Get the buffer of the given type."""
    with self._lock:
      return buffer.iterate(self.buffers[type])
    
  def buffer_empty(self, type):
    """Check whether the buffer of the given type is empty."""
    with self._lock:
      return buffer.is_empty(self.buffers[type])
    
  def pop_buffer(self, type):
    """Pop an element from the buffer of the given type."""
    with self._lock:
      return buffer.pop_item(self.buffers[type])
    
  def pop_all_buffer(self, type):
    """Pop all elements from the buffer of the given type."""
    with self._lock:
      return buffer.pop_all(self.buffers[type])

  # ------------------------
  # reference list functions
  # ------------------------

  # TODO 

  # ----------------------
  # equality set functions
  # ----------------------

  # TODO 

  # --------------------------
  # conversation log functions
  # --------------------------

  def get_conversation_log(self):
    """Get the current conversation history."""
    with self._lock:
      return self.conversation_log
    
  def log_turn(self, turn):
    """Log and write a given DialogueTurn in the conversation log."""
    with self._lock:
      self.conversation_log.append(turn)
      self._write_turn(turn)

  # ----------------
  # memory functions
  # ----------------

  def add_to_memory(self, fact, importance=DEFAULT_IMPORTANCE):
    """Add a fact to the memory."""
    with self._lock:
      self.memory.instantiate(fact, importance=importance, context=False)

  def add_to_context(self, fact, importance=DEFAULT_IMPORTANCE):
    """Add a fact to the context."""
    with self._lock:
      self.memory.instantiate(fact, importance=importance)

  def remove_from_context(self, fact):
    """Remove a fact from the context."""
    with self._lock:
      self.memory.remove_matching_from_context(fact)

  def access_from_context(self, pred_patt):
    """Access facts from context matching a given predicate pattern."""
    with self._lock:
      return self.memory.get_from_context(pred_patt, access=True)
    
  def flush_context(self):
    """Flush the dialogue context of "instantaneous" events."""
    with self._lock:
      self.memory.flush_context()

  def get_memory(self):
    """Get the memory storage object."""
    with self._lock:
      return self.memory
    
  def eval_truth_value(self, wff):
    """Evaluate the truth value of a wff in memory/context."""
    with self._lock:
      def eval_truth_value_recur(wff):
        # (wff1 = wff2)
        if equal_prop_p(wff):
          return wff[0] == wff[2]
        # (not wff1)
        elif not_prop_p(wff):
          return not eval_truth_value_recur(wff[1])
        # (wff1 and wff2)
        elif and_prop_p(wff):
          return eval_truth_value_recur(wff[0]) and eval_truth_value_recur(wff[2])
        # (wff1 or wff2)
        elif or_prop_p(wff):
          return eval_truth_value_recur(wff[0]) or eval_truth_value_recur(wff[2])
        # (wff1 ** e)
        elif characterizes_prop_p(wff):
          return self.memory.does_characterize_episode(wff[0], wff[2])
        # Otherwise, check to see if wff is true in context
        return True if self.memory.get_from_context(wff) else False
      return eval_truth_value_recur(wff)

  # -------------------
  # timegraph functions
  # -------------------

  # TODO

  # --------------------
  # transducer functions
  # --------------------
    
  def apply_transducer(self, type, *args):
    """Apply the transducer(s) of the given type to a list of arguments."""
    with self._lock:
      if type not in self.transducers:
        return []
      if isinstance(self.transducers[type], list):
        return remove_nil(remove_duplicates(append([t(*args) for t in self.transducers[type]]), order=True))
      else:
        return self.transducers[type](*args)
    
  # ---------------
  # other functions
  # ---------------

  def bind(self, var, val):
    """Bind the given variable symbol to the given value throughout the dialogue state."""
    with self._lock:
      if self.plan:
        self.plan.bind(var, val)
    
  def unbind(self, var):
    """Unbind the given variable symbol throughout the dialogue state."""
    with self._lock:
      if self.plan:
        self.plan.unbind(var)

  def cost(self):
    """Compute the accumulated (monetary) cost of each transducer for this session."""
    cost = 0.
    with self._lock:
      for t in self.transducers.values():
        if isinstance(t, list):
          cost += sum([t1.cost() for t1 in t])
        else:
          cost += t.cost()
    return cost
  
  def retrieve_facts(self, query=None, n_schema=1, n_schema_facts=3, n_memory=3):
    """Retrieve and combine facts from the current dialogue schema, relevant episode schemas, and memory.
    
    The facts are divided into two subsets for facts that are "backgrounded" and those that are "foregrounded",
    which may be leveraged by downstream tasks (e.g., in generation, we may assume that foregrounded facts should
    be used in the generated response in some way, whereas backgrounded facts may condition the generation without
    being directly used).

    Currently, it is assumed that background facts correspond to the current dialogue schema conditions, whereas
    foregrounded facts are retrieved from relevant episode schemas and memory.

    Parameters
    ----------
    query : str, optional
      The query string to use for retrieval. If not given, the previous user turn will be used.
    n_schema : int, default=1
      The number of schemas to retrieve.
    n_schema_facts : int, default=3
      The number of facts to use from the retrieved schemas (in addition to schema headers).
    n_memories : int, default=3
      The number of facts to use from memory.

    Returns
    -------
    facts_bg : list[Eventuality]
      The retrieved background facts.
    facts_fg : list[Eventuality]
      The retrieved foreground facts.
    """
    with self._lock:
      facts_bg = []
      facts_fg = []

      for sec in ['rigid-conds', 'static-conds', 'preconds', 'goals']:
        facts_bg += append([schema.get_section(sec) for schema in self.plan.get_schemas()])

      if not query:
        query = get_prior_words(self.conversation_log, YOU)

      facts_fg += self.schemas.retrieve_knowledge('epi', query=query, m=n_schema, n=n_schema_facts)
      facts_fg += [m.event for m in self.memory.retrieve(query=query, n=n_memory)]

      return facts_bg, facts_fg
  
  def write_output_buffer(self):
    """Write the output buffer (a list of Utterances) to output files."""
    with self._lock:
      if not self.output_buffer:
        return
      output = ' '.join([utt.words for utt in self.output_buffer])
      affects = [utt.affect for utt in self.output_buffer if utt.affect != 'neutral']
      affect = affects[0] if affects else 'neutral'
      file.write_file(self.get_io_path('turn-output.txt'), output)
      file.write_file(self.get_io_path('turn-affect.txt'), affect)
      self.output_buffer = []

  def push_output_buffer(self, utt):
    """Push an utterance onto the output buffer."""
    with self._lock:
      self.output_buffer.append(utt)
  
  def print_schema_instances(self, no_bind=False):
    """Print all current schema instances."""
    for schema in self.schema_instances.values():
      print(schema.format(no_bind))

  # ----------------
  # helper functions
  # ----------------

  def _make_buffers(self):
    return {
      'observations' : [],
      'inferences' : [],
      'actions' : [],
      'plans' : []
    }
  
  def _make_timegraph(self):
    return None
  
  def _create_session_io_files(self):
    file.ensure_dir_exists(self.get_io_path())
    file.ensure_dir_exists(self.get_io_path(IO_IN_DIR))
    file.ensure_dir_exists(self.get_io_path(IO_OUT_DIR))
    file.ensure_dir_exists(self.get_io_path(IO_CLOG_DIR))
    for system in self.get_perception_servers()+self.get_specialist_servers():
      file.ensure_file_exists(self.get_io_path(f'{IO_IN_DIR}{system}.txt'))
      file.ensure_file_exists(self.get_io_path(f'{IO_OUT_DIR}{system}.txt'))
    file.ensure_file_exists(self.get_io_path('turn-output.txt'))
    file.ensure_file_exists(self.get_io_path('turn-affect.txt'))
    for fname in CLOG_FILES:
      file.ensure_file_exists(self.get_io_path(f'{IO_CLOG_DIR}{fname}.txt'))

  def _create_session_log_files(self):
    file.ensure_dir_exists(self.get_log_path())
    for fname in CLOG_FILES:
      file.ensure_file_exists(self.get_log_path(f'{fname}.txt'))
    file.write_json(self.get_log_path('config-agent.json'), self.config_agent, pretty=True)
    file.write_json(self.get_log_path('config-user.json'), self.config_user, pretty=True)

  def _write_turn(self, turn):
    text = turn.utterance.words
    affect = turn.utterance.affect
    gist = " ".join(['"'+list_to_s_expr(t)+'"' for t in turn.gists]) if turn.gists else 'NIL'
    semantics = " ".join([list_to_s_expr(t) for t in turn.semantics]) if turn.semantics else 'NIL'
    pragmatics = " ".join([list_to_s_expr(t) for t in turn.pragmatics]) if turn.pragmatics else 'NIL'
    obligations = " ".join([list_to_s_expr(t) for t in turn.obligations]) if turn.obligations else 'NIL'
    plan_step = self.plan.step
    step = self.plan.step.format(schemas=True)
    outputs = {
      'text' : f'{turn.agent} : {text}\n',
      'affect' : f'{turn.agent} : {affect}\n',
      'gist' : f'{turn.agent} : {gist}\n',
      'semantic' : f'{turn.agent} : {semantics}\n',
      'pragmatic' : f'{pragmatics}\n',
      'obligations' : f'{obligations}\n',
      'step' : f'{step}\n'
    }
    for fname in CLOG_FILES:
      file.append_file(self.get_io_path(f'{IO_CLOG_DIR}{fname}.txt'), outputs[fname])
      file.append_file(self.get_log_path(f'{fname}.txt'), outputs[fname])
    

class ProcessManager(BaseManager):
  """Manager to handle multiprocessing."""
  pass


def eta(config_agent, config_user):
  """Initialize the dialogue state for a new session and spawn each core process.
  
  Parameters
  ----------
  config_agent : dict
    A dict of config parameters for the agent.
  config_user : dict
    A dict of config parameters for the user.
  """
  ProcessManager.register('DialogueState', DialogueState)

  with ProcessManager() as manager:
    ds = manager.DialogueState(config_agent, config_user)

    perception = Process(target=perception_loop, args=(ds,))
    reasoning = Process(target=reasoning_loop, args=(ds,))
    planning = Process(target=planning_loop, args=(ds,))
    execution = Process(target=execution_loop, args=(ds,))

    perception.start()
    reasoning.start()
    planning.start()
    execution.start()

    perception.join()
    reasoning.join()
    planning.join()
    execution.join()

    # Write any remaining output
    ds.write_output_buffer()

    print(ds.get_memory())
    print()
    print(ds.get_plan())

    print(f'total cost of session: ${ds.cost()}')


def main(agent_config_name, user_config_name):
  """Clear the symbol table, read the agent and user configs, and start Eta."""
  clear_symtab()
  agent_config = import_module(f'eta.config.{agent_config_name}').config()
  user_config = file.load_json(f'user_config/{user_config_name}.json')
  eta(agent_config, user_config)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(
                    prog='eta',
                    description='Starts the Eta dialogue manager')
  parser.add_argument('--agent', type=str, default='sophie_offline', help='The name of an agent config in eta.config')
  parser.add_argument('--user', type=str, default='test', help='The name of a user config in ./user_config/')
  args = parser.parse_args()
  main(args.agent, args.user)
