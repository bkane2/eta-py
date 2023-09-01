"""Base Transducers

Contains abstract base transducer classes for each supported transducer.

A transducer is an object that maps some set of arguments to some value; multiple
abstract transducers are supported for various types of mappings with different
function signatures.

The abstract transducers defined in this module do not actually implement any
behavior; it is expected that they will be extended with transducers that use
various techniques to perform a mapping (e.g., rule-based tree transduction,
statistical models, large language models, etc.).

Note that each transducer type should return a list; this allows multiple
transducer implementations to be "stacked" in practice, e.g., using both a
tree transduction and an LLM transducer and collating the results.

Exported classes
----------------
Transducer : the base transducer class.
ReasonTopDownTransducer : maps from a plan step event and a list of facts to a list of new facts inferred from those.
ReasonBottomUpTransducer : maps from a list of facts to a list of new facts inferred from those.
GistTransducer : maps an utterance to a list of gist clauses, given a conversation history.
SemanticTransducer : maps a gist clause to a list of ULF formulas capturing its semantic meaning.
PragmaticTransducer : maps a gist clause to a list of ULF formulas capturing its pragmatic meaning.
ReactionTransducer : maps an observed event to a formula for an action that an agent can take.
SubplanTransducer : maps a plan step event to a list of subplans, i.e., sequences of events that are substeps of the given step.
ParaphraseTransducer : maps a gist clause, given a conversation history and relevant knowledge, to a paraphrased response.
ResponseTransducer : maps a conversation history and relevant knowledge to a response utterance.
AnswerTransducer : maps a conversation history and relevant knowledge to an answer utterance.
AskTransducer : maps a conversation history and relevant knowledge to a question utterance.
AffectTransducer : maps the word content of an utterance to an appropriate affect, given a conversation history.
"""

from eta.lf import Eventuality
from eta.discourse import Utterance, DialogueTurn

class Transducer():
  """The base transducer class."""

  def __init__(self):
    pass

  def __call__(self, *args):
    """Map from input(s) to output."""
    self._validate(*args)
    pass

  def _validate(self, *args):
    """Validate the arguments passed to the transducer."""
    assert True

  def cost(self):
    """Report cumulative costs of applying this transducer."""
    return 0.
  

class ReasonTopDownTransducer(Transducer):
  """Maps from a plan step event and a list of facts to a list of new facts inferred from those.
  
  Parameters
  ----------
  step : Eventuality
    The event corresponding to the plan step to use as context for inference.
  facts : list[Eventuality]
    The list of facts to make inferences from.
  
  Returns
  -------
  list[Eventuality]
    A list of new facts inferred from the plan step and given facts.
  """

  def __init__(self):
    pass

  def __call__(self, step, facts):
    self._validate(step, facts)
    new_facts = []
    return new_facts
  
  def _validate(self, step, facts):
    pred1 = isinstance(step, Eventuality)
    pred2 = isinstance(facts, list) and all([isinstance(x, Eventuality) for x in facts])
    assert pred1 and pred2, 'Incorrect argument type for ReasonTopDownTransducer.'


class ReasonBottomUpTransducer(Transducer):
  """Maps from a list of facts to a list of new facts inferred from those.
  
  Parameters
  ----------
  facts : list[Eventuality]
    The list of facts to make inferences from.
  
  Returns
  -------
  list[Eventuality]
    A list of new facts inferred from the given facts.
  """

  def __init__(self):
    pass

  def __call__(self, facts):
    self._validate(facts)
    new_facts = []
    return new_facts
  
  def _validate(self, facts):
    pred = isinstance(facts, list) and all([isinstance(x, Eventuality) for x in facts])
    assert pred, 'Incorrect argument type for ReasonBottomUpTransducer.'
  

class GistTransducer(Transducer):
  """Maps an utterance to a list of gist clauses, given a conversation history.
  
  Parameters
  ----------
  utt : Utterance
    The utterance to interpret as a gist clause.
  conversation_log : list[DialogueTurn]
    The conversation history to use as context for interpretation.
  
  Returns
  -------
  list[str]
    A list of gist clauses.
  """

  def __init__(self):
    pass

  def __call__(self, utt, conversation_log):
    self._validate(utt, conversation_log)
    gists = []
    return gists
  
  def _validate(self, utt, conversation_log):
    pred1 = isinstance(utt, Utterance)
    pred2 = isinstance(conversation_log, list) and all([isinstance(x, DialogueTurn) for x in conversation_log])
    assert pred1 and pred2, 'Incorrect argument types for GistTransducer.'
  

