from time import sleep

from eta.constants import *
import eta.util.file as file
from eta.discourse import Utterance, DialogueTurn, get_prior_turn
from eta.util.general import standardize, episode_name, append, remove_duplicates
from eta.lf import parse_eventuality

PROMPT_GIST = file.read_file('resources/prompts/gist.txt')

def perception_loop(ds):
  while ds.do_continue():
    sleep(.1)

    # Observe all facts from registered perception servers
    for source in ds.get_perception_servers():
      inputs = observe(ds.get_io_path(f'in/{source}.txt'))

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
      ds.add_all_to_buffer(observations, 'inferences')


def observe(source):
  """str -> List[str]"""
  if not file.exists(source):
    return []
  inputs = file.read_lines(source)
  file.remove(source)
  return inputs


def process_utterances(inputs, ds):
  """List[str], List[DialogueTurn] -> List[Eventuality]"""
  observations = []
  for input in inputs:
    ep = episode_name()
    input = standardize(input)
    observations += [parse_eventuality([YOU, SAY_TO, ME, f'"{input}"'], ep=ep)]

    # Interpret gist clauses using conversation log
    conversation_log = ds.get_conversation_log()
    gists = ds.apply_transducer('gist', input, conversation_log)
    observations += [parse_eventuality([YOU, PARAPHRASE_TO, ME, f'"{gist}"'], ep=ep) for gist in gists]

    # Interpret semantic meanings of gist clauses
    semantics = append([ds.apply_transducer('semantic', gist) for gist in gists])
    observations += [parse_eventuality([YOU, ARTICULATE_TO, ME, semantic], ep=ep) for semantic in semantics]

    # Interpret pragmatic meanings of gist clauses
    pragmatics = append([ds.apply_transducer('pragmatic', gist) for gist in gists])
    observations += [parse_eventuality(pragmatic, ep=ep) for pragmatic in pragmatics]

    # An utterance may always be considered a reply to the preceeding Eta turn, if any
    prior_turn = get_prior_turn(conversation_log, ME)
    if prior_turn:
      prior_ep = prior_turn.ep
      observations += [parse_eventuality([YOU, REPLY_TO, prior_ep], ep=ep)]

    # Add user turn to conversation log
    ds.log_turn(DialogueTurn(
      agent=YOU,
      utterance=Utterance(input),
      gists=gists,
      semantics=semantics,
      pragmatics=pragmatics,
      ep=ep
    ))

  return remove_duplicates(observations, order=True)

  
def process_observations(inputs):
  """List[str] -> List[Eventuality]"""
  return [parse_eventuality(standardize(input)) for input in inputs]
    

def main():
  pass


if __name__ == "__main__":
  main()