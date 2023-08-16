import re

import eta.util.file as file
from eta.constants import ME, YOU
from eta.util.general import standardize
from eta.discourse import Utterance, DialogueTurn, get_prior_turn
from eta.transducers.base import *
from eta.util.gpt import generate_gpt
from eta.lf import parse_eventuality

def reasoning_validator(prompt, resp):
  facts = [l.strip() for l in resp.split('\n') if l.strip()]
  facts = [re.sub(r'^[0-9]*\. ', '', fact) for fact in facts]
  return facts

def paraphrase_validator(prompt, resp):
  return None if any([x in resp for x in ['Person A:', 'Person B:']]) else resp

def answer_validator(prompt, resp):
  if '.' not in resp:
    return None
  return re.sub(r'\.[^\.]*\?$', '.', resp)

PROMPTS = {
  'reasoning' : file.read_file('resources/prompts/reasoning.txt'),
  'gist' : file.read_file('resources/prompts/gist.txt'),
  'paraphrase' : file.read_file('resources/prompts/paraphrase.txt'),
  'response' : file.read_file('resources/prompts/response.txt'),
  'answer' : file.read_file('resources/prompts/answer.txt'),
  'ask' : file.read_file('resources/prompts/ask.txt')
}

VALIDATORS = {
  'reasoning' : [reasoning_validator],
  'gist' : [],
  'paraphrase' : [paraphrase_validator],
  'response' : [],
  'answer' : [answer_validator],
  'ask' : []
}

def apply_zip(prompt, kwargs):
  zip_regex = re.compile(r'@zip\((((<[a-zA-Z0-9_-]+>)(,[ ]*)?)+)\)')
  prompt1 = prompt
  for m in zip_regex.finditer(prompt):
    vars = [v.strip() for v in m.group(1).split(',')]
    vals = [''.join(t) for t in zip(*[kwargs[v.strip('<').strip('>')] for v in vars])]
    prompt1 = re.sub(fr'@zip\({m.group(1)}\)', '\n'.join(vals), prompt1)
  return prompt1


def subst_kwargs(prompt, kwargs):
  prompt = apply_zip(prompt, kwargs)
  for kw, arg in kwargs.items():
    if isinstance(arg, list):
      val = '\n'.join(arg) if arg else 'None'
    else:
      val = arg
    prompt = prompt.replace(f'<{kw}>', val)
  return prompt


def subst_examples(prompt, examples):
  if not '@startexamples' in prompt or not '@endexamples' in prompt:
    return prompt
  prompt1, template = prompt.split('@startexamples')
  template, prompt2 = template.split('@endexamples')
  template = template.strip()
  return prompt1 + '\n\n'.join([subst_kwargs(template, e) for e in examples]) + prompt2


class GPTTransducer(Transducer):
  def __init__(self, prompt, validators, examples=[]):
    self.prompt = subst_examples(prompt, examples)
    self.validators = validators
    self._cost = 0.

  def __call__(self, kwargs, stop=None):
    prompt = subst_kwargs(self.prompt, kwargs)
    result, cost = generate_gpt(prompt, postprocessors=self.validators, stop=stop)
    self._cost += cost
    return result
  
  def cost(self):
    return self._cost


class GPTReasoningTransducer(GPTTransducer, ReasoningTransducer):
  def __init__(self):
    super().__init__(PROMPTS['reasoning'], VALIDATORS['reasoning'])

  def __call__(self, facts):
    """List[Eventuality] -> List[Eventuality]"""
    new_facts = []
    if facts:
      new_facts_str = super().__call__({'facts': [fact.get_nl() for fact in facts]})
      new_facts = [parse_eventuality(standardize(fact)) for fact in new_facts_str]
    return new_facts
  

class GPTGistTransducer(GPTTransducer, GistTransducer):
  def __init__(self, examples=[]):
    super().__init__(PROMPTS['gist'], VALIDATORS['gist'], examples=examples)

  def __call__(self, utt, conversation_log):
    """str, List[DialogueTurn] -> str"""
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
    """str -> List"""
    # TODO
    ulf = []
    return ulf
  

class GPTPragmaticTransducer(GPTTransducer, PragmaticTransducer):
  def __init__(self):
    # TODO
    pass

  def __call__(self, gist):
    """str -> List"""
    # TODO
    ulf = []
    return ulf
  

class GPTReactionTransducer(GPTTransducer, ReactionTransducer):
  def __init__(self):
    # TODO
    pass

  def __call__(self, observation):
    """Eventuality -> List"""
    # TODO
    action = []
    return action
  

