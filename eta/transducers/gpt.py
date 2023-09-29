"""Contains implementations of transducers that rely on OpenAI's GPT API.

Each transducer type defined here subclasses GPTTransducer, which contains the core implementation of the GPT mapping process.

Each GPT transducer is instantiated with a prompt (possibly formatted with examples upon initialization)
as well as a set of validator functions for validating and postprocessing the model output.

Applying a GPT transducer consists of formatting the prompt with the provided arguments, and then
generating using the GPT API until a valid generation is found.

Full documentation on the GPT interface can be found in the ``eta.util.gpt`` module.
"""

import re

import eta.util.file as file
from eta.constants import *
from eta.util.general import standardize
from eta.discourse import get_prior_words, swap_duals
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
  'reason-bottom-up' : file.read_file('resources/prompts/reason-bottom-up.txt', in_module=True),
  'gist' : file.read_file('resources/prompts/gist.txt', in_module=True),
  'paraphrase' : file.read_file('resources/prompts/paraphrase.txt', in_module=True),
  'response' : file.read_file('resources/prompts/response.txt', in_module=True),
  'answer' : file.read_file('resources/prompts/answer.txt', in_module=True),
  'ask' : file.read_file('resources/prompts/ask.txt', in_module=True),
  'affect' : file.read_file('resources/prompts/affect.txt', in_module=True),
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

  Parameters
  ----------
  prompt : str
    An LLM prompt.
  validators : list[function]
    A list of validator functions.
  examples : list[dict], optional
    A list of examples to format the prompt with (which should have corresponding ``@startexamples`` and
    ``@endexamples`` annotations); each example should contain a mapping from placeholders in the prompt
    to values (which may be strings or lists of strings).

  Attributes
  ----------
  prompt : str
  validators : list[function]
  _cost : float
    An accumulator variable for the total cost of applying a transducer instance within a session.
  """

  def __init__(self, prompt, validators, examples=[], debug=True):
    self.prompt = subst_examples(prompt, examples)
    self.validators = validators
    self._cost = 0.
    self.debug = debug
    if self.debug:
      file.ensure_file_exists(GPT_DEBUG_FILE)
      file.clear(GPT_DEBUG_FILE)
    self.idx = 1

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
    if self.debug:
      file.append_file(GPT_DEBUG_FILE, str(self.idx)+':\n\n'+prompt+'\n\n')
      file.append_file(GPT_DEBUG_FILE, 'result: '+str(result)+'\n\n-------------------\n\n')
      self.idx += 1
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
    agent = utt.agent
    utt = utt.words
    prior_agent = ME if agent == YOU else YOU
    prev_utt = get_prior_words(conversation_log, prior_agent)
    if agent == ME:
      prev_utt = swap_duals(prev_utt)

    gist = super().__call__({'prev-utt': prev_utt, 'utt': utt})
    if gist == 'NONE':
      return []
    gist = standardize(gist)
    if agent == YOU:
      gist = swap_duals(gist)
    
    # TODO: ultimately we should split each sentence into a separate gist clause,
    # but this likely requires coref.
    return [gist]
  

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
  def __init__(self, examples=[], history_window_size=4):
    for e in examples:
      e['agents-gen'] = self._to_generic_agents(e['agents'])
    super().__init__(PROMPTS['paraphrase'], VALIDATORS['paraphrase'], examples=examples)
    self.window_size = history_window_size

  def __call__(self, gist, conversation_log, facts_bg, facts_fg):
    self._validate(gist, conversation_log, facts_bg, facts_fg)
    # do not use conversation log if only single Eta utterance so far
    if len(conversation_log) == 1 and conversation_log[0].agent == ME:
      conversation_log = []
    if self.window_size >= 1:
      conversation_log = conversation_log[-self.window_size:]
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    agents_gen = self._to_generic_agents(agents)
    utt = super().__call__({
      'facts-bg' : [fact.get_nl() for fact in facts_bg],
      'facts-fg' : [fact.get_nl() for fact in facts_fg],
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

  def __call__(self, conversation_log, facts_bg, facts_fg):
    self._validate(conversation_log, facts_bg, facts_fg)
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    utt = super().__call__({
      'facts-bg' : [fact.get_nl() for fact in facts_bg],
      'facts-fg' : [fact.get_nl() for fact in facts_fg],
      'agents' : agents,
      'history' : history
    },
    stop=['^you:', '^me:'])
    return [standardize(utt)]
  

class GPTAnswerTransducer(GPTTransducer, AnswerTransducer):
  def __init__(self):
    super().__init__(PROMPTS['answer'], VALIDATORS['answer'])

  def __call__(self, conversation_log, facts_bg, facts_fg):
    self._validate(conversation_log, facts_bg, facts_fg)
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    utt = super().__call__({
      'facts-bg' : [fact.get_nl() for fact in facts_bg],
      'facts-fg' : [fact.get_nl() for fact in facts_fg],
      'agents' : agents,
      'history' : history
    })
    return [standardize(utt)]
  

class GPTAskTransducer(GPTTransducer, AskTransducer):
  def __init__(self):
    super().__init__(PROMPTS['ask'], VALIDATORS['ask'])

  def __call__(self, conversation_log, facts_bg, facts_fg):
    self._validate(conversation_log, facts_bg, facts_fg)
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    utt = super().__call__({
      'facts-bg' : [fact.get_nl() for fact in facts_bg],
      'facts-fg' : [fact.get_nl() for fact in facts_fg],
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