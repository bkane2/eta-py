"""Tools for storing and processing discourse in Eta dialogues."""

import eta.util.file as file
from eta.constants import EMOTIONS_LIST
from eta.util.general import cons, replaceall

CONTRACTIONS = file.load_json('eta/resources/lexical/contractions.json')
NEGPAIRS = file.load_json('eta/resources/lexical/negpairs.json')
DUALS = file.load_json('eta/resources/lexical/duals.json')


class Utterance:
  """Represents a single utterance, which contains both the words of the utterance and an affect.
  
  Parameters
  ----------
	agent : str
    The agent making the utterance.
  words : str
    The content of the utterance.
  affect : str, default='neutral'
    The affect of the utterance. Must be contained within the list of supported emotions.

  Attributes
  ----------
  agent : str
  words : str
  affect : str
  """

  def __init__(self, agent, words, affect=EMOTIONS_LIST[0]):
    self.agent = agent
    self.words = words
    if affect in EMOTIONS_LIST:
      self.affect = affect
    else:
      self.affect = EMOTIONS_LIST[0]


class DialogueTurn:
  """Represents a dialogue turn by an agent, which contains the utterance as well as any associated dialogue information.
  
  Parameters
  ----------
  utterance : Utterance
    The utterance of this turn.
  gists : list[str], optional
    A list of gist clauses capturing the meaning of this turn.
  semantics : list[s-expr], optional
    A list of semantic interpretations of this turn.
  pragmatics : list[s-expr], optional
    A list of pragmatic inferences drawn from this turn.
  obligations : list[s-expr], optional
    A list of obligations created by this turn.
  ep : str, optional
    The episode that this turn corresponds to.

  Attributes
  ----------
  agent : str
    The agent of this turn (copied from the utterance for convenience).
  utterance : Utterance
  gists : list[str]
  semantics : list[s-expr]
  pragmatics : list[s-expr]
  obligations : list[s-expr]
  ep : str or None
  """
  
  def __init__(self, utterance, gists=[], semantics=[], pragmatics=[], obligations=[], ep=None):
    self.agent = utterance.agent
    self.utterance = utterance
    self.gists = gists
    self.semantics = semantics
    self.pragmatics = pragmatics
    self.obligations = obligations
    self.ep = ep


def get_prior_turn(turns, agent=None):
  """Retrieve the immediately prior turn by the specified agent(s).
  
  Parameters
  ----------
  turns : list[DialogueTurn]
    A list of dialogue turns in the conversation, in chronological order.
  agent : str, optional
    The agent whose prior turn should be found (by default, find the prior turn by any agent).

  Returns
  -------
  DialogueTurn or None
    The prior turn by the given agent (if one exists).
  """
  if agent:
    agent_turns = [t for t in turns if t.agent == agent]
    return agent_turns[-1] if agent_turns else None
  else:
    return turns[-1] if turns else None
	

def get_prior_words(turns, agent=None):
	"""Retrieve the prior utterance in the conversation, using a generic utterance if none is found.
  
  Parameters
  ----------
  turns : list[DialogueTurn]
    A list of dialogue turns in the conversation, in chronological order.
  agent : str, optional
    The agent whose prior words should be found (by default, find the prior turn by any agent).

  Returns
  -------
  str
    The prior words by the given agent, if one exists, or a generic utterance.
	"""
	prior_utt = 'Hello.'
	prior_turn = get_prior_turn(turns, agent)
	if prior_turn:
		prior_utt = prior_turn.utterance.words
	return prior_utt
  

def parse_utt_str(str):
  """Parse an utterance string into a word string and affect.
  
  Parameters
  ----------
  str : str
    A string representing an utterance, potentially prefixed by an emotion tag, e.g., ``[happy]`` or ``[sad]``.
  
  Returns
  -------
  affect : str
    The affect/emotion of the utterance.
  words : str
    The word string of the utterance.
  """
  affect = None
  words = str
  for e in EMOTIONS_LIST:
    tag1 = f'[{e}]'
    tag2 = f'[{e.upper()}]'
    if tag1 in str or tag2 in str:
      words = words.replace(tag1, '').replace(tag2, '').strip()
      affect = e
  return affect, words


def decompress(str):
	"""Expand contractions into full phrases (e.g. 'don't' or 'dont' by 'do not')."""
	def decompress_rec(words):
		if not words:
			return []
		elif words[0] in CONTRACTIONS:
			return cons(CONTRACTIONS[words[0]], decompress_rec(words[1:]))
		else:
			return cons(words[0], decompress_rec(words[1:]))
	return ' '.join(decompress_rec(str.split()))


def compress(str):
	"""Replace auxiliary-NOT combinations by -N'T contractions."""
	def compress_rec(words):
		if not words:
			return []
		elif not words[1:]:
			return words
		elif words[1] == 'not' and words[0] in NEGPAIRS:
			return cons(NEGPAIRS[words[0]], compress_rec(words[2:]))
		else:
			return cons(words[0], compress_rec(words[1:]))
	return ' '.join(compress_rec(str.split()))


def presubst(str):
  """Prepare a string for calling the swap_duals function to avoid ungrammatical substitutions.

  For example, in swapping dual pronouns, we want to avoid outputs such as "why do you say i are stupid",
  while still correctly producing "why do you say your brothers are stupid".

	This function replaces "are" by "are2" when preceded or followed by "you"; similarly, it replaces
  "were" by "were2" and "was" by "was2".

	It also replaces "you" by "you2" when it is the last word, or when it is not one of the first two
  words and is not preceded by certain conjunctions ("and", "or", "but", "that", "because", "if",
	"when", "then", "why", ...), or certain subordinating verbs ("think", "believe", "know", ...), or
  when it follows "to".

	This is in preparation for replacement of "you2" by "me" (rather than "i") when swap_duals is applied.
	"""
  re_punct = ['?','!',',','.',':',';']
  re_blocker = ['and', 'or', 'but', 'that', 'because', 'if', 'so', 'when', 'then', 'why',
			  				'think', 'see', 'guess', 'believe', 'hope', 'do', 'can', 'would', 'should',
								'than', 'know', 'i', 'you', '-', '--']
  str = ' '+str+' '
  str = replaceall(str, [
		(" you are ", " you1 are2 ", False),
		(" are you ", " are2 you1 ", False),
		(" i was ", " i was2 ", False),
		(" was i ", " was2 i ", False),
		(" you were ", " you1 were2 ", False),
		(" were you ", " were2 you1 ", False),
		(fr" you ([{'|'.join(re_punct)}]) ", r" you2 \1 ", True),
		(" to you ", " to you2 ", False),
	])
  str = str.replace(' you ', ' you0 ')
  str = replaceall(str, [
		(r"^ you0 ", r" you ", True),
		(r"^ ([\S]+) you0 ", r" \1 you ", True),
		(fr"([{'|'.join(re_punct)}]) you0 ", r"\1 you ", True),
		(fr"([{'|'.join(re_punct)}]) ([\S]+) you0 ", r"\1 \2 you ", True),
		(fr"({'|'.join(re_blocker)}) you0 ", r"\1 you ", True)
  ])
  return str.replace(' you0 ', ' you2 ').strip()


def swap_duals(str):
	"""Swap first-person pronouns (I, me, ...) with second-person pronouns (you, ...), and vice-versa."""
	def swap_duals_rec(words):
		if not words:
			return []
		elif words[0] in DUALS:
			return cons(DUALS[words[0]], swap_duals_rec(words[1:]))
		else:
			return cons(words[0], swap_duals_rec(words[1:]))
	str = presubst(str)
	return ' '.join(swap_duals_rec(str.split()))