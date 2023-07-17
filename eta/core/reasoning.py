import re

import eta.util.file as file
from eta.util.gpt import generate_gpt
from eta.util.general import *

PROMPT_REASONING = file.read_file('docs/prompts/reasoning.txt')

def reasoning_validator(prompt, resp):
  facts = [l.strip() for l in resp.split('\n') if l.strip()]
  facts = [re.sub(r'^[0-9]*\. ', '', fact) for fact in facts]
  return facts


def reason(facts):
  """List[str] -> List[str]"""
  if not facts:
    return None
  prompt = PROMPT_REASONING.replace('<facts>', '\n'.join(facts))
  new_facts = generate_gpt(prompt, postprocessors=[reasoning_validator])
  return new_facts


def main():
  facts = [
    'Socrates is a man',
    'All men are mortal',
    'John went to the store yesterday',
    'Mary loves to paint',
    'you say to me "I like to go skiing."'
  ]
  new_facts = reason(facts)
  print(new_facts)


if __name__ == "__main__":
  main()