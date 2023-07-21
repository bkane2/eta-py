from multiprocessing import Process
from multiprocessing import Lock
from multiprocessing import Value
from multiprocessing.managers import BaseManager

from eta.util.general import *
import eta.util.time as time
import eta.util.buffer as buffer
from eta.lf import Fact
import eta.schema as schema
import eta.sessioninfo as sessioninfo
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
    self.io_path = sessioninfo.IO_PATH + config_agent['avatar'] + '/' + config_user['user_id'] + '/'
    self.me = config_agent['avatar_name']
    self.you = config_user['user_name']
    self.output_count = 0
    self.output_buffer = []
    self.step_failure_timer = time.now()
    self.quit_conversation = False

    # === TODO ===
    self.rules = None
    self.schemas = None
    self.concept_aliases = None
    self.concept_sets = None
    self.init_knowledge = None

    # === dialogue variables ===
    self.plan = [] # TODO: replace with plan struct
    self.schema_instances = {}
    self.plan_var_table = {}
    self.buffers = self._make_buffers()
    self.reference_list = []
    self.equality_sets = {}
    self.conversation_log = []
    self.memory = []
    self.context = []
    self.kb = []
    self.timegraph = self._make_timegraph()
    self.time = gentemp("NOW")
    self.count = 0
    self.rule_last_used = {}
  
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

  # === dialogue accessors ===

  def get_rule_last_used(self, rule_node):
    with self._lock:
      if rule_node not in self.rule_last_used:
        self.set_rule_last_used(rule_node, -10000)
      return self.rule_last_used[rule_node]
  
  def set_rule_last_used(self, rule_node, t):
    with self._lock:
      self.rule_last_used[rule_node] = t

  def has_plan():
    # (if *sessions* (ds-curr-plan (session-ds (car *sessions*))))
    pass

  def get_context(self):
    with self._lock:
      return self.context
    
  def add_to_context(self, fact):
    with self._lock:
      self.context.append(fact)

  def add_all_to_context(self, facts):
    [self.add_to_context(fact) for fact in facts]

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

  # === helpers ===

  def _make_buffers(self):
    return {
      'perceptions' : [],
      'gists' : [],
      'semantics' : [],
      'pragmatics' : [],
      'inferences' : [],
      'actions' : []
    }
  
  def _make_timegraph(self):
    return None
  

class ProcessManager(BaseManager):
  """Manager to handle multiprocessing"""
  pass


def eta():

  config_agent = {
    'avatar': 'lissa-gpt',
    'avatar_name': 'Lissa',
    'perception_servers': ['audio', 'world'],
    'specialist_servers': [],
    'emotion_tags': False,
    'model_names': {'information_retrieval': {'model': 'sentence-transformers/all-distilroberta-v1', 'api': True}},
    'session_number': 1
  }

  config_user = {
    'user_id': '_test',
    'user_name': 'John Doe',
    'start_schema': 'have-eta-dialog.v'
  }

  ProcessManager.register('DialogueState', DialogueState)

  with ProcessManager() as manager:
    ds = manager.DialogueState(config_agent, config_user)

    cost = Value('d', 0)

    perception = Process(target=perception_loop, args=(ds, cost))
    reasoning = Process(target=reasoning_loop, args=(ds, cost))

    perception.start()
    reasoning.start()

    perception.join()
    reasoning.join()

    for fact in ds.get_context():
      print(fact)

    with cost.get_lock():
      print(f'total cost of session: ${cost.value}')





def main():
  eta()


if __name__ == "__main__":
  main()