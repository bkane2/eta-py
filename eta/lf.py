"""Classes for representing and modifying logical forms and eventualities."""

import glob
from ulf2english import ulf2english

from eta.constants import *
from eta.util.sexpr import parse_s_expr, list_to_str, list_to_s_expr, read_lisp
from eta.util.general import listp, atom, cons, flatten, episode_name, episode_var, subst, substall, rec_replace, dict_substall_keys, replaceall, remove_duplicates

KEYWORDS = ['not', 'plur', 'past', 'pres', 'perf', 'prog', 'pasv', 'k', 'ka', 'ke', 'to', 'that', 'tht', 'fquan', 'nquan',
            'nmod', 'amod', '*h', '*s', '*p', 'set-of', 'n+preds', 'np+preds', 'sub', 'rep', "'s", 'poss-by', 'adv-a',
            'adv-e', 'adv-f', 'adv-s', '?', '!', '=', 'voc', 'voc-O', 'ds', 'ans-to', 'pu', 'cf', 'mod-a', 'mod-n',
            'most-n', 'poss-ques', 'poss-ans']
"""list[str] : a list of special keywords that are reserved for operators in ULF."""

KEYWORDS_R = [k for k in KEYWORDS if k not in ['not', 'that', "'s", '?', '!']]
"""list[str] : a subset of keywords that don't mirror natural language words/punctuation."""


def remove_type(atm):
  """Remove the type suffix from a ULF atom."""
  if atm == '.':
    return atm
  elif atm == '."':
    return atm
  else:
    return atm.split('.')[0].replace('|', '')
  

class Domain:
  """Defines a domain of individuals.

  Parameters
  ----------
  individuals : list[Individual], optional
    A list of initial individuals to add to the domain.

  Attributes
  ----------
  domain : dict
    A dict mapping the canonical names of an individual to that individual object.

  Notes
  -----
  TODO: currently incomplete and unused.
  """

  def __init__(self, individuals=[]):
    self.domain = {}
    for i in individuals:
      self.add(i)

  def add(self, individual):
    """Add an individual to the domain."""
    self.domain[individual.name] = individual

  def add_aliases(self, name, aliases):
    """Add a list of aliases (strings) to the individual denoted by the given canonical name."""
    if name in self.domain:
      self.domain[name].add_aliases(aliases)
    else:
      self.domain[name] = Individual(name, aliases)
  

class Individual:
  """Defines an individual, with some canonical name and a list of aliases.

  Parameters
  ----------
  name : str
    The canonical name of the individual.
  aliases : list[str], optional
    A list of aliases of the individual.

  Attributes
  ----------
  name : str
  aliases : list[str]

  Notes
  -----
  TODO: currently incomplete and unused.
  """

  def __init__(self, name, aliases=[]):
    self.name = name
    self.aliases = aliases
  
  def add_aliases(self, aliases):
    """Add a list of aliases to this individual."""
    self.aliases = self.aliases + aliases

  def __str__(self):
    return self.name
  

class Var:
  """Defines a variable, with some variable symbol and some value assignment.

  Parameters
  ----------
  var : str
    The variable symbol.
  val : object, optional
    The value this variable is currently bound to. Generally this will be a string,
    though it may in principle be some other object (e.g., an Individual) as well.

  Attributes
  ----------
  var : str
  val : object

  Notes
  -----
  TODO: currently incomplete and unused.
  """

  def __init__(self, var, val=None):
    self.var = var
    self.val = val
  
  def bind(self, val):
    """Bind this variable to the given value."""
    self.val = val
    return self

  def unbind(self):
    """Unbind this variable."""
    self.val = None
    return self

  def __str__(self):
    if self.val:
      return str(self.val)
    else:
      return self.var


