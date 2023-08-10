import re
import random
import string
from datetime import datetime
from copy import copy

import eta.util.file as file

# ``````````````````````````````````````
# "Symbol" util
# ``````````````````````````````````````

SYMTAB_PATH = 'io/symtab.json'

def clear_symtab():
	file.write_json(SYMTAB_PATH, {})


def gentemp(str):
	"""
	str -> str
	````````````````
	Generates a unique copy of a "symbol" (string) that hasn't been
	used before by appending an integer suffix i and then incrementing i.
	NOTE: this relies on read/writes to an external symbol table, which exploits the
	fact that race conditions with a shared file cannot occur with Python multiprocess
	(see: https://superfastpython.com/multiprocessing-race-condition-python/#Race_Condition_With_Shared_Data-2)
	However, this is somewhat clumsy/inefficient and should eventually be replaced by a proper solution.
	"""
	symtab = file.load_json(SYMTAB_PATH)
	if not str in symtab:
		symtab[str] = 1
	else:
		symtab[str] += 1
	file.write_json(SYMTAB_PATH, symtab)
	return f'{str}{symtab[str]}'


def episode_name():
	return gentemp('e')


def episode_var():
	return gentemp('?e')


def escaped_symbol_p(s):
	return isinstance(s, str) and len(s) >= 2 and s.count('|') == 2


def symbolp(s):
	return isinstance(s, str)


def variablep(s):
	"""Check whether a symbol is a variable, i.e., starts with '?' or '!'.
		 NOTE: for now, this excludes indexical variables, such as '^you'."""
	return symbolp(s) and s[0] in ['?', '!'] and s not in ['?', '!']


def dual_var(ep_var):
	"""Given an episode variable like ?e1, return the non-fluent dual
		 of that variable, e.g., !e1 (and vice-versa if !e1 is given)."""
	if variablep(ep_var):
		return '!'+ep_var[1:] if ep_var[0] == '?' else '?'+ep_var[1:]
	else:
		return ''
	

def duplicate_var(var):
	"""Given a variable, duplicate the variable by generating a new variable
	   symbol with the initial variable as a prefix (stripping any trailing numbers)."""
	if not variablep(var):
		return var
	else:
		return gentemp(var.rstrip(string.digits))


# ``````````````````````````````````````
# String util
# ``````````````````````````````````````


def replaceall(str, replist):
	for tup in replist:
		if len(tup) == 3:
			a, b, is_regex = tup
		else:
			a, b = tup
			is_regex = False
		if is_regex:
			str = re.sub(a, b, str)
		else:
			str = str.replace(a, b)
	return str


def indent(n):
	return "  "*(n-1)


def standardize(str):
	str = str.replace('--', '-').replace('_', ' ')
	str = re.sub(r'([.|,|!|?|:|;|-])', r' \1 ', str)
	str = re.sub(r'[\s]+', ' ', str)
	return str.strip()



# ``````````````````````````````````````
# List util
# ``````````````````````````````````````



def rec_replace(old, new, lst):
	if lst == old:
		return new

	new_lst = []
	for e in lst:
		if e == old:
			new_lst.append(new)
		elif type(e) == list:
			new_lst.append(rec_replace(old, new, e))
		else:
			new_lst.append(e)

	return new_lst


def rec_remove(target, lst):
	new_lst = []
	for e in lst:
		if e == target:
			continue
		elif type(e) == list:
			new_lst.append(rec_remove(target, e))
		else:
			new_lst.append(e)

	return new_lst


def listp(lst):
	return isinstance(lst, list)


def cons(lst1, lst2):
	if listp(lst2):
		return [lst1] + lst2
	elif isinstance(lst2, set):
		return {lst1} | lst2
	else:
		return [lst1, lst2]
	

def atom(lst):
	return not lst or not listp(lst)


def append(lst):
  return [x for l in lst for x in l]


