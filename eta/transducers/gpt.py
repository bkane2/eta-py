import re

import eta.util.file as file
from eta.constants import ME
from eta.util.general import standardize
from eta.discourse import Utterance, DialogueTurn, get_prior_turn
from eta.transducers.base import *
from eta.util.gpt import generate_gpt
from eta.lf import parse_eventuality

def reasoning_validator(prompt, resp):
  facts = [l.strip() for l in resp.split('\n') if l.strip()]
  facts = [re.sub(r'^[0-9]*\. ', '', fact) for fact in facts]
  return facts

PROMPTS = {
  'reasoning' : file.read_file('resources/prompts/reasoning.txt'),
  'gist' : file.read_file('resources/prompts/gist.txt')
}

VALIDATORS = {
  'reasoning' : [reasoning_validator],
  'gist' : []
}


class GPTTransducer(Transducer):
  def __init__(self, prompt, validators):
    self.prompt = prompt
    self.validators = validators
    self._cost = 0.

  def __call__(self, kwargs):
    prompt = self.prompt
    for kw, arg in kwargs.items():
      prompt = prompt.replace(f'<{kw}>', arg)
    result, cost = generate_gpt(prompt, postprocessors=self.validators)
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
      new_facts_str = super().__call__({'facts': '\n'.join([fact.get_nl() for fact in facts])})
      new_facts = [parse_eventuality(standardize(fact)) for fact in new_facts_str]
    return new_facts
  

class GPTGistTransducer(GPTTransducer, GistTransducer):
  def __init__(self):
    super().__init__(PROMPTS['gist'], VALIDATORS['gist'])

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
  

class GPTSemanticTransducer(GPTTransducer, GistTransducer):
  def __init__(self):
    # TODO
    pass

  def __call__(self, gist):
    """str -> List"""
    # TODO
    ulf = []
    return ulf
  

class PragmaticTransducer(GPTTransducer, GistTransducer):
  def __init__(self):
    # TODO
    pass

  def __call__(self, gist):
    """str -> List"""
    # TODO
    ulf = []
    return ulf


class GPTParaphraseTransducer(GPTTransducer, ParaphraseTransducer):
  def __init__(self):
    # TODO
    pass
    # super().__init__(PROMPTS['gist'], [])

  def __call__(self, gist, prev_gist, history):
    """str, str, List[str] -> Eventuality"""
    # TODO
    pass


def test1():
  facts = ['it is snowing outside .', 'i am mortal .', 'i own a cat , and my cat is nice .', 'i own skiis .', '^you say-to ^me "I like to go skiing" .']
  test = GPTReasoningTransducer()
  new_facts = test([parse_eventuality(f) for f in facts])
  for f in new_facts:
    print(f)


def test2():
  test = GPTGistTransducer()

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
  test = GPTParaphraseTransducer()

  prev_gist = ''
  gist = 'this is an out of domain gist clause .'
  hist = []
  print(test(gist, prev_gist, hist))

  prev_gist = 'the prognosis is that i cannot be cured .'
  gist = 'i drove here today .'
  hist = []
  print(test(gist, prev_gist, hist))

  prev_gist = 'the prognosis is that i cannot be cured .'
  gist = 'what is my prognosis ?'
  hist = []
  print(test(gist, prev_gist, hist))


def main():
  # test1()
  test2()
  # test3()


if __name__ == '__main__':
  main()