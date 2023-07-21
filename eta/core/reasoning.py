import re
from time import sleep

import eta.util.file as file
from eta.util.gpt import generate_gpt
from eta.util.general import *
from eta.lf import Fact
import eta.sessioninfo as sessioninfo

PROMPT_REASONING = file.read_file('docs/prompts/reasoning.txt')

def reasoning_loop(ds, cost):
  while not ds.get_quit_conversation():
    sleep(.1)

    # Make inferences from queue of interpretations
    facts = ds.pop_all_buffer('perceptions')

    if facts:
      for f in facts:
        print(f.nl)
      new_facts = reason(facts)
      ds.add_all_to_context(new_facts)

  with cost.get_lock():
    cost.value += sessioninfo.COST


def reasoning_validator(prompt, resp):
  facts = [l.strip() for l in resp.split('\n') if l.strip()]
  facts = [re.sub(r'^[0-9]*\. ', '', fact) for fact in facts]
  return facts


def reason(facts):
  """List[Fact] -> List[Fact]"""
  if not facts:
    return None
  facts_str = [fact.nl for fact in facts]
  prompt = PROMPT_REASONING.replace('<facts>', '\n'.join(facts_str))
  new_facts_str = generate_gpt(prompt, postprocessors=[reasoning_validator])
  new_facts = [Fact.from_input(fact) for fact in new_facts_str]
  return new_facts


def main():
  facts = [
    'Socrates is a man',
    'All men are mortal',
    'John went to the store yesterday',
    'Mary loves to paint',
    'you say to me "I like to go skiing."'
  ]
  facts = [Fact.from_input(fact) for fact in facts]
  new_facts = reason(facts)
  for fact in new_facts:
    print(fact)


if __name__ == "__main__":
  main()