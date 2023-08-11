from eta.constants import DEFAULT_IMPORTANCE, TELIC_VERBS
from eta.util.general import get_time, cons_dict, listp, atom, cons, variablep, to_key, dict_get, dict_rem, dict_rem_val
from eta.lf import parse_eventuality


class Memory:
  """
  Represents a single memory, which consists of a temporally bounded event with some importance value.

  Note that the start time only marks the earliest time point at which an episode is known to be true;
  likewise for the end time. Thus, their logical interpretation should be as follows:
  (<start_time> during <event>.ep)
  (<end_time> during <event>.ep)
  Where <end_time> is to be read as an indexical variable ^now if no value is supplied.
  """
  def __init__(self, event, importance=DEFAULT_IMPORTANCE):
    self.event = event
    self.start_time = get_time()
    self.end_time = None
    self.last_access = self.start_time
    self.importance = importance

  def update_last_access(self):
    self.last_access = get_time()

  def end(self):
    self.end_time = get_time()

  def get_ep(self):
    return self.event.get_ep()
  
  def get_wff(self):
    return self.event.get_wff()

  def get_time_wffs(self):
    start_wff = [self.start_time, 'during', self.event.get_ep()]
    if self.end_time:
      end_wff = [self.end_time, 'during', self.event.get_ep()]
    else:
      end_wff = ['^now', 'during', self.event.get_ep()]
    return (start_wff, end_wff)
  
  def is_telic(self):
    wff = self.get_wff()
    return listp(wff) and any([v in wff for v in TELIC_VERBS])
  
  def __hash__(self):
    return hash(self.event)
  
  def __eq__(self, other):
    return isinstance(other, Memory) and self.event == other.event
  
  def __str__(self):
    return self.event.format()


class MemoryStorage:
  """
  Stores memories, keyed on the episode names as well as predicates of the ULF formula (if any).
  Also maintain a set of facts that are "true now", i.e., whose end time is None.
  """
  def __init__(self):
    self.memories = set()
    self.ep_ht = {}
    self.wff_ht = {}
    self.context = set()

  def _get_wff_keys(self, wff):
    """
    Create keys for storing a given WFF, provided the WFF is a logical formula and not a string.
    If wff is single predicate, keys = [(pred), pred]
    If wff is binary predicate, keys = [(subj, pred), pred]
    Otherwise, add all permutations of single pred+arg pairs, i.e., keys = 
    (subj, pred, None, None, ...)
    (None, pred, obj1, None, ...)
    (None, pred, None, obj2, ...)
    """
    if not wff or not listp(wff):
      return []
    if len(wff) == 1:
      return [to_key(wff), to_key(wff[0])]
    keys = [to_key(wff), to_key(wff[1])]
    if len(wff) > 2:
      keys.append(to_key(wff[:2]+[None for _ in wff[2:]]))
      for i in range(2, len(wff)):
        keys.append(to_key([None, wff[1]]+[None for _ in wff[2:i]]+[wff[i]]+[None for _ in wff[i+1:]]))
    return keys
  
  def access(self, memory):
    """
    'Accesses' a memory by updating the most recent access date of that memory.
    If the event is telic (i.e., assumed to be "instantaneous"), remove it from the context.
    """
    if listp(memory):
      return [self.access(m) for m in memory]
    
    if memory not in self.memories:
      return None
    memory.update_last_access()
    if memory.is_telic():
      self.remove_from_context(memory)
    return memory
    
  def store(self, memory):
    """TBC"""
    if listp(memory):
      return [self.store(m) for m in memory]
    
    self.memories.add(memory)
    ep = memory.get_ep()
    wff = memory.get_wff()
    cons_dict(self.ep_ht, ep, memory)
    for key in self._get_wff_keys(wff):
      cons_dict(self.wff_ht, key, memory)
    self.context.add(memory)
    
    # TODO: need to refine the following code. In addition to removing the negated WFF,
    # should the negative WFF then be kept in context? In that case, we would need to
    # remove the negative WFF once the positive version is added, and so on...
    # It seems like, in general, we need some sort of contradiction detection for removing
    # facts from context once contradicting facts are added.
    # if negative_wff(wff):
    #   self.remove_matching_from_context(wff[1])
    # else:
    #   self.context.add(memory)

  def remove(self, memory):
    """TBC"""
    if listp(memory):
      return [self.remove(m) for m in memory]

    if not memory in self.memories:
      return None
    self.memories.remove(memory)
    ep = memory.get_ep()
    wff = memory.get_wff()
    dict_rem_val(self.ep_ht, ep, memory)
    for key in self._get_wff_keys(wff):
      dict_rem_val(self.wff_ht, key, memory)
    if memory in self.context:
      self.context.remove(memory)

  def remove_from_context(self, memory):
    """TBC"""
    if listp(memory):
      return [self.remove_from_context(m) for m in memory]
    
    ep = memory.get_ep()
    memories = self.ep_ht[ep]
    for m in memories:
      if m in self.context:
        m.end()
        self.context.remove(m)
      
  def instantiate(self, event, importance=DEFAULT_IMPORTANCE):
    """TBC"""
    if listp(event):
      if not (listp(importance) and len(event) == len(importance)):
        importance = [DEFAULT_IMPORTANCE for _ in event]
      return [self.instantiate(e, i) for e, i in zip(event, importance)]
    
    memory = Memory(event, importance=importance)
    self.store(memory)

  def get_episode(self, ep):
    """TBC"""
    return dict_get(self.ep_ht, ep)
  
  def access_episode(self, ep):
    """TBC"""
    return self.access(self.get_episode(ep))

  def get_matching(self, pred_patt):
    """Retrieve a list of memories according to a given pred_patt, which
       is an s-expr with variables such as [b, between.p, ?x, c]"""
    if atom(pred_patt):
      return dict_get(self.wff_ht, to_key(pred_patt))
    elif len(pred_patt) == 1:
      return dict_get(self.wff_ht, to_key(pred_patt[0]))
    else:
      arglist = cons(pred_patt[0], pred_patt[2:])
      pred = pred_patt[1]
      nvars = len([arg for arg in arglist if variablep(arg)])
      nconst = len(arglist) - nvars
      if nvars == 0:
        return dict_get(self.wff_ht, to_key(cons(arglist[0], cons(pred, arglist[1:]))))
      elif nconst == 0:
        return dict_get(self.wff_ht, to_key(pred))
      elif nconst == 1:
        return dict_get(self.wff_ht, to_key([None if variablep(x) else x for x in pred_patt]))
      else:
        const = [arg for arg in arglist if not variablep(arg)][0]
        key = [arg if arg == const else None for arg in arglist]
        key = cons(key[0], cons(pred, key[1:]))
        memories = dict_get(self.wff_ht, to_key(key))
        # Filter out memories whose constant args don't match pred_patt
        selected = []
        for m in memories:
          wff = m.get_wff()
          if all([(variablep(x) or x == y) for x, y in zip(arglist, cons(wff[0], wff[2:]))]):
            selected.append(m)
        return selected
      
  def access_matching(self, pred_patt):
    """TBC"""
    return self.access(self.get_matching(pred_patt))
      
  def get_from_context(self, pred_patt):
    """TBC"""
    memories = self.get_matching(pred_patt)
    return [m for m in memories if m in self.context]
  
  def access_from_context(self, pred_patt):
    """TBC"""
    return self.access(self.get_from_context(pred_patt))
      
  def remove_episode(self, ep):
    """TBC"""
    memories = self.get_episode(ep)
    self.remove(memories)

  def remove_matching(self, pred_patt):
    """TBC"""
    memories = self.get_matching(pred_patt)
    self.remove(memories)

  def remove_episode_from_context(self, ep):
    """TBC"""
    memories = self.get_episode(ep)
    self.remove_from_context(memories)

  def remove_matching_from_context(self, pred_patt):
    """TBC"""
    memories = self.get_matching(pred_patt)
    self.remove_from_context(memories)


  def retrieve(self, query=None):
    """TBC"""
    pass

  def forget(self):
    """
    TODO: this function should be implemented to permanently evict facts from memory as memory
    sizes become too large for tractable retrieval. It should remove facts where the retrieval
    score (combined relevance/importance/salience) falls below a certain threshold.
    """
    pass

  def __str__(self):
    return '\n'.join([str(memory) for memory in self.memories])
  

