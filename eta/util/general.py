"""Generic utility functions for various basic data types."""

import re
import numpy as np
import random
import string
from copy import copy

from eta.constants import SYMTAB_PATH
import eta.util.file as file

# ``````````````````````````````````````
# "Symbol" util
# ``````````````````````````````````````

def clear_symtab():
	"""Clear the symbol table used for creating new symbols."""
	file.write_json(SYMTAB_PATH, {})


def gentemp(str):
	"""Generate a unique symbol that hasn't been used before by appending an integer suffix i and then incrementing i.

	This currently relies on an external symbol table stored in a file, which
	exploits the fact that race conditions with a shared file cannot occur with Python multiprocess
	(see: https://superfastpython.com/multiprocessing-race-condition-python/#Race_Condition_With_Shared_Data-2)
	However, this is somewhat clumsy/inefficient and should eventually be replaced by a proper solution.

	Parameters
	----------
	str : str
		String to use for symbol generation.

	Returns
	-------
	str
		A "symbol" with a unique integer suffix attached to the given string.
	"""
	symtab = file.load_json(SYMTAB_PATH)
	if not str in symtab:
		symtab[str] = 1
	else:
		symtab[str] += 1
	file.write_json(SYMTAB_PATH, symtab)
	return f'{str}{symtab[str]}'


def episode_name():
	"""Generate a new episode name."""
	return gentemp('e')


def episode_var():
	"""Generate a new episode variable."""
	return gentemp('?e')


def escaped_symbol_p(s):
	"""Check if a given symbol is an "escaped" symbol, equivalent to '|sym| in LISP."""
	return isinstance(s, str) and len(s) >= 2 and s.count('|') == 2


def symbolp(s):
	"""Check if a given variable is a "symbol" (i.e., a string)."""
	return isinstance(s, str)


def variablep(s):
	"""Check if a given input is a variable symbol, i.e., starts with '?' or '!'.
	
	NOTE: for now, this excludes indexical variables, such as '^you'.
	"""
	return symbolp(s) and s[0] in ['?', '!'] and s not in ['?', '!']


def dual_var(ep_var):
	"""Given an episode variable like ?e1, return the non-fluent dual of that variable, e.g., !e1 (and vice-versa)."""
	if variablep(ep_var):
		return '!'+ep_var[1:] if ep_var[0] == '?' else '?'+ep_var[1:]
	else:
		return ''
	

def duplicate_var(var):
	"""Duplicate a variable by generating a new variable symbol with the initial variable (excluding trailing numbers) as a prefix."""
	if not variablep(var):
		return var
	else:
		return gentemp(var.rstrip(string.digits))


# ``````````````````````````````````````
# String util
# ``````````````````````````````````````


def replaceall(str, replist):
	"""Make a list of replacements to a given string in sequence.
	
	Parameters
	----------
	str : str
		A string whose contents should be replaced.
	replist : list[tuple]
		A list of replacements to make. A replacement is a tuple of one of the following forms:
			(old, new)
			(old, new, is_regex)
		If is_regex is given as True (default is False), the old and new values are interpreted as regex strings.
	
	Returns
	-------
	str
	"""
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
	"""Indent a string some number of levels."""
	return "  "*(n-1)


def standardize(str):
	"""Standardize a string by applying a series of transformations.
	
	Specifically:
	1. Replace -- with -, and _ with whitespace.
	2. Remove parenthetical content (i.e., [...] or *...*).
	3. Add whitespace around all punctuation.
	4. Collapse all whitespace to a single space.
	5. Convert to lowercase.
	"""
	str = str.replace('--', '-').replace('_', ' ')
	str = re.sub(r'\[[a-zA-Z0-9\s]*\]', '', str)
	str = re.sub(r'\*[a-zA-Z0-9\s]*\*', '', str)
	str = re.sub(r'([.|,|!|?|:|;|-])', r' \1 ', str)
	str = re.sub(r'[\s]+', ' ', str)
	return str.lower().strip()


def isquote(s):
	"""Check if a given input is a quoted expression."""
	return isinstance(s, str) and len(s) >= 2 and s[0] == '"' and s[-1] == '"'



# ``````````````````````````````````````
# List util
# ``````````````````````````````````````



