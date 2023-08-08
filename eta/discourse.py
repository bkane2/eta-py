from eta.constants import EMOTIONS_LIST

class Utterance:
  def __init__(self, words, affect=EMOTIONS_LIST[0]):
    self.words = words
    if affect in EMOTIONS_LIST:
      self.affect = affect
    else:
      self.affect = EMOTIONS_LIST[0]


class DialogueTurn:
  def __init__(self, agent, utterance, gists=[], semantics=[], pragmatics=[], obligations=[], ep=None):
    self.agent = agent
    self.utterance = utterance
    self.gists = gists
    self.semantics = semantics
    self.pragmatics = pragmatics
    self.obligations = obligations
    self.ep = ep