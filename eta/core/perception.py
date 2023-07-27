from time import sleep

import eta.util.file as file
from eta.util.gpt import generate_gpt
from eta.lf import Eventuality
import eta.util.buffer as buffer

PROMPT_GIST = file.read_file('resources/prompts/gist.txt')

def perception_loop(ds):
  while not ds.get_quit_conversation():
    sleep(.1)

    # 1. Observe all facts from registered perception servers
    for source in ds.get_perception_servers():
      speech = True if source in ['terminal', 'audio'] else False
      facts = observe(ds.get_io_path(f'{source}.txt'), speech=speech)
      if facts:
        ds.add_all_to_context(facts)
        ds.add_all_to_buffer(facts, 'perceptions')

        if any(['bye' in fact.nl for fact in facts]):
          ds.set_quit_conversation(True)

    # perception = ds.pop_buffer('perceptions')

    # 2. Interpret gist clauses for speech using previous conversation history,
    # adding "you paraphrase to me" fact to context and to queue for further processing

    # 3. Interpret other facts in context of current plan, adding new facts to context
    # and to queue for further processing

    
    


def observe(source, speech=False):
  """str -> List[Eventuality]"""
  inputs = file.read_lines(source)
  file.clear(source)
  
  if speech:
    facts = [Eventuality.from_input(f'(^you say-to.v ^me "{input}")') for input in inputs]
  else:
    facts = [Eventuality.from_input(input) for input in inputs]
  return facts
  # if 'user' in source and facts:
  #   return flatten([process_utterance(utt) for utt in facts])
  # else:
  #   return facts


def process_utterance(utt):
  """str -> (str, str)"""
  facts = [f'you say to me "{utt}"']
  gist = gist_interpretation(utt, prev_utt="I like skiing.")
  if gist:
    facts.append(f'you paraphrase to me "{gist}"')
  return facts


def gist_interpretation(utt, prev_utt=None):
  """str, Optional[str] -> str"""
  if not prev_utt:
    prev_utt = 'Hello.'
  prompt = PROMPT_GIST.replace('<utt>', utt).replace('<prev-utt>', prev_utt)
  gist, _ = generate_gpt(prompt)
  if gist == 'NONE':
    return None
  return gist


def main():
  for fact in observe('io/user.txt', speech=True):
    print(fact)


if __name__ == "__main__":
  main()