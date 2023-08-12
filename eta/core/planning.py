from time import sleep

import eta.util.file as file
from eta.util.general import listp
from eta.lf import Condition, Repetition, parse_eventuality, extract_set
from eta.plan import init_plan_from_eventualities, insert_before_plan_node, expand_plan_node

def planning_loop(ds):
  while ds.do_continue():
    sleep(.1)

    # Pop from buffer of possible actions and attempt to add to plan
    actions = ds.pop_all_buffer('actions')
    new_plan = add_possible_actions_to_plan(actions, ds)
    ds.set_plan(new_plan)
    ds.add_to_buffer(new_plan, 'plans')

    # Attempt to modify current plan by expanding, merging, and reordering steps
    plan = ds.pop_buffer('plans')
    new_plan = expand_plan_steps(plan, ds)
    new_plan = merge_plan_steps(new_plan, ds)
    new_plan = reorder_plan_steps(new_plan, ds)
    ds.set_plan(new_plan)
    ds.add_to_buffer(new_plan, 'plans')


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
  """TBC"""
  # TODO
  return plan


def reorder_plan_steps(plan, ds):
  """TBC"""
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
    if schema:
      local_vars = [var for var in local_vars if var not in schema.participants]
    [ds.unbind(var) for var in local_vars]
    return init_plan_from_eventualities(eventualities+[event], schema=schema)


def expand_primitive_step(event, ds):
  """TBC"""
  # TODO
  pass


def schema_step(wff, ds):
  return listp(wff) and ((len(wff) == 1 and ds.is_dial_schema(wff[0])) or ds.is_dial_schema(wff[1]))


def split_schema_step(wff):
  if len(wff) == 1:
    return wff[0], []
  predicate = wff[1]
  args = extract_set(wff[0]) + wff[2:]
  return predicate, args


# def plan(facts):
#   prompt = PROMPT_PLAN.replace('<facts>', '\n'.join(facts))
#   action, _ = generate_gpt(prompt)
#   return [action]


def main():
  pass
  # facts = [
  #   'Socrates is a man',
  #   'All men are mortal',
  #   'John went to the store yesterday',
  #   'Mary loves to paint',
  #   'you say to me "I like to go skiing."'
  # ]
  # p = plan(facts)
  # print(p)


if __name__ == "__main__":
  main()