class GPTExpandStepTransducer(GPTTransducer, ExpandStepTransducer):
  def __init__(self):
    # TODO
    pass

  def __call__(self, step):
    """Eventuality -> List[Eventuality]"""
    # TODO
    substeps = []
    return substeps


class GPTParaphraseTransducer(GPTTransducer, ParaphraseTransducer):
  def __init__(self, examples=[]):
    for e in examples:
      e['agents-gen'] = self._to_generic_agents(e['agents'])
    super().__init__(PROMPTS['paraphrase'], VALIDATORS['paraphrase'], examples=examples)

  def __call__(self, gist, conversation_log, conds=[], facts=[]):
    """str, List[DialogueTurn], List[Eventuality], List[Eventuality] -> str"""
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
    return standardize(utt)
  
  def _to_generic_agents(self, agents):
    return ['Person A: ' if 'you' in a else 'Person B: ' for a in agents]
  

class GPTResponseTransducer(GPTTransducer, ResponseTransducer):
  def __init__(self):
    super().__init__(PROMPTS['response'], VALIDATORS['response'])

  def __call__(self, conversation_log, conds=[], facts=[]):
    """List[DialogueTurn], List[Eventuality], List[Eventuality] -> str"""
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    utt = super().__call__({
      'conds' : [cond.get_nl() for cond in conds],
      'facts' : [fact.get_nl() for fact in facts],
      'agents' : agents,
      'history' : history
    },
    stop=['^you:', '^me:'])
    return standardize(utt)
  

class GPTAnswerTransducer(GPTTransducer, AnswerTransducer):
  def __init__(self):
    super().__init__(PROMPTS['answer'], VALIDATORS['answer'])

  def __call__(self, conversation_log, conds=[], facts=[]):
    """List[DialogueTurn], List[Eventuality], List[Eventuality] -> str"""
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    utt = super().__call__({
      'conds' : [cond.get_nl() for cond in conds],
      'facts' : [fact.get_nl() for fact in facts],
      'agents' : agents,
      'history' : history
    })
    return standardize(utt)
  

class GPTAskTransducer(GPTTransducer, AskTransducer):
  def __init__(self):
    super().__init__(PROMPTS['ask'], VALIDATORS['ask'])

  def __call__(self, conversation_log, conds=[], facts=[]):
    """List[DialogueTurn], List[Eventuality], List[Eventuality] -> str"""
    history = [turn.utterance.words for turn in conversation_log]
    agents = [f'{turn.agent}: ' for turn in conversation_log]
    utt = super().__call__({
      'conds' : [cond.get_nl() for cond in conds],
      'facts' : [fact.get_nl() for fact in facts],
      'agents' : agents,
      'history' : history
    })
    return standardize(utt)


def test1():
  facts = ['it is snowing outside .', 'i am mortal .', 'i own a cat , and my cat is nice .', 'i own skiis .', '^you say-to ^me "I like to go skiing" .']
  test = GPTReasoningTransducer()
  new_facts = test([parse_eventuality(f) for f in facts])
  for f in new_facts:
    print(f)


def test2():
  examples = file.load_json('avatars/sophie-gpt/gist_examples.json')
  test = GPTGistTransducer(examples)

  clog = []
  utt = 'where is your pain ?'
  print(test(utt, clog))

  clog = [
    DialogueTurn('^me', Utterance('do i really need chemotherapy ?'), gists=['do i need chemotherapy ?']),
    DialogueTurn('^you', Utterance('hmm ...'))
  ]
  utt = 'yes , i would recommend it . did you come here with anyone today ?'
  print(test(utt, clog))


def test3():
  examples = file.load_json('avatars/sophie-gpt/paraphrase_examples.json')
  test = GPTParaphraseTransducer(examples)

  facts = [parse_eventuality('^me drove here today .'), parse_eventuality('^me wants to see ^my grandson graduate .')]
  clog = [
    DialogueTurn('^me', Utterance('is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn('^you', Utterance('nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  gist = 'what is my prognosis ?'
  print(test(gist, clog, facts=facts), '\n')


def test4():
  test = GPTResponseTransducer()

  conds = [parse_eventuality('^me should avoid using long words .'), parse_eventuality('^me is having trouble speaking because of how sad and shocked ^me is .')]
  facts = [parse_eventuality('^me drove here today .'), parse_eventuality('^me wants to see ^my grandson graduate .')]
  clog = [
    DialogueTurn('^me', Utterance('is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn('^you', Utterance('nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  print(test(clog, conds=conds, facts=facts), '\n')


def main():
  # test1()
  # test2()
  # test3()
  test4()


if __name__ == '__main__':
  main()