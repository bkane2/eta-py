from eta.memory import *
from eta.lf import *
from eta.embedding import *
  
def test2():
  sep = '\n----------------------------\n'

  test = MemoryStorage()
  fact1 = parse_eventuality('(me say-to.v you "Test")', ep='e1')
  fact2 = parse_eventuality('(me be.v happy.a)', ep='e2')
  fact3 = parse_eventuality('(you reply-to.v e1)', ep='e3')
  test.instantiate(fact1)
  test.instantiate(fact2)
  test.instantiate(fact3)

  for m in test.context:
    print(m)
  print(sep)

  for m in test.get_matching(['?x', 'say-to.v', '?y', '?words']):
    print(m)
  print(sep)

  for m in test.context:
    print(m)
  print(sep)

  for m in test.get_matching(['?x', 'say-to.v', '?y', '?words'], access=True):
    print(m)
  print(sep)

  for m in test.context:
    print(m)
  print(sep)

  for m in test.get_matching(['?x', 'be.v', 'happy.a'], access=True):
    print(m)
  print(sep)

  for m in test.context:
    print(m)
  print(sep)

  for m in test.get_from_context(['?x', 'reply-to.v', '?y'], access=True):
    print(m)
  print(sep)

  for m in test.get_from_context(['?x', 'reply-to.v', '?y'], access=True):
    print(m)
  print(sep)


def test1():
  sep = '\n----------------------------\n'

  test = MemoryStorage()
  fact1 = parse_eventuality('(raining-outside.v)', ep='e1')
  fact2 = parse_eventuality('(me laugh.v)', ep='e2')
  fact3 = parse_eventuality('(me go-to.v (the.d store.n) yesterday.adv-e)', ep='e3')
  fact4 = parse_eventuality('(me go-to.v (the.d store.n) tuesday.adv-e)', ep='e4')
  fact5 = parse_eventuality('(you go-to.v (the.d store.n) tuesday.adv-e)', ep='e4')
  fact6 = parse_eventuality('test string fact', ep='e5')
  test.instantiate(fact1)
  test.instantiate(fact2)
  test.instantiate(fact3)
  test.instantiate(fact4)
  test.instantiate(fact5)
  test.instantiate(fact6)

  for k,v in test.wff_ht.items():
    print(k)
    for i in v:
      print(i)
  print(sep)

  for m in test.get_episode('e4'):
    print(m)
  print(sep)

  for m in test.get_matching(['?x', 'go-to.v', '?y', '?z']):
    print(m)
  print(sep)

  test.remove_matching(['?x', 'go-to.v', '?y', 'tuesday.adv-e'])

  for m in test.get_matching('go-to.v'):
    print(m)
  print(sep)

  for m in test.context:
    print(m)
  print(sep)

  for m in test.get_matching('test string fact'):
    print(m)
  print(sep)

  # fact6 = parse_eventuality('(not (me laugh.v))', ep='e5')
  # test.instantiate(fact6)

  # for m in test.context:
  #   print(m)
  # print(sep)

  # print(test)


def test_retrieval():
  sep = '\n----------------------------\n'

  test = MemoryStorage(STEmbedder())
  importance = 1.
  test.instantiate(parse_eventuality('(^you ((pres play.v) (k football.n)))'), importance=importance)
  test.instantiate(parse_eventuality('^me like to travel .'), importance=importance)
  test.instantiate(parse_eventuality('(^you ((past go.v) (to.p (the.d store.n)) yesterday.adv-e)'), importance=importance)
  test.instantiate(parse_eventuality('(^you say-to.v ^me "this is a test sentence ."'), importance=importance)
  test.instantiate(parse_eventuality('(^me ((past visit.v) |Spain| (adv-e ({during}.p ({the}.d (last.a year.n)))))'), importance=importance)
  test.instantiate(parse_eventuality('(^you ((pres test.v) (the.d system.n)))'), importance=importance)

  mems = test.retrieve(query='i like to travel', n=3)
  for m in mems:
    print(m)


def main():
  test1()
  test2()
  test_retrieval()
  

if __name__ == '__main__':
  main()