def flatten(lst):
	if not listp(lst):
		return [lst]
	else:
		return append([flatten(x) for x in lst])
	

def remove_duplicates(lst, order=False):
	"""Remove duplicate items in a list.
		 If preserving order is important, specify order=True"""
	if order:
		visited = []
		lst1 = []
		for l in lst:
			if not l in visited:
				lst1.append(l)
				visited.append(l)
		return lst1
	else:
		return list(set(lst))
	

def subst(a, b, lst):
	def subst_rec(a, b, x):
		if x == b:
			return a
		elif atom(x):
			return x
		else:
			return [subst_rec(a, b, y) for y in x]
	return subst_rec(a, b, lst)


def substall(lst, replist):
	# Note that the order of var/val in replist is reversed
	for (b, a) in replist:
		lst = subst(a, b, lst)
	return lst


def random_element(lst):
	return random.choice(lst)


def get_keyword_contents(lst, keys):
	"""Gets the contents corresponding to a list of keywords in a record structure
	   (assuming the contents are a single element initially following the keyword)."""
	return [e2 for (e1, e2) in zip(lst, lst[1:]+[None]) if e1 in keys and e2]


def to_key(lst):
	"""Converts a list to a valid dict key consisting of only tuples and strings."""
	if lst is None:
		return None
	if atom(lst):
		return str(lst)
	else:
		return tuple([to_key(x) for x in lst])



# ``````````````````````````````````````
# Dict util
# ``````````````````````````````````````



def dict_substall_keys(dct, replist):
	# Rep b with a
	for (b, a) in replist:
		dct = { (a if var==b else var):val for var, val in dct.items() }
	return dct


def cons_dict(dct, k, v):
	"""Adds v to the list at key k in dct, creating a new list if none exists."""
	if k in dct:
		dct[k].append(v)
	else:
		dct[k] = [v]


def dict_get(dct, k):
	"""Safe version of dict accessor that returns an empty list if key is not found."""
	if k in dct:
		return copy(dct[k])
	else:
		return []


def dict_rem_val(dct, k, val):
	"""Safe version of dict remove that removes val from the list stored at key (or pops
	   the key if it stores an atom)."""
	if k in dct:
		if isinstance(dct[k], list):
			dct[k].remove(val)
		else:
			dct.pop(k)


def dict_rem(dct, k):
	"""Safe version of dict pop that removes a key from the dict."""
	if k in dct:
		dct.pop(k)



# ``````````````````````````````````````
# Discourse util
# ``````````````````````````````````````



CONTRACTIONS = file.load_json('resources/lexical/contractions.json')
NEGPAIRS = file.load_json('resources/lexical/negpairs.json')
DUALS = file.load_json('resources/lexical/duals.json')


def decompress(str):
	"""Replaces contractions (e.g. 'don't' or 'dont' by 'do not')"""
	def decompress_rec(words):
		if not words:
			return []
		elif words[0] in CONTRACTIONS:
			return cons(CONTRACTIONS[words[0]], decompress_rec(words[1:]))
		else:
			return cons(words[0], decompress_rec(words[1:]))
	return ' '.join(decompress_rec(str.split()))


def compress(str):
	"""Replaces auxiliary-NOT combinations by -N'T contractions"""
	def compress_rec(words):
		if not words:
			return []
		elif not words[1:]:
			return words
		elif words[1] == 'not' and words[0] in NEGPAIRS:
			return cons(NEGPAIRS[words[0]], compress_rec(words[2:]))
		else:
			return cons(words[0], compress_rec(words[1:]))
	return ' '.join(compress_rec(str.split()))


