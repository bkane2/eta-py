"""Classes and methods for creating and modifying dialogue plan structures.

A plan structure consists of a doubly linked list of plan nodes, interpreted as sequentially ordered
steps in the system's plan. Each step contains the expected or intended event corresponding to that node.

Additionally, plan steps may be related to other plan steps in a tree structure, such that each plan
step has a list of substeps (more concrete steps that together constitute an abstract step), as well
as a list of supersteps (more abstract steps that a step partially constitutes).

The process of planning dialogue, then, consists of iteratively expanding abstract steps to create a
"frontier" of concrete plan steps, which become plan nodes (replacing the plan node that previously
held the abstract step).

Similarly, executing a plan consists of advancing the pointer to the currently due plan node within
the linked list of plan nodes.

TODO: short writeup explaining figure

.. image:: ../_static/figures/plan.png
"""

import graphviz

from eta.util.general import gentemp, remove_duplicates, indent, cons

class PlanNode:
  """A node in the doubly linked list that represents the system's plan.

  Parameters
  ----------
  step : PlanStep
    The plan step contained within this node.
  
  Attributes
  ----------
  step : PlanStep
    The plan step contained within this node.
  prev : PlanNode
    The next plan node in the linked list.
  next : PlanNode
    The previous plan node in the linked list.
  """

  def __init__(self, step):
    self.step = step
    self.prev = None
    self.next = None

  def add_superstep_to_subplan(self, node):
    """Add the step of a given plan node as a superstep of each node within the subplan headed by this node.

    Parameters
    ----------
    node : PlanNode
      The node whose step should be added as a superstep.
    """
    start = self
    while start.next:
      start.step.add_superstep(node.step)
      start = start.next
    start.step.add_superstep(node.step)

  def add_supersteps(self, start_node, end_node):
    """Given a subplan bounded between a given start and end node, add each as a superstep of this node.

    Parameters
    ----------
    start_node : PlanNode
      The beginning of the subplan whose steps should be added as a superstep.
    end_node : PlanNode
      The end of the subplan whose steps should be added as a superstep.
    """
    start = start_node
    while start.next and not start == end_node:
      self.step.add_superstep(start.step)
      start = start.next
    self.step.add_superstep(start.step)

  def add_schema_to_subplan(self, schema):
    """Add the given schema to each plan step in the subplan headed by this node.

    Parameters
    ----------
    schema : Schema
      The schema object to add to the schema lists for each plan step.
    """
    start = self
    while start.next:
      start.step.schemas.append(schema)
      start = start.next
    start.step.schemas.append(schema)

  def get_schemas(self):
    """Get all schemas of this plan."""
    return self.step.schemas

  def get_all_roots(self):
    """Get all root plan steps (i.e., the most abstract steps) reachable from the current plan."""
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
    """Bind the given variable symbol to the given value throughout the entire plan structure."""
    def bind_rec(node, var, val, left, right):
      node.step.bind(var, val)
      if node.prev and left:
        bind_rec(node.prev, var, val, True, False)
      if node.next and right:
        bind_rec(node.next, var, val, False, True)
    bind_rec(self, var, val, True, True)
    return self
  
  def unbind(self, var):
    """Unbind the given variable symbol throughout the entire plan structure."""
    def unbind_rec(node, var, left, right):
      node.step.unbind(var)
      if node.prev and left:
        unbind_rec(node.prev, var, True, False)
      if node.next and right:
        unbind_rec(node.next, var, False, True)
    unbind_rec(self, var, True, True)
    return self
  
  def status(self, before=3, after=5, schemas=False):
    """Format the plan structure as a status string showing the current, past, and future surface steps.

    Parameters
    ----------
    before : int, default=3
      The number of past surface steps to show.
    after : int, default=5
      The number of future surface steps to show.
    schemas : bool, default=False
      Whether to also display schema predicates for each step.

    Returns
    -------
    str
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
    """Format a string representing the subtree of the plan structure reachable from this node.
    
    Parameters
    ----------
    schemas : bool, default=False
      Whether to also display schema predicates for each step.
    
    Returns
    -------
    str
    """
    return self.step.serialize(schemas=schemas)
  
  def serialize_from_roots(self, schemas=False):
    """Format a string representing the subtrees of the plan structure reachable from each root step.
    
    Parameters
    ----------
    schemas : bool, default=False
      Whether to also display schema predicates for each step.
    
    Returns
    -------
    str
    """
    return [root.serialize(reverse=True, schemas=schemas) for root in self.get_all_roots()]
  
  def to_graph(self, before=3, after=5, schemas=False):
    """Convert a plan structure to a standard graph object, i.e., a list of vertices and edges.

    Parameters
    ----------
    before : int, default=3
      The number of past surface steps to include in the graph.
    after : int, default=5
      The number of future surface steps to include in the graph.
    schemas : bool, default=False
      Whether to also display schema predicates in the labels for each step.

    Returns
    -------
    nodes : list[tuple[str, str]]
      A list of vertices/nodes in the resulting graph, where each node is an ``(<id>, <label>)`` tuple.
    edges : list[tuple[str, str]]
      A list of edges in the resulting graph, where each edge is an ``(<id1>, <id2>)`` tuple.
    """
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
  
  def __str__(self):
    return self.status()
  

class PlanStep:
  """A plan step containing an eventuality, related to other plan steps through a tree structure.

  Parameters
  ----------
  event : Eventuality
    The eventuality corresponding to this step.
  
  Attributes
  ----------
  id : str
    A unique ID for this step.
  event : Eventuality
    The eventuality corresponding to this step.
  substeps : list[PlanStep]
    A list of more concrete plan steps that together realize this step.
  supersteps : list[PlanStep]
    A list of more abstract plan steps which this step (partially) realizes.
  obligations : list[Eventuality]
    A list of dialogue obligations associated with this plan step.
  schemas : list[Schema]
    A list of schemas that this expected/intended step arises from (if any).
  """
  
  def __init__(self, event=None):
    self.id = gentemp('STEP')
    self.event = event
    self.substeps = []
    self.supersteps = []
    self.obligations = []
    self.schemas = []

  def get_obligations(self):
    """Get any dialogue obligations associated with a particular step in the plan.

    Notes
    -----
    TODO: this is currently a bit of a hack, in that it involves looking at the superstep
    as well if no obligations are found. This is because say-to.v actions may need to access
    the parent paraphrase-to.v actions in order to inherit relevant obligations of the latter.
    It may be possible to instead modify the plan expansion method so that obligations are
    inherited upon expansion.
    """
    obligations = self.obligations
    if self.supersteps and not obligations:
      obligations = self.supersteps[0].obligations
    return obligations

  def add_superstep(self, superstep):
    """Add bidirectional subplan/superplan links between this step and a given superstep.

    The schemas of the superstep also become the schemas associated with this step, but
    only in the case where this step doesn't already have associated schemas (e.g.,
    if it was created from an episode list in expanding an action).

    Parameters
    ----------
    superstep : PlanStep
      The superstep to add to this step.

    Notes
    -----
    TODO: it's not clear whether the above is the sensible behavior, or if instead we
    should always append the schemas of the superstep to this step.
    """
    self.supersteps.append(superstep)
    superstep.substeps.append(self)
    if not self.schemas:
      self.schemas = superstep.schemas
    # self.schemas = remove_duplicates(superstep.schemas + self.schemas, order=True)
    
  def bind(self, var, val):
    """Bind the given variable symbol to the given value throughout the entire plan step tree (and associated schemas)."""
    def bind_rec(step, var, val):
      step.event.bind(var, val)
      [o.bind(var, val) for o in step.obligations]
      [schema.bind(var, val) for schema in self.schemas]
      [superstep.bind(var, val) for superstep in self.supersteps]
    bind_rec(self, var, val)
    return self
  
  def unbind(self, var):
    """Unbind the given variable symbol throughout the entire plan step tree (and associated schemas)."""
    def unbind_rec(step, var):
      step.event.unbind(var)
      [o.unbind(var) for o in step.obligations]
      [schema.unbind(var) for schema in self.schemas]
      [superstep.unbind(var) for superstep in self.supersteps]
    unbind_rec(self, var)
    return self

  def serialize(self, reverse=False, schemas=False):
    """Format a string representing a serialized version of the subtree rooted at this step.

    This is generated using a DFS, maintaining a record of recurring plan steps so that numerical
    references can be inserted in place of nodes that appear more than once in the tree.

    Parameters
    ----------
    reverse : bool, default=False
      If given as True, print the subtree "above" this step rather than below.
    schemas : bool, default=False
      Whether to also display schema predicates for each step.
    
    Returns
    -------
    str
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
    """Format a string representing this plan step as an S-expression.

    Parameters
    ----------
    schemas : bool, default=False
      Whether to also display schema predicates for each step.

    Returns
    -------
    str
      The step formatted as one of the following S-expression string representations:
      - ``((<ep-name> <wff>) <certainty>)``
      - ``((<ep-name> <wff>) <certainty>) (:schemas <schema-preds>)``
    """
    if schemas:
      schema_instances = [s.predicate for s in self.schemas]
      schemas_str = f"({' '.join(schema_instances)})"
      return f'{self.event.format()} (:schemas {schemas_str})'
    else:
      return self.event.format()

  def __str__(self):
    return self.format()
  

