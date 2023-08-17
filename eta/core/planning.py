from time import sleep

from eta.constants import *
from eta.util.general import listp
from eta.lf import Condition, Repetition, parse_eventuality, extract_set, is_set, set_union, atom
from eta.plan import init_plan_from_eventualities, insert_before_plan_node, expand_plan_node, merge_plan_nodes

def planning_loop(ds):
  while ds.do_continue():
    sleep(.1)

    # Pop from buffer of possible actions and attempt to add to plan
    actions = ds.pop_all_buffer('actions')
    new_plan = add_possible_actions_to_plan(actions, ds)
    ds.set_plan(new_plan)
    ds.replace_buffer(new_plan, 'plans')

    # Attempt to modify current plan by expanding, merging, and reordering steps
    plan = ds.pop_buffer('plans')
    if plan:
      new_plan = expand_plan_steps(plan, ds)
      new_plan = merge_plan_steps(new_plan, ds)
      new_plan = reorder_plan_steps(new_plan, ds)
      ds.set_plan(new_plan)
      ds.replace_buffer(new_plan, 'plans')


def add_possible_actions_to_plan(actions, ds):
  """
  Given a list of possible actions, attempt to add actions into the current plan.
  TODO:
  1. For now, we assume that only the first action in a set of possible actions is used.
     In the future, this might be extended with a policy for attempting to add the top K possible actions.
  2. This currently adds the action unconditionally; ultimately, the system should verify that the action
     can be added to the plan. This may be done by way of a pattern transducer.
  3. The action is currently inserted as the current step, but ultimately we should be able to insert actions
     elsewhere in the plan as well.
  """
  if not actions:
    return None
  action = actions[0]
  plan_node = init_plan_from_eventualities([parse_eventuality(action, expectation=True)])
  new_plan = insert_before_plan_node(ds.get_plan(), plan_node)
  return new_plan


def expand_plan_steps(plan, ds):
  """
  This attempts to expand the surface steps in the plan using one of:
  1. A keyword step, which have special expansion behavior
  2. A schema whose header matches the step WFF (unifying any schema args)
  3. A "primitive" type of plan step whose expansion is directly supported
  4. (TBC) A pattern transduction tree mapping the step WFF to substep WFF(s)
  TODO: currently, this only attempts to expand the currently due step; however,
  it may be possible to use pattern transduction to expand other steps in the plan as well."""
  if not plan:
    return None
  
  event = plan.step.event
  schema = plan.step.schemas[0] if plan.step.schemas else None
  wff = event.get_wff()

  if isinstance(event, Condition):
    subplan = expand_condition_step(event, ds, schema)
  elif isinstance(event, Repetition):
    subplan = expand_repetition_step(event, ds, schema)
  elif schema_step(wff, ds):
    predicate, args = split_schema_step(wff)
    subplan = ds.init_plan_from_schema(predicate, args)
  else:
    subplan = expand_primitive_step(event, ds)
    if not subplan:
      subplan = ds.apply_transducer('expand-step', event)

  if subplan:
    return expand_plan_node(ds.get_plan(), subplan)
  else:
    return None


def merge_plan_steps(plan, ds):
  """
  Merge steps in the plan that are deemed to be equivalent, unifiable, or otherwise
  able to be simultaneously instantiated by a single step.

  TODO: currently, the only thing this function does is merge directly adjacent
  reply-to steps in the plan. It should be refactored using a transducer that
  maps a plan to a new plan with merged steps, possibly making use of retrieved
  equivalency knowledge.
  """
  if plan is None:
    return plan
  wff1 = plan.step.event.get_wff()
  if plan.next:
    wff2 = plan.next.step.event.get_wff()
    if equivalent_speech_acts(wff1, wff2):
      subj = wff1[0]
      predicate = wff1[1]
      obj = set_union(wff1[2], wff2[2])
      subplan = init_plan_from_eventualities([parse_eventuality([subj, predicate, obj], expectation=True)])
      return merge_plan_nodes(plan, plan.next, subplan)
  return plan


def reorder_plan_steps(plan, ds):
  """TBC"""
  if plan is None:
    return plan
  # TODO
  return plan


def expand_condition_step(event, ds, schema=None):
  """TBC"""
  for (condition, eventualities) in event.conditions:
    if condition == True or ds.eval_truth_value(condition.get_formula()):
      return init_plan_from_eventualities(eventualities, schema=schema)
  return None


