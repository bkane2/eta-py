from eta.transducers.gpt import *

def test1():
  facts = ['it is snowing outside .', 'i am mortal .', 'i own a cat , and my cat is nice .', 'i own skiis .', '^you say-to ^me "I like to go skiing" .']
  test = GPTReasoningTransducer()
  new_facts = test([parse_eventuality(f) for f in facts])
  for f in new_facts:
    print(f)


def test2():
  examples = file.load_json('avatars/sophie-gpt/gist_examples.json')
  test = GPTGistTransducer(examples)

  clog = []
  utt = 'where is your pain ?'
  print(test(utt, clog))

  clog = [
    DialogueTurn('^me', Utterance('do i really need chemotherapy ?'), gists=['do i need chemotherapy ?']),
    DialogueTurn('^you', Utterance('hmm ...'))
  ]
  utt = 'yes , i would recommend it . did you come here with anyone today ?'
  print(test(utt, clog))


def test3():
  examples = file.load_json('avatars/sophie-gpt/paraphrase_examples.json')
  test = GPTParaphraseTransducer(examples)

  facts = [parse_eventuality('^me drove here today .'), parse_eventuality('^me wants to see ^my grandson graduate .')]
  clog = [
    DialogueTurn('^me', Utterance('is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn('^you', Utterance('nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  gist = 'what is my prognosis ?'
  print(test(gist, clog, facts), '\n')


def test4():
  test = GPTResponseTransducer()

  conds = [parse_eventuality('^me should avoid using long words .'), parse_eventuality('^me is having trouble speaking because of how sad and shocked ^me is .')]
  facts = [parse_eventuality('^me drove here today .'), parse_eventuality('^me wants to see ^my grandson graduate .')]
  clog = [
    DialogueTurn('^me', Utterance('is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn('^you', Utterance('nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  print(test(clog, conds, facts), '\n')


def test5():
  test = GPTAffectTransducer()

  clog = [
    DialogueTurn('^me', Utterance('is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn('^you', Utterance('nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  words = 'how long do you think i have left ?'
  print(test(words, clog), '\n')


def main():
  test1()
  test2()
  test3()
  test4()
  test5()


if __name__ == '__main__':
  main()