from time import sleep

import eta.util.file as file
from eta.lf import parse_eventuality
from eta.plan import init_plan_from_eventualities, insert_before_plan_node

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
  """TBC"""
  # Return None if cannot be expanded
  return plan


def merge_plan_steps(plan, ds):
  """TBC"""
  return plan


def reorder_plan_steps(plan, ds):
  """TBC"""
  return plan


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