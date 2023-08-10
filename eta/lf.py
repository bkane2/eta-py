from eta.util.sexpr import parse_s_expr, list_to_str, list_to_s_expr
from eta.util.general import listp, flatten, episode_name, episode_var, subst, substall, dict_substall_keys, replaceall, dual_var

KEYWORDS = ['not', 'plur', 'past', 'pres', 'perf', 'prog', 'pasv', 'k', 'ka', 'ke', 'to', 'that', 'tht', 'fquan', 'nquan',
            'nmod', 'amod', '*h', '*s', '*p', 'set-of', 'n+preds', 'np+preds', 'sub', 'rep', "'s", 'poss-by', 'adv-a',
            'adv-e', 'adv-f', 'adv-s', '?', '!', '=', 'voc', 'voc-O', 'ds', 'ans-to', 'pu', 'cf', 'mod-a', 'mod-n',
            'most-n', 'poss-ques', 'poss-ans']

KEYWORDS_R = [k for k in KEYWORDS if k not in ['not', 'that', "'s", '?', '!']]


def remove_type(atm):
  if atm == '.':
    return atm
  elif atm == '."':
    return atm
  else:
    return atm.split('.')[0].replace('|', '')
  

class Domain:
  """TODO: currently unused"""
  def __init__(self, individuals=[]):
    self.domain = {}
    for i in individuals:
      self.domain[i.name] = i

  def add(self, individual):
    self.domain[individual.name] = individual

  def add_aliases(self, name, aliases):
    if name in self.domain:
      self.domain[name].add_aliases(aliases)
    else:
      self.domain[name] = Individual(name, aliases)
  

class Individual:
  """TODO: currently unused"""
  def __init__(self, name, aliases=[]):
    self.name = name
    self.aliases = aliases
  
  def add_aliases(self, aliases):
    self.aliases = self.aliases + aliases

  def __str__(self):
    return self.name
  

class Var:
  """TODO: currently unused"""
  def __init__(self, var, val=None):
    self.var = var
    self.val = val
  
  def bind(self, val):
    self.val = val
    return self

  def unbind(self):
    self.val = None
    return self

  def __str__(self):
    if self.val:
      return str(self.val)
    else:
      return self.var


class LF:
  def __init__(self, formula):
    if isinstance(formula, str):
      self.formula = parse_s_expr(formula)
    else:
      self.formula = formula
    self.bindings = {}

  def bind(self, var, val):
    self.bindings[var] = val
    return self
  
  def unbind(self, var):
    if var in self.bindings:
      self.bindings.pop(var)
    return self
  
  def replacevar(self, var1, var2):
    self.bindings = dict_substall_keys(self.bindings, [(var1, var2)])
    self.formula = subst(var2, var1, self.formula)
  
  def get_formula(self):
    return substall(self.formula, list(self.bindings.items()))

  def __str__(self):
    return list_to_s_expr(self.get_formula())
  

class ULF(LF):
  def __init__(self, formula):
    super().__init__(formula)

  def to_nl(self):
    # TODO - replace naive implementation with ULF2English
    words = ' '.join([remove_type(w) for w in list_to_str(self.get_formula()).split() if w not in KEYWORDS_R])
    words = ' '.join(flatten([w.split('-') for w in words.split()]))
    words = ' '.join([w.replace('_', ' ') for w in words.split()])
    return words
    

class ELF(LF):
  def __init__(self, formula):
    super().__init__(formula)
    

