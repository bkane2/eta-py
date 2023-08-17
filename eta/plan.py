import graphviz
import math

from eta.util.general import gentemp, remove_duplicates, indent, cons, subst
from eta.lf import parse_eventuality
from eta.schema import DialSchema
from eta.constants import EXPECTED_STEP_FAILURE_PERIOD_COEFFICIENT

class PlanNode:
  """
  Defines a top-level node in Eta's plan (a doubly linked list).
  Each node has a plan step associated, which may be linked to other
  plan steps in a tree-like structure.
  """
  def __init__(self, step):
    self.step = step
    self.prev = None
    self.next = None

  def add_superstep_to_subplan(self, node):
    """
    Add the step of a given plan-node as a superstep of each node within the
    subplan headed by this node.
    """
    start = self
    while start.next:
      start.step.add_superstep(node.step)
      start = start.next
    start.step.add_superstep(node.step)

  def add_supersteps(self, start_node, end_node):
    """
    Given a sequence of plan nodes bounded between a given start and end node,
    add each plan node as a superstep of this node.
    """
    start = start_node
    while start.next and not start == end_node:
      self.step.add_superstep(start.step)
      start = start.next
    self.step.add_superstep(start.step)

  def add_schema_to_subplan(self, schema):
    """
    Adds the given schema-id to each plan-step in a subplan structure
    headed by this node.
    """
    start = self
    while start.next:
      start.step.schemas.append(schema)
      start = start.next
    start.step.schemas.append(schema)

  def get_all_roots(self):
    """Get all root plan-steps in a plan structure."""
    ret = []
    def recur1(node, left=False, right=False):
      recur2(node.step)
      if node.prev and left:
        recur1(node.prev, left=True, right=False)
      if node.next and right:
        recur1(node.next, left=False, right=True)
    def recur2(step):
      nonlocal ret
      if not step.supersteps:
        ret = cons(step, ret)
      for superstep in step.supersteps:
        recur2(superstep)
    recur1(self, left=True, right=True)
    return remove_duplicates(ret, order=True)
  
  def bind(self, var, val):
    """Recursively binds a variable throughout a plan structure."""
    def bind_rec(node, var, val, left, right):
      node.step.bind(var, val)
      if node.prev and left:
        bind_rec(node.prev, var, val, True, False)
      if node.next and right:
        bind_rec(node.next, var, val, False, True)
    bind_rec(self, var, val, True, True)
    return self
  
  def unbind(self, var):
    """Recursively unbinds a variable throughout a plan structure."""
    def unbind_rec(node, var, left, right):
      node.step.unbind(var)
      if node.prev and left:
        unbind_rec(node.prev, var, True, False)
      if node.next and right:
        unbind_rec(node.next, var, False, True)
    unbind_rec(self, var, True, True)
    return self
  
  def status(self, before=3, after=5, schemas=False):
    """
    Prints the current plan status (i.e., steps that are currently in
    the surface plan, with a pointer to the currently due step). Allows
    the number of steps to be shown before and after this pointer to be
    specified as key arguments.
    """
    ret = ''
    prev = self.prev
    next = self.next

    steps_prev = []
    step_curr = None
    steps_next = []
    while prev and (before > 0 or before < 0):
      steps_prev.append(prev.step.format(schemas))
      prev = prev.prev
      before -= 1
    step_curr = self.step.format(schemas)
    while next and (after > 0 or after < 0):
      steps_next.append(next.step.format(schemas))
      next = next.next
      after -= 1

    if prev:
      ret += '   ...\n'
    for step_prev in steps_prev[::-1]:
      ret += f'   {step_prev}\n'
    ret += f'>> {step_curr}\n'
    for step_next in steps_next:
      ret += f'   {step_next}\n'
    if next:
      ret += '   ...\n'
    return ret
  
  def serialize_subtree(self, schemas=False):
    """Prints the subtree of the plan structure reachable from the current node."""
    return self.step.serialize(schemas=schemas)
  
  def serialize_from_roots(self, schemas=False):
    """Prints the subtrees of the plan structure reachable from each root step."""
    return [root.serialize(reverse=True, schemas=schemas) for root in self.get_all_roots()]
  
  def to_graph(self, before=3, after=5, schemas=False):
    """Converts a (sub)plan (possibly bounded by some number of plan nodes before/after
       the current node) into a graph structure, i.e., a list of nodes and edges."""
    nodes = []
    edges = []
    visited = {}

    k = 1
    def subtree_rec(step, parent):
      nonlocal k
      if step in visited:
        edges.append((parent, visited[step]))
      else:
        label = f'S{k}'
        nodes.append((label, step.format(schemas)))
        edges.append((parent, label))
        visited[step] = label
        k += 1
        [subtree_rec(s, label) for s in step.supersteps]
      
    prev = self.prev
    i = -1
    while prev and (before > 0 or before < 0):
      nodes.append((f'N{i}', prev.step.format(schemas)))
      edges.append((f'N{i}', f'N{i+1}'))
      [subtree_rec(s, f'N{i}') for s in prev.step.supersteps]
      prev = prev.prev
      before -= 1
      i -= 1
    if prev:
      nodes.append(('N-inf', '...'))
      edges.append(('N-inf', f'N{i+1}'))
      
    nodes.append(('N0', self.step.format(schemas)))
    [subtree_rec(s, f'N0') for s in self.step.supersteps]

    next = self.next
    i = 1
    while next and (after > 0 or after < 0):
      nodes.append((f'N{i}', next.step.format(schemas)))
      edges.append((f'N{i-1}', f'N{i}'))
      [subtree_rec(s, f'N{i}') for s in next.step.supersteps]
      next = next.next
      after -= 1
      i += 1
    if next:
      nodes.append(('Ninf', '...'))
      edges.append((f'N{i-1}', 'Ninf'))

    return nodes, edges
    # END to_graph
  
  def __str__(self):
    return self.status()
  # END PlanNode
  

