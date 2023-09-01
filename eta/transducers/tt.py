"""Tree Transduction (TT) Transducers

Contains implementations of transducers that rely on rule-based Tree Transduction (TT). Each
transducer type defined here subclasses TTTransducer, which contains the core implementation
of the TT mapping process.

Each TT transducer is instantiated with a forest of choice trees read from a directory of LISP choice tree packets,
as well as one or multiple root names that are used to begin the choice process for that particular transducer.
If multiple roots are provided, the results from each are combined.

The choice tree results are processed slightly differently depending on the directive of the result,
i.e., string-like directives (:out, :gist, etc.) are joined to create strings, whereas S-expression-like
directives (:ulf, :schema, :raw, etc.) are returned as-is. Results using the :and keyword are also
flattened to create a single list of outputs.

Full documentation on TT can be found in the eta.util.tt package. 

Exported classes
----------------
TTReasonTopDownTransducer
TTReasonBottomUpTransducer
TTGistTransducer
TTSemanticTransducer
TTPragmaticTransducer
TTReactionTransducer
TTSubplanTransducer
TTParaphraseTransducer
TTResponseTransducer
TTAnswerTransducer
TTAskTransducer
TTAffectTransducer
"""

from eta.transducers.base import *
from eta.lf import parse_eventuality, is_set, extract_set
from eta.discourse import get_prior_turn

from eta.constants import *
from eta.util.general import listp, cons, remove_duplicates, isquote
from eta.util.tt.choice import choose_result_for
from eta.util.tt.parse import from_lisp_dirs

class TTTransducer(Transducer):
  """The abstract TT transducer class containing the core implementation of the TT mapping process.
  
  Each TT transducer is initialized with a set of trees and word features read from a directory of LISP
  choice tree packets, as well as a list of root names to use specific to that particular transducer.

  The transducer performs a mapping by passing its arguments (or some data derived from the arguments)
  to its root choice tree(s), processing the results based on the directive, and combining them into a
  single flat list.

  Attributes
  ----------
  trees : dict
    A dict mapping choice tree root names to the choice tree roots.
  feats : dict
    A dict mapping words to feature lists.
  roots : list[str]
    A list of root names to use for choosing results.
  """

  def __init__(self, rule_dirs, roots):
    """Create a TT transducer instance.
    
    Parameters
    ----------
    rule_dirs : str or list[str]
      The directory name(s) containing LISP choice tree packets to read from.
    roots : str or list[str]
      The root name(s) to use for choosing results for this transducer instance.
    """
    self.trees, self.feats = from_lisp_dirs(rule_dirs)
    if isinstance(roots, str):
      self.roots = [roots]
    else:
      self.roots = roots

  def __call__(self, inputs):
    """Choose a result for some input using TT.

    Parameters
    ----------
    inputs : str or list[str] or s-expr
      The input or inputs to use for choosing a result. If the input is a string or list of
      strings (where none of the strings are quoted expressions), it is used to create a single
      word list after concatenating each substring. Otherwise, the input is an S-expression and
      is used directly as input.
    
    Returns
    -------
    list[str or s-expr]
      A list of chosen results (which may be processed further by the specific transducer instance).
    """
    # TODO: the following logic may not work in the case where ULF inputs are mixed with string inputs
    # (the latter of which should still be split into word lists), but for the time being we assume
    # representations won't be mixed.
    if isinstance(inputs, str):
      clause = inputs.split()
    elif inputs and listp(inputs) and all([isinstance(x, str) and not isquote(x) for x in inputs]):
      clause = ' '.join(inputs).split()
    else:
      clause = inputs

    ret = []
    for root in self.roots:
      choice = choose_result_for(clause, root, self.trees, self.feats)
      choice = self._process_choice(choice)
      if choice and listp(choice) and choice[0] == ':and':
        ret = ret + choice[1:]
      elif choice and listp(choice) and is_set(choice):
        ret = ret + extract_set(choice)
      else:
        ret.append(choice)
    return remove_duplicates([r for r in ret if r], order=True)

  def _process_choice(self, choice):
    if not choice:
      return []
    if listp(choice) and choice[0] == ':and':
      return cons(':and', [self._process_choice(c) for c in choice[1:]])
    if not isinstance(choice, tuple) or not isinstance(choice[0], str) or not choice[0][0] == ':':
      return choice
    
    directive, result = choice
    if directive == ':out':
      result = ' '.join(result)
      return result
    elif directive == ':gist':
      # The legacy choice tree format supported 'topic keys', but we ignore those for now
      if listp(result[0]):
        result = result[0]
      result = ' '.join(result)
      return result
    elif directive == ':nl':
      result = ' '.join(result)
      return result
    elif directive == ':ulf':
      return result
    elif directive in [':schema', ':schemas', ':schema+args', ':subtrees', ':raw']:
      return result

  def cost(self):
    """TT is performed locally so does not incur any cost."""
    return 0.
  

