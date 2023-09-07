"""The core process responsible for executing primitive actions and matching expected events."""

from time import sleep

import eta.util.time as time
from eta.constants import *
from eta.util.general import listp, variablep
from eta.util.time import has_elapsed_certainty_period
from eta.discourse import DialogueTurn, Utterance, parse_utt_str
from eta.lf import Condition, Repetition, parse_eventuality

def execution_loop(ds):
  """Either execute the current intended step of the plan or attempt to match an expectation.

  This will do one of several things depending on the class of the currently pending step:

    1. If a condition or repetition step, advance the plan once none of the conditions are true.

    2. If an expected step, attempt to match the step to a fact in context, until a time period
       based on the certainty of that step has elapsed, in which case the step is characterized
       as a failure and the plan is advanced.

    3. If an intended step that contains a primitive action, attempt to execute that action, and
       advance the plan if successful.

  In any the case where an execution or match is successful, the plan is advanced, and a list of
  variable bindings obtained from the execution or match is applied throughout the dialogue state.
  Additionally, if the plan was advanced, the contents of the 'plans' buffer is replaced with
  the modified plan.
  
  Note that, if the plan wasn't advanced but the step is a condition or repetition step,
  the plan is still added to the 'plans' buffer, but only if currently empty. This is because
  the condition may change with any observation, so the planning loop must constantly check for
  possible expansions of that step.
  
  Parameters
  ----------
  ds : DialogueState
  """
  while ds.do_continue():
    sleep(SLEEPTIME)

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
  """Process a condition step by advancing only if none of the condition are true.
  
  Parameters
  ----------
  event : Condition
    The condition step to process.
  ds : DialogueState

  Returns
  -------
  bool
    Whether to advance the plan.
  """
  for (condition, _) in event.conditions:
    if condition == True or ds.eval_truth_value(condition.get_formula()):
      return False
  ds.instantiate_curr_step()
  return True


def process_repetition_step(event, ds):
  """Process a repetition step by advancing only if the condition is satisfied.
  
  Parameters
  ----------
  event : Repetition
    The repetition step to process.
  ds : DialogueState

  Returns
  -------
  bool
    Whether to advance the plan.
  """
  if not ds.eval_truth_value(event.condition.get_formula()):
    return False
  ds.instantiate_curr_step()
  return True


def process_expected_step(event, ds):
  """Process an expected step by failing it if the waiting period has elapsed, or matching it to a fact in context.

  Since an expected user step indicates the user's dialogue turn, we also write the current output buffer at this point.

  The dialogue context is flushed of "telic" predicates, i.e., those assumed to be essentially instantaneous,
  after a successful match (we assume that such predicates may only be used once in a match before becoming outdated).
  
  Parameters
  ----------
  event : Eventuality
    The expected step to process.
  ds : DialogueState

  Returns
  -------
  bool
    Whether to advance the plan.
  """
  # It is assumed that it is time to write output and listen for input if expected user turn
  if you_pred(event.get_wff()):
    ds.write_output_buffer()

  # If the timer exceeds period (function of certainty of step), instantiate a 'failed' episode
  certainty = event.prob
  if has_elapsed_certainty_period(time.now() - ds.get_step_failure_timer(), certainty):
    return fail_curr_step(event, ds)

  # Otherwise, inquire about truth of the immediately pending episode, and advance accordingly
  match = inquire_truth_of_curr_step(event, ds)
  if match:
    ds.flush_context()
  return match


def inquire_truth_of_curr_step(event, ds):
  """Attempt to match an expected event to a fact in context.

  If a match is successful, this will bind all variables unified in the match
  throughout the dialogue state.
  
  Parameters
  ----------
  event : Eventuality
    The expected step to attempt to match.
  ds : DialogueState

  Returns
  -------
  bool
    Whether the match was successful.
  """
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
  """Characterize the current step as a failure using a special 'no-op' predicate.
  
  Parameters
  ----------
  event : Eventuality
    The expected step to fail.
  ds : DialogueState

  Returns
  -------
  bool
    Whether to advance the plan.
  """
  step = ds.instantiate_curr_step()
  ep = step.event.get_ep()
  wff = step.event.get_wff()
  if you_pred(wff):
    ds.add_to_context(parse_eventuality(NOOP_YOU, ep=ep))
  else:
    ds.add_to_context(parse_eventuality(NOOP_GEN, ep=ep))
  return True


def process_intended_step(event, ds):
  """Process an intended step by attempting to map it to a primitive action to execute.
  
  If an action was successfully executed, the action returns variable bindings that are
  then applied throughout the dialogue state.
  
  Parameters
  ----------
  event : Eventuality
    The expected step to fail.
  ds : DialogueState

  Returns
  -------
  bool
    Whether to advance the plan.
  """
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
  """Execute a say-to step.
  
  This will create a response and affect using the corresponding transducers,
  as well as potentially deriving a gist clause and semantic interpretation
  from the response. Any obligations are retrieved from the step as well.
  The resulting dialogue turn is added to the conversation log and pushed onto
  the output buffer.

  Parameters
  ----------
  step : PlanStep
    The say-to step to execute.
  ds : DialogueState

  Returns
  -------
  dict
    Dict of variable bindings obtained in the course of execution.
  """
  bindings = {}
  ep = step.event.get_ep()
  wff = step.event.get_wff()
  expr = wff[3]
  conversation_log = ds.get_conversation_log()

  # If argument is a variable, use response transducer to generate response
  if variablep(expr):
    facts_bg, facts_fg = ds.retrieve_facts()
    utts = ds.apply_transducer('response', conversation_log, facts_bg, facts_fg)
    utt = utts[0] if utts and utts[0] else ''
    bindings[expr] = f'"{utt}"'
  else:
    utt = expr.strip('"')

  # Get affect of utterance and create Utterance object
  affect, words = parse_utt_str(utt)
  if not affect:
    affects = ds.apply_transducer('affect', words, conversation_log)
    affect = affects[0] if affects and affects[0] else EMOTIONS_LIST[0]
  utt = Utterance(words, affect)

  # Find and store additional gist clauses corresponding to Eta's utterance
  gists = ds.apply_transducer('gist', utt, conversation_log)
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
  """Execute a say-bye step.
  
  This will signal that the conversation should be ended immediately, setting
  the quit_conversation flag to True in the dialogue state and writing the remaining
  output buffer.

  Parameters
  ----------
  step : PlanStep
    The say-to step to execute.
  ds : DialogueState

  Returns
  -------
  dict
    Dict of variable bindings obtained in the course of execution.
  """
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
  return listp(wff) and len(wff) == 2 and wff[:2] == [ME, SAY_BYE]

def get_action(wff):
  if say_to_step(wff):
    return SAY_TO
  elif say_bye_step(wff):
    return SAY_BYE
  else:
    return None