class PlanStep:
  """
  Defines a plan-step, which is an expectation or intention within
  Eta's plan. Each plan-step may be a top-level concrete step (i.e.,
  corresponding to a plan-node), or an abstract step linked to a more
  concrete step through a superstep relation.

  In general, each plan-step corresponds to an Eventuality (an expected
  event, with certainty in [0,1]), and has both a list of substeps and
  a list of supersteps. Additionally, we maintain any obligation(s) (i.e.,
  Eventualities that are obligated by the plan-step, but not yet expectations
  in the plan), and a list of schema instances that generated the plan-step.
  """
  def __init__(self, event=None):
    self.id = gentemp('STEP')
    self.event = event
    self.substeps = []
    self.supersteps = []
    self.obligations = []
    self.schemas = []

  def get_obligations(self):
    """
    Gets any obligations associated with a particular step in a plan in the
    schema that the step is part of (look at the parent step as well in case of
    no obligations).
    TODO: this is a bit hacky currently because say-to.v actions may need to access
    the parent paraphrase-to.v actions in order to access obligations. Rather, it seems
    that the say-to.v actions should inherit the obligations upon creation.
    """
    obligations = self.obligations
    if self.supersteps and not obligations:
      obligations = self.supersteps[0].obligations
    return obligations

  def add_superstep(self, superstep):
    """
    Adds bidirectional supplan/superplan links between a plan-step and a
    given superstep. Also add the schemas of the superstep to the plan-step
    in the case where the plan-step doesn't have any associated schemas (e.g.,
    if it was created from an episode list in expanding an action).
    TODO: should we instead always append the schemas of the superstep?
    """
    self.supersteps.append(superstep)
    superstep.substeps.append(self)
    if not self.schemas:
      self.schemas = superstep.schemas
    # self.schemas = remove_duplicates(superstep.schemas + self.schemas, order=True)

  def get_parent_ep(self):
    """
    If the current step is a subplan of another step, get the episode name/var
    corresponding to that step.
    NOTE: in case there are multiple supersteps, this currently just returns the first.
    """
    if self.supersteps:
      return self.supersteps[0].event.get_ep()
    else:
      return None
    
  def bind(self, var, val):
    """Recursively binds a variable throughout a plan-step subtree."""
    def bind_rec(step, var, val):
      step.event.bind(var, val)
      [o.bind(var, val) for o in step.obligations]
      [schema.bind(var, val) for schema in self.schemas]
      [superstep.bind(var, val) for superstep in self.supersteps]
    bind_rec(self, var, val)
    return self
  
  def unbind(self, var):
    """Recursively unbinds a variable throughout a plan-step subtree."""
    def unbind_rec(step, var):
      step.event.unbind(var)
      [o.unbind(var) for o in step.obligations]
      [schema.unbind(var) for schema in self.schemas]
      [superstep.unbind(var) for superstep in self.supersteps]
    unbind_rec(self, var)
    return self

  def serialize(self, reverse=False, schemas=False):
    """
    Serializes a tree of plan-steps using a DFS, maintaining a record of nodes
    so that variables can be inserted in place of nodes that appear more than once
    in the tree.
    If reverse=True is given, print the tree "above" the current step rather than below.
    """
    visited = {}
    c = 1
    def serialize_recur(step, i):
      nonlocal c
      if not step:
        return ''
      elif step.id in visited:
        return f'{indent(i)}{i} [{visited[step.id]}]\n'
      else:
        ret = f'{indent(i)}{i} [{c} = {step.format(schemas)}]\n'
        visited[step.id] = c
        c += 1
        if reverse:
          rec = [serialize_recur(sub, i+1) for sub in step.substeps]
          ret = ''.join([r for r in rec if r]) + ret
        else:
          rec = [serialize_recur(sup, i+1) for sup in step.supersteps]
          ret = ret + ''.join([r for r in rec if r])
        return ret
    return serialize_recur(self, 1)

  def format(self, schemas=False):
    """
    Formats the step corresponding to a given plan node, as
    "((ep-name wff) certainty)"
    Or, if a hash table of schema instances is given, as
    "((ep-name wff) certainty) (:schemas schema-preds)"
    Where schema-preds is a list of schema predicates corresponding
    to the schemas in which this step appears.
    """
    if schemas:
      schema_instances = [s.predicate for s in self.schemas]
      schemas_str = f"({' '.join(schema_instances)})"
      return f'{self.event.format()} (:schemas {schemas_str})'
    else:
      return self.event.format()

  def __str__(self):
    return self.format()
  # END PlanStep
  

