"""Tools for storing and retrieving eventualities in Eta's semantic memory."""

from eta.constants import DEFAULT_IMPORTANCE, TELIC_VERBS
from eta.util.general import cons_dict, listp, atom, cons, variablep, to_key, dict_get, dict_rem_val, squash, linsum, argmax
from eta.util.time import TimePoint

class Memory:
  """Represents a single memory, which consists of a temporally bounded event with some importance value.

  Parameters
  ----------
  event : Eventuality
    The eventuality of this memory.
  importance : float, optional
    A numerical score representing how important this memory is.
  
  Attributes
  ----------
  event : Eventuality
  start_time : TimePoint
    The earliest time at which the event in this memory is known to be true. This is initialized as the
    current time upon initialization of a new memory.
  end_time : TimePoint, optional
    The latest time at which the event in this memory is known to be true. This is initialized as None,
    interpreted as the event being "true now".
  last_access : TimePoint
    The most recent time that this memory was accessed from memory storage, initialized as the start time.
  importance : float

  Notes
  -----
  The start time only marks the earliest time point at which an episode is known to be true;
  likewise for the end time. Thus, their logical interpretation should be as follows:

    * ``(<start_time> during <event>.ep)``
    * ``(<end_time> during <event>.ep)``

  Where ``<end_time>`` is to be read as an indexical variable ``^now`` if no value is supplied.
  """

  def __init__(self, event, importance=DEFAULT_IMPORTANCE):
    self.event = event
    self.start_time = TimePoint()
    self.end_time = None
    self.last_access = TimePoint(self.start_time.time)
    self.importance = importance

  def update_last_access(self):
    """Update the most recent access of this memory to the current time."""
    self.last_access.update()

  def end(self):
    """Declare that this memory is no longer true by storing the current time as its end time."""
    self.end_time = TimePoint()

  def get_ep(self):
    """Get the episode of the event of this memory."""
    return self.event.get_ep()
  
  def get_wff(self):
    """Get the wff of the event of this memory."""
    return self.event.get_wff()

  def get_time_wffs(self):
    """Get the wffs corresponding to the beginning and end of this memory."""
    start_wff = [self.start_time.to_ulf(), 'during', self.event.get_ep()]
    if self.end_time:
      end_wff = [self.end_time.to_ulf(), 'during', self.event.get_ep()]
    else:
      end_wff = ['^now', 'during', self.event.get_ep()]
    return (start_wff, end_wff)
  
  def is_telic(self):
    """Check whether this memory represents a telic event (i.e., one that is essentially instantaneous)."""
    wff = self.get_wff()
    return listp(wff) and any([v in wff for v in TELIC_VERBS])
  
  def __hash__(self):
    return hash(self.event)
  
  def __eq__(self, other):
    return isinstance(other, Memory) and self.event == other.event
  
  def __str__(self):
    return self.event.format()


