# Taken from: https://github.com/bitbanger/schemas/blob/master/pyschemas/sexpr.py

from eta.util.general import flatten, replaceall, cons, symbolp, atom, escaped_symbol_p, standardize
import eta.util.file as file

def balanced_substr(s):
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
	s_expr = s_expr.replace('\n', '')
	s_expr = s_expr.replace('\t', '')
	while '  ' in s_expr:
		s_expr = s_expr.replace('  ', ' ')
	return s_expr


def standardize_symbols(s_expr):
	"""Standardizes the symbols in an s-expr by mapping to lowercase,
	   unless enclosed in |...|."""
	def standardize_rec(e):
		if symbolp(e) and not escaped_symbol_p(e):
			return e.lower()
		elif symbolp(e):
			parts = e.split('|')
			return parts[0].lower() + parts[1] + parts[2].lower()
		else:
			return [standardize_rec(x) for x in e]
	return standardize_rec(s_expr)


def convert_quotes(s_expr):
	"""Convert any quoted word lists (i.e., single ' symbol
	   followed by a list of symbols) to a string."""
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
	"""Wrapper function for parse_s_expr1"""
	return convert_quotes(standardize_symbols(parse_s_expr1(s_expr)))


def parse_s_expr1(s_expr):
	"""Parses a string containing an s-expr into a structured list"""
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
			items.append(parse_s_expr1(inner))
			i += len(inner)

	if len(item_buf) > 0:
		items.append(''.join(item_buf))
		item_buf = []

	return items


def list_to_s_expr(lst):
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
	if type(lst) != list:
		return str(lst)
	words = [str(w) for w in flatten(lst)]

	return ' '.join(words)


def clean_lisp(str):
	"""Cleans S-expressions from a .lisp file by removing comments and
	   removing escape characters."""
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
  contents = '(' + clean_lisp(file.read_file(fname)) + ')'
  sexpr = parse_s_expr(contents)
  return sexpr
  

def write_lisp(fname, sexpr):
  file.write_file(fname, list_to_s_expr(sexpr))


def main():

	# sexpr = read_lisp('tests/tt/test2.lisp')
	# print(sexpr)

	# test = "((^you go.v (to.p (the.d |Store|.n))) ** E1)"
	# s_expr = parse_s_expr(test)
	# print(s_expr)

	# print(list_to_s_expr(s_expr))

	test = "(^you paraphrase-to.v ^me '(this is a test quote .))"
	s_expr = parse_s_expr(test)
	print(s_expr)

	test = "((^you paraphrase-to.v ^me '(this is a test quote .)) ** E1)"
	s_expr = parse_s_expr(test)
	print(s_expr)


if __name__ == "__main__":
  main()