"""Buffer Utilities

Contains interface functions for manipulating priority queues, termed "buffers" in Eta's architecture.

NOTE: although importance values are positive, the values stored in the underlying priority queues are
negated, since heapq implements a min heap.

Exported functions
------------------
enqueue : enqueue an item (either an object or an (importance, object) tuple) in a buffer.
enqueue_ordered : enqueue a list of items in a buffer, ensuring that order is preserved unless specified otherwise.
is_empty : check if a buffer is empty.
pop_item : pop the top item from a buffer.
pop_all : pop all items from a buffer.
get_item : retrieve the top item from a buffer without popping it.
max_importance : return the maximum importance value in a buffer.
clear : empty a buffer.
iterate : return a buffer as a list (optionally applying some function to each value).
"""

import heapq

def enqueue(item, buffer):
  """Enqueue an item (either an object or an (importance, object) tuple) in a buffer.

  Parameters
  ----------
  item : object or tuple[float, object]
    If item is an object, enqueue using a default importance value. Otherwise, item is
    an (importance, object) tuple, and the object is enqueued with the given importance.
  buffer : list[tuple[float, object]]
  """
  if isinstance(item, tuple) and len(item) == 2 and isinstance(item[0], (int, float)):
    heapq.heappush(buffer, (-item[0], item[1]))
  else:
    heapq.heappush(buffer, (-1, item))


def enqueue_ordered(items, buffer, inc_val=0.0001):
  """Enqueue a list of items, preserving original order unless an importance value is explicitly specified.
  
  Parameters
  ----------
  items : list
    A list where each item is either an object or (importance, object) tuple. For each item where an importance
    is not specified, a default importance value is generated using an increment so as to preserve the original order.
  buffer : list[tuple[float, object]]
  inc_val : float, optional
    The increment to use for generated importance values.
  """
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
  """Check whether a buffer is empty.
  
  Parameters
  ----------
  buffer : list[tuple[float, object]]

  Returns
  -------
  bool
  """
  return False if buffer else True


def pop_item(buffer, importance=False):
  """Pop the top item from a buffer.
  
  Parameters
  ----------
  buffer : list[tuple[float, object]]
  importance : bool
    If True is given, return the importance as well as the object.

  Returns
  -------
  object or tuple[float, object]
  """
  if is_empty(buffer):
    return None
  item = heapq.heappop(buffer)
  if importance:
    return (-item[0], item[1])
  else:
    return item[1]


def pop_all(buffer, importance=False):
  """Pop all items from a buffer.
  
  Parameters
  ----------
  buffer : list[tuple[float, object]]
  importance : bool
    If True is given, return the importances as well as the objects.

  Returns
  -------
  list[object] or list[tuple[float, object]]
  """
  ret = []
  while not is_empty(buffer):
    ret.append(pop_item(buffer, importance=importance))
  return ret


def get_item(buffer, importance=False):
  """Get the top item from a buffer without popping it.
  
  Parameters
  ----------
  buffer : list[tuple[float, object]]
  importance : bool
    If True is given, return the importance as well as the object.

  Returns
  -------
  object or tuple[float, object]
  """
  if not is_empty(buffer):
    item = heapq.nsmallest(1, buffer)[0]
    if importance:
      return (-item[0], item[1])
    else:
      return item[1]
  else:
    return None


def max_importance(buffer):
  """Get the maximum importance value from a buffer.

  Parameters
  ----------
  buffer : list[tuple[float, object]]

  Returns
  -------
  float
  """
  if not is_empty(buffer):
    return -heapq.nsmallest(1, buffer)[0][0]
  else:
    return 0
  

def clear(buffer):
  """Empty a buffer.

  Parameters
  ----------
  buffer : list[tuple[float, object]]
  """
  buffer.clear()


def iterate(buffer, func=None):
  """Return a buffer as a list (optionally applying some function to each value).
  
  Parameters
  ----------
  buffer : list[tuple[float, object]]
  func : function
    A function to apply to each value in the buffer.
  
  Returns
  -------
  list[object]
  """
  elems = [item[1] for item in heapq.nsmallest(len(buffer), buffer)]
  if func:
    return [func(e) for e in elems]
  else:
    return elems