class MemoryStorage:
  """Stores memories and a context of "true now" facts, keyed on both episode names and predicates for efficient lookup.

  Parameters
  ----------
  embedder : Embedder, optional
    If provided, an embedder to embed all memories that are added to storage.
  
  Attributes
  ----------
  memories : set[Memory]
    A set containing all stored memories.
  ep_ht : dict[str, Memory]
    A hash table mapping episode variables/constants to memories of events that characterize those episodes.
  wff_ht : dict[str or tuple, Memory]
    A hash table mapping tuples of wff keys to memories of events with wffs matching those keys.
    Valid keys may be:

      1. A single predicate string, e.g., ``pred``.
      2. A binary predicate tuple, e.g., ``(subj, pred)``.
      3. A tuple containing the predicate of a wff with one other argument, with other arguments being replaced with ``None``, e.g.,
        - ``(subj, pred, None, None, ...)``
        - ``(None, pred, obj1, None, ...)``
        - ``(None, pred, None, obj2, ...)``
        
  context : set[Memory]
    A set containing all memories that are "true now".
  embedder : Embedder or None
  """

  def __init__(self, embedder=None):
    self.memories = set()
    self.ep_ht = {}
    self.wff_ht = {}
    self.context = set()
    self.embedder = embedder

  def _get_wff_keys(self, wff):
    """Create keys for storing a given `wff` in the `wff_ht` dict (provided the wff is a logical formula and not a string)."""
    if isinstance(wff, str):
      return [wff]
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
    """"Access" a memory (or list of memories) by updating the most recent access date of that memory.

    If the event is telic (i.e., assumed to be "instantaneous"), remove it from `context` as well.

    Parameters
    ----------
    memory : Memory or list[Memory]

    Returns
    -------
    Memory or list[Memory]
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
    """Store a memory (or list of memories), adding to each hash table as well as to `context`.
    
    Parameters
    ----------
    memory : Memory or list[Memory]

    Notes
    -----
    TODO: this should be extended so that storing a fact such as ``(not <wff>)`` actually removes
    the embedded wff from `context`. However, in addition to removing the negated WFF,
    should the negative WFF then be kept in `context`? In that case, we would need to
    remove the negative WFF once the positive version is added, and so on...
    It seems like, in general, we need some sort of contradiction detection for removing
    facts from `context` once contradicting facts are added.

    TODO: in the case of events with duplicate wffs but different episode constants being inserted
    (e.g., ``(^you reply-to.v E1) ** E3`` and ``(^you reply-to.v E1) ** E4)``), we should probably merge them
    into a single memory/event with a new episode constant, e.g., E5. We may then either replace all
    other occurrences of E3 and E4 throughout memory with E5, or we may somehow store that E3 and E4
    are both sub-events of E5.
    """
    if listp(memory):
      return [self.store(m) for m in memory]
    
    self.memories.add(memory)
    ep = memory.get_ep()
    wff = memory.get_wff()
    cons_dict(self.ep_ht, ep, memory)
    for key in self._get_wff_keys(wff):
      cons_dict(self.wff_ht, key, memory)
    self.context.add(memory)

  def remove(self, memory):
    """Remove a memory (or list of memories) from all sets and hash tables.
    
    Parameters
    ----------
    memory : Memory or list[Memory]
    """
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
    """Remove a memory (or list of memories) from `context`.

    Parameters
    ----------
    memory : Memory or list[Memory]

    Notes
    -----
    TODO: currently, this only removes the individual memory from `context`. However, since multiple memories
    may characterize the same episode, if one memory characterizing a particular episode is removed from
    `context`, should all memories characterizing the same episode be removed from `context`? This is currently
    unclear; in the future, we may need to add partial characterization (i.e., ``(<wff> * <ep>)``) to account for this.
    """
    if listp(memory):
      return [self.remove_from_context(m) for m in memory]
    
    if memory in self.context:
      memory.end()
      self.context.remove(memory)
      
  def instantiate(self, event, importance=DEFAULT_IMPORTANCE):
    """Instantiate an event (or list of events) as a new memory and store it.
    
    Parameters
    ----------
    event : Eventuality or list[Eventuality]
      The eventuality object(s) to store as new memories.
    importance : float or list[float], optional
      The importance value(s) to assign to each new memory.
    """
    if listp(event):
      if not (listp(importance) and len(event) == len(importance)):
        importance = [DEFAULT_IMPORTANCE for _ in event]
      return [self.instantiate(e, i) for e, i in zip(event, importance)]
    
    if self.embedder:
      event.embed(self.embedder)
    memory = Memory(event, importance=importance)
    self.store(memory)

  def get_episode(self, ep, access=False):
    """Get memories that characterize a specific episode.
    
    Parameters
    ----------
    ep : str
      An episode symbol.
    access : bool, default=False
      Whether to update the last access time of the memories.
    
    Returns
    -------
    list[Memory]
    """
    memories = dict_get(self.ep_ht, ep)
    return self.access(memories) if access else memories

  def get_matching(self, pred_patt, access=False):
    """Get memories matching a given predicate pattern potentially containing variables.

    Parameters
    ----------
    pred_patt : str or s-expr
      A predicate symbol or predicate pattern, i.e., an S-expression possibly containing variables
      at the top level, e.g., ``between.p`` or ``[Block1, between.p, ?x, Block2]``.
    access : bool, default=False
      Whether to update the last access time of the memories.
    
    Returns
    -------
    list[Memory]

    Notes
    -----
    TODO: currently, due to the indexing scheme used by `wff_ht`, we only allow variables in the
    top level of a predication (i.e., variables may not be nested within an S-expression). In
    the future, we may wish to allow for more general matching.
    """
    def match_patt(pred_patt):
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
    
    memories = match_patt(pred_patt)
    return self.access(memories) if access else memories
      
  def get_from_context(self, pred_patt, access=False):
    """Get a memory from `context` matching a given predicate pattern potentially containing variables.
    
    Parameters
    ----------
    pred_patt : str or s-expr
      A predicate symbol or predicate pattern, i.e., an S-expression possibly containing variables
      at the top level, e.g., ``between.p`` or ``[Block1, between.p, ?x, Block2]``.
    access : bool, default=False
      Whether to update the last access time of the memories.
    
    Returns
    -------
    list[Memory]
    """
    memories = self.get_matching(pred_patt)
    memories = [m for m in memories if m in self.context]
    return self.access(memories) if access else memories
      
  def remove_episode(self, ep):
    """Remove all memories characterizing a given episode.
    
    Parameters
    ----------
    ep : str
      An episode symbol.
    """
    memories = self.get_episode(ep)
    self.remove(memories)

  def remove_matching(self, pred_patt):
    """Remove all memories matching a given predicate pattern potentially containing variables.
    
    Parameters
    ----------
    pred_patt : str or s-expr
      A predicate symbol or predicate pattern, i.e., an S-expression possibly containing variables
      at the top level, e.g., ``between.p`` or ``[Block1, between.p, ?x, Block2]``.
    """
    memories = self.get_matching(pred_patt)
    self.remove(memories)

  def remove_episode_from_context(self, ep):
    """Remove all memories from `context` characterizing a given episode.
    
    Parameters
    ----------
    ep : str
      An episode symbol.
    """
    memories = self.get_episode(ep)
    self.remove_from_context(memories)

  def remove_matching_from_context(self, pred_patt):
    """Remove all memories from `context` matching a given predicate pattern potentially containing variables.
    
    Parameters
    ----------
    pred_patt : str or s-expr
      A predicate symbol or predicate pattern, i.e., an S-expression possibly containing variables
      at the top level, e.g., ``between.p`` or ``[Block1, between.p, ?x, Block2]``.
    """
    memories = self.get_matching(pred_patt)
    self.remove_from_context(memories)

  def flush_context(self):
    """Remove from `context` all "telic" events (i.e., events that we regard as essentially instantaneous)."""
    memories = [m for m in self.context if m.is_telic()]
    for memory in memories:
      self.remove_from_context(memory)

  def get_characterizing_episode(self, pred_patt, ep):
    """Get all memories that both match a given predicate pattern and characterize a given episode.
    
    Parameters
    ----------
    pred_patt : str or s-expr
      A predicate symbol or predicate pattern, i.e., an S-expression possibly containing variables
      at the top level, e.g., ``between.p`` or ``[Block1, between.p, ?x, Block2]``.
    ep : str
      An episode symbol.

    Returns
    -------
    list[Memory]
    """
    memories1 = self.get_matching(pred_patt)
    memories2 = self.get_episode(ep)
    return list(set(memories1).intersection(set(memories2)))

  def does_characterize_episode(self, pred_patt, ep):
    """Check whether a given predicate pattern matches a memory characterizing a given episode.
    
    Parameters
    ----------
    pred_patt : str or s-expr
      A predicate symbol or predicate pattern, i.e., an S-expression possibly containing variables
      at the top level, e.g., ``between.p`` or ``[Block1, between.p, ?x, Block2]``.
    ep : str
      An episode symbol.

    Returns
    -------
    bool
    """
    memories1 = self.get_matching(pred_patt)
    memories2 = self.get_episode(ep)
    return True if set(memories1).intersection(set(memories2)) else False

  def retrieve(self, query=None, n=5, coeffs=(1.,1.,1.)):
    """Retrieve some number of relevant memories according to recency, importance, and salience.
    
    The following three sub-criteria are used to determine which memories are retrieved:
    - recency : the latest access time of each memory.
    - importance : the importance values assigned to each memory.
    - salience : the embedding similarity between each memory and a query (if given).

    Each sub-criteria score is mapped to a score in [0,1], and the final score is a linear sum of
    each sub-score multiplied by the respective coefficient in 'coeffs'. The highest scoring memories
    are returned.

    Parameters
    ----------
    query : str, optional
      The query to use in computing salience scores. If no query is given, or if
      no embedder is defined, the salience score will be ``1`` for every memory.
    n : int, default=5
      The number of memories to retrieve.
    coeffs : tuple[float, float, float], default=(1., 1., 1.)
      A tuple of coefficients to be used to weight each respective sub-score.

    Returns
    -------
    list[Memory]
    """
    memories = list(self.memories)
    recency = squash([m.last_access.to_num() for m in memories])
    importance = squash([m.importance for m in memories])
    if not query or not self.embedder:
      salience = squash([1. for _ in memories])
    else:
      salience = squash(self.embedder.score(query, memories, [m.event.embedding for m in memories]))
    scores = linsum([recency, importance, salience], coeffs)
    return argmax(memories, scores, n)

  def forget(self):
    """Evict some facts from memory in order to reduce memory size (TBC).

    Notes
    -----
    TODO: this function should be implemented to permanently evict facts from memory as memory
    sizes become too large for tractable retrieval. It should remove facts where the combined relevance
    and importance values fall below some threshold.
    """
    pass

  def __str__(self):
    return '\n'.join([str(memory) for memory in self.memories])