import eta.util.file as file
from eta.util.gpt import generate_gpt
from eta.util.general import *

PROMPT_PLAN = file.read_file('docs/prompts/plan.txt')

def plan(facts):
  prompt = PROMPT_PLAN.replace('<facts>', '\n'.join(facts))
  action, _ = generate_gpt(prompt)
  return [action]


def main():
  facts = [
    'Socrates is a man',
    'All men are mortal',
    'John went to the store yesterday',
    'Mary loves to paint',
    'you say to me "I like to go skiing."'
  ]
  p = plan(facts)
  print(p)


if __name__ == "__main__":
  main()