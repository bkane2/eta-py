"""ULF Lexicalization

Functions for converting lexemes to ULF symbols.

Relies on the NLTK Snowball stemmer.

Exported functions
------------------
to_ulf : convert a word to a ULF of a given type category.
"""

from nltk.stem.snowball import SnowballStemmer

import eta.util.file as file
from eta.util.general import atom

STEMMER = SnowballStemmer("english")

NAMES = file.load_json('eta/resources/lexical/ulf/names.json')
NOUNS = file.load_json('eta/resources/lexical/ulf/nouns.json')
VERBS = file.load_json('eta/resources/lexical/ulf/verbs.json')
VERBS_PASV = file.load_json('eta/resources/lexical/ulf/verbs_passive.json')
WH_PREDS = file.load_json('eta/resources/lexical/ulf/wh_preds.json')
SUP_ADJS = file.load_json('eta/resources/lexical/ulf/sup_adjs.json')
ADV_ADJS = file.load_json('eta/resources/lexical/ulf/adv_adjs.json')


def to_ulf(cat, word):
  """Convert a word to a ULF of a given type category.

  This version is incomplete and intended for very limited experimental use.

  Parameters
  ----------
  cat : str
    The ULF type category to generate (e.g., 'name', 'v', or 'p').
  word : str
    The word to lexicalize (e.g., 'mercedes', 'are', or 'on-top-of').

  Returns
  -------
  s-expr
    The generated ULF.
  """
  if cat == 'name':
    if word in NAMES:
      return NAMES[word]
    else:
      return f'|{word.upper()} |' if len(word) < 4 else f"|{word.replace('_', ' ').title()}|"
  if cat == 'pro':
    return f'{word}.pro'
  if cat == 'punc':
    return word
  if cat == 'nn':
    return f'{word}.n'
  if cat == 'nns':
    stem = STEMMER.stem(word)
    return ['plur', f'{stem}.n']
  if cat in ['n', 'noun']:
    if word in NOUNS:
      return NOUNS[word]
    else:
      stem = STEMMER.stem(word)
      # assume singular if unchanged (somewhat error-prone)
      if stem == word:
        return f'{word}.n'
      else:
        return ['plur', f'{stem}.n']
  if cat in ['p', 'prep']:
    return f'{word}.p'
  if cat == 'ps':
    return f'{word}.ps'
  if cat in ['d', 'det']:
    return f'{word}.d'
  if cat in ['v', 'verb']:
    if word in VERBS:
      return VERBS[word]
    else:
      return f'{word}.v'
  if cat in ['v-pasv', 'verb-passive']:
    if word in VERBS_PASV:
      return VERBS_PASV[word]
    else:
      return ['past', ['pasv', f'{word}.v']]
  if cat in ['v-pasv-', 'verb-passive-']:
    if word in VERBS_PASV:
      return VERBS_PASV[word][1]
    else:
      return ['pasv', f'{word}.v']
  if cat in ['v-', 'verb-untensed']:
    # This is a bit hacky...
    w1 = to_ulf('v', word)
    if atom(w1):
      return w1
    else:
      if w1[1] == f'{word}.v':
        return f'{word}.v'
      else:
        return w1[1]
  if cat == 'wh-pred':
    if word in WH_PREDS:
      return WH_PREDS[word]
    else:
      return f'{word}.adv'
  if cat in ['a', 'adj']:
    return f'{word}.a'
  if cat == 'sup-adj':
    if word in SUP_ADJS:
      return SUP_ADJS[word]
    else:
      return f'{stem_superlative(word)}.a'
  if cat == 'adv-adj':
    if word in ADV_ADJS:
      return ADV_ADJS[word]
    else:
      return f'{word}.a'
  return f'{word}.{cat}'
  # END to_ulf


def stem_superlative(sup_adv):
  """Find stem of a superlative adjective.

  This is a stub, intended as default when word-specific stems have not been
  found in the calling program only a simple check whether the stem probably
  shouldn't have a doubled up final consonant is made.
 
  Parameters
  ----------
  sup-adj : str
    An upper-case symbolic atom such as 'biggest', "smartest', etc.
  
  Returns
  -------
  str
    The stemmed superlative.
  """
  stem = sup_adv[:-3]
  if stem[-2:] in ['bb', 'dd', 'gg', 'nn', 'pp', 'tt']:
    return stem[:-1]
  else:
    return stem