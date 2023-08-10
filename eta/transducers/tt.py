from eta.transducers.base import *
from eta.lf import parse_eventuality
from eta.discourse import Utterance, DialogueTurn

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
      return ['^me', 'say-to.v', '^you', f"{result}"]
    elif directive == ':gist':
      # The legacy choice tree format supported 'topic keys', but we ignore those for now
      if listp(result[0]):
        result = result[0]
      result = ' '.join(result)
      return ['^you', 'paraphrase-to.v', '^me', f"{result}"]
    elif directive == ':nl':
      result = ' '.join(result)
      return result
    elif directive == ':ulf':
      return result
    elif directive in [':schema', ':schemas', ':schema+args', ':subtrees', ':raw']:
      return result

  def cost(self):
    return 0.
    

class TTReasoningTransducer(TTTransducer, ReasoningTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'reasoning')

  def __call__(self, facts):
    """List[Eventuality] -> List[Eventuality]"""
    new_facts = super().__call__([fact.get_nl() for fact in facts])
    return [parse_eventuality(fact) for fact in new_facts]
  

class TTGistTransducer(TTTransducer, GistTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'gist')

  def __call__(self, utt, conversation_log):
    """str, List[DialogueTurn] -> List"""
    prev_gist = ''
    eta_turns = [t for t in conversation_log if t.agent == '^me']
    if eta_turns:
      prev_gists = eta_turns[-1].gists
      if prev_gists:
        prev_gist = prev_gists[0]
    return super().__call__([prev_gist.split(), utt.split()])
  

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
  new_facts = test([parse_eventuality(f) for f in facts])
  for f in new_facts:
    print(f)


def test2():
  test = TTGistTransducer('avatars/sophie-gpt/rules')

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
  test2()
  # test3()


if __name__ == '__main__':
  main()