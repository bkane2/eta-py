# Definitions of custom predicates used in TT matching; based on the original Lisp definitions:
# https://github.com/bkane2/eta/blob/master/core/tt/tt-match-predicates.lisp
# 
# Some simplifications were made here, limiting the extensibility and (to a small extent) efficiency
# of custom predicates. First, due to Python lacking a macro system, all predicates must be defined
# here, rather than in domain-specific rule files. Second, predicate functions are invoked based on
# name strings, obtained through manipulation of the corresponding variable strings, rather than through
# the implicit-pred and *-variant hash tables.
#
# Ultimately, this should be reworked to allow custom domain-specific definitions of TT predicates, in
# order to avoid the redundant loading of lexical data into the core code.

import eta.util.general as gute
import eta.util.ulf.lex as lex

NEG = ['neg', 'deny', 'disagree', 'no', 'nah', 'nope', 'not', 'never', 'zero', 'hardly',
             'little', 'barely', 'scarcely', 'incorrect', 'inaccurate', 'untrue', 'disagreed', 'doubt']

NEG_MOD = ['really', 'quite', 'very', 'exactly', 'entirely', 'all', 'completely']

AFFIRM_ADV = ['certainly', 'certain', 'absolutely', 'really', 'quite', 'completely', 'exactly',
                    'entirely', 'sure', 'definitely', 'correct', 'accurate', 'true']

MODAL = ['can', 'will', 'shall', 'could', 'would', 'should', 'might', 'may', 'ought']

NON_ALCOHOLIC = ['water', 'coffee', 'milk', 'tea', 'soda', 'pop']

MEDICINE_GEN = ['medicine', 'medicines', 'medication', 'medications', 'drug', 'drugs', 'pill',
                'pills', 'med', 'meds', 'dose', 'doses', 'dosage', 'dosages', 'lortab', 'vicodin',
                'norco', 'ibuprofen', 'aleve', 'cozar', 'narcotic', 'narcotics', 'oxycodone', 'morphine']

SENTENCE_CONJUNCTIONS = ['but' ,'and', 'however', 'because', 'since', 'although', 'as', 'if']

def expr(x):
  return True

def atom(x):
  return gute.atom(x)

def lst(x):
  return isinstance(x, list)

def comma(x):
  return x == ','

def zero(x):
  return x == 0 or x == '0'

def non_neg(x):
  return x not in NEG

def non_neg_mod(x):
  return x not in NEG and x not in NEG_MOD

def affirm_adv(x):
  return x in AFFIRM_ADV

def modal(x):
  return x in MODAL

def not_non_alcoholic(x):
  return x not in NON_ALCOHOLIC

def not_medicine_gen(x):
  return x not in MEDICINE_GEN

def test(*lst):
  return ' '.join(lst) + '_test'

def lex_ulf(cat, word):
  return lex.to_ulf(cat, word)

def quote_to_list(s):
  if not isinstance(s, str):
    return s
  return s.strip('"').split()

def split_sentences(wordlist):
  result = []
  cur = []
  for word in wordlist:
    if word in ['.', '?', '!']:
      cur.append(word)
      result.append(cur)
      cur = []
    else:
      cur.append(word)
  if cur:
    result.append(cur)
  cur = []
  # Loop through each word with lookahead to split sentences conjoined by a comma+connective
  result1 = result.copy()
  for words in result:
    for word, lookahead in zip(words, words[1:]+[None]):
      if word in [','] and lookahead in SENTENCE_CONJUNCTIONS:
        cur.append('.')
        result1.append(cur)
        cur = []
      else:
        cur.append(word)
    if cur:
      result1.append(cur)
    cur = []
  return gute.remove_duplicates(result1, order=True)

def main():
  print(split_sentences('this is a test sentence . this is another test sentence , and it is for testing .'.split()))

if __name__ == '__main__':
  main()