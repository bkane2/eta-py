from eta.util.general import *

def main():
	print(subst('a', 'b', ['a', 'b', ['x', 'y', 'b', ['b'], 'c', 'b']]))
	print(subst('x', ['a', 'b'], ['a', 'b', ['c', ['a', 'b'], ['a', 'b'], 'a', 'b', 'c', [['a', 'b']]]]))
	print(subst('a', 'b', 'b'))

	print(to_key([None, 'test.v', ['a', 'b']]))

	print(append(['a', 'b', 'c']))
	print(flatten(['a', 'b', 'c']))
	print(append([['a', 'b'], ['c', 'd']]))
	print(flatten([['a', 'b'], ['c', 'd']]))
	print(append([[['a', 'b'], ['c', 'd']], ['e', 'd']]))
	print(flatten([[['a', 'b'], ['c', 'd']], ['e', 'd']]))
	print(flatten([[['test string 1'], ['test string 2', 'test string 3']], ['test string 4', 'test string 5']]))

	clear_symtab()

	print(gentemp('teststr5'))
	print(gentemp('teststr5'))
     
	print(extract_category(['a', [2, 'b'], 3, 'c'],
                        lambda x: isinstance(x, int),
                        lambda x: len(x) <= 2))
  # -> (['a', [2, 'b'], 'c'], [3])
	

if __name__ == "__main__":
  main()