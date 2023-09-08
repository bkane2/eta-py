from transduction import tt
from eta.util.tt.preds import *
from agents.test.rules.preds import test

tt.register_pred(comma)
tt.register_pred(zero)
tt.register_pred(non_neg)
tt.register_pred(non_neg_mod)
tt.register_pred(affirm_adv)
tt.register_pred(modal)
tt.register_pred(test)
tt.register_pred(lex_ulf)
tt.register_pred(quote_to_list)
tt.register_pred(split_sentences)
tt.register_pred(prefix_each)


def test_match():
  print(tt.match('a', 'a'))      # --> 'a'
  print(tt.match('!atom', 'a'))  # --> 'a'
  print(tt.match('?atom', []))   # --> [':seq', []]
  print(tt.match('!expr', []))   # --> []
  print(tt.match('!atom', '3.14')) # --> 3.14
  print(tt.match('?atom', 'a'))  # --> [':seq', 'a']
  print(tt.match('*atom', 'a'))  # --> [':seq', 'a']
  print(tt.match('+atom', 'a'))  # --> [':seq', 'a']

  print(tt.match(['!expr', '*list', ['f', 'g'], '?atom', '!atom'],
               [['a'], ['b', 'c'], ['d', 'e'], ['f', 'g'], 'h']))
  # --> [['a'], [':seq', ['b', 'c'], ['d', 'e']], ['f', 'g'], [':seq'], 'h']

  print(tt.match(['?expr', 'a', '3', 'e', '*list'],
               [['x', ['y', 'z']], 'a', ['b', 'c'], 'd', 'e', []]))
  # --> [[':seq', ['x', ['y', 'z']]], 'a', [':seq', ['b', 'c'], 'd'], 'e', [':seq', []]]

  print(tt.match(['+expr', '!atom', '0'],
               [['a', 'b'], 'c', 'd', 'e', 'f', 'g']))
  # --> [[':seq', ['a', 'b']], 'c', [':seq', 'd', 'e', 'f', 'g']]
 
  print(tt.match(['+expr', '!atom'],
               [['a', 'b'], 'c']))
  # --> [[':seq', ['a', 'b']], 'c']
 
  print(tt.match(['*expr', '+atom'],
               ['a', 'b', 'c']))
  # --> [[':seq'], [':seq', 'a', 'b', 'c']]
 
  print(tt.match(['!atom', ['a', 'b', '*list', 'c'], '?atom'],
               ['x', ['a', 'b', ['u'], ['v', 'w'], 'c'], 'd']))
  # --> ['x', ['a', 'b', [':seq', ['u'], ['v', 'w']], 'c'], [':seq', 'd']]
  
  print(tt.match(['?atom', '+expr', ['*list', ['d', ['*atom', ['?atom']]]], '?expr'],
               [['a'], 'b', [['c'], ['d', ['e', 'f', ['g']]]], [['h']]]))
  # --> [[':seq'], [':seq', ['a'], 'b'], [[':seq', ['c']], ['d', [[':seq', 'e', 'f'], [[':seq', 'g']]]]], [':seq', [['h']]]]
 
  print(tt.match(['.ADVP', '+expr'],
               ['PP', ['IN', 'on'], ['NNP', 'Monday']],
               feats={'PP':['ADVP']}))
  # --> ['PP', [':seq', ['IN', 'on'], ['NNP', 'Monday']]]

  print(tt.match(['.dog', '.reptile', '.animal', '.animal', 'animal', 'lizard'],
               ['dog', 'snake', 'cat', 'lizard', 'animal', 'lizard'],
               feats={'dog':['animal'], 'cat':['animal'], 'reptile':['animal'], 'lizard':['reptile'], 'snake':['reptile']}))
  # --> ['dog', 'snake', 'cat', 'lizard', 'animal', 'lizard']

  print(tt.match(['.dog', '.reptile', '.animal', '.animal', 'animal', 'lizard'],
               ['dog', 'cat', 'animal', 'animal', 'animal', 'lizard'],
               feats={'dog':['animal'], 'cat':['animal'], 'reptile':['animal'], 'lizard':['reptile'], 'snake':['reptile']}))
  # --> []

  print(tt.match(['you', '!modal', '3', 'not', '0'],
               'you can not do that .'.split()))
  # --> ['you', 'can', [':seq'], 'not', [':seq', 'do', 'that', '.']]

  print(tt.match(['you', '!modal', '3', 'not', '0'],
               'you can really not do that .'.split()))
  # --> ['you', 'can', [':seq', 'really'], 'not', [':seq', 'do', 'that', '.']]

  print(tt.match(['you', '!modal', '3', 'not', '0'],
               'you can really really really really not do that .'.split()))
  # --> []

  print(tt.match(['you', '!modal', '3', 'not', '0'],
               'you can not'.split()))
  # --> ['you', 'can', [':seq'], 'not', [':seq']]

  print(tt.match(['i', 'have', '.num', 'dollars'],
               ['i', 'have', '5', 'dollars'],
               feats={'5':['num']}))
  # --> ['i', 'have', '5', 'dollars']

  print(tt.match(['i', 'have', '5', 'dollars'],
               ['i', 'have', 'no', 'dollars'],
               feats={'5':['num']}))
  # --> ['i', 'have', [':seq', 'no'], 'dollars']

  m = tt.match(['i', 'have', '.num', 'dollars'],
             ['i', 'have', '5', 'dollars'],
             feats={'5':['num']})
  print(tt.fill_template(['I', 'believe', 'you', 'have', '3', 'dollars'], m))
  # --> ['I', 'believe', 'you', 'have', '5', 'dollars']

  m = tt.match(['you', '!modal', '3', 'not', '0'],
               'you can really not do that thing .'.split())
  print(tt.fill_template(['I', 'want', 'to', '5'], m))
  # --> ['I', 'want', 'to', 'do', 'that', 'thing', '.']

  m = tt.match(['you', '!modal', '3', 'not', '0'],
               'you can really not do that thing .'.split())
  print(tt.fill_template(['I', 'want', 'to', 'test!', '5'], m))
  # --> ['I', 'want', 'to', 'do that thing ._test']

  m = tt.match(['!atom', ['a', 'b', '*list', 'c'], '?atom'],
             ['x', ['a', 'b', ['u'], ['v', 'w'], 'c'], 'd'])
  print(tt.fill_template(['1', '2', '2.1', '2.3'], m))
  # --> ['x', ['a', 'b', ['u'], ['v', 'w'], 'c'], 'a', ['u'], ['v', 'w']]

  m = tt.match(['where', '1', 'the', 'twitter', 'block', '?'],
             ['where', 'is', 'the', 'twitter', 'block', '?'])
  print(tt.fill_template([['where.pro', [['lex-ulf!', 'v', '2'], ['the.d', [['lex-ulf!', 'name', '4'], 'block.n']]]], '?'], m))
  # --> [['where.pro', [['pres', 'be.v'], ['the.d', ['|Twitter|', 'block.n']]]], '?']

 
def main():
  # print(flatten_sequences(['x', ['y', 'z'], [':seq', ['a', 'b'], 'c', ['d', ['f', 'g']]], 'u', [':seq', 'v', ['w', 'w']]]))

  # print(indexed_element_of(['a', ['b', 'c'], 'd'], 2))
  # print(indexed_element_of(['a', ['b', 'c'], 'd'], [2, 1]))
  # print(indexed_element_of(['a', ['b', ['c', 'd'], 'e'], ['f', 'g']], [2, 2, 2]))

  # print(val('*non-neg', 'alfalfa'))

  # feats = {'dog':['animal'], 'cat':['animal'], 'reptile':['animal'], 'lizard':['reptile'], 'snake':['reptile']}
  # print(isa('dog', 'dog', feats))
  # print(isa('dog', 'cat', feats))
  # print(isa('dog', 'animal', feats))
  # print(isa('dog', 'reptile', feats))
  # print(isa('snake', 'reptile', feats))

  test_match()

  # print(check_position_index_syntax('1.2.5'))
  # print(position_index('test'))
  # print(position_index('3'))
  # print(position_index('1.3.2'))


if __name__ == '__main__':
  main()