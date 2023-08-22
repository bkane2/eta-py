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


def get_prior_turn(turns, agent=None):
  if agent:
    agent_turns = [t for t in turns if t.agent == agent]
    return agent_turns[-1] if agent_turns else None
  else:
    return turns[-1] if turns else None
  

def parse_utt_str(str):
  affect = None
  words = str
  for e in EMOTIONS_LIST:
    tag1 = f'[{e}]'
    tag2 = f'[{e.upper()}]'
    if tag1 in str or tag2 in str:
      words = words.replace(tag1, '').replace(tag2, '').strip()
      affect = e
  return affect, words