class LF:
  """Defines an abstract logical form.

  A logical form (whether ULF or ELF) must contain a formula, variable bindings, functions
  for binding/unbinding variables, for replacing variables, and for getting the formula (or
  a natural language representation thereof) after making all variable assignments.

  Parameters
  ----------
  formula : str or s-expr
    The formula for this logical form (an S-expression or LISP-formatted string representation thereof).

  Attributes
  ----------
  formula : s-expr
    The formula for this logical form.
  bindings : dict
    A mapping from variables to bound values.
  """

  def __init__(self, formula):
    if isinstance(formula, str):
      self.formula = parse_s_expr(formula)
    else:
      self.formula = formula
    self.bindings = {}

  def bind(self, var, val):
    """Bind the given variable symbol to the given value."""
    self.bindings[var] = val
    return self
  
  def unbind(self, var):
    """Unbind the given variable symbol."""
    if var in self.bindings:
      self.bindings.pop(var)
    return self
  
  def replacevar(self, var1, var2):
    """Replace the first variable symbol with the second variable symbol throughout the logical form."""
    self.bindings = dict_substall_keys(self.bindings, [(var1, var2)])
    self.formula = subst(var2, var1, self.formula)
  
  def get_formula(self):
    """Get the formula, applying any variable assignments first."""
    return substall(self.formula, list(self.bindings.items()))
  
  def to_nl(self):
    """Convert the formula to a natural language string."""
    formula = self.get_formula()
    formula = rec_replace(['^me', "'s"], '^my', formula)
    formula = rec_replace(['^you', "'s"], '^your', formula)
    return ulf2english.convert(formula, standardize=True)

  def __str__(self):
    return list_to_s_expr(self.get_formula())
  

class ULF(LF):
  """Defines a ULF formula.
  
  Parameters
  ----------
  formula : str or s-expr
    The formula for this logical form (an S-expression or LISP-formatted string representation thereof).
  """

  def __init__(self, formula):
    super().__init__(formula)
    

class ELF(LF):
  """Defines an ELF formula.
  
  Parameters
  ----------
  formula : str or s-expr
    The formula for this logical form (an S-expression or LISP-formatted string representation thereof).
  """

  def __init__(self, formula):
    super().__init__(formula)
    

class Eventuality:
  """Defines an "eventuality", which represents an event or fact at several levels (natural language, ULF, and ELF).
  
  An Eventuality subsumes logical forms as well as their natural language expression, encapsulating them in one object.
  Minimally, an Eventuality has an episode variable/constant and a natural language string expressing the formula characterizing
  that event. On top of that, a ULF representation of that formula may be provided. At the highest level, a fully deindexed ELF
  representation may be provided.
  
  We assume that the level of representation builds upward, i.e., a natural language string may be easily derived from the ULF,
  and likewise, a ULF may be easily derived from the full ELF. On the other hand, mapping from natural language to ULF requires
  semantic parsing, and mapping from ULF to ELF requires disambiguation, scoping, and deindexing. Hence, we want to regard those
  upper levels of representation as "optional", since they may not be needed in simpler dialogue applications.

  Parameters
  ----------
  ep : str
    A symbol denoting the episode variable or constant.
  nl : str
    The natural language representation of the formula characterizing the event.
  ulf : ULF, optional
    The ULF formula characterizing the event.
  elf : ELF, optional
    The ELF formula characterizing the event.
  prob : float, default=1.
    The probability associated with this event.

  Attributes
  ----------
  ep : str
  nl : str
  ulf : ULF or None
  elf : ELF or None
  prob : float
  bindings : dict
    A mapping from variables to bound values.
  embedding : list[float]
    A vector embedding of this eventuality.
  """

  def __init__(self, ep, nl, ulf, elf, prob=1.):
    self.ep = ep
    self.nl = nl
    self.set_ulf(ulf)
    self.set_elf(elf)
    self.prob = prob
    self.bindings = {}
    self.embedding = []

  def set_ep(self, ep):
    """Set the episode symbol."""
    self.ep = ep

  def set_ulf(self, ulf):
    """Set the ULF formula."""
    if not ulf:
      self.ulf = None
    elif isinstance(ulf, ULF):
      self.ulf = ulf
    else:
      self.ulf = ULF(ulf)

  def set_elf(self, elf):
    """Set the ULF formula."""
    if not elf:
      self.elf = None
    elif isinstance(elf, ELF):
      self.elf = elf
    else:
      self.elf = ELF(elf)

  def set_prob(self, prob):
    """Set the probability of this event."""
    self.prob = prob
    
  def bind(self, var, val):
    """Bind the given variable symbol to the given value."""
    self.bindings[var] = val
    if self.ulf:
      self.ulf.bind(var, val)
    if self.elf:
      self.elf.bind(var, val)
    return self

  def unbind(self, var):
    """Unbind the given variable symbol."""
    if var in self.bindings:
      self.bindings.pop(var)
    if self.ulf:
      self.ulf.unbind(var)
    if self.elf:
      self.elf.unbind(var)
    return self

  def replacevar(self, var1, var2):
    """Replace the first variable symbol with the second variable symbol throughout the eventuality."""
    self.bindings = dict_substall_keys(self.bindings, [(var1, var2)])
    if self.ep == var1:
      self.ep = var2
    self.nl = self.nl.replace(var1, var2)
    if self.ulf:
      self.ulf.replacevar(var1, var2)
    if self.elf:
      self.elf.replacevar(var1, var2)

  def embed(self, embedder):
    """Embed the eventuality based on the natural language representation, given an embedder object."""
    self.embedding = embedder.embed(self.get_nl())

  def get_ep(self):
    """Get the episode symbol for this eventuality, applying any variable assignments."""
    return self.bindings[self.ep] if self.ep in self.bindings else self.ep

  def get_nl(self):
    """Get the natural language representation for this eventuality, applying any variable assignments."""
    nl_bindings = [(var, list_to_str(val)) for var, val in self.bindings.items()]
    return replaceall(self.nl, nl_bindings)

  def get_ulf(self):
    """Get the ULF representation for this eventuality, applying any variable assignments."""
    if not self.ulf:
      return []
    return self.ulf.get_formula()
  
  def get_elf(self):
    """Get the ELF representation for this eventuality, applying any variable assignments."""
    if not self.elf:
      return []
    return self.elf.get_formula()
  
  def get_wff(self, no_bind=False):
    """Get the highest level of representation available for this eventuality (if no_bind is given as True, do not apply bindings)."""
    if no_bind:
      return self.elf.formula if self.elf else self.ulf.formula if self.ulf else self.nl
    return self.get_elf() if self.elf else self.get_ulf() if self.ulf else self.get_nl()

  def format(self):
    """Format an eventuality as ((<ep> <wff>) <prob>), where <wff> is the highest level of representation for this eventuality."""
    return f'(({self.get_ep()} {self.get_wff()}) {self.prob})'

  def __str__(self):
    return self.format()
  
  def __eq__(self, other):
    # Assume that two Eventualities are equivalent if their surface realizations are the same
    return self.get_wff() == other.get_wff()
  
  def __hash__(self):
    return hash(f'({self.get_ep()} {self.get_wff()})')


