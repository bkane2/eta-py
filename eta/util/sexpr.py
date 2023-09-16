"""Utilities for handling S-expression lists.

Contains functions for parsing and manipulating S-expressions in Python, which are
represented as recursively nested lists, with strings as "symbols".

Some of this code is borrowed from the following repository:
https://github.com/bitbanger/schemas/blob/master/pyschemas/sexpr.py
"""

from eta.util.general import flatten, replaceall, symbolp, atom, escaped_symbol_p, standardize
import eta.util.file as file

def balanced_substr(s):
	"""Find a substring with a balanced number of parentheses."""
	count = 1
	for i in range(1, len(s)):
		c = s[i]

		if c == '(':
			count += 1
		if c == ')':
			count -= 1
		if count == 0:
			return s[:i+1]

	return None


def clean_s_expr(s_expr):
	"""Clean a string representation of an S-expression by removing newlines and standardizing whitespace."""
	s_expr = s_expr.replace('\n', '')
	s_expr = s_expr.replace('\t', '')
	while '  ' in s_expr:
		s_expr = s_expr.replace('  ', ' ')
	s_expr = replaceall(s_expr,
						[(r'\| ([a-zA-Z0-9-_]+)\|', r'|\1|', True),
						 (r'\|([a-zA-Z0-9-_]+) \|', r'|\1|', True)])
	return s_expr


def standardize_symbols(s_expr):
	"""Standardize the symbols within an S-expression by mapping to lowercase, unless enclosed in escape symbols."""
	def standardize_rec(e):
		if symbolp(e) and not escaped_symbol_p(e):
			return e.lower()
		elif symbolp(e):
			parts = e.split('|')
			before = parts[0].lower()
			escaped = parts[1]
			after = parts[2].lower()
			if '.' in escaped:
				word, suffix = escaped.split('.')
				escaped = word
				after = '.'+suffix.lower()+after
			return before+escaped+after
		else:
			return [standardize_rec(x) for x in e]
	return standardize_rec(s_expr)


def convert_quotes(s_expr):
	"""Convert any quoted word lists (i.e., single ' symbol followed by a list of symbols) to a single quoted string."""
	def convert_quotes_rec(e):
		if atom(e):
			return e
		elif len(e) == 1:
			return [convert_quotes_rec(e[0])]
		else:
			e1 = []
			for x1, x2 in zip([None]+e[:-1], e):
				if x1 == "'" and x2 and isinstance(x2, list) and all([isinstance(x, str) for x in x2]):
					e1.append('"'+standardize(' '.join(x2))+'"')
				elif x2 != "'":
					e1.append(x2)
			return [convert_quotes_rec(x) for x in e1]
	return convert_quotes_rec(s_expr)


def parse_s_expr(s_expr):
	"""Parse a string containing an S-expression (in LISP form) into a structured list.
	
	Parameters
	----------
	s_expr : str
		An S-expression in LISP form, e.g., ``(a (b c (d e)) '(f g h))``.
	
	Returns
	-------
	s-expr
		A structured S-expression, i.e., a recursively nested list structure with string "symbols" as atoms.
		e.g., ``['a', ['b', 'c', ['d', 'e']], "f g h"]``
	"""
	def parse_s_expr_rec(s_expr):
		s_expr = clean_s_expr(s_expr)

		if len(s_expr) == 0:
			return None

		if s_expr[0] != '(' or s_expr[-1] != ')':
			return s_expr

		items = []

		item_buf = []
		i = 1
		while i < len(s_expr):
			c = s_expr[i]

			if c == ' ':
				if len(item_buf) > 0:
					items.append(''.join(item_buf))
					item_buf = []
				i += 1
			elif c != '(':
				if c != ')':
					item_buf.append(c)
				i += 1
			else:
				if len(item_buf) > 0:
					items.append(''.join(item_buf))
					item_buf = []
				inner = balanced_substr(s_expr[i:])
				items.append(parse_s_expr_rec(inner))
				i += len(inner)

		if len(item_buf) > 0:
			items.append(''.join(item_buf))
			item_buf = []

		return items

	return convert_quotes(standardize_symbols(parse_s_expr_rec(s_expr)))


def list_to_s_expr(lst):
	"""Convert an S-expression list structure to a string representing a LISP formatted S-expression.
	
	Parameters
	----------
	lst : s-expr
		An S-expression in recursively nested list form, e.g., ``['a', ['b', ['c', 'd']], 'e']``.
	
	Returns
	-------
	str
		A LISP formatted string representation of the S-expression, e.g., ``(a (b (c d)) e)``.
	"""
	if type(lst) != list:
		return str(lst)

	buf = []

	buf.append('(')
	for i in range(len(lst)):
		if i > 0:
			buf.append(' ')
		buf.append(list_to_s_expr(lst[i]))
	buf.append(')')

	return ''.join(buf)


def list_to_str(lst):
	"""Convert an S-expression list structure to a flattened string containing each of the symbols.
	
	Parameters
	----------
	lst : s-expr
		An S-expression in recursively nested list form, e.g., ``['a', ['b', ['c', 'd']], 'e']``.
	
	Returns
	-------
	str
		A flattened string containing each of the symbols, e.g., ``"a b c d e"``.
	"""
	if type(lst) != list:
		return str(lst)
	words = [str(w) for w in flatten(lst)]

	return ' '.join(words)


def clean_lisp(str):
	"""Clean S-expressions from a LISP file by removing all commented lines and removing escape characters on symbols."""
	lines = [l.replace('\;', '[TEMP]') for l in str.split('\n')]
	lines = [l.split(';')[0].strip() for l in lines]
	lines = [l.replace('[TEMP]', '\;') for l in lines if l]
	lines = [' '+l if l and l[0] not in ['(', ')', "'"] else l for l in lines]
	return replaceall('\n'.join(lines), [
		('\.', '.', False),
		('\,', ',', False),
		('\:', ':', False),
		('\;', ';', False),
		("\\'", "'", False)
	])


def read_lisp(fname):
  """Read a list of S-expressions from a LISP file.
	
	Parameters
	----------
	fname : str
		The LISP file to read from.
	
	Returns
	-------
	list[s-expr]
		A list of S-expressions, in recursively nested list form.
	"""
  contents = '(' + clean_lisp(file.read_file(fname)) + ')'
  sexpr = parse_s_expr(contents)
  return sexpr
  

def write_lisp(fname, sexpr):
	"""Write an S-expression to a LISP file.
	
	Parameters
	----------
	fname : str
		The LISP file to write to.
	sexpr : s-expr
		An S-expression, in recursively nested list form, to write to the file in LISP format.
	"""
	file.write_file(fname, list_to_s_expr(sexpr))