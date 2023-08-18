import argparse
from importlib import import_module

from multiprocessing import Process
from multiprocessing import Lock
from multiprocessing.managers import BaseManager

from eta.constants import IO_PATH, DEFAULT_START
from eta.util.general import gentemp, clear_symtab, remove_duplicates, remove_nil, append, variablep, episode_name
import eta.util.file as file
import eta.util.time as time
import eta.util.buffer as buffer
from eta.lf import equal_prop_p, not_prop_p, and_prop_p, or_prop_p, characterizes_prop_p, expectation_p
from eta.lf import from_lisp_dirs as eventualities_from_lisp_dirs
from eta.memory import MemoryStorage
from eta.schema import from_lisp_dirs as schema_from_lisp_dirs
from eta.plan import init_plan_from_eventualities

from eta.core.perception import perception_loop
from eta.core.reasoning import reasoning_loop
from eta.core.planning import planning_loop
from eta.core.execution import execution_loop


class DialogueState():
  def __init__(self, config_agent, config_user):
    self._lock = Lock()

    # === session variables ===
    self.id = gentemp('SESSION')
    self.config_agent = config_agent
    self.config_user = config_user
    self.start_schema = config_agent['start_schema'] if 'start_schema' in config_agent else DEFAULT_START
    self.io_path = IO_PATH + config_agent['avatar'] + '/' + config_user['user_id'] + '/'
    self.me = config_agent['avatar_name']
    self.you = config_user['user_name']
    self.output_buffer = []
    self.step_failure_timer = time.now()
    self.quit_conversation = False

    self.schemas = schema_from_lisp_dirs(config_agent['schema_dirs'])
    self.concept_aliases = None # TODO
    self.concept_sets = None # TODO
    self.init_knowledge = []
    if 'knowledge_dirs' in config_agent:
      self.init_knowledge = eventualities_from_lisp_dirs(config_agent['knowledge_dirs'])

    # === dialogue variables ===
    if not self.start_schema in self.schemas['dial-schema']:
      raise Exception('Start schema for session not found.')
    self.schema_instances = {}
    self.plan = self.init_plan_from_schema(self.start_schema)
    self.buffers = self._make_buffers()
    self.reference_list = []
    self.equality_sets = {}
    self.conversation_log = []
    self.memory = MemoryStorage()
    self.add_to_memory(self.init_knowledge)
    self.timegraph = self._make_timegraph()
    self.transducers = self.config_agent.pop('transducers')
    self.embedder = self.config_agent.pop('embedder')

    self._create_session_io_files()
  
  # === session accessors ===

  def get_io_path(self, fname=''):
    return self.io_path + fname
  
  def get_perception_servers(self):
    return self.config_agent['perception_servers']
  
  def get_specialist_servers(self):
    return self.config_agent['specialist_servers']
  
  def get_user_id(self):
    return self.config_user['id']

  def get_use_embeddings(self):
    return self.config_user['use_embeddings']

  def set_output_buffer(self, buf):
    with self._lock:
      self.output_buffer = buf

  def push_output_buffer(self, x):
    with self._lock:
      self.output_buffer.append(x)

  def get_step_failure_timer(self):
    with self._lock:
      return self.step_failure_timer

  def reset_step_failure_timer(self):
    with self._lock:
      self.step_failure_timer = time.now()

  def get_quit_conversation(self):
    with self._lock:
      return self.quit_conversation

  def set_quit_conversation(self, quit):
    with self._lock:
      self.quit_conversation = quit

  # === schema accessors ===

  def is_schema(self, predicate):
    with self._lock:
      return all([predicate in dct for dct in self.schemas.values()])
    
  def is_dial_schema(self, predicate):
    with self._lock:
      return predicate in self.schemas['dial-schema']

  # === plan accessors ===

  def has_plan(self):
    with self._lock:
      return self.plan is not None
    
  def get_plan(self):
    with self._lock:
      return self.plan
    
  def set_plan(self, plan):
    if plan is None:
      return
    with self._lock:
      self.plan = plan
    
  def do_continue(self):
    """Check whether to continue with the current dialogue."""
    return self.has_plan() and not self.get_quit_conversation()
    
  def init_plan_from_schema(self, predicate, args=[]):
    """
    Given a schema predicate, find the schema corresponding to that predicate and instantiate
    that schema (replacing variables occurring in the header with the supplied args, if any),
    and then instantiate a plan structure from the episodes list of that schema. By default,
    we assume that the episodes of the schema define sequential steps.

    TODO: the plan structure created when instantiating a schema is currently
    "flat" - in the future, we might want to add support for annotating abstraction
    hierarchies in the schema, in which case these would be added as supersteps to
    the steps of the plan-nodes that are created.

    TODO: add support for using schema episode-relations when chaining together plan-nodes.

    TODO: add support for binding types in schema to objects in context / inferring facts
    from other schema sections based on context.
    """
    with self._lock:
      if predicate not in self.schemas['dial-schema']:
        raise Exception(f'Attempting to instantiate a dialogue schema, {predicate}, that does not exist.')
      schema = self.schemas['dial-schema'][predicate]
      if not schema.get_section('episodes'):
        raise Exception(f'Attempting to initialize a plan from a schema, {predicate}, that has no episodes.')

      schema_instance = schema.instantiate(args)
      self.schema_instances[schema_instance.id] = schema_instance
      
      return init_plan_from_eventualities(schema_instance.get_section('episodes'), schema=schema_instance)
    
  def advance_plan(self):
    """Advances the plan to the next step, or signals to quit the conversation if none exists."""
    with self._lock:
      if self.plan is not None and self.plan.next:
        self.plan = self.plan.next
      else:
        self.quit_conversation = True

  def instantiate_curr_step(self):
    """Instantiates the current plan step, binding it everywhere in the dialogue state.
       Also adds the fact to memory (only if not a top-level expectation)."""
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
    
  # === buffer accessors ===

  def add_to_buffer(self, x, type):
    if x is None:
      return
    with self._lock:
      buffer.enqueue(x, self.buffers[type])

  def add_to_buffer_if_empty(self, x, type):
    if x is None:
      return
    with self._lock:
      if buffer.is_empty(self.buffers[type]):
        buffer.enqueue(x, self.buffers[type])

  def add_all_to_buffer(self, xs, type):
    with self._lock:
      buffer.enqueue_ordered(xs, self.buffers[type])

  def replace_buffer(self, x, type):
    if x is None:
      return
    with self._lock:
      buffer.pop_all(self.buffers[type])
      buffer.enqueue(x, self.buffers[type])

  def replace_all_buffer(self, xs, type):
    with self._lock:
      buffer.pop_all(self.buffers[type])
      buffer.enqueue_ordered(xs, self.buffers[type])

  def get_buffer(self, type):
    with self._lock:
      return buffer.iterate(self.buffers[type])
    
  def buffer_empty(self, type):
    with self._lock:
      return buffer.is_empty(self.buffers[type])
    
  def pop_buffer(self, type):
    with self._lock:
      return buffer.pop_item(self.buffers[type])
    
  def pop_all_buffer(self, type):
    with self._lock:
      return buffer.pop_all(self.buffers[type])

  # === reference list accessors ===

  # TODO 

  # === equality set accessors ===

  # TODO 

  # === conversation log accessors ===

  def get_conversation_log(self):
    with self._lock:
      return self.conversation_log
    
  def log_turn(self, turn):
    with self._lock:
      self.conversation_log.append(turn)

  # === memory accessors ===

  def add_to_memory(self, fact):
    with self._lock:
      self.memory.store(fact)

  def add_to_context(self, fact):
    with self._lock:
      self.memory.instantiate(fact)

  def access_from_context(self, pred_patt):
    with self._lock:
      return self.memory.access_from_context(pred_patt)

  def get_memory(self):
    with self._lock:
      return self.memory
    
  def eval_truth_value(self, wff):
    """Evaluates the truth value of a WFF in memory/context."""
    with self._lock:
      def eval_truth_value_recur(wff):
        # (wff1 = wff2)
        if equal_prop_p(wff):
          return wff[0] == wff[2]
        # (not wff1)
        elif not_prop_p(wff):
          blarf = not eval_truth_value_recur(wff[1])
          return blarf
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

  # === timegraph accessors ===

  # TODO

  # === transducer accessors ===
    
  def apply_transducer(self, type, *args):
    with self._lock:
      if isinstance(self.transducers[type], list):
        return remove_nil(remove_duplicates(append([t(*args) for t in self.transducers[type]]), order=True))
      else:
        return self.transducers[type](*args)
    
  # === other ===

  def bind(self, var, val):
    """Bind a variable throughout the current dialogue state."""
    with self._lock:
      if self.plan:
        self.plan.bind(var, val)
    
  def unbind(self, var):
    """Unbinds a variable throughout the current dialogue state."""
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
  
  def write_output_buffer(self):
    """Writes the output buffer (a list of Utterances)"""
    with self._lock:
      if not self.output_buffer:
        return
      output = ' '.join([utt.words for utt in self.output_buffer])
      affects = [utt.affect for utt in self.output_buffer if utt.affect != 'neutral']
      affect = affects[0] if affects else 'neutral'
      affect = 'neutral'
      file.write_file(self.get_io_path('turn-output.txt'), output)
      file.write_file(self.get_io_path('turn-affect.txt'), affect)
      self.output_buffer = []

  def push_output_buffer(self, utt):
    """Pushes an utterance onto the output buffer"""
    with self._lock:
      self.output_buffer.append(utt)
  
  def print_schema_predicates(self, surface_english=False):
    """Prints all of the stored schema predicates."""
    for predicate in self.schemas.keys():
      if surface_english:
        print(predicate.split('.')[0].replace('-', ' ').lower())
      else:
        print(predicate)
  
  def print_schema_instances(self, no_bind=False):
    """Prints all schema instances."""
    for schema in self.schema_instances.values():
      print(schema.format(no_bind))

  # === helpers ===

  def _make_buffers(self):
    return {
      'observations' : [],
      # 'interpretations' : [],
      'inferences' : [],
      'actions' : [],
      'plans' : []
    }
  
  def _make_timegraph(self):
    return None
  
  def _create_session_io_files(self):
    file.ensure_dir_exists(self.get_io_path())
    file.ensure_dir_exists(self.get_io_path('in/'))
    file.ensure_dir_exists(self.get_io_path('out/'))
    file.ensure_dir_exists(self.get_io_path('conversation-log/'))
    for system in self.get_perception_servers()+self.get_specialist_servers():
      file.ensure_file_exists(self.get_io_path(f'in/{system}.txt'))
      file.ensure_file_exists(self.get_io_path(f'out/{system}.txt'))
    file.ensure_file_exists(self.get_io_path('conversation-log/text.txt'))
    file.ensure_file_exists(self.get_io_path('conversation-log/affect.txt'))
    file.ensure_file_exists(self.get_io_path('conversation-log/gist.txt'))
    file.ensure_file_exists(self.get_io_path('conversation-log/semantic.txt'))
    file.ensure_file_exists(self.get_io_path('conversation-log/pragmatic.txt'))
    file.ensure_file_exists(self.get_io_path('conversation-log/obligations.txt'))
    file.ensure_file_exists(self.get_io_path('turn-output.txt'))
    file.ensure_file_exists(self.get_io_path('turn-affect.txt'))
    

class ProcessManager(BaseManager):
  """Manager to handle multiprocessing"""
  pass


def eta(config_agent, config_user):

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
  clear_symtab()
  agent_config = import_module(f'eta.config.{agent_config_name}').config()
  user_config = file.load_json(f'user_config/{user_config_name}.json')
  eta(agent_config, user_config)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(
                    prog='eta',
                    description='Starts the Eta dialogue manager')
  parser.add_argument('--agent', type=str, default='lissa_gpt', help='The name of an agent config in eta.config')
  parser.add_argument('--user', type=str, default='test', help='The name of a user config in ./user_config/')
  args = parser.parse_args()
  main(args.agent, args.user)