def get_first_plan_node(plan_node):
  """Gets the first plan-node in the plan structure, given an arbitrary plan-node."""
  node = plan_node
  while node.prev:
    node = node.prev
  return node


def get_last_plan_node(plan_node):
  """Gets the last plan-node in the plan structure, given an arbitrary plan-node."""
  node = plan_node
  while node.next:
    node = node.next
  return node


def expand_plan_node(plan_node, subplan_node_start):
  """
  Given a plan-node and the start/end plan-nodes of some subplan, insert the
  subplan into the plan in place of the given plan-node. This modifies the
  pointers of the previous/next steps in the plan (if any), and also adds the
  plan-step of the original plan-node to the list of supersteps of each substep.
  Returns the start node of the subplan.
  """
  subplan_node_end = get_last_plan_node(subplan_node_start)
  plan_node.add_superstep_to_subplan(subplan_node_start)
  if plan_node.prev:
    plan_node.prev.next = subplan_node_start
    subplan_node_start.prev = plan_node.prev
  if plan_node.next:
    plan_node.next.prev = subplan_node_end
    subplan_node_end.next = plan_node.next
  return subplan_node_start


def insert_before_plan_node(plan_node, new_plan_node_start):
  """Inserts a new plan before the given plan node (adjusting the pointers),
     and returns the new plan node."""
  new_plan_node_end = get_last_plan_node(new_plan_node_start)
  if plan_node.prev:
    plan_node.prev.next = new_plan_node_start
    new_plan_node_start.prev = plan_node.prev
  plan_node.prev = new_plan_node_end
  new_plan_node_end.next = plan_node
  return new_plan_node_start


