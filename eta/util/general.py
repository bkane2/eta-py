import eta.util.file as file

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



def append(lst):
  return [x for l in lst for x in l]



def flatten(lst):
	if not isinstance(lst, list):
		return [lst]
	else:
		return append([flatten(x) for x in lst])



def main():
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