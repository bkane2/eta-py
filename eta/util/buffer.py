import heapq

def enqueue(item, buffer):
  if isinstance(item, tuple) and len(item) == 2 and isinstance(item[0], (int, float)):
    heapq.heappush(buffer, (-item[0], item[1]))
  else:
    heapq.heappush(buffer, (-1, item))


def enqueue_ordered(items, buffer, inc_val=0.0001):
  cur_max = max_importance(buffer)
  inc = inc_val
  importance = cur_max
  for item in items[::-1]:
    if isinstance(item, tuple) and len(item) == 2 and isinstance(item[0], (int, float)):
      importance = item[0]
      item = item[1]
    else:
      importance = cur_max
    importance += inc
    enqueue((importance, item), buffer)
    inc += inc_val


def is_empty(buffer):
  return False if buffer else True


def pop_item(buffer, importance=False):
  item = heapq.heappop(buffer)
  if importance:
    return (-item[0], item[1])
  else:
    return item[1]


def pop_all(buffer, importance=False):
  ret = []
  while not is_empty(buffer):
    ret.append(pop_item(buffer, importance=importance))
  return ret


def get_item(buffer, importance=False):
  if not is_empty(buffer):
    item = heapq.nsmallest(1, buffer)[0]
    if importance:
      return (-item[0], item[1])
    else:
      return item[1]
  else:
    return None


def max_importance(buffer):
  if not is_empty(buffer):
    return -heapq.nsmallest(1, buffer)[0][0]
  else:
    return 0
  

def clear(buffer):
  buffer.clear()


def iterate(buffer, func=None):
  elems = [item[1] for item in heapq.nsmallest(len(buffer), buffer)]
  if func:
    return [func(e) for e in elems]
  else:
    return elems
  

def main():
  test = []
  enqueue('alfalfa', test)
  enqueue('zoota', test)
  enqueue('roff', test, importance=2)
  print(iterate(test))
  print(iterate(test, func=lambda str: str + '_1'))
  print(pop_item(test))
  print(pop_item(test))
  clear(test)
  
  enqueue_ordered(['x', 'y', 'z', 'd', 'c', 'b', 'a'], test)
  print(get_item(test, importance=True))
  print(iterate(test))
  print(pop_all(test))
  print(test)



if __name__ == '__main__':
  main()