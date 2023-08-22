from eta.util.tt.parse import *

def main():
  # trees, feats = from_lisp_file('avatars/sophie-gpt/rules/word-features.lisp')
  # print(feats)
  # print(isa('lortab', 'medicine-gen', feats))

  # trees, feats = from_lisp_file('avatars/sophie-gpt/rules/user-interpretation/gist/rules-for-yes-no.lisp')
  # print(trees.keys())
  # print(trees['match-affirm'])

  trees, feats = from_lisp_dirs(['avatars/sophie-gpt/rules', 'avatars/sophie-gpt/day1/rules'])
  print(trees.keys())
  print(feats.keys())


if __name__ == '__main__':
  main()