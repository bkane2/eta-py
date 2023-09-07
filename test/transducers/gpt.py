from eta.transducers.gpt import *
from eta.discourse import *

def test1():
  facts = ['it is snowing outside .', 'i am mortal .', 'i own a cat , and my cat is nice .', 'i own skiis .', '^you say-to ^me "I like to go skiing" .']
  test = GPTReasonBottomUpTransducer()
  new_facts = test([parse_eventuality(f) for f in facts])
  for f in new_facts:
    print(f)


def test2():
  pass
  # test = GPTReasonTopDownTransducer()


def test3():
  examples = file.load_json('agents/sophie-gpt/gist_examples.json')
  test = GPTGistTransducer(examples)

  clog = []
  utt = Utterance('^you', 'where is your pain ?')
  print(test(utt, clog))

  clog = [
    DialogueTurn(Utterance('^me', 'do i really need chemotherapy ?'), gists=['do i need chemotherapy ?']),
    DialogueTurn(Utterance('^you', 'hmm ...'))
  ]
  utt = Utterance('^you', 'yes , i would recommend it . did you come here with anyone today ?')
  print(test(utt, clog))


def test4():
  examples = file.load_json('agents/sophie-gpt/paraphrase_examples.json')
  test = GPTParaphraseTransducer(examples)

  facts_bg = [parse_eventuality('^me drove here today .'), parse_eventuality('^me wants to see ^my grandson graduate .')]
  clog = [
    DialogueTurn(Utterance('^me', 'is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn(Utterance('^you', 'nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  gist = 'what is my prognosis ?'
  print(test(gist, clog, facts_bg, []), '\n')


def test5():
  test = GPTResponseTransducer()

  facts_bg = [parse_eventuality('^me should avoid using long words .'), parse_eventuality('^me is having trouble speaking because of how sad and shocked ^me is .')]
  facts_fg = [parse_eventuality('^me drove here today .'), parse_eventuality('^me wants to see ^my grandson graduate .')]
  clog = [
    DialogueTurn(Utterance('^me', 'is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn(Utterance('^you', 'nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  print(test(clog, facts_bg, facts_fg), '\n')


def test6():
  test = GPTAffectTransducer()

  clog = [
    DialogueTurn(Utterance('^me', 'is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn(Utterance('^you', 'nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  words = 'how long do you think i have left ?'
  print(test(words, clog), '\n')


def main():
  # test1()
  # test2()
  test3()
  # test4()
  # test5()
  # test6()


if __name__ == '__main__':
  main()