def get_first_plan_node(plan_node):
  """Get the first plan node in a linked list of plan nodes.

  Parameters
  ----------
  plan_node : PlanNode
    An arbitrary node within the linked list of plan nodes.
  
  Returns
  -------
  PlanNode
    The first node in the linked list.
  """
  node = plan_node
  while node.prev:
    node = node.prev
  return node


def get_last_plan_node(plan_node):
  """Get the last plan node in a linked list of plan nodes.

  Parameters
  ----------
  plan_node : PlanNode
    An arbitrary node within the linked list of plan nodes.
  
  Returns
  -------
  PlanNode
    The last node in the linked list.
  """
  node = plan_node
  while node.next:
    node = node.next
  return node


def expand_plan_node(plan_node, subplan_node_start):
  """Expand a plan node using the subplan headed by another node.

  The subplan is inserted into the plan in place of the given plan node, which
  is done by adding the plan node as a superstep of each step in the subplan,
  and then modifying the pointers of the linked list so that the step before
  the plan node points to the first node in the subplan, and the step after
  the plan node points to the last node in the subplan.

  Parameters
  ----------
  plan_node : PlanNode
    The node to expand.
  subplan_node_start : PlanNode
    The first node in the subplan to replace `plan_node` with.

  Returns
  -------
  PlanNode
    The first node in the given subplan.
  """
  subplan_node_end = get_last_plan_node(subplan_node_start)
  subplan_node_start.add_superstep_to_subplan(plan_node)
  if plan_node.prev:
    plan_node.prev.next = subplan_node_start
    subplan_node_start.prev = plan_node.prev
  if plan_node.next:
    plan_node.next.prev = subplan_node_end
    subplan_node_end.next = plan_node.next
  return subplan_node_start