class Eventuality:
  """
  TODO: write up documentation.
  TODO: make ULF / ELF distinction clearer
  """
  def __init__(self, ep, nl, ulf, elf, prob=1.):
    self.ep = ep
    self.nl = nl
    self.set_ulf(ulf)
    self.set_elf(elf)
    self.prob = prob
    self.bindings = {}

  def set_ep(self, ep):
    self.ep = ep

  def set_ulf(self, ulf):
    if not ulf:
      self.ulf = None
    elif isinstance(ulf, ULF):
      self.ulf = ulf
    else:
      self.ulf = ULF(ulf)

  def set_elf(self, elf):
    if not elf:
      self.elf = None
    elif isinstance(elf, ELF):
      self.elf = elf
    else:
      self.elf = ELF(elf)

  def set_prob(self, prob):
    self.prob = prob
    
  def bind(self, var, val):
    self.bindings[var] = val
    if self.ulf:
      self.ulf.bind(var, val)
    if self.elf:
      self.elf.bind(var, val)
    return self

  def unbind(self, var):
    if var in self.bindings:
      self.bindings.pop(var)
    if self.ulf:
      self.ulf.unbind(var)
    if self.elf:
      self.elf.unbind(var)
    return self

  def replacevar(self, var1, var2):
    self.bindings = dict_substall_keys(self.bindings, [(var1, var2)])
    if self.ep == var1:
      self.ep = var2
    self.nl = self.nl.replace(var1, var2)
    if self.ulf:
      self.ulf.replacevar(var1, var2)
    if self.elf:
      self.elf.replacevar(var1, var2)

  def get_ep(self):
    return self.bindings[self.ep] if self.ep in self.bindings else self.ep

  def get_nl(self):
    nl_bindings = [(var, list_to_str(val)) for var, val in self.bindings.items()]
    return replaceall(self.nl, nl_bindings)

  def get_ulf(self):
    if not self.ulf:
      return []
    return self.ulf.get_formula()
  
  def get_elf(self):
    if not self.elf:
      return []
    return self.elf.get_formula()
  
  def get_wff(self, no_bind=False):
    if no_bind:
      return self.elf.formula if self.elf else self.ulf.formula if self.ulf else self.nl
    return self.get_elf() if self.elf else self.get_ulf() if self.ulf else self.get_nl()

  def format(self):
    """
    Formats an Eventuality as ((<ep> <wff>) <prob>), where
    <wff> is the "highest level" of specification for this Eventuality.
    """
    return f'(({self.get_ep()} {self.get_wff()}) {self.prob})'

  def __str__(self):
    return self.format()
  
  def __eq__(self, other):
    # Assume that two Eventualities are equivalent if their surface realizations are the same
    return self.get_nl() == other.get_nl()
  
  def __hash__(self):
    return hash(f'({self.get_ep()} {self.get_wff()})')
  # END Eventuality


class Condition(Eventuality):
  """
  A Condition is a special type of Eventuality indicated by a :try-in-sequence or :if keyword.
  In addition to an episode, wff, and certainty, it also has a list of (condition, eventualities) pairs.
  TODO: for now, I'm assuming that each condition is a ULF, rather than itself being an Eventuality;
        this may need to be re-evaluated in the future.
  """
  def __init__(self, ep, nl, ulf, elf, conditions, prob=1.):
    super().__init__(ep, nl, ulf, elf, prob)
    self.conditions = conditions

  def bind(self, var, val):
    super().bind(var, val)
    for (cond, eventualities) in self.conditions:
      if isinstance(cond, ULF):
        cond.bind(var, val)
      for e in eventualities:
        e.bind(var, val)
    return self

  def unbind(self, var):
    super().unbind(var)
    for (cond, eventualities) in self.conditions:
      if isinstance(cond, ULF):
        cond.unbind(var)
      for e in eventualities:
        e.unbind(var)
    return self

  def replacevar(self, var1, var2):
    super().replacevar(var1, var2)
    for (cond, eventualities) in self.conditions:
      if isinstance(cond, ULF):
        cond.replacevar(var1, var2)
      for e in eventualities:
        e.replacevar(var1, var2)
    

class Repetition(Eventuality):
  """
  A Repetition is a special type of Eventuality indicated by a :repeat-until keyword.
  In addition to an episode, wff, and certainty, it also has a condition and sub-list of eventualities.
  TODO: for now, I'm assuming that each condition is a ULF, rather than itself being an Eventuality;
        this may need to be re-evaluated in the future.
  """
  def __init__(self, ep, nl, ulf, elf, condition, eventualities, prob=1.):
    super().__init__(ep, nl, ulf, elf, prob)
    self.condition = condition
    self.eventualities = eventualities

  def bind(self, var, val):
    super().bind(var, val)
    if isinstance(self.condition, ULF):
      self.condition.bind(var, val)
    for e in self.eventualities:
      e.bind(var, val)
    return self

  def unbind(self, var):
    super().unbind(var)
    if isinstance(self.condition, ULF):
      self.condition.unbind(var)
    for e in self.eventualities:
      e.unbind(var)
    return self

  def replacevar(self, var1, var2):
    super().replacevar(var1, var2)
    if isinstance(self.condition, ULF):
      self.condition.replacevar(var1, var2)
    for e in self.eventualities:
      e.replacevar(var1, var2)