def merge_plan_nodes(plan_node_start, plan_node_end, new_plan_node):
  """
  Merges a sequence of plan nodes (bounded between plan-node-start and plan-node-end)
  into a given subplan node. Returns the new subplan node.
  TODO: do we also need to deal with cases where the plan-nodes are discontiguous in the plan?
  """
  new_plan_node.add_supersteps(plan_node_start, plan_node_end)
  if plan_node_start.prev:
    plan_node_start.prev.next = new_plan_node
    new_plan_node.prev = plan_node_start.prev
  if plan_node_end.next:
    plan_node_end.next.prev = new_plan_node
    new_plan_node.next = plan_node_end.next
  return new_plan_node


def init_plan_from_eventualities(eventualities, schema=None):
  """
  Creates a plan structure from a list of eventualities, assumed to occur sequentially.
  (TODO: we might, in the future, allow for episode-relations in the schema to provide initial
  constraints over plan construction here).
  TODO: In the case of :repeat-until, we should create duplicate PlanSteps but reuse the same
  Eventuality objects (we may need a function to un-bind in plan and schema?).
  """
  first_node = None
  prev_node = None
  curr_node = None
  for e in eventualities:
    # Make plan-step structure
    step = PlanStep(event=e)

    # If schema is provided, add it to schemas of step, and also inherit any obligations/etc.
    if schema is not None:
      step.schemas.append(schema)
      step.obligations += schema.get_obligations_of_ep(e.get_ep())

    # Make plan-node and set pointers when a previous step exists
    curr_node = PlanNode(step)
    if first_node is None:
      first_node = curr_node
    if prev_node is not None:
      curr_node.prev = prev_node
      prev_node.next = curr_node
    prev_node = curr_node

  return first_node


def certainty_to_period(certainty):
  """
  Maps a certainty from [0,1] to a period corresponding to the
  period (in seconds) that Eta must wait to consider an expected episode
  failed and move on in the plan.
  The proportion between the period (in task cycles) and the
  quantity -log(1 - certainty) is determined by the global
  constant *expected-step-failure-period-coefficient*.
  """
  if certainty >= 1 or certainty < 0:
    return 'inf'
  else:
    return -EXPECTED_STEP_FAILURE_PERIOD_COEFFICIENT * math.log(1-certainty)
  

def has_elapsed_certainty_period(time, certainty):
  """Checks whether a given time delta has elapsed the period corresponding to a particular certainty."""
  if certainty >= 1 or certainty < 0:
    return False
  else:
    period = certainty_to_period(certainty)
    return time >= period


def visualize_plan(plan_node, before=3, after=5, schemas=False, vert=False):
  """
  Visualizes a plan using graphviz dot.
  TODO: may want to move this function elsewhere in order to have cleaner dependency structure.
  TODO: try to fix order of top-level nodes
  """
  nodes, edges = plan_node.to_graph(before=before, after=after, schemas=schemas)
  dot = graphviz.Digraph()
  if vert:
    dot.attr(rankdir='LR')

  def node_key(n):
    if n[0][1:].replace('-', '').isdigit():
      return int(n[0][1:])
    elif n[0] == 'N-inf':
     return -100000
    elif n[0] == 'Ninf':
     return 100000
  nodes_top = [n for n in nodes if n[0][0]=='N']
  nodes_top.sort(key=node_key)

  with dot.subgraph(name='nodes', node_attr={'shape': 'box'}) as dot1:
    dot1.attr(rank='same')
    for n in nodes_top:
      if n[0] == 'N0':
        dot1.node(n[0], n[1], style='filled')
      else:
        dot1.node(n[0], n[1])
    for e in [e for e in edges if e[0][0]=='N' and e[1][0]=='N']:
      dot1.edge(e[0], e[1], constraint='false')

  with dot.subgraph(name='steps') as dot1:
    for n in [n for n in nodes if n[0][0]=='S']:
      print(n)
      dot1.node(n[0], n[1])
    for e in [e for e in edges if e[0][0]!='N' or e[1][0]!='N']:
      dot1.edge(e[0], e[1], dir='none')

  dot.render('tests/graphviz/plan.gv', view=True)


