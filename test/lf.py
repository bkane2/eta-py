from eta.lf import *

def test1():
  fact = Eventuality('e5',
              'John went to the store yesterday.',
              '(|John| ((past go.v) (to.p (the.d store.n)) (adv-e yesterday.pro)))',
              '(((|John| go.v (to.p |Store1|)) ** E1) (E1 during |Yesterday|))')
  
  print(fact)

  fact2 = parse_eventuality('(|John| ((past go.v) (to.p (the.d store.n)) (adv-e ({during}.p yesterday.pro))))')
  print(fact2)

  fact3 = parse_eventuality('(|Mary| leave.v)', ep='e3')
  print(fact3)

  fact4 = parse_eventuality('John went to the store yesterday')
  print(fact4)

  fact5 = parse_eventuality([[['the.d', ["|McDonald's|", 'block.n']], [['pres', 'be.v'], ['to_the_left_of.p', ['the.d', ['|Twitter|', 'block.n']]]]], '?'])
  print(fact5)

  fact6 = parse_eventuality('I say to ^you "test"', expectation=True)
  print(fact6)

  ep_var = fact6.get_ep()
  fact6.bind(ep_var, 'e100')
  print(fact6)
  fact6.bind('^you', 'Joe')
  print(fact6)

  fact7 = parse_eventuality('(?person ((past go.v) (to.p ?location) (adv-e yesterday.pro)))')
  fact7.bind('?person', 'John')
  fact7.bind('?location', ['the.d', 'store.n'])
  print(fact7)

  facts = parse_eventuality_list(['!t1', ['^me', 'person.n'], '?s1', ['^me', [['pres', 'be.v'], ['at.p', ['the.d', 'store.n']]]],
                                  '?e1', ['^you', 'meet.v', '^me']])
  for f in facts:
    print(f)

  facta = parse_eventuality('(|person| run.v)')
  factb = parse_eventuality('(|person| run.v)')
  print(remove_duplicates([facta, factb], order=True))


def main():
  test1()
  knowledge = from_lisp_dirs('avatars/test/knowledge')
  for e in knowledge:
    print(e)


if __name__ == '__main__':
  main()