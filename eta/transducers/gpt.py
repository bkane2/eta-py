"""GPT Transducers

Contains implementations of transducers that rely on OpenAI's GPT API. Each transducer type defined
here subclasses GPTTransducer, which contains the core implementation of the GPT mapping process.

Each GPT transducer is instantiated with a prompt (possibly formatted with examples upon initialization)
as well as a set of validator functions for validating and postprocessing the model output.

Applying a GPT transducer consists of formatting the prompt with the provided arguments, and then
generating using the GPT API until a valid generation is found.

Full documentation on the GPT interface can be found in the eta.util.gpt module. 

Exported classes
----------------
GPTReasonTopDownTransducer
GPTReasonBottomUpTransducer
GPTGistTransducer
GPTSemanticTransducer
GPTPragmaticTransducer
GPTReactionTransducer
GPTSubplanTransducer
GPTParaphraseTransducer
GPTResponseTransducer
GPTAnswerTransducer
GPTAskTransducer
GPTAffectTransducer
"""

import re

import eta.util.file as file
from eta.constants import *
from eta.util.general import standardize
from eta.discourse import get_prior_turn
from eta.transducers.base import *
from eta.util.gpt import generate_gpt, subst_examples, subst_kwargs 
from eta.lf import parse_eventuality

def _reason_validator(prompt, resp):
  facts = [l.strip() for l in resp.split('\n') if l.strip()]
  facts = [re.sub(r'^[0-9]*\. ', '', fact) for fact in facts]
  return facts

def _paraphrase_validator(prompt, resp):
  return None if any([x in resp for x in ['Person A:', 'Person B:']]) else resp

def _answer_validator(prompt, resp):
  if '.' not in resp:
    return None
  return re.sub(r'\.[^\.]*\?$', '.', resp)

def _affect_validator(prompt, resp):
  if resp not in EMOTIONS_LIST:
    return EMOTIONS_LIST[0]
  return resp

PROMPTS = {
  'reason-bottom-up' : file.read_file('eta/resources/prompts/reason-bottom-up.txt'),
  'gist' : file.read_file('eta/resources/prompts/gist.txt'),
  'paraphrase' : file.read_file('eta/resources/prompts/paraphrase.txt'),
  'response' : file.read_file('eta/resources/prompts/response.txt'),
  'answer' : file.read_file('eta/resources/prompts/answer.txt'),
  'ask' : file.read_file('eta/resources/prompts/ask.txt'),
  'affect' : file.read_file('eta/resources/prompts/affect.txt')
}
"""dict: a dict of prompts to use for initializing each transducer type."""

VALIDATORS = {
  'reason-bottom-up' : [_reason_validator],
  'gist' : [],
  'paraphrase' : [_paraphrase_validator],
  'response' : [],
  'answer' : [_answer_validator],
  'ask' : [],
  'affect' : [_affect_validator]
}
"""dict: a dict of validator functions to use for each transducer type."""


class GPTTransducer(Transducer):
  """The abstract GPT transducer class containing the core implementation of the GPT mapping process.
  
  Each GPT transducer is initialized with a prompt (generally containing placeholders for arguments),
  and a list of validator functions to validate GPT output and perform postprocessing.

  The transducer performs a mapping by filling in placeholders in the prompt with arguments (or data
  derived from the arguments), and generating some output from GPT until one is found that passes the
  validator functions.

  Attributes
  ----------
  prompt : str
    An LLM prompt.
  validators : list[function]
    A list of validator functions.
  _cost : float
    An accumulator variable for the total cost of applying a transducer instance within a session.
  """

  def __init__(self, prompt, validators, examples=[]):
    """Create a GPT transducer instance.
    
    Parameters
    ----------
    prompt : str
    validators : list[function]
    examples : list[dict], optional
      A list of examples to format the prompt with (which should have corresponding @startexamples and
      @endexamples annotations); each example should contain a mapping from placeholders in the prompt
      to values (which may be strings or lists of strings).
    """
    self.prompt = subst_examples(prompt, examples)
    self.validators = validators
    self._cost = 0.

  def __call__(self, kwargs, stop=None):
    """Generate a result for some input using GPT.

    Parameters
    ----------
    kwargs : dict
      A dict mapping placeholders in the prompt to values (which may be strings or lists of strings).
    stop : list[str], optional
      A list of stop sequences to pass to GPT.
    
    Returns
    -------
    str or list[str]
      The output of the validator functions after generation (which may be processed further by the
      specific transducer instance).
    """
    prompt = subst_kwargs(self.prompt, kwargs)
    result, cost = generate_gpt(prompt, postprocessors=self.validators, stop=stop)
    self._cost += cost
    return result
  
  def cost(self):
    """Get the accumulated cost of applying a GPT transducer within a session."""
    return self._cost
  

class GPTReasonTopDownTransducer(GPTTransducer, ReasonTopDownTransducer):
  def __init__(self):
    # TODO
    pass

  def __call__(self, step, facts):
    self._validate(step, facts)
    # TODO
    new_facts = []
    return new_facts


