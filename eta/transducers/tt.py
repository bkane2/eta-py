from eta.transducers.base import *
from eta.lf import parse_eventuality
from eta.discourse import Utterance, DialogueTurn, get_prior_turn

from eta.constants import ME, YOU
from eta.util.general import listp, cons, remove_duplicates, isquote
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
    elif inputs and listp(inputs) and all([isinstance(x, str) and not isquote(x) for x in inputs]):
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
    """str, List[DialogueTurn] -> List[str]"""
    prev_gist = ''
    prior_turn = get_prior_turn(conversation_log, ME)
    if prior_turn:
      prev_gists = prior_turn.gists
      if prev_gists:
        prev_gist = prev_gists[0]
    return super().__call__([prev_gist.split(), utt.split()])
  

class TTSemanticTransducer(TTTransducer, SemanticTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'semantic')

  def __call__(self, gist):
    """str -> List"""
    return super().__call__(gist.split())
  

class TTPragmaticTransducer(TTTransducer, PragmaticTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'pragmatic')

  def __call__(self, gist):
    """str -> List"""
    return super().__call__(gist.split())
  

class TTReactionTransducer(TTTransducer, ReactionTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'reaction')

  def __call__(self, observation):
    """Eventuality -> List"""
    wff = observation.get_wff()
    return super().__call__(wff)
  

class TTExpandStepTransducer(TTTransducer, ExpandStepTransducer):
  def __init__(self, rule_dirs):
    # TODO
    pass

  def __call__(self, step):
    """Eventuality -> List[Eventuality]"""
    # TODO
    substeps = []
    return substeps
  

class TTParaphraseTransducer(TTTransducer, ParaphraseTransducer):
  def __init__(self, rule_dirs):
    super().__init__(rule_dirs, 'paraphrase')

  def __call__(self, gist, conversation_log, conds, facts):
    """str, List[DialogueTurn], List[Eventuality], List[Eventuality] -> List[str]"""
    prev_gist = ''
    prior_turn = get_prior_turn(conversation_log, YOU)
    if prior_turn:
      prev_gists = prior_turn.gists
      if prev_gists:
        prev_gist = prev_gists[0]
    return super().__call__([prev_gist.split(), gist.split()])
  

class TTResponseTransducer(TTTransducer, ResponseTransducer):
  def __init__(self, rule_dirs):
    # TODO
    pass

  def __call__(self, conversation_log, conds, facts):
    """List[DialogueTurn], List[Eventuality], List[Eventuality] -> List[str]"""
    # TODO
    utts = []
    return utts
  

class TTAnswerTransducer(TTTransducer, AnswerTransducer):
  def __init__(self, rule_dirs):
    # TODO
    pass

  def __call__(self, conversation_log, conds, facts):
    """List[DialogueTurn], List[Eventuality], List[Eventuality] -> List[str]"""
    # TODO
    utts = []
    return utts
  

class TTAskTransducer(TTTransducer, AskTransducer):
  def __init__(self, rule_dirs):
    # TODO
    pass

  def __call__(self, conversation_log, conds, facts):
    """List[DialogueTurn], List[Eventuality], List[Eventuality] -> str"""
    # TODO
    utts = []
    return utts
  

class TTAffectTransducer(TTTransducer, AffectTransducer):
  def __init__(self, rule_dirs):
    # TODO
    pass

  def __call__(self, words, conversation_log):
    """str, List[DialogueTurn] -> List[str]"""
    # TODO
    affects = []
    return affects
  

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

  clog = []
  gist = 'this is an out of domain gist clause .'
  print(test(gist, clog))

  clog = [
    DialogueTurn('^me', Utterance('is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn('^you', Utterance('nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  gist = 'what is my prognosis ?'
  print(test(gist, clog))

  gist = 'i drove here today .'
  print(test(gist, clog))


def main():
  # test1()
  # test2()
  test3()


if __name__ == '__main__':
  main()