def presubst(str):
	"""
	This function is applied to a string prior to calling the
	dual function. It helps avoid ungrammatical substitutions
	such as "why do you say i are stupid", while still correctly
	producing "why do you say your brothers are stupid".

	It replaces "are" by "are2" when preceded or followed by "you";
	similarly, it replaces "were" by "were2" and "was" by "was2".

	It also replaces "you" by "you2" when it is the last word, or
	when it is not one of the first two words and is not preceded by
	certain conjunctions ("and", "or", "but", "that", "because", "if",
	"when", "then", "why", ...), or certain subordinating verbs ("think",
	"believe", "know", ...), or when it follows "to".

	This is in preparation for replacement of "you2" by "me" (rather than "i")
	when dual is applied.
	"""
	re_punct = ['?','!',',','.',':',';']
	re_blocker = ['and', 'or', 'but', 'that', 'because', 'if', 'so', 'when', 'then', 'why',
			  				'think', 'see', 'guess', 'believe', 'hope', 'do', 'can', 'would', 'should',
								'than', 'know', 'i', 'you', '-', '--']
	str = replaceall(str, [
		("you are", "you1 are2", False),
		("are you", "are2 you1", False),
		("i was", "i was2", False),
		("was i", "was2 i", False),
		("you were", "you1 were2", False),
		("were you", "were2 you1", False),
		(fr"you ([{'|'.join(re_punct)}])", r"you2 \1", True),
		("to you", "to you2", False),
	])
	str = str.replace('you', 'you0')
	str = replaceall(str, [
		(r"^you0", r"you", True),
		(r"^([\S]+) you0", r"\1 you", True),
		(fr"([{'|'.join(re_punct)}]) you0", r"\1 you", True),
		(fr"([{'|'.join(re_punct)}]) ([\S]+) you0", r"\1 \2 you", True),
		(fr"({'|'.join(re_blocker)}) you0", r"\1 you", True)
	])
	return str.replace('you0', 'you2')


def swap_duals(str):
	"""Replaces 'I' by 'you', 'you' by 'I', 'my' by 'your', etc."""
	def swap_duals_rec(words):
		if not words:
			return []
		elif words[0] in DUALS:
			return cons(DUALS[words[0]], swap_duals_rec(words[1:]))
		else:
			return cons(words[0], swap_duals_rec(words[1:]))
	str = presubst(str)
	return ' '.join(swap_duals_rec(str.split()))



# ``````````````````````````````````````
# Time util
# ``````````````````````````````````````



def get_time():
	now = datetime.now()
	time = now.strftime(":year/%Y/:month/%m/:day/%d/:hour/%H/:minute/%M/:sec/%S").split('/')
	return ['$', 'date+time']+time



# ``````````````````````````````````````
# 
# ``````````````````````````````````````

def main():
	print(swap_duals("i told you that i think you know that's not true ."))
	print(swap_duals("but you said that i think you know that's not true ."))

	print(decompress("i'm gonna go to the store tomorrow, what're you doing?"))
	print(compress("you are not going to do that. you can not do that."))

	print(subst('a', 'b', ['a', 'b', ['x', 'y', 'b', ['b'], 'c', 'b']]))
	print(subst('x', ['a', 'b'], ['a', 'b', ['c', ['a', 'b'], ['a', 'b'], 'a', 'b', 'c', [['a', 'b']]]]))
	print(subst('a', 'b', 'b'))

	print(get_time())

	print(to_key([None, 'test.v', ['a', 'b']]))

	# print(append(['a', 'b', 'c']))
	# print(flatten(['a', 'b', 'c']))
	# print(append([['a', 'b'], ['c', 'd']]))
	# print(flatten([['a', 'b'], ['c', 'd']]))
	# print(append([[['a', 'b'], ['c', 'd']], ['e', 'd']]))
	# print(flatten([[['a', 'b'], ['c', 'd']], ['e', 'd']]))
	# print(flatten([[['test string 1'], ['test string 2', 'test string 3']], ['test string 4', 'test string 5']]))

	# clear_symtab()

	# print(gentemp('teststr5'))
	# print(gentemp('teststr5'))
	

if __name__ == "__main__":
  main()