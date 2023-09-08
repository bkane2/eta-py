from eta.util.tt.choice import choose_result_for
from eta.util.tt.parse import from_lisp_dirs


def latency_test():
  trees, feats, preds = from_lisp_dirs('agents/test/rules')

  lst = ['test', 'string', 'one', '.']
  print(choose_result_for(lst, 'latency-test', trees, feats, preds))
  print(choose_result_for(lst, 'latency-test', trees, feats, preds))
  print(choose_result_for(lst, 'latency-test', trees, feats, preds))
  print(choose_result_for(lst, 'latency-test', trees, feats, preds))
  print(choose_result_for(lst, 'latency-test', trees, feats, preds))
  print(choose_result_for(lst, 'latency-test', trees, feats, preds))
  print(choose_result_for(lst, 'latency-test', trees, feats, preds))
  print(choose_result_for(lst, 'latency-test', trees, feats, preds))
  print(choose_result_for(lst, 'latency-test', trees, feats, preds))


def david_test():
  trees, feats, preds = from_lisp_dirs('agents/david-qa/rules')
  # print(trees.keys())

  print(choose_result_for("that is enough for now .".split(),
                          'spatial-question-input',
                          trees,
                          feats,
                          preds))
  
  print(choose_result_for("bye .".split(),
                          'spatial-question-input',
                          trees,
                          feats,
                          preds))

  print(choose_result_for('where is the twitter block ?'.split(),
                          'spatial-question-input',
                          trees,
                          feats,
                          preds))
  
  print(choose_result_for('can you answer modal questions ?'.split(),
                          'spatial-question-input',
                          trees,
                          feats,
                          preds))
  
  print(choose_result_for('here is my question is the mcdonalds blocked to the left of the twitter talk ?'.split(),
                          'spatial-question-input',
                          trees,
                          feats,
                          preds))
  
  print(choose_result_for(['spatial-question', 'is', 'the', 'mcdonalds', 'block', 'to_the_left_of', 'the', 'twitter', 'block', '?'],
                          'semantic',
                          trees,
                          feats,
                          preds))


def sophie_test():
  trees, feats, preds = from_lisp_dirs(['agents/sophie-gpt/rules', 'agents/sophie-gpt/day1/rules'])
  # print(trees.keys())

  print(choose_result_for(['do', 'i', 'need', 'chemotherapy', '?'],
                          'gist-clause-trees-for-input',
                          trees,
                          feats,
                          preds))
  
  print(choose_result_for(['my', 'lortab', 'has', 'not', 'been', 'working', 'recently', '.'],
                          'gist-clause-trees-for-input',
                          trees,
                          feats,
                          preds))
  
  print(choose_result_for(['what', 'are', 'my', 'options', 'for', 'treatment', '?'],
                          'gist-clause-trees-for-input',
                          trees,
                          feats,
                          preds))

  print(choose_result_for([],
                          'gist-clause-trees-for-input',
                          trees,
                          feats,
                          preds))
  
  print(choose_result_for('i wish i could say no , but unfortunately your cancer has spread .'.split(),
                          '*cancer-worse-input*',
                          trees,
                          feats,
                          preds))
  
  print(choose_result_for('where does it hurt the most ?'.split(),
                          '*general-input*',
                          trees,
                          feats,
                          preds))
  
  print(choose_result_for([[], 'yes , i think that would be the best option .'.split()],
                           '*gist*',
                           trees,
                           feats,
                           preds))
  
  print(choose_result_for([[], 'where is your pain located ?'.split()],
                           '*gist*',
                           trees,
                           feats,
                           preds))
  

def main():
  sep = '\n----------------------------\n'
  latency_test()
  print(sep)
  david_test()
  print(sep)
  sophie_test()
  print(sep)


if __name__ == '__main__':
  main()