class GPTReasonBottomUpTransducer(GPTTransducer, ReasonBottomUpTransducer):
  def __init__(self):
    super().__init__(PROMPTS['reason-bottom-up'], VALIDATORS['reason-bottom-up'])

  def __call__(self, facts):
    self._validate(facts)
    new_facts = []
    if facts:
      new_facts_str = super().__call__({'facts': [fact.get_nl() for fact in facts]})
      new_facts = [parse_eventuality(standardize(fact)) for fact in new_facts_str]
    return new_facts
  

class GPTGistTransducer(GPTTransducer, GistTransducer):
  def __init__(self, examples=[]):
    super().__init__(PROMPTS['gist'], VALIDATORS['gist'], examples=examples)

  def __call__(self, utt, conversation_log):
    self._validate(utt, conversation_log)
    # TODO: need to deal with pronoun swapping here
    utt = utt.words
    prev_utt = 'Hello.'
    prior_turn = get_prior_turn(conversation_log, ME)
    if prior_turn:
      prev_utt = prior_turn.utterance.words
    gist = super().__call__({'prev-utt': prev_utt, 'utt': utt})
    if gist == 'NONE':
      return []
    # TODO: ultimately we should split each sentence into a separate gist clause,
    # but this likely requires coref.
    return [standardize(gist)]
  

class GPTSemanticTransducer(GPTTransducer, SemanticTransducer):
  def __init__(self):
    # TODO
    pass

  def __call__(self, gist):
    self._validate(gist)
    # TODO
    ulf = []
    return ulf
  

class GPTPragmaticTransducer(GPTTransducer, PragmaticTransducer):
  def __init__(self):
    # TODO
    pass

  def __call__(self, gist):
    self._validate(gist)
    # TODO
    ulf = []
    return ulf
  

class GPTReactionTransducer(GPTTransducer, ReactionTransducer):
  def __init__(self):
    # TODO
    pass

  def __call__(self, observation):
    self._validate(observation)
    # TODO
    action = []
    return action
  

class GPTSubplanTransducer(GPTTransducer, SubplanTransducer):
  def __init__(self):
    # TODO
    pass

  def __call__(self, step):
    self._validate(step)
    # TODO
    substeps = []
    return substeps


class GPTParaphraseTransducer(GPTTransducer, ParaphraseTransducer):
  def __init__(self, examples=[]):
    for e in examples:
      e['agents-gen'] = self._to_generic_agents(e['agents'])
    super().__init__(PROMPTS['paraphrase'], VALIDATORS['paraphrase'], examples=examples)

  def __call__(self, gist, conversation_log, conds, facts):
    self._validate(gist, conversation_log, conds, facts)
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    agents_gen = self._to_generic_agents(agents)
    utt = super().__call__({
      'conds' : [cond.get_nl() for cond in conds],
      'facts' : [fact.get_nl() for fact in facts],
      'agents-gen' : agents_gen,
      'agents' : agents,
      'history' : history,
      'gist' : gist
    },
    stop=['^you:', '^me:', '^me [REWRITTEN]'])
    return [standardize(utt)]
  
  def _to_generic_agents(self, agents):
    return ['Person A: ' if 'you' in a else 'Person B: ' for a in agents]
  

class GPTResponseTransducer(GPTTransducer, ResponseTransducer):
  def __init__(self):
    super().__init__(PROMPTS['response'], VALIDATORS['response'])

  def __call__(self, conversation_log, conds, facts):
    self._validate(conversation_log, conds, facts)
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    utt = super().__call__({
      'conds' : [cond.get_nl() for cond in conds],
      'facts' : [fact.get_nl() for fact in facts],
      'agents' : agents,
      'history' : history
    },
    stop=['^you:', '^me:'])
    return [standardize(utt)]
  

class GPTAnswerTransducer(GPTTransducer, AnswerTransducer):
  def __init__(self):
    super().__init__(PROMPTS['answer'], VALIDATORS['answer'])

  def __call__(self, conversation_log, conds, facts):
    self._validate(conversation_log, conds, facts)
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    utt = super().__call__({
      'conds' : [cond.get_nl() for cond in conds],
      'facts' : [fact.get_nl() for fact in facts],
      'agents' : agents,
      'history' : history
    })
    return [standardize(utt)]
  

class GPTAskTransducer(GPTTransducer, AskTransducer):
  def __init__(self):
    super().__init__(PROMPTS['ask'], VALIDATORS['ask'])

  def __call__(self, conversation_log, conds, facts):
    self._validate(conversation_log, conds, facts)
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    utt = super().__call__({
      'conds' : [cond.get_nl() for cond in conds],
      'facts' : [fact.get_nl() for fact in facts],
      'agents' : agents,
      'history' : history
    })
    return [standardize(utt)]
  

class GPTAffectTransducer(GPTTransducer, AffectTransducer):
  def __init__(self):
    super().__init__(PROMPTS['affect'], VALIDATORS['affect'])

  def __call__(self, words, conversation_log):
    self._validate(words, conversation_log)
    history = [turn.utterance.words for turn in conversation_log[-3:]]
    agents = [f'{turn.agent}: ' for turn in conversation_log[-3:]]
    affect = super().__call__({
      'emotions' : ', '.join(EMOTIONS_LIST),
      'agents' : agents,
      'history' : history,
      'words' : words
    })
    return [affect]