from eta.util.tt.parse import *

def main():
  # trees, feats = from_lisp_file('agents/sophie-gpt/rules/word-features.lisp')
  # print(feats)
  # print(isa('lortab', 'medicine-gen', feats))

  # trees, feats = from_lisp_file('agents/sophie-gpt/rules/user-interpretation/gist/rules-for-yes-no.lisp')
  # print(trees.keys())
  # print(trees['match-affirm'])

  trees, feats, preds = from_lisp_dirs(['agents/sophie-gpt/rules', 'agents/sophie-gpt/day1/rules'])
  print(trees.keys())
  print(feats.keys())
  print(preds)


if __name__ == '__main__':
  main()