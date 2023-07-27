import eta.util.file as file
from eta.util.gpt import generate_gpt

PROMPT_EXECUTE = file.read_file('resources/prompts/execute.txt')

def execute(plan):
  """List[str] -> List[str], str"""
  action = plan[0]
  rest = plan[1:]
  prompt = PROMPT_EXECUTE.replace('<action>', action)
  utt, _ = generate_gpt(prompt)
  return rest, utt


def main():
  plan = ['I say to you "Do you like skiing?"', 'I say goodbye to you']

  plan, utt = execute(plan)
  print(utt)
  print(plan)

  plan, utt = execute(plan)
  print(utt)
  print(plan)


if __name__ == "__main__":
  main()