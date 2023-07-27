from eta.transducers.base import *
from eta.lf import Eventuality

from eta.util.general import listp, cons
from eta.util.tt.choice import choose_result_for
from eta.util.tt.parse import from_lisp_dirs

class TTTransducer(Transducer):
  def __init__(self, rule_dirs, root, split=False):
    self.trees, self.feats = from_lisp_dirs(rule_dirs)
    self.root = root
    self.split = split

  def __call__(self, inputs):
    """str | List[str] | List[List] -> List"""
    # TODO: this function can likely be consolidated
    ret = []
    if self.split:
      if isinstance(inputs, str):
        inputs = [inputs]
      for input in inputs:
        if isinstance(input, str):
          clause = input.split()
        else:
          clause = input
        choice = choose_result_for(clause, self.root, self.trees, self.feats)
        choice = self.process_choice(choice)
        if choice and listp(choice) and choice[0] == ':and':
          ret = ret + choice[1:]
        else:
          ret.append(choice)
    else:
      if isinstance(inputs, str):
        clause = inputs.split()
      elif inputs and listp(inputs) and all([isinstance(x, str) for x in inputs]):
        clause = ' '.join(inputs).split()
      else:
        clause = inputs
      choice = choose_result_for(clause, self.root, self.trees, self.feats)
      choice = self.process_choice(choice)
      if choice and listp(choice) and choice[0] == ':and':
        ret = ret + choice[1:]
      else:
        ret.append(choice)
    return [r for r in ret if r]

  def process_choice(self, choice):
    """TODO: this should be reworked to allow transducer implementations to override
       the directive processing as necessary"""
    if not choice:
      return []
    if listp(choice) and choice[0] == ':and':
      return cons(':and', [self.process_choice(c) for c in choice[1:]])
    if not isinstance(choice, tuple) or not isinstance(choice[0], str) or not choice[0][0] == ':':
      return choice
    
    directive, result = choice
    if directive == ':out':
      result = ' '.join(result)
      return Eventuality.from_input(f'(^me say-to.v ^you "{result}")', expectation=True)
    elif directive == ':gist':
      result = ' '.join(result)
      return Eventuality.from_input(f'(^you paraphrase-to.v ^me "{result}")')
    elif directive == ':nl':
      result = ' '.join(result)
      return Eventuality.from_input(result)
    elif directive == ':ulf':
      return Eventuality.from_input(result)
    elif directive in [':schema', ':schemas', ':schema+args', ':subtrees', ':raw']:
      return result

  def cost(self):
    return 0.
    

class TTReasoningTransducer(TTTransducer, ReasoningTransducer):
  def __init__(self, rule_dirs, root, split=False):
    super().__init__(rule_dirs, root, split=split)

  def __call__(self, facts):
    """List[Eventuality] -> List[Eventuality]"""
    return super().__call__([fact.nl for fact in facts])
  

def main():
  facts = ['it is snowing outside', 'i am mortal', 'i own skiis', '^you say-to ^me "I like to go skiing"']

  test = TTReasoningTransducer('avatars/test/rules', 'reasoning-split', split=True)
  new_facts = test([Eventuality.from_input(f) for f in facts])
  for f in new_facts:
    print(f)

  test = TTReasoningTransducer('avatars/test/rules', 'reasoning', split=False)
  new_facts = test([Eventuality.from_input(f) for f in facts])
  for f in new_facts:
    print(f)


if __name__ == '__main__':
  main()