class SemanticTransducer(Transducer):
  """Maps a gist clause to a list of ULF formulas capturing its semantic meaning.
  
  Parameters
  ----------
  gist : str
    The gist clause to parse to a logical form.
  
  Returns
  -------
  list[s-expr]
    A list of ULF S-expressions.
  """

  def __init__(self):
    pass

  def __call__(self, gist):
    self._validate(gist)
    ulf = []
    return ulf
  
  def _validate(self, gist):
    pred = isinstance(gist, str)
    assert pred, 'Incorrect argument type for SemanticTransducer.'
  

class PragmaticTransducer(Transducer):
  """Maps a gist clause to a list of ULF formulas capturing its pragmatic meaning.
  
  Parameters
  ----------
  gist : str
    The gist clause to parse to a logical form.
  
  Returns
  -------
  list[s-expr]
    A list of ULF S-expressions.
  """

  def __init__(self):
    pass

  def __call__(self, gist):
    self._validate(gist)
    ulf = []
    return ulf
  
  def _validate(self, gist):
    pred = isinstance(gist, str)
    assert pred, 'Incorrect argument type for PragmaticTransducer.'
  

class ReactionTransducer(Transducer):
  """Maps an observed event to a formula for an action that an agent can take.

  TODO: this should likely be expanded to support a list of observed events rather than a single event,
  since in general a reaction may be contingent on multiple combined observations.
  
  Parameters
  ----------
  observation : Eventuality
    The observed event for the agent to react to.
  
  Returns
  -------
  list[s-expr]
    A list of action formulas that the agent can take in reaction to the observation.
  """

  def __init__(self):
    pass

  def __call__(self, observation):
    self._validate(observation)
    action = []
    return action
  
  def _validate(self, observation):
    pred = isinstance(observation, Eventuality)
    assert pred, 'Incorrect argument type for ReactionTransducer.'
  

class SubplanTransducer(Transducer):
  """Maps a plan step event to a list of subplans, i.e., sequences of events that are substeps of the given step.
  
  Parameters
  ----------
  step : Eventuality
    The event corresponding to a plan step to expand.
  
  Returns
  -------
  list[list[Eventuality]]
    A list of subplans, where each subplan is a sequence of substep events.
  """

  def __init__(self):
    pass

  def __call__(self, step):
    self._validate(step)
    substeps = []
    return substeps
  
  def _validate(self, step):
    pred = isinstance(step, Eventuality)
    assert pred, 'Incorrect argument type for SubplanTransducer.' 
  

class ParaphraseTransducer(Transducer):
  """Maps a gist clause, given a conversation history and relevant knowledge, to a paraphrased response.
  
  Parameters
  ----------
  gist : str
    The gist clause to paraphrase.
  conversation_log : list[DialogueTurn]
    The conversation history to use as context for paraphrasing.
  conds : list[Eventuality]
    A list of "background" knowledge to use for paraphrasing, i.e., knowledge that may impact the
    resulting paraphrase, but may not be directly included in the paraphrased response.
  facts : list[Eventuality]
    A list of "foreground" knowledge to use for paraphrasing, i.e., knowledge that should be
    directly included in the paraphrased response.
  
  Returns
  -------
  list[str]
    A list of paraphrased responses.
  """

  def __init__(self):
    pass

  def __call__(self, gist, conversation_log, conds, facts):
    self._validate(gist, conversation_log, conds, facts)
    utts = []
    return utts
  
  def _validate(self, gist, conversation_log, conds, facts):
    pred1 = isinstance(gist, str)
    pred2 = isinstance(conversation_log, list) and all([isinstance(x, DialogueTurn) for x in conversation_log])
    pred3 = isinstance(conds, list) and all([isinstance(x, Eventuality) for x in conds])
    pred4 = isinstance(facts, list) and all([isinstance(x, Eventuality) for x in facts])
    assert pred1 and pred2 and pred3 and pred4, 'Incorrect argument type for ParaphraseTransducer.' 
  