def negative_wff(wff):
  return listp(wff) and len(wff) == 2 and wff[0] == 'not'
  

def test2():
  sep = '\n----------------------------\n'

  test = MemoryStorage()
  fact1 = parse_eventuality('(me say-to.v you "Test")', ep='e1')
  fact2 = parse_eventuality('(me be.v happy.a)', ep='e2')
  fact3 = parse_eventuality('(you reply-to.v e1)', ep='e3')
  test.instantiate(fact1)
  test.instantiate(fact2)
  test.instantiate(fact3)

  for m in test.context:
    print(m)
  print(sep)

  for m in test.get_matching(['?x', 'say-to.v', '?y', '?words']):
    print(m)
  print(sep)

  for m in test.context:
    print(m)
  print(sep)

  for m in test.access_matching(['?x', 'say-to.v', '?y', '?words']):
    print(m)
  print(sep)

  for m in test.context:
    print(m)
  print(sep)

  for m in test.access_matching(['?x', 'be.v', 'happy.a']):
    print(m)
  print(sep)

  for m in test.context:
    print(m)
  print(sep)

  for m in test.access_from_context(['?x', 'reply-to.v', '?y']):
    print(m)
  print(sep)

  for m in test.access_from_context(['?x', 'reply-to.v', '?y']):
    print(m)
  print(sep)


def test1():
  sep = '\n----------------------------\n'

  test = MemoryStorage()
  fact1 = parse_eventuality('(raining-outside.v)', ep='e1')
  fact2 = parse_eventuality('(me laugh.v)', ep='e2')
  fact3 = parse_eventuality('(me go-to.v (the.d store.n) yesterday.adv-e)', ep='e3')
  fact4 = parse_eventuality('(me go-to.v (the.d store.n) tuesday.adv-e)', ep='e4')
  fact5 = parse_eventuality('(you go-to.v (the.d store.n) tuesday.adv-e)', ep='e4')
  test.instantiate(fact1)
  test.instantiate(fact2)
  test.instantiate(fact3)
  test.instantiate(fact4)
  test.instantiate(fact5)

  for k,v in test.wff_ht.items():
    print(k)
    for i in v:
      print(i)
  print(sep)

  for m in test.get_episode('e4'):
    print(m)
  print(sep)

  for m in test.get_matching(['?x', 'go-to.v', '?y', '?z']):
    print(m)
  print(sep)

  test.remove_matching(['?x', 'go-to.v', '?y', 'tuesday.adv-e'])

  for m in test.get_matching('go-to.v'):
    print(m)
  print(sep)

  for m in test.context:
    print(m)
  print(sep)

  # fact6 = parse_eventuality('(not (me laugh.v))', ep='e5')
  # test.instantiate(fact6)

  # for m in test.context:
  #   print(m)
  # print(sep)

  # print(test)


def main():
  test1()
  # test2()
  

if __name__ == '__main__':
  main()