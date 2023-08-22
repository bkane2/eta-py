from eta.util.general import *

def main():
	print(swap_duals("i told you that i think you know that's not true ."))
	print(swap_duals("but you said that i think you know that's not true ."))

	print(decompress("i'm gonna go to the store tomorrow, what're you doing?"))
	print(compress("you are not going to do that. you can not do that."))

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
	

if __name__ == "__main__":
  main()