class TTReasonTopDownTransducer(TTTransducer, ReasonTopDownTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'reason-top-down')
  
  def __call__(self, step, facts):
    self._validate(step, facts)
    new_facts = super().__call__(cons(step.get_wff(), [fact.get_wff() for fact in facts]))
    return [parse_eventuality(fact) for fact in new_facts]
    

class TTReasonBottomUpTransducer(TTTransducer, ReasonBottomUpTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'reason-bottom-up')

  def __call__(self, facts):
    self._validate(facts)
    new_facts = super().__call__([fact.get_wff() for fact in facts])
    return [parse_eventuality(fact) for fact in new_facts]
  

class TTGistTransducer(TTTransducer, GistTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'gist')

  def __call__(self, utt, conversation_log):
    self._validate(utt, conversation_log)
    utt = utt.words
    prev_gist = ''
    prior_turn = get_prior_turn(conversation_log, ME)
    gists = []
    if prior_turn:
      prev_gists = prior_turn.gists
      for prev_gist in prev_gists:
        gists += super().__call__([prev_gist.split(), utt.split()])
    return gists
  

class TTSemanticTransducer(TTTransducer, SemanticTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'semantic')

  def __call__(self, gist):
    self._validate(gist)
    return super().__call__(gist.split())
  

class TTPragmaticTransducer(TTTransducer, PragmaticTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'pragmatic')

  def __call__(self, gist):
    self._validate(gist)
    return super().__call__(gist.split())
  

class TTReactionTransducer(TTTransducer, ReactionTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'reaction')

  def __call__(self, observation):
    self._validate(observation)
    wff = observation.get_wff()
    return super().__call__(wff)
  

class TTSubplanTransducer(TTTransducer, SubplanTransducer):
  def __init__(self, rule_dirs):
    # TODO
    pass

  def __call__(self, step):
    self._validate(step)
    # TODO
    substeps = []
    return substeps
  

class TTParaphraseTransducer(TTTransducer, ParaphraseTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'paraphrase')

  def __call__(self, gist, conversation_log, conds, facts):
    self._validate(gist, conversation_log, conds, facts)
    prev_gist = ''
    prior_turn = get_prior_turn(conversation_log, YOU)
    utts = []
    if prior_turn:
      prev_gists = prior_turn.gists
      for prev_gist in prev_gists:
        utts += super().__call__([prev_gist.split(), gist.split()])
    return utts
  

class TTResponseTransducer(TTTransducer, ResponseTransducer):
  def __init__(self, rule_dirs):
    # TODO
    pass

  def __call__(self, conversation_log, conds, facts):
    self._validate(conversation_log, conds, facts)
    # TODO
    utts = []
    return utts
  

class TTAnswerTransducer(TTTransducer, AnswerTransducer):
  def __init__(self, rule_dirs):
    # TODO
    pass

  def __call__(self, conversation_log, conds, facts):
    self._validate(conversation_log, conds, facts)
    # TODO
    utts = []
    return utts
  

class TTAskTransducer(TTTransducer, AskTransducer):
  def __init__(self, rule_dirs):
    # TODO
    pass

  def __call__(self, conversation_log, conds, facts):
    self._validate(conversation_log, conds, facts)
    # TODO
    utts = []
    return utts
  

class TTAffectTransducer(TTTransducer, AffectTransducer):
  def __init__(self, rule_dirs):
    # TODO
    pass

  def __call__(self, words, conversation_log):
    self._validate(words, conversation_log)
    # TODO
    affects = []
    return affects