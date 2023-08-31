from eta.transducers.tt import * 

def test1():
  facts = ['it is snowing outside .', 'i am mortal .', 'i own a cat , and my cat is nice .', 'i own skiis .', '^you say-to ^me "I like to go skiing" .']
  test = TTReasoningTransducer('avatars/test/rules')
  new_facts = test([parse_eventuality(f) for f in facts])
  for f in new_facts:
    print(f)


def test2():
  test = TTGistTransducer(['avatars/sophie-gpt/rules', 'avatars/sophie-gpt/day1/rules'])

  clog = []
  utt = 'where is your pain ?'
  print(test(utt, clog))

  clog = [
    DialogueTurn('^me', Utterance('do i really need chemotherapy ?'), gists=['do i need chemotherapy ?']),
    DialogueTurn('^you', Utterance('hmm ...'))
  ]
  utt = 'yes , i would recommend it . did you come here with anyone today ?'
  print(test(utt, clog))

  clog = [
    DialogueTurn('^me', Utterance("hi , doctor . i'm meeting with you today to help get some questions answered about my condition .")),
    DialogueTurn('^me', Utterance("i wanted to talk to you about the recent increase in my pain . i'm not sure why it's been getting worse lately , and i was hoping you could provide some insight ."),
                 gists=['why has my pain been getting worse recently ?']),
  ]
  utt = 'unfortunately sophie your cancer has spread .'
  print(test(utt, clog))


def test3():
  test = TTParaphraseTransducer('avatars/sophie/rules')

  clog = []
  gist = 'this is an out of domain gist clause .'
  print(test(gist, clog))

  clog = [
    DialogueTurn('^me', Utterance('is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn('^you', Utterance('nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  gist = 'what is my prognosis ?'
  print(test(gist, clog))

  gist = 'i drove here today .'
  print(test(gist, clog))


def main():
  test1()
  test2()
  test3()


if __name__ == '__main__':
  main()