from eta.util.tt.match import *

def test_match():
  print(match('a', 'a'))      # --> 'a'
  print(match('!atom', 'a'))  # --> 'a'
  print(match('?atom', []))   # --> [':seq', []]
  print(match('!expr', []))   # --> []
  print(match('!atom', '3.14')) # --> 3.14
  print(match('?atom', 'a'))  # --> [':seq', 'a']
  print(match('*atom', 'a'))  # --> [':seq', 'a']
  print(match('+atom', 'a'))  # --> [':seq', 'a']

  print(match(['!expr', '*list', ['f', 'g'], '?atom', '!atom'],
               [['a'], ['b', 'c'], ['d', 'e'], ['f', 'g'], 'h']))
  # --> [['a'], [':seq', ['b', 'c'], ['d', 'e']], ['f', 'g'], [':seq'], 'h']

  print(match(['?expr', 'a', '3', 'e', '*list'],
               [['x', ['y', 'z']], 'a', ['b', 'c'], 'd', 'e', []]))
  # --> [[':seq', ['x', ['y', 'z']]], 'a', [':seq', ['b', 'c'], 'd'], 'e', [':seq', []]]

  print(match(['+expr', '!atom', '0'],
               [['a', 'b'], 'c', 'd', 'e', 'f', 'g']))
  # --> [[':seq', ['a', 'b']], 'c', [':seq', 'd', 'e', 'f', 'g']]
 
  print(match(['+expr', '!atom'],
               [['a', 'b'], 'c']))
  # --> [[':seq', ['a', 'b']], 'c']
 
  print(match(['*expr', '+atom'],
               ['a', 'b', 'c']))
  # --> [[':seq'], [':seq', 'a', 'b', 'c']]
 
  print(match(['!atom', ['a', 'b', '*list', 'c'], '?atom'],
               ['x', ['a', 'b', ['u'], ['v', 'w'], 'c'], 'd']))
  # --> ['x', ['a', 'b', [':seq', ['u'], ['v', 'w']], 'c'], [':seq', 'd']]
  
  print(match(['?atom', '+expr', ['*list', ['d', ['*atom', ['?atom']]]], '?expr'],
               [['a'], 'b', [['c'], ['d', ['e', 'f', ['g']]]], [['h']]]))
  # --> [[':seq'], [':seq', ['a'], 'b'], [[':seq', ['c']], ['d', [[':seq', 'e', 'f'], [[':seq', 'g']]]]], [':seq', [['h']]]]
 
  print(match(['.ADVP', '+expr'],
               ['PP', ['IN', 'on'], ['NNP', 'Monday']],
               feats={'PP':['ADVP']}))
  # --> ['PP', [':seq', ['IN', 'on'], ['NNP', 'Monday']]]

  print(match(['.dog', '.reptile', '.animal', '.animal', 'animal', 'lizard'],
               ['dog', 'snake', 'cat', 'lizard', 'animal', 'lizard'],
               feats={'dog':['animal'], 'cat':['animal'], 'reptile':['animal'], 'lizard':['reptile'], 'snake':['reptile']}))
  # --> ['dog', 'snake', 'cat', 'lizard', 'animal', 'lizard']

  print(match(['.dog', '.reptile', '.animal', '.animal', 'animal', 'lizard'],
               ['dog', 'cat', 'animal', 'animal', 'animal', 'lizard'],
               feats={'dog':['animal'], 'cat':['animal'], 'reptile':['animal'], 'lizard':['reptile'], 'snake':['reptile']}))
  # --> []

  print(match(['you', '!modal', '3', 'not', '0'],
               'you can not do that .'.split()))
  # --> ['you', 'can', [':seq'], 'not', [':seq', 'do', 'that', '.']]

  print(match(['you', '!modal', '3', 'not', '0'],
               'you can really not do that .'.split()))
  # --> ['you', 'can', [':seq', 'really'], 'not', [':seq', 'do', 'that', '.']]

  print(match(['you', '!modal', '3', 'not', '0'],
               'you can really really really really not do that .'.split()))
  # --> []

  print(match(['you', '!modal', '3', 'not', '0'],
               'you can not'.split()))
  # --> ['you', 'can', [':seq'], 'not', [':seq']]

  print(match(['i', 'have', '.num', 'dollars'],
               ['i', 'have', '5', 'dollars'],
               feats={'5':['num']}))
  # --> ['i', 'have', '5', 'dollars']

  print(match(['i', 'have', '5', 'dollars'],
               ['i', 'have', 'no', 'dollars'],
               feats={'5':['num']}))
  # --> ['i', 'have', [':seq', 'no'], 'dollars']

  m = match(['i', 'have', '.num', 'dollars'],
             ['i', 'have', '5', 'dollars'],
             feats={'5':['num']})
  print(fill_template(['I', 'believe', 'you', 'have', '3', 'dollars'], m))
  # --> ['I', 'believe', 'you', 'have', '5', 'dollars']

  m = match(['you', '!modal', '3', 'not', '0'],
               'you can really not do that thing .'.split())
  print(fill_template(['I', 'want', 'to', '5'], m))
  # --> ['I', 'want', 'to', 'do', 'that', 'thing', '.']

  m = match(['you', '!modal', '3', 'not', '0'],
               'you can really not do that thing .'.split())
  print(fill_template(['I', 'want', 'to', 'test!', '5'], m))
  # --> ['I', 'want', 'to', 'do that thing ._test']

  m = match(['!atom', ['a', 'b', '*list', 'c'], '?atom'],
             ['x', ['a', 'b', ['u'], ['v', 'w'], 'c'], 'd'])
  print(fill_template(['1', '2', '2.1', '2.3'], m))
  # --> ['x', ['a', 'b', ['u'], ['v', 'w'], 'c'], 'a', ['u'], ['v', 'w']]

  m = match(['where', '1', 'the', 'twitter', 'block', '?'],
             ['where', 'is', 'the', 'twitter', 'block', '?'])
  print(fill_template([['where.pro', [['lex-ulf!', 'v', '2'], ['the.d', [['lex-ulf!', 'name', '4'], 'block.n']]]], '?'], m))
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