class ResponseTransducer(Transducer):
  """Maps a conversation history and relevant knowledge to a response utterance.
  
  Parameters
  ----------
  conversation_log : list[DialogueTurn]
    The conversation history to use as context for the response.
  conds : list[Eventuality]
    A list of "background" knowledge to use for the response, i.e., knowledge that may impact the
    resulting response, but may not be directly included in the response.
  facts : list[Eventuality]
    A list of "foreground" knowledge to use for the response, i.e., knowledge that should be
    directly included in the response.
  
  Returns
  -------
  list[str]
    A list of responses.
  """

  def __init__(self):
    pass

  def __call__(self, conversation_log, conds, facts):
    self._validate(conversation_log, conds, facts)
    utts = []
    return utts
  
  def _validate(self, conversation_log, conds, facts):
    pred1 = isinstance(conversation_log, list) and all([isinstance(x, DialogueTurn) for x in conversation_log])
    pred2 = isinstance(conds, list) and all([isinstance(x, Eventuality) for x in conds])
    pred3 = isinstance(facts, list) and all([isinstance(x, Eventuality) for x in facts])
    assert pred1 and pred2 and pred3, 'Incorrect argument type for ResponseTransducer.'  
  

class AnswerTransducer(Transducer):
  """Maps a conversation history and relevant knowledge to an answer utterance.
  
  Parameters
  ----------
  conversation_log : list[DialogueTurn]
    The conversation history to use as context for the answer.
  conds : list[Eventuality]
    A list of "background" knowledge to use for the answer, i.e., knowledge that may impact the
    resulting answer, but may not be directly included in the answer.
  facts : list[Eventuality]
    A list of "foreground" knowledge to use for the answer, i.e., knowledge that should be
    directly included in the answer.
  
  Returns
  -------
  list[str]
    A list of answers.
  """

  def __init__(self):
    pass

  def __call__(self, conversation_log, conds, facts):
    self._validate(conversation_log, conds, facts)
    utts = []
    return utts
  
  def _validate(self, conversation_log, conds, facts):
    pred1 = isinstance(conversation_log, list) and all([isinstance(x, DialogueTurn) for x in conversation_log])
    pred2 = isinstance(conds, list) and all([isinstance(x, Eventuality) for x in conds])
    pred3 = isinstance(facts, list) and all([isinstance(x, Eventuality) for x in facts])
    assert pred1 and pred2 and pred3, 'Incorrect argument type for AnswerTransducer.'  
  

class AskTransducer(Transducer):
  """Maps a conversation history and relevant knowledge to a question utterance.
  
  Parameters
  ----------
  conversation_log : list[DialogueTurn]
    The conversation history to use as context for the question.
  conds : list[Eventuality]
    A list of "background" knowledge to use for the question, i.e., knowledge that may impact the
    resulting question, but may not be directly included in the question.
  facts : list[Eventuality]
    A list of "foreground" knowledge to use for the question, i.e., knowledge that should be
    directly included in the question.
  
  Returns
  -------
  list[str]
    A list of questions.
  """

  def __init__(self):
    pass

  def __call__(self, conversation_log, conds, facts):
    self._validate(conversation_log, conds, facts)
    utts = []
    return utts
  
  def _validate(self, conversation_log, conds, facts):
    pred1 = isinstance(conversation_log, list) and all([isinstance(x, DialogueTurn) for x in conversation_log])
    pred2 = isinstance(conds, list) and all([isinstance(x, Eventuality) for x in conds])
    pred3 = isinstance(facts, list) and all([isinstance(x, Eventuality) for x in facts])
    assert pred1 and pred2 and pred3, 'Incorrect argument type for AskTransducer.'  
  

class AffectTransducer(Transducer):
  """Maps the word content of an utterance to an appropriate affect, given a conversation history.
  
  Parameters
  ----------
  words : str
    The words to match to an appropriate affect.
  conversation_log : list[DialogueTurn]
    The conversation history to use as context for affect detection.
  
  Returns
  -------
  list[str]
    A list of affects.
  """

  def __init__(self):
    pass

  def __call__(self, words, conversation_log):
    self._validate(words, conversation_log)
    affects = []
    return affects
  
  def _validate(self, words, conversation_log):
    pred1 = isinstance(words, str)
    pred2 = isinstance(conversation_log, list) and all([isinstance(x, DialogueTurn) for x in conversation_log])
    assert pred1 and pred2, 'Incorrect argument type for AffectTransducer.'