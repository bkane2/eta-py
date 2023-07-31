from eta.transducers.base import *
from eta.lf import Eventuality

from eta.util.general import listp, cons, remove_duplicates
from eta.util.tt.choice import choose_result_for
from eta.util.tt.parse import from_lisp_dirs

class TTTransducer(Transducer):
  def __init__(self, rule_dirs, roots):
    self.trees, self.feats = from_lisp_dirs(rule_dirs)
    if isinstance(roots, str):
      self.roots = [roots]
    else:
      self.roots = roots

  def __call__(self, inputs):
    """str | List[str] | List[List] -> List"""
    ret = []
    if isinstance(inputs, str):
      clause = inputs.split()
    elif inputs and listp(inputs) and all([isinstance(x, str) for x in inputs]):
      clause = ' '.join(inputs).split()
    else:
      clause = inputs
    for root in self.roots:
      choice = choose_result_for(clause, root, self.trees, self.feats)
      choice = self.process_choice(choice)
      if choice and listp(choice) and choice[0] == ':and':
        ret = ret + choice[1:]
      else:
        ret.append(choice)
    return remove_duplicates([r for r in ret if r], order=True)

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
      # The legacy choice tree format supported 'topic keys', but we ignore those for now
      if listp(result[0]):
        result = result[0]
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
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'reasoning')

  def __call__(self, facts):
    """List[Eventuality] -> List[Eventuality]"""
    return super().__call__([fact.nl for fact in facts])
  

class TTGistTransducer(TTTransducer, GistTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'gist')

  def __call__(self, utt, prev_gist, history):
    """str, str, List[str] -> Eventuality"""
    ret = super().__call__([prev_gist.split(), utt.split()])
    if ret:
      return ret[0]
    return ret
  

class TTParaphraseTransducer(TTTransducer, ParaphraseTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'paraphrase')

  def __call__(self, gist, prev_gist, history):
    """str, str, List[str] -> Eventuality"""
    ret = super().__call__([prev_gist.split(), gist.split()])
    if ret:
      return ret[0]
    return ret
  

def test1():
  facts = ['it is snowing outside .', 'i am mortal .', 'i own a cat , and my cat is nice .', 'i own skiis .', '^you say-to ^me "I like to go skiing" .']
  test = TTReasoningTransducer('avatars/test/rules')
  new_facts = test([Eventuality.from_input(f) for f in facts])
  for f in new_facts:
    print(f)


def test2():
  test = TTGistTransducer('avatars/sophie-gpt/rules')

  prev_gist = ''
  utt = 'where is your pain ?'
  hist = []
  print(test(utt, prev_gist, hist))

  prev_gist = 'do i need chemotherapy ?'
  utt = 'yes , i would recommend it .'
  hist = []
  print(test(utt, prev_gist, hist))


def test3():
  test = TTParaphraseTransducer('avatars/sophie/rules')

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
  # test2()
  test3()




if __name__ == '__main__':
  main()