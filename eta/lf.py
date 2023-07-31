from eta.util.sexpr import parse_s_expr, list_to_str, list_to_s_expr
from eta.util.general import flatten, gentemp

KEYWORDS = ['not', 'plur', 'past', 'pres', 'perf', 'prog', 'pasv', 'k', 'ka', 'ke', 'to', 'that', 'tht', 'fquan', 'nquan',
            'nmod', 'amod', '*h', '*s', '*p', 'set-of', 'n+preds', 'np+preds', 'sub', 'rep', "'s", 'poss-by', 'adv-a',
            'adv-e', 'adv-f', 'adv-s', '?', '!', '=', 'voc', 'voc-O', 'ds', 'ans-to', 'pu', 'cf', 'mod-a', 'mod-n',
            'most-n', 'poss-ques', 'poss-ans']

KEYWORDS_R = [k for k in KEYWORDS if k not in ['not', 'that', "'s", '?', '!']]


def remove_type(atm):
  if atm == '.':
    return atm
  elif atm == '."':
    return atm
  else:
    return atm.split('.')[0].replace('|', '')


class LF:
  def __init__(self, formula):
    if isinstance(formula, str):
      self.formula = parse_s_expr(formula)
    else:
      self.formula = formula

  def __str__(self):
    return list_to_s_expr(self.formula)
  

class ULF(LF):
  def __init__(self, formula):
    super().__init__(formula)

  def to_nl(self):
    # TODO - replace naive implementation with ULF2English
    words = ' '.join([remove_type(w) for w in list_to_str(self.formula).split() if w not in KEYWORDS_R])
    words = ' '.join(flatten([w.split('-') for w in words.split()]))
    words = ' '.join([w.replace('_', ' ') for w in words.split()])
    return words
    

class ELF(LF):
  def __init__(self, formula):
    super().__init__(formula)
    

class Eventuality:
  def __init__(self, ep, nl, ulf, elf, certainty=1.):
    self.ep = ep
    self.nl = nl
    self.set_ulf(ulf)
    self.set_elf(elf)
    self.certainty = certainty

  def set_ep(self, ep):
    self.ep = ep

  def set_ulf(self, ulf):
    if isinstance(ulf, ULF):
      self.ulf = ulf
    else:
      self.ulf = ULF(ulf)

  def set_elf(self, elf):
    if isinstance(elf, ELF):
      self.elf = elf
    else:
      self.elf = ELF(elf)

  def set_certainty(self, certainty):
    self.certainty = certainty

  def from_input(s, expectation=False):
    # s is already an s-expr
    if isinstance(s, list):
      parsed = s
    else:
      parsed = parse_s_expr(s)

    # s encodes a valid s-expr
    if isinstance(parsed, list):
      if len(parsed) >= 2 and parsed[1] == '**':
        ulf = ULF(parsed[0])
        ep = parsed[2]
      else:
        ulf = ULF(parsed)
        ep = gentemp('?e') if expectation else gentemp('e')
      return Eventuality(ep, ulf.to_nl(), ulf, None)
    # otherwise s is a natural language string
    else:
      ep = gentemp('?e') if expectation else gentemp('e')
      return Eventuality(ep, s, None, None)

  def __str__(self):
    return f'Eventuality:\n  ep: {self.ep}\n  nl: {self.nl}\n  ulf: {self.ulf}\n  elf: {self.elf}\n  certainty: {self.certainty}'
  
  def __eq__(self, other):
    # Assume that two Eventualities are equivalent if their surface realizations are the same
    return self.nl == other.nl
  
  def __hash__(self):
    return hash(self.nl)
  

def main():
  fact = Eventuality('e5',
              'John went to the store yesterday.',
              '(|John| ((past go.v) (to.p (the.d store.n)) (adv-e yesterday.pro)))',
              '(((|John| go.v (to.p |Store1|)) ** E1) (E1 during |Yesterday|))')
  
  print(fact)

  fact2 = Eventuality.from_input('(|John| ((past go.v) (to.p (the.d store.n)) (adv-e yesterday.pro)))')
  print(fact2)

  fact3 = Eventuality.from_input('((|Mary| leave.v) ** E3)')
  print(fact3)

  fact4 = Eventuality.from_input('John went to the store yesterday')
  print(fact4)

  fact5 = Eventuality.from_input([[['the.d', ["|McDonald's|", 'block.n']], [['pres', 'be.v'], ['to_the_left_of.p', ['the.d', ['|Twitter|', 'block.n']]]]], '?'])
  print(fact5)

  fact6 = Eventuality.from_input('I say to you "test"', expectation=True)
  print(fact6)


if __name__ == '__main__':
  main()