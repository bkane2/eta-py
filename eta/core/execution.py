from time import sleep

import eta.util.time as time
from eta.constants import *
from eta.util.general import listp, variablep
from eta.plan import has_elapsed_certainty_period
from eta.discourse import DialogueTurn, Utterance, parse_utt_str
from eta.lf import Condition, Repetition, parse_eventuality

def execution_loop(ds):
  while ds.do_continue():
    sleep(.1)

    plan = ds.get_plan()
    event = plan.step.event
    wff = event.get_wff()

    if isinstance(event, Condition):
      advance_plan = process_condition_step(event, ds)
    elif isinstance(event, Repetition):
      advance_plan = process_repetition_step(event, ds)
    elif you_pred(wff):
      advance_plan = process_expected_step(event, ds)
    elif me_pred(wff):
      advance_plan = process_intended_step(event, ds)
    else:
      advance_plan = process_expected_step(event, ds)

    if advance_plan:
      ds.reset_step_failure_timer()
      ds.advance_plan()

    if advance_plan or type(event) in [Condition, Repetition]:
      new_plan = ds.get_plan()
      if advance_plan:
        ds.replace_buffer(new_plan, 'plans')
      else:
        ds.add_to_buffer_if_empty(new_plan, 'plans')


def process_condition_step(event, ds):
  """TBC"""
  for (condition, _) in event.conditions:
    if condition == True or ds.eval_truth_value(condition.get_formula()):
      return False
  ds.instantiate_curr_step()
  return True


def process_repetition_step(event, ds):
  """TBC"""
  if not ds.eval_truth_value(event.condition.get_formula()):
    return False
  ds.instantiate_curr_step()
  return True


def process_expected_step(event, ds):
  """TBC"""
  # It is assumed that Eta is done speaking if step is an expectation
  ds.write_output_buffer()

  # If the timer exceeds period (function of certainty of step), instantiate a 'failed' episode
  certainty = event.prob
  if has_elapsed_certainty_period(time.now() - ds.get_step_failure_timer(), certainty):
    return fail_curr_step(event, ds)

  # Otherwise, inquire about truth of the immediately pending episode, and advance accordingly
  return inquire_truth_of_curr_step(event, ds)


def inquire_truth_of_curr_step(event, ds):
  """TBC"""
  ep_var = event.get_ep()
  wff = event.get_wff()

  match = ds.access_from_context(wff)
  if not match:
    return False
  
  match = match[0].event
  ep = match.get_ep()

  ds.bind(ep_var, ep)

  for x, y in zip(wff, match.get_wff()):
    if variablep(x) and y:
      ds.bind(x, y)
  
  return True


def fail_curr_step(event, ds):
  """TBC"""
  step = ds.instantiate_curr_step()
  ep = step.event.get_ep()
  wff = step.event.get_wff()
  if you_pred(wff):
    ds.add_to_context(parse_eventuality(NOOP_YOU, ep=ep))
  else:
    ds.add_to_context(parse_eventuality(NOOP_GEN, ep=ep))
  return True


def process_intended_step(event, ds):
  """TBC"""
  advance_plan = False
  bindings = {}

  wff = event.get_wff()
  action = get_action(wff)

  if action:
    step = ds.instantiate_curr_step()
    bindings = ACTION_DICT[action](step, ds)
    advance_plan = True

  for (var, val) in bindings.items():
    ds.bind(var, val)

  return advance_plan


def execute_say_to(step, ds):
  """TBC"""
  bindings = {}
  ep = step.event.get_ep()
  wff = step.event.get_wff()
  expr = wff[3]
  conversation_log = ds.get_conversation_log()

  # If argument is a variable, use response transducer to generate response
  if variablep(expr):
    conds = [] # TODO
    facts = [] # TODO
    utts = ds.apply_transducer('response', conversation_log, conds=conds, facts=facts)
    utt = utts[0] if utts and utts[0] else ''
    bindings[expr] = f'"{utt}"'
  else:
    utt = expr.strip('"')

  # Get affect of utterance and create Utterance object
  affect, words = parse_utt_str(utt)
  if not affect:
    affects = ds.apply_transducer('affect', words, conversation_log)
    affect = affects[0] if affect and affects[0] else EMOTIONS_LIST[0]
  utt = Utterance(words, affect)

  # Find and store additional gist clauses corresponding to Eta's utterance
  gists = ds.apply_transducer('gist', words, conversation_log)
  for e in [parse_eventuality([ME, PARAPHRASE_TO, YOU, f'"{gist}"'], ep=ep) for gist in gists]:
    ds.add_to_context(e)
  gists1 = ds.get_memory().get_characterizing_episode(PARAPHRASE_TO, ep)
  gists1 = [gist.event.get_wff()[3].strip('"') for gist in gists1]

  # Get semantics corresponding to Eta's utterance
  semantics1 = ds.get_memory().get_characterizing_episode(ARTICULATE_TO, ep)
  semantics1 = [sem.event.get_wff()[3] for sem in semantics1]

  # Get any obligations placed on the user from the schema this episode is part of
  obligations = step.get_obligations()

  # Log and write dialogue turn
  ds.log_turn(DialogueTurn(
    agent=ME,
    utterance=utt,
    gists=gists1,
    semantics=semantics1,
    pragmatics=[],
    obligations=obligations,
    ep=ep
  ))

  ds.push_output_buffer(utt)
  return bindings


def execute_say_bye(step, ds):
  """TBC"""
  ds.write_output_buffer()
  ds.set_quit_conversation(True)
  return {}


def you_pred(wff):
  return (isinstance(wff, list) and wff[0] == YOU) or (isinstance(wff, str) and wff.split()[0] == YOU)

def me_pred(wff):
  return (isinstance(wff, list) and wff[0] == ME) or (isinstance(wff, str) and wff.split()[0] == ME)

ACTION_DICT = {
  SAY_TO : execute_say_to,
  SAY_BYE : execute_say_bye
}

def say_to_step(wff):
  return listp(wff) and len(wff) >= 4 and wff[:3] == [ME, SAY_TO, YOU]

def say_bye_step(wff):
  return listp(wff) and len(wff) == 2 and wff[:1] == [ME, SAY_BYE]

def get_action(wff):
  if say_to_step(wff):
    return SAY_TO
  elif say_bye_step(wff):
    return SAY_BYE
  else:
    return None


def main():
  pass


if __name__ == "__main__":
  main()