def parse_eventuality(s, ep=None, expectation=False, prob_dict={}):
  """
  Create an Eventuality from a string which may be either a natural language
  expression or a ULF. Use a specific episode name/var is given; otherwise
  generate a new variable or constant, depending on whether 'expectation' is
  given as True or False respectively.
  
  In the case where 's' is an s-expr containing a condition/repetition keyword,
  this recursively processes the eventuality as one of the respective special types.

  A probability dict can also be passed containing (ep : prob) mappings, which will
  be used to assign probabilities for each Eventuality created.
  """
  if not ep:
    ep = episode_var() if expectation else episode_name()
  prob = prob_dict[ep] if ep in prob_dict else 1.

  # s is already an s-expr
  if isinstance(s, list):
    parsed = s
  else:
    parsed = parse_s_expr(s)

  # s encodes a valid s-expr
  if isinstance(parsed, list):
    ulf = ULF(parsed)

    # s is a special condition/repetition expression
    if parsed[0] in [':try-in-sequence', ':if']:
      return parse_condition(parsed, ulf, ep, prob, prob_dict=prob_dict)
    elif parsed[0] in [':repeat-until']:
      return parse_repetition(parsed, ulf, ep, prob, prob_dict=prob_dict)
    else:
      return Eventuality(ep, ulf.to_nl(), ulf, None, prob=prob)
  
  # otherwise s is a natural language string
  else:
    if not ep:
      ep = episode_var() if expectation else episode_name()
    return Eventuality(ep, s, None, None, prob=prob)
  

def parse_condition(s, ulf, ep, prob, prob_dict={}):
  if s[0] == ':if':
    conditions = [(ULF(s[1]), parse_eventuality_list(s[2:], prob_dict=prob_dict))]
  else:
    conditions = []
    for cond in s[1:]:
      if cond[0] == ':if':
        conditions.append((ULF(cond[1]), parse_eventuality_list(cond[2:], prob_dict=prob_dict)))
      elif cond[0] == ':else':
        conditions.append((True, parse_eventuality_list(cond[1:], prob_dict=prob_dict)))
  return Condition(ep, ulf.to_nl(), ulf, None, conditions, prob=prob)


def parse_repetition(s, ulf, ep, prob, prob_dict={}):
  condition = ULF(s[1])
  eventualities = parse_eventuality_list(s[2:], prob_dict=prob_dict)
  return Repetition(ep, ulf.to_nl(), ulf, None, condition, eventualities, prob=prob)


def parse_eventuality_list(lst, prob_dict={}):
  """Given a list of format [ep1, wff1, ep2, wff2, ...], parse each (ep, wff) pair into an Eventuality."""
  ret = []
  for ep, wff in zip(lst[::2], lst[1::2]):
    ret.append(parse_eventuality(wff, ep=ep, prob_dict=prob_dict))
  return ret


def main():
  fact = Eventuality('e5',
              'John went to the store yesterday.',
              '(|John| ((past go.v) (to.p (the.d store.n)) (adv-e yesterday.pro)))',
              '(((|John| go.v (to.p |Store1|)) ** E1) (E1 during |Yesterday|))')
  
  print(fact)

  fact2 = parse_eventuality('(|John| ((past go.v) (to.p (the.d store.n)) (adv-e yesterday.pro)))')
  print(fact2)

  fact3 = parse_eventuality('(|Mary| leave.v)', ep='e3')
  print(fact3)

  fact4 = parse_eventuality('John went to the store yesterday')
  print(fact4)

  fact5 = parse_eventuality([[['the.d', ["|McDonald's|", 'block.n']], [['pres', 'be.v'], ['to_the_left_of.p', ['the.d', ['|Twitter|', 'block.n']]]]], '?'])
  print(fact5)

  fact6 = parse_eventuality('I say to ^you "test"', expectation=True)
  print(fact6)

  ep_var = fact6.get_ep()
  fact6.bind(ep_var, 'e100')
  print(fact6)
  fact6.bind('^you', 'Joe')
  print(fact6)

  fact7 = parse_eventuality('(?person ((past go.v) (to.p ?location) (adv-e yesterday.pro)))')
  fact7.bind('?person', 'John')
  fact7.bind('?location', ['the.d', 'store.n'])
  print(fact7)

  facts = parse_eventuality_list(['!t1', ['^me', 'person.n'], '?s1', ['^me', [['pres', 'be.v'], ['at.p', ['the.d', 'store.n']]]],
                                  '?e1', ['^you', 'meet.v', '^me']])
  for f in facts:
    print(f)


if __name__ == '__main__':
  main()