def make_test_plan_tree():
  """Creates an artificial plan tree for testing purposes."""
  pe1 = PlanStep(event=parse_eventuality('step 1'))
  pe2a = PlanStep(event=parse_eventuality('step 2a'))
  pe2b = PlanStep(event=parse_eventuality('step 2b'))
  pe3a = PlanStep(event=parse_eventuality('step 3a'))
  pe3b = PlanStep(event=parse_eventuality('step 3b'))
  pe1.supersteps = [pe2a, pe2b]
  pe2a.supersteps = [pe3a]
  pe2b.supersteps = [pe3a, pe3b]
  pe2a.substeps = [pe1]
  pe2b.substeps = [pe1]
  pe3a.substeps = [pe2a, pe2b]
  pe3b.substeps = [pe2b]
  return pe1, pe3a, pe3b


def make_test_plan():
  """Creates an artificial plan structure for testing purposes."""
  schema_instances = {}
  s1 = DialSchema(**DialSchema.read_param_dict('schema1.v', ['dial-schema', ':header', ['schema1.v', '**', '?e']]))
  s2 = DialSchema(**DialSchema.read_param_dict('schema2.v', ['dial-schema', ':header', ['schema2.v', '**', '?e']]))
  s3 = DialSchema(**DialSchema.read_param_dict('schema3.v', ['dial-schema', ':header', ['schema3.v', '**', '?e']]))
  s4 = DialSchema(**DialSchema.read_param_dict('schema4.v', ['dial-schema', ':header', ['schema4.v', '**', '?e']]))
  sid1 = s1.id
  sid2 = s2.id
  sid3 = s3.id
  sid4 = s4.id
  pe1 = PlanStep(event=parse_eventuality('(test ?e1)', ep='?e1'))
  pe2 = PlanStep(event=parse_eventuality('(test ?e1)', ep='?e2'))
  pe3 = PlanStep(event=parse_eventuality('(test ?e1 ?e2 ?words)', ep='?e3'))
  pe4 = PlanStep(event=parse_eventuality('(test ?e1 ?e2 ?e3)', ep='?e4'))
  pe5 = PlanStep(event=parse_eventuality('(test ?e1 ?e2 ?e3 ?e4 ?words)', ep='?e5'))
  pe6 = PlanStep(event=parse_eventuality('(test ?e4 ?words ?e5)', ep='?e6'))
  pe7 = PlanStep(event=parse_eventuality('(test ?e1 ?e6)', ep='?e7'))
  pe8 = PlanStep(event=parse_eventuality('(test ?e9 ?e7)', ep='?e8'))
  pe9 = PlanStep(event=parse_eventuality('(test ?e1 ?e12)', ep='?e9'))
  pe10 = PlanStep(event=parse_eventuality('(test ?e7 ?e8 ?e9)', ep='?e10'))
  pe11 = PlanStep(event=parse_eventuality('(test ?e1 ?words)', ep='?e11'))
  pe12 = PlanStep(event=parse_eventuality('(test ?e1 ?e11)', ep='?e12'))
  n8 = PlanNode(pe8)
  n9 = PlanNode(pe9)
  n10 = PlanNode(pe10)
  n11 = PlanNode(pe11)
  n12 = PlanNode(pe12)
  n7 = PlanNode(pe7)
  pe1.substeps = [pe3, pe4, pe5]
  pe2.substeps = [pe4, pe6, pe7]
  pe3.substeps = [pe8, pe9]
  pe4.substeps = [pe10]
  pe5.substeps = [pe9, pe11]
  pe6.substeps = [pe12]
  pe3.supersteps = [pe1]
  pe4.supersteps = [pe1, pe2]
  pe5.supersteps = [pe1]
  pe6.supersteps = [pe2]
  pe7.supersteps = [pe2]
  pe8.supersteps = [pe3]
  pe9.supersteps = [pe3, pe5]
  pe10.supersteps = [pe4]
  pe11.supersteps = [pe5]
  pe12.supersteps = [pe6]
  pe1.schemas = [s1]
  pe2.schemas = [s2]
  pe3.schemas = [s1, s3]
  pe4.schemas = [s1, s2]
  pe5.schemas = [s1, s2, s4]
  pe6.schemas = [s2]
  pe7.schemas = [s2]
  pe8.schemas = [s1, s3]
  pe9.schemas = [s1, s3, s4]
  pe10.schemas = [s1, s2]
  pe11.schemas = [s1, s2, s4]
  pe12.schemas = [s2]
  n8.next = n9
  n9.prev = n8
  n9.next = n10
  n10.prev = n9
  n10.next = n11
  n11.prev = n10
  n11.next = n12
  n12.prev = n11
  n12.next = n7
  n7.prev = n12
  for schema in [s1, s2, s3, s4]:
    schema_instances[schema.id] = schema
  plan_vars = [
    ('?e1', '?ea1', sid1),
    ('?e2', '?eb1', sid2),
    ('?e3', '?ea2', sid1),
    ('?e3', '?ec1', sid3),
    ('?words', '?w', sid1),
    ('?words', '?w', sid3),
    ('?e4', '?ea3', sid1),
    ('?e4', '?eb2', sid2),
    ('?e5', '?ea4', sid1),
    ('?e5', '?eb3', sid2),
    ('?e5', '?ed1', sid4),
    ('?e6', '?eb4', sid2),
    ('?e7', '?eb5', sid2),
    ('?e8', '?ea5', sid1),
    ('?e8', '?ec2', sid3),
    ('?e9', '?ea6', sid1),
    ('?e9', '?ec3', sid3),
    ('?e9', '?ed2', sid4),
    ('?e10', '?ea7', sid1),
    ('?e10', '?eb6', sid2),
    ('?e11', '?ea8', sid1),
    ('?e11', '?eb7', sid2),
    ('?e11', '?ed3', sid4),
    ('?e12', '?eb8', sid2),
  ]
  return n11, schema_instances


def test_formatting():
  sep = '\n----------------------------\n'

  step_surface, step_root1, step_root2 = make_test_plan_tree()
  print(step_surface.serialize(), sep)
  print(step_root1.serialize(), sep)
  print(step_root1.serialize(reverse=True), sep)
  print(step_root2.serialize(reverse=True), sep)

  plan, schema_instances = make_test_plan()

  print(plan.step.serialize(), sep)

  print(plan.serialize_subtree(), sep)

  print('\n'.join(plan.serialize_from_roots()), sep)

  print(plan, sep)

  print(plan.serialize_subtree(schema_instances), sep)

  # visualize_plan(plan)


def test_bind():
  sep = '\n----------------------------\n'

  plan, schema_instances = make_test_plan()

  print(plan, sep)
  print(plan.serialize_subtree(), sep)

  plan.bind('?words', ['this', 'is', 'a', 'test', 'sentence', '.'])
  
  print(plan, sep)
  print(plan.serialize_subtree(), sep)

  plan.bind('?e7', 'e100')
  plan.bind('?e1', 'e101')

  print(plan, sep)
  print(plan.serialize_subtree(), sep)



def main():
  test_formatting()
  # test_bind()


if __name__ == "__main__":
  main()
