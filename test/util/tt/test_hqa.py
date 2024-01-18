import json

from eta.util.general import standardize
from eta.util.tt.choice import choose_result_for
from eta.util.tt.parse import from_lisp_dirs

def hqa_test():
  trees, feats, preds = from_lisp_dirs('agents/david-qa/rules')
  # print(trees.keys())

  with open('test/util/tt/hqa.json', 'r') as f:
    data = json.load(f)

  mappings = {}
  for turn in data:
    question = standardize(turn['question'])
    gist = choose_result_for(question.split(), 'spatial-question-input', trees, feats, preds)
    if gist[0] == ':gist':
      gist = gist[1][0]
    if isinstance(gist, list) and gist[0] == 'spatial-question':
      ulf = choose_result_for(gist, 'semantic', trees, feats, preds)
      if ulf[0] == ':ulf':
        ulf = ulf[1][0]
    else:
      ulf = None
    
    mappings[question] = ulf

  with open('test/util/tt/hqa_ulf.json', 'w') as f:
    json.dump(mappings, f)
  

def main():
  hqa_test()


if __name__ == '__main__':
  main()