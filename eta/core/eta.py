import argparse
from importlib import import_module

from multiprocessing import Process
from multiprocessing import Lock
from multiprocessing import Value
from multiprocessing.managers import BaseManager

from eta.constants import IO_PATH, DEFAULT_START
from eta.util.general import gentemp, clear_symtab, remove_duplicates, append
import eta.util.file as file
import eta.util.time as time
import eta.util.buffer as buffer
from eta.lf import Eventuality
from eta.discourse import Utterance, DialogueTurn
from eta.memory import MemoryStorage
from eta.schema import from_lisp_dirs
from eta.plan import init_plan_from_eventualities
# import eta.core.execution as execution
# import eta.core.perception as perception
# import eta.core.planning as planning
# import eta.core.reasoning as reasoning
from eta.core.perception import perception_loop
from eta.core.reasoning import reasoning_loop


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
    self.output_count = 0
    self.output_buffer = []
    self.step_failure_timer = time.now()
    self.quit_conversation = False

    self.schemas = from_lisp_dirs(config_agent['schema_dirs'])
    self.concept_aliases = None # TODO
    self.concept_sets = None # TODO
    self.init_knowledge = None # TODO

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
    self.timegraph = self._make_timegraph()
    self.transducers = self.config_agent.pop('transducers')

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
  
  def set_output_count(self, c):
    with self._lock:
      self.output_count = c

  def set_output_buffer(self, buf):
    with self._lock:
      self.output_buffer = buf

  def push_output_buffer(self, x):
    with self._lock:
      self.output_buffer.append(x)

  def set_step_failure_timer(self, t):
    with self._lock:
      self.step_failure_timer = t

  def get_quit_conversation(self):
    with self._lock:
      return self.quit_conversation

  def set_quit_conversation(self, quit):
    with self._lock:
      self.quit_conversation = quit

  # === schema accessors ===

  # TODO

  # === plan accessors ===

  def has_plan(self):
    with self._lock:
      return self.plan is not None
    
  def do_continue(self):
    """Check whether to continue with the current dialogue."""
    return self.has_plan() and not self.get_quit_conversation()
  
  def advance_plan(self):
    """Advances the plan to the next step, or signals to quit the conversation if none exists."""
    with self._lock:
      if self.has_plan() and self.plan.next:
        self.plan = self.plan.next
      else:
        self.quit_conversation = True
    
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
    
  # === buffer accessors ===

  def add_to_buffer(self, fact, type):
    with self._lock:
      buffer.enqueue(fact, self.buffers[type])

  def add_all_to_buffer(self, facts, type):
    with self._lock:
      buffer.enqueue_ordered(facts, self.buffers[type])

  def get_buffer(self, type):
    with self._lock:
      return buffer.iterate(self.buffers[type])
    
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

  def add_to_context(self, fact):
    with self._lock:
      self.memory.instantiate(fact)

  def add_all_to_context(self, facts):
    [self.add_to_context(fact) for fact in facts]

  def get_memory(self):
    with self._lock:
      return self.memory

  # === timegraph accessors ===

  # TODO

  # === transducer accessors ===
    
  def apply_transducer(self, type, *args):
    with self._lock:
      if isinstance(self.transducers[type], list):
        return remove_duplicates(append([t(*args) for t in self.transducers[type]]), order=True)
      else:
        return self.transducers[type](*args)
    
  # === other ===

  def bind(self, var, val):
    """Bind a variable throughout the current dialogue state."""
    with self._lock:
      if self.plan:
        self.plan.bind(var, val)
      return self
    
  def unbind(self, var):
    """Unbinds a variable throughout the current dialogue state."""
    with self._lock:
      if self.plan:
        self.plan.unbind(var)
      return self

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
    output = ' '.join([utt.words for utt in self.output_buffer])
    affects = [utt.affect for utt in self.output_buffer if utt.affect != 'neutral']
    affect = affects[0] if affects else 'neutral'
    affect = 'neutral'
    file.write_file(self.get_io_path('turn-output.txt'), output)
    file.write_file(self.get_io_path('turn-affect.txt'), affect)
    self.output_buffer = []
  
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
    file.ensure_file_exists(self.get_io_path('output.txt'))
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

    perception.start()
    reasoning.start()

    perception.join()
    reasoning.join()

    # Write any remaining output
    ds.write_output_buffer()

    print(ds.get_memory())

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