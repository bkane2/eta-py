import re

import eta.util.file as file
from eta.transducers.base import *
from eta.util.gpt import generate_gpt
from eta.lf import Eventuality

def reasoning_validator(prompt, resp):
  facts = [l.strip() for l in resp.split('\n') if l.strip()]
  facts = [re.sub(r'^[0-9]*\. ', '', fact) for fact in facts]
  return facts

PROMPTS = {
  'reasoning' : file.read_file('resources/prompts/reasoning.txt')
}

VALIDATORS = {
  'reasoning' : [reasoning_validator]
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
      new_facts_str = super().__call__({'facts': '\n'.join([fact.nl for fact in facts])})
      new_facts = [Eventuality.from_input(fact) for fact in new_facts_str]
    return new_facts
  

class GPTGistTransducer(GPTTransducer, GistTransducer):
  def __init__(self):
    # TODO
    pass
    # super().__init__(PROMPTS['gist'], [])

  def __call__(self, utt, prev_gist, history):
    """str, str, List[str] -> Eventuality"""
    # TODO
    pass


class GPTParaphraseTransducer(GPTTransducer, ParaphraseTransducer):
  def __init__(self):
    # TODO
    pass
    # super().__init__(PROMPTS['gist'], [])

  def __call__(self, gist, prev_gist, history):
    """str, str, List[str] -> Eventuality"""
    # TODO
    pass