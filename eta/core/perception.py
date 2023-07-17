import eta.util.file as file
from eta.util.gpt import generate_gpt
from eta.util.general import *

PROMPT_GIST = file.read_file('docs/prompts/gist.txt')

def perceive(source):
  """str -> List[str]"""
  facts = file.read_lines(source)
  file.clear(source)
  if 'user' in source and facts:
    return flatten([process_utterance(utt) for utt in facts])
  else:
    return facts


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
  gist = generate_gpt(prompt)
  if gist == 'NONE':
    return None
  return gist


def main():
  print(perceive('io/user.txt'))


if __name__ == "__main__":
  main()