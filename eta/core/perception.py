"""The core process responsible for perceiving and interpreting inputs and adding them to memory."""

from time import sleep

from eta.constants import *
import eta.util.file as file
from eta.discourse import Utterance, DialogueTurn, get_prior_turn
from eta.util.general import standardize, episode_name, append, remove_duplicates
from eta.lf import parse_eventuality

def perception_loop(ds):
  """Observe and interpret inputs from perceptual servers.

  The resulting observations are added to dialogue context, as well as
  to the ``observations`` and ``inferences`` buffers.

  In the case where the observed input is speech, this also interprets
  the input as a gist clause, as well as deriving the underlying semantic
  and pragmatic meanings. The input is also interpreted as a reply to
  the previous turn in the conversation log, if any. The observed turn
  is then added to the conversation log.
  
  Parameters
  ----------
  ds : DialogueState
  """
  while ds.do_continue():
    sleep(SLEEPTIME)

    # Observe all facts from registered perception servers
    for source in ds.get_perception_servers():
      inputs = observe(ds.get_io_path(f'{IO_IN_DIR}{source}.txt'))

      # Shortcut for quitting conversation
      if any([input == ':q' for input in inputs]):
        ds.set_quit_conversation(True)

      # Process utterances/observations
      if source == 'speech':
        observations = process_utterances(inputs, ds)
      else:
        observations = process_observations(inputs)
        
      ds.add_to_context(observations)
      ds.add_all_to_buffer(observations, 'observations')

      # Each observation is a new fact for inference with depth 0
      new_facts = [{'fact':o, 'depth':1} for o in observations]
      ds.add_all_to_buffer(new_facts, 'inferences')


def observe(source):
  """Collect all observations from a given perceptual server source.
  
  Parameters
  ----------
  source : str
    The name of the perceptual server (``speech`` in the special case
    of a user utterance).

  Returns
  -------
  list[str]
    A list of observations, each being either a natural language string
    or a LISP-formatted S-expression string representing a logical form.
  """
  if not file.exists(source):
    return []
  inputs = file.read_lines(source)
  file.remove(source)
  return inputs


def process_utterances(inputs, ds):
  """Process utterances by deriving gist clauses, semantics, pragmatics, and logging each turn.
  
  Parameters
  ----------
  inputs : list[str]
    A list of speech inputs to process as dialogue turns.
  ds : DialogueState
  
  Returns
  -------
  list[Eventuality]
    All eventualities derived from the input utterances.
  """
  observations = []
  for input in inputs:
    ep = episode_name()
    input = standardize(input)
    observations += [parse_eventuality([YOU, SAY_TO, ME, f'"{input}"'], ep=ep)]
    utt = Utterance(YOU, input)

    # Interpret gist clauses using conversation log
    conversation_log = ds.get_conversation_log()
    gists = remove_duplicates(ds.apply_transducer('gist', utt, conversation_log), order=True)
    observations += [parse_eventuality([YOU, PARAPHRASE_TO, ME, f'"{gist}"'], ep=ep) for gist in gists]

    # Interpret semantic meanings of gist clauses
    semantics = remove_duplicates(append([ds.apply_transducer('semantic', gist) for gist in gists]), order=True)
    observations += [parse_eventuality([YOU, ARTICULATE_TO, ME, semantic], ep=ep) for semantic in semantics]

    # Interpret pragmatic meanings of gist clauses
    pragmatics = remove_duplicates(append([ds.apply_transducer('pragmatic', gist) for gist in gists]), order=True)
    observations += [parse_eventuality(pragmatic, ep=ep) for pragmatic in pragmatics]

    # An utterance may always be considered a reply to the preceeding Eta turn, if any
    prior_turn = get_prior_turn(conversation_log, ME)
    if prior_turn:
      prior_ep = prior_turn.ep
      observations += [parse_eventuality([YOU, REPLY_TO, prior_ep], ep=ep)]

    # Add user turn to conversation log
    ds.log_turn(DialogueTurn(
      utterance=utt,
      gists=gists,
      semantics=semantics,
      pragmatics=pragmatics,
      ep=ep
    ))

  return remove_duplicates(observations, order=True)

  
def process_observations(inputs):
  """Process non-speech observations by parsing them as eventualities.
  
  Parameters
  ----------
  inputs : list[str]
    A list of observed facts, as either natural language strings or
    LISP-formatted S-expression strings.
  
  Returns
  -------
  list[Eventuality]
    All eventualities derived from the observations.
  """
  return [parse_eventuality(standardize(input)) for input in inputs]