def expand_repetition_step(event, ds, schema=None):
  """TBC"""
  condition = event.condition
  eventualities = event.eventualities
  # If termination has been reached, do nothing
  if ds.eval_truth_value(condition.get_formula()):
    return None
  # Otherwise, unbind all variables within each of the embedded eventualities and
  # return the repetition step as a new subplan
  else:
    local_vars = [var for e in eventualities for var in e.bindings.keys()]
    # This is a bit of a hack to ensure that only variables bound in the course of
    # execution of the embedded eventualities (e.g., ?words) are unbound.
    # TODO: some modifications still need to be made here in order to make the generated
    # plans and facts in memory coherent in case of repetition
    if schema:
      local_vars = [var for var in local_vars if var not in schema.participants]
    [ds.unbind(var) for var in local_vars]
    [e.unbind(var) for e in eventualities for var in local_vars]
    [event.unbind(var) for var in local_vars]
    [schema.unbind(var) for var in local_vars]
    return init_plan_from_eventualities(eventualities+[event], schema=schema)


def expand_primitive_step(event, ds):
  """TBC"""
  ep = event.get_ep()
  wff = event.get_wff()
  if paraphrase_step(wff):
    return plan_paraphrase(wff[3], ds)
  elif respond_step(wff) or reply_step(wff):
    return plan_respond(wff[2], ds)
  elif answer_step(wff):
    return plan_answer(wff[3], ds)
  elif ask_step(wff):
    return plan_ask(wff[3], ds)
  elif react_step(wff):
    return plan_react(wff[2], ds)
  else:
    return None
  

def plan_paraphrase(expr, ds):
  """TBC"""
  if not isinstance(expr, str) or not expr[0] == '"' or not expr[-1] == '"':
    return None
  gist = expr.strip('"')
  conversation_log = ds.get_conversation_log()
  conds = [] # TODO
  facts = [] # TODO
  return say_to_step_from_utts(ds.apply_transducer('paraphrase', gist, conversation_log, conds=conds, facts=facts))


def plan_respond(expr, ds):
  """TBC"""
  conversation_log = ds.get_conversation_log()
  conds = [] # TODO
  facts = [] # TODO
  return say_to_step_from_utts(ds.apply_transducer('response', conversation_log, conds=conds, facts=facts))


def plan_answer(expr, ds):
  """TBC"""
  conversation_log = ds.get_conversation_log()
  conds = [] # TODO
  facts = [] # TODO
  return say_to_step_from_utts(ds.apply_transducer('answer', conversation_log, conds=conds, facts=facts))


def plan_ask(expr, ds):
  """TBC"""
  conversation_log = ds.get_conversation_log()
  conds = [] # TODO
  facts = [] # TODO
  return say_to_step_from_utts(ds.apply_transducer('ask', conversation_log, conds=conds, facts=facts))


def plan_react(expr, ds):
  """TBC"""
  eps = extract_set(expr)
  events = [m.event for ep in eps for m in ds.get_memory().get_episode(ep)]
  actions = []
  for event in events:
    actions += ds.apply_transducer('reaction', event)
  if actions:
    return init_plan_from_eventualities([parse_eventuality(actions[0], expectation=True)])
  else:
    return None


def say_to_step_from_utt(utt):
  return init_plan_from_eventualities([parse_eventuality([ME, SAY_TO, YOU, f'"{utt}"'], expectation=True)])


def say_to_step_from_utts(utts):
  if utts and utts[0]:
    return say_to_step_from_utt(utts[0])
  else:
    return None


def schema_step(wff, ds):
  return listp(wff) and ((len(wff) == 1 and ds.is_dial_schema(wff[0])) or ds.is_dial_schema(wff[1]))


def split_schema_step(wff):
  if len(wff) == 1:
    return wff[0], []
  predicate = wff[1]
  args = extract_set(wff[0]) + wff[2:]
  return predicate, args


def paraphrase_step(wff):
  return listp(wff) and len(wff) >= 4 and wff[:3] == [ME, PARAPHRASE_TO, YOU]

def respond_step(wff):
  return listp(wff) and len(wff) == 3 and wff[:2] == [ME, RESPOND_TO]

def reply_step(wff):
  return listp(wff) and len(wff) == 3 and wff[:2] == [ME, REPLY_TO]

def react_step(wff):
  return listp(wff) and len(wff) == 3 and wff[:2] == [ME, REACT_TO]

def answer_step(wff):
  return listp(wff) and len(wff) == 4 and wff[:3] == [ME, ANSWER, YOU]

def ask_step(wff):
  return listp(wff) and len(wff) == 4 and wff[:3] == [ME, ASK, YOU]

def relative_speech_act_step(wff):
  return listp(wff) and len(wff) == 3 and wff[1] in SPEECH_ACTS and (atom(wff[2] or is_set(wff[2])))

def equivalent_speech_acts(wff1, wff2):
  return relative_speech_act_step(wff1) and relative_speech_act_step(wff2) and wff1[0] == wff2[0] and wff1[1] == wff2[1]


def main():
  pass


if __name__ == "__main__":
  main()