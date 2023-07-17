from eta.util.sexpr import parse_s_expr, list_to_str, list_to_s_expr
from eta.util.general import *

KEYWORDS = ['not', 'plur', 'past', 'pres', 'perf', 'prog', 'pasv', 'k', 'ka', 'ke', 'to', 'that', 'tht', 'fquan', 'nquan',
            'nmod', 'amod', '*h', '*s', '*p', 'set-of', 'n+preds', 'np+preds', 'sub', 'rep', "'s", 'poss-by', 'adv-a',
            'adv-e', 'adv-f', 'adv-s', '?', '!', '=', 'voc', 'voc-O', 'ds', 'ans-to', 'pu', 'cf', 'mod-a', 'mod-n',
            'most-n', 'poss-ques', 'poss-ans']

KEYWORDS_R = [k for k in KEYWORDS if k not in ['not', 'that', "'s", '?', '!']]

def remove_type(atm):
  if atm == '.':
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
    # TODO
    return ' '.join([remove_type(w) for w in list_to_str(self.formula).split() if w not in KEYWORDS_R])
    

class ELF(LF):
  def __init__(self, formula):
    super().__init__(formula)
    

class Fact:
  def __init__(self, nl, ulf, elf):
    self.nl = nl
    self.set_ulf(ulf)
    self.set_elf(elf)

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

  def from_input(s):
    parsed = parse_s_expr(s)
    if isinstance(parsed, list):
      ulf = ULF(parsed)
      return Fact(ulf.to_nl(), ulf, None)
    else:
      return Fact(s, None, None)

  def __str__(self):
    return f'Fact:\n  nl: {self.nl}\n  ulf: {self.ulf}\n  elf: {self.elf}'
  

def main():
  fact = Fact('John went to the store yesterday.',
              '(|John| ((past go.v) (to.p (the.d store.n)) (adv-e yesterday.pro)))',
              '(((|John| go.v (to.p |Store1|)) ** E1) (E1 during |Yesterday|))')
  
  print(fact)

  fact2 = Fact.from_input('(|John| ((past go.v) (to.p (the.d store.n)) (adv-e yesterday.pro)))')
  print(fact2)


if __name__ == '__main__':
  main()