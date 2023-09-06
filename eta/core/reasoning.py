"""The core process responsible for inferring new facts and possible actions to take from previous facts/observations."""

from time import sleep

from eta.constants import *
from eta.util.general import remove_duplicates

def reasoning_loop(ds):
  """Infer new facts and possible actions from previous facts/observations.

  First, all recent inferences are popped from the ``inferences`` buffer, and from
  these inferences, the system attempts to infer new facts in both a *top down* and
  a *bottom up* manner.
  
  A depth limit is imposed, such that only facts which are below some number of
  inference steps away from a direct observation are considered for further inference.
  Any inferred facts are added back to the ``inferences`` buffer, with a depth
  that is one greater than the minimum depth of the facts used to infer them.

  In the top down approach, the current state of the dialogue plan is used as
  the context for making inferences from each fact.

  In the bottom up approach, a set of relevant facts are retrieved from memory
  and used to make inferences from each fact.

  Second, all direct observations are popped from the ``observations`` buffer,
  and used to suggest possible actions that the system can take in reaction
  to those observations.
  
  Parameters
  ----------
  ds : DialogueState
  """
  while ds.do_continue():
    sleep(SLEEPTIME)

    # Infer new facts from prior facts (that haven't yet surpassed the depth limit)
    facts = ds.pop_all_buffer('inferences')
    if facts:
      min_depth = min([f['depth'] for f in facts])
      facts = [f['fact'] for f in facts if not f['depth'] > REASONING_DEPTH_LIMIT]

    new_facts = []
    new_facts += infer_top_down(facts, ds)
    new_facts += infer_bottom_up(facts, ds)
    ds.add_to_context(new_facts)
    new_facts = [{'fact':f, 'depth':min_depth+1} for f in new_facts]
    ds.add_all_to_buffer(new_facts, 'inferences')

    # Infer possible actions to take based on observations
    observations = ds.pop_all_buffer('observations')
    actions = suggest_possible_actions(observations, ds)
    ds.add_all_to_buffer(actions, 'actions')


def infer_top_down(facts, ds):
  """Infer new facts in a "top-down" manner, using the current expected/intended plan step as context.
  
  Parameters
  ----------
  facts : list[Eventuality]
    A list of facts to use for inference.
  ds : DialogueState

  Returns
  -------
  list[Eventuality]
    A list of inferred facts.
  """
  plan = ds.get_plan()
  if not plan or not facts:
    return []
  
  step = plan.step.event
  new_facts = remove_duplicates(ds.apply_transducer('reason-top-down', step, facts), order=True)
  return new_facts


def infer_bottom_up(facts, ds):
  """Infer new facts in a "bottom-up" manner, using relevant facts in memory.
  
  Parameters
  ----------
  facts : list[Eventuality]
    A list of facts to use for inference.
  ds : DialogueState

  Returns
  -------
  list[Eventuality]
    A list of inferred facts.

  Notes
  -----
  TODO: still need to implement retrieval of relevant facts from memory (and generic knowledge?).
  """
  if not facts:
    return []
  
  new_facts = remove_duplicates(ds.apply_transducer('reason-bottom-up', facts), order=True)
  return new_facts


def suggest_possible_actions(observations, ds):
  """Suggest possible actions to take in reaction to a list of observations.

  Parameters
  ----------
  observations : list[Eventuality]
    A list of observed events to use for reaction.
  ds : DialogueState

  Returns
  -------
  list[str]
    A list of possible actions (as natural language strings or
    LISP-formatted S-expression strings).

  Notes
  -----
  TODO: some possible future improvements:
    1. Reconsider previous failed plan steps as possible actions to retry.
    2. Consider the system's desires, and/or obligations placed on the system,
       as well as observations, in considering possible actions.
    3. Allow urgency scores to be included in the transducer results, allowing
       for differential priority for different kinds of possible actions (e.g.,
       even in a simple chit-chat domain, we may wish for answering a question to
       have a higher urgency than responding to a statement.)
  """
  actions = []
  for observation in observations:
    actions += ds.apply_transducer('reaction', observation)
  return actions