def rec_replace(old, new, lst):
	"""Recursively replace some old value with a new value throughout a list."""
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
	"""Recursively remove a given target from a list."""
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
	"""Check whether an input is a list (including the empty list)."""
	return isinstance(lst, list)


def cons(lst1, lst2):
	"""Insert a value to the front of a list or set.
	
	Parameters
	----------
	lst1 : object
		An object (possibly a sublist) to insert.
	lst2 : list[object], set[object], or object
		A list, set, or object to cons the given object to.
	
	Returns
	-------
	list[object] or set[object]
	"""
	if listp(lst2):
		return [lst1] + lst2
	elif isinstance(lst2, set):
		return {lst1} | lst2
	else:
		return [lst1, lst2]
	

def push(lst1, lst2):
	"""Insert a value to the end of a list or set.

	Parameters
	----------
	lst1 : object
		An object (possibly a sublist) to insert.
	lst2 : list[object], set[object], or object
		A list, set, or object to push the given object to.
	
	Returns
	-------
	list[object] or set[object]
	"""
	if listp(lst2):
		return lst2 + [lst1]
	elif isinstance(lst2, set):
		return lst2 | {lst1}
	else:
		return [lst2, lst1]
	

def atom(lst):
	"""Check whether an input is an atom (either empty list or a non-list)."""
	return not lst or not listp(lst)


def append(lst):
  """Append each sublist within lst together, creating a single combined list."""
  return [x for l in lst for x in l]


def flatten(lst):
	"""Recursively flatten a list, creating a single list with no sub-lists."""
	if not listp(lst):
		return [lst]
	else:
		return append([flatten(x) for x in lst])
	

def remove_duplicates(lst, order=False):
	"""Remove duplicate items in a list, preserving the initial order of 'order' is given as True."""
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
	

def remove_nil(lst):
	"""Remove any null values from a list."""
	return [x for x in lst if x]
	

def subst(a, b, lst):
	"""Recursively substitute b for a throughout a list."""
	def subst_rec(a, b, x):
		if x == b:
			return a
		elif atom(x):
			return x
		else:
			return [subst_rec(a, b, y) for y in x]
	return subst_rec(a, b, lst)


def substall(lst, replist):
	"""Given a set of replacements, make a substitution in a list for each replacement."""
	for (b, a) in replist:
		lst = subst(a, b, lst)
	return lst


def random_element(lst):
	"""Select a random element from a list."""
	return random.choice(lst)


def get_keyword_contents(lst, keys):
	"""Get the contents immediately following each keyword in 'keys' from a list."""
	return [e2 for (e1, e2) in zip(lst, lst[1:]+[None]) if e1 in keys and e2]


def to_key(lst):
	"""Convert a list to a valid dict key consisting of only tuples and strings."""
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
	"""Given a set of replacements, make a substitution to the keys in a dict for each replacement."""
	for (b, a) in replist:
		dct = { (a if var==b else var):val for var, val in dct.items() }
	return dct


def cons_dict(dct, k, v):
	"""Add v to the list at key k in dct, creating a new list if none exists."""
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
	"""Safe version of dict remove that removes val from the list stored at key (or pops the key if it stores an atom)."""
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
# Number util
# ``````````````````````````````````````



def squash(vector, range=(0, 1)):
	"""Squash each number within a vector to be within the given range."""
	if min(vector) == max(vector):
		return [1. for _ in vector]
	v = np.array(vector)
	mn = min(vector)
	mx = max(vector)
	a = (range[1]-range[0]) / (mx-mn)
	b = range[1] - (a * mx)
	return ((a * v) + b).tolist()


def normalize(vector):
	"""Normalize a vector to sum to 1."""
	v = np.array(vector)
	v = v / v.sum()
	return v.tolist()


def linsum(vectors, coeffs):
	"""Compute a linear sum of a list of vectors, scaling each vector by the corresponding coefficient."""
	r = np.array([0. for _ in vectors[0]])
	vs = [np.array(v) for v in vectors]
	for idx, v in enumerate(vs):
		r += coeffs[idx] * v
	return r


def argmax(lst, scores, n):
	"""Select the n top values in a given list, according to a list of scores for each list element."""
	objs = np.array(lst, dtype=object)
	scores_top = np.argsort(scores)[:-(min(n, len(scores))+1):-1]
	return objs[scores_top].tolist()