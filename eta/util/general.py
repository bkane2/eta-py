GENTEMP = {}

def gentemp(str):
	if not str in GENTEMP:
		GENTEMP[str] = 1
	else:
		GENTEMP[str] += 1
	return f'{str}{GENTEMP[str]}'



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

	print(gentemp('teststr5'))
	print(gentemp('teststr5'))
	

if __name__ == "__main__":
  main()