def insert_before_plan_node(plan_node, new_plan_node_start):
  """Insert a new plan directly before a given plan node in the linked list.
  
  Parameters
  ----------
  plan_node : PlanNode
    The node that the new plan should precede.
  new_plan_node_start : PlanNode
    The first node in the new plan to insert before `plan_node`.
    
  Returns
  -------
  PlanNode
    The first node in the new plan.
  """
  new_plan_node_end = get_last_plan_node(new_plan_node_start)
  if plan_node.prev:
    plan_node.prev.next = new_plan_node_start
    new_plan_node_start.prev = plan_node.prev
  plan_node.prev = new_plan_node_end
  new_plan_node_end.next = plan_node
  return new_plan_node_start


def merge_plan_nodes(plan_node_start, plan_node_end, new_plan_node):
  """Merge a sequence of plan nodes (bounded between a given start and end node) into a given subplan node.

  Parameters
  ----------
  plan_node_start : PlanNode
    The first node in the plan sequence to merge.
  plan_node_end : PlanNode
    The last node in the plan sequence to merge.
  new_plan_node : PlanNode
    The new subplan node that should replace the merged sequence.

  Returns
  -------
  PlanNode
    The new subplan node that replaced the merged sequence.

  Notes
  -----
  TODO: this may need to be extended to deal with cases where the plan nodes to merge are discontiguous in the plan.
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
  """Create a plan structure from a list of eventualities, assumed to occur sequentially.

  Parameters
  ----------
  eventualities : list[Eventualities]
    The list of eventualities to use to create a plan.
  schema : Schema, optional
    If a schema is provided, it will be added to the created plan steps and used to
    inherit obligations, etc.

  Returns
  -------
  PlanNode
    The first node in the created plan structure.

  Notes
  -----
  TODO: we might, in the future, allow for episode-relations in the schema to provide initial
  constraints over plan construction here.
  """
  first_node = None
  prev_node = None
  curr_node = None

  for e in eventualities:
    step = PlanStep(event=e)

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


def visualize_plan(plan_node, before=3, after=5, schemas=False, vert=False, dir='io/'):
  """Visualize a plan as a graph using graphviz dot.

  Parameters
  ----------
  before : int, default=3
    The number of past surface steps to include in the graph.
  after : int, default=5
    The number of future surface steps to include in the graph.
  schemas : bool, default=False
    Whether to also display schema predicates in the labels for each step.
  vert : bool, default=False
    Whether to rotate the direction of the graph to left-right.
  dir : str, default='io/'
    The directory to store the generated graph image.

  Notes
  -----
  TODO: it may be better to move this function elsewhere in order to have a cleaner dependency structure.
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

  dot.render(f'{dir}plan.gv', view=True)