class Condition(Eventuality):
  """A Condition is a special type of Eventuality that represents a conditional event.

  In addition to the basic Eventuality attributes, it also has a list of (<condition>, <eventualities>) pairs,
  where <condition> is either a ULF or True (for a default condition), and <eventualities> is a list of
  sub-eventualities that occur if the condition is true.

  Such an event is indicated by a :try-in-sequence or :if keyword in e.g. a schema.

  Attributes
  ----------
  ep : str
  nl : str
  ulf : ULF or None
  elf : ELF or None
  prob : float
  bindings : dict
  embedding : list[float]
  conditions : list[tuple[True or ULF, list[Eventuality]]]
    A list of pairs of conditions and eventuality lists.
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
  """A Repetition is a special type of Eventuality that represents a repeating event.

  In addition to the basic Eventuality attributes, it also has a condition and a sub-list of eventualities.
  The condition is either a ULF (or True for a repetition with no termination), such that the eventualities
  will occur until the condition is no longer true.

  Such an event is indicated by a :repeat-until keyword in a schema.

  Attributes
  ----------
  ep : str
  nl : str
  ulf : ULF or None
  elf : ELF or None
  prob : float
  bindings : dict
  embedding : list[float]
  condition : True or ULF
    The stopping condition for repetition.
  eventualities : list[Eventuality]
    The list of eventualities to repeat.
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
  """Parse an S-expression into an eventuality.

  Parameters
  ----------
  s : s-expr
    An S-expression to parse. If s contains a condition or repetition keyword as
    the first element, a Condition or Repetition object is created respectively; otherwise,
    a basic Eventuality object is created containing s as a formula.
  ep : str, optional
    If given, use this episode symbol for the created eventuality, rather than generating a new symbol.
  expectation : bool, default=False
    If True, this will interpret the eventuality as an expected episode rather than an observed episode,
    i.e., `ep` will become an episode variable instead of an episode constant.
  prob_dict : dict, optional
    A dictionary mapping episode symbols to probabilities, used to set the probability of this eventuality.

  Returns
  -------
  Eventuality
    The eventuality generated according to the above parameters.
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
  """Parse an S-expression containing conditional keywords into a Condition eventuality."""
  conditions = []
  if s[0] == ':if':
    if len(s) >= 4 and s[-2] == ':else':
      conditions.append((ULF(s[1]), parse_eventuality_list(s[2:-2], prob_dict=prob_dict)))
      conditions.append((True, parse_eventuality_list(s[-1], prob_dict=prob_dict)))
    else:
      conditions.append((ULF(s[1]), parse_eventuality_list(s[2:], prob_dict=prob_dict)))
  else:
    for cond in s[1:]:
      if cond[0] == ':if':
        conditions.append((ULF(cond[1]), parse_eventuality_list(cond[2:], prob_dict=prob_dict)))
      elif cond[0] == ':else':
        conditions.append((True, parse_eventuality_list(cond[1:], prob_dict=prob_dict)))
  return Condition(ep, ulf.to_nl(), ulf, None, conditions, prob=prob)


def parse_repetition(s, ulf, ep, prob, prob_dict={}):
  """Parse an S-expression containing repetition keywords into a Repetition eventuality."""
  condition = ULF(s[1])
  eventualities = parse_eventuality_list(s[2:], prob_dict=prob_dict)
  return Repetition(ep, ulf.to_nl(), ulf, None, condition, eventualities, prob=prob)


def parse_eventuality_list(lst, prob_dict={}):
  """Parse a list of alternating episode symbols and formulas into a list of eventualities.
  
  Parameters
  ----------
  lst : list[s-expr]
    A list of format ``[ep1, wff1, ep2, wff2, ...]``, where each ``(ep, wff)`` pair is to be parsed into an eventuality.
  prob_dict : dict, optional
    A dictionary mapping episode symbols to probabilities, used to set the probability of this eventuality.

  Returns
  -------
  list[Eventuality]
  """
  ret = []
  for ep, wff in zip(lst[::2], lst[1::2]):
    ret.append(parse_eventuality(wff, ep=ep, prob_dict=prob_dict))
  return ret


def from_lisp_file(fname, eventualities):
  """Read a list of eventualities from a LISP file, modifying the list in-place.
  
  Parameters
  ----------
  fname : str
    The LISP file to read.
  eventualities : list[Eventuality]
    The list of eventualities to modify in-place.
  """
  for expr in read_lisp(fname):
    if expr[0] == 'defparameter':
      contents = expr[2]
      for wff in contents:
        eventualities.append(parse_eventuality(wff))


def from_lisp_dirs(dirs):
  """Recursively read all LISP files in a given dir or list of dirs, returning a list of eventualities.
  
  Parameters
  ----------
  dirs : str or list[str]
    Either a directory name or a list of directory names to read.

  Returns
  -------
  list[Eventuality]
  """
  eventualities = []
  if isinstance(dirs, str):
    dirs = [dirs]
  for dir in dirs:
    fnames = glob.glob(dir + '/**/*.lisp', recursive=True)
    for fname in fnames:
      from_lisp_file(fname, eventualities)
  return eventualities


def expectation_p(e):
  """Check whether eventuality e is an expectation or intention.
  
  An eventuality is an expectation iff it is not a special eventuality type, and the subject of its wff is not Eta.
  """
  if type(e) in [Condition, Repetition]:
    return False
  wff = e.get_wff()
  return not ((isinstance(wff, list) and wff[0] == ME) or (isinstance(wff, str) and wff.split()[0] == ME))


def extract_set(ulf):
  """Extract a list of items from a wff of form ``[set-of, x, y, ...]``, or of form ``[x, and, y, and, ...]``."""
  if atom(ulf):
    return [ulf]
  elif ulf[0] == 'set-of':
    return ulf[1:]
  else:
    return [x for x in ulf if x not in ['and.cc', 'and']]
  

def make_set(lst):
  """Create a set wff from a list of items."""
  if atom(lst):
    return lst
  elif len(lst) == 1:
    return lst[0]
  else:
    return cons('set-of', lst)
  

def is_set(lst):
  """Check whether a given S-expression is a set wff."""
  return isinstance(lst, list) and (lst[0] == 'set-of' or lst[1] in ['and.cc', 'and'])


def set_union(lst1, lst2):
  """Forms a union set wff from two set wffs."""
  return make_set(remove_duplicates(extract_set(lst1)+extract_set(lst2), order=True))
  

def equal_prop_p(ulf):
  """Check whether a given wff is an equality predicate."""
  return listp(ulf) and len(ulf) == 3 and ulf[1] == '='

def not_prop_p(ulf):
  """Check whether a given wff is a negative predicate."""
  return listp(ulf) and len(ulf) == 2 and ulf[0] == 'not'

def and_prop_p(ulf):
  """Check whether a given wff is a conjunction predicate."""
  return listp(ulf) and len(ulf) == 3 and ulf[1] == 'and'

def or_prop_p(ulf):
  """Check whether a given wff is a disjunction predicate."""
  return listp(ulf) and len(ulf) == 3 and ulf[1] == 'or'

def characterizes_prop_p(ulf):
  """Check whether a given wff is a characterization predicate."""
  return listp(ulf) and len(ulf) == 3 and ulf[1] == '**'