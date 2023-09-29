from eta.transducers.tt import * 
from eta.discourse import *

def test1():
  facts = ['it is snowing outside .', 'i am mortal .', 'i own a cat , and my cat is nice .', 'i own skiis .', '^you say-to ^me "I like to go skiing" .']
  test = TTReasonBottomUpTransducer('agents/test/rules')
  new_facts = test([parse_eventuality(f) for f in facts])
  for f in new_facts:
    print(f)


def test2():
  step = parse_eventuality('(^you reply-to.v E1)')
  facts = ['(^you do.v something.pro)', '(^me say-to.v ^you "Hi")']
  test = TTReasonTopDownTransducer('agents/test/rules')
  new_facts = test(step, [parse_eventuality(f) for f in facts])
  for f in new_facts:
    print(f)

  facts = ['(^you do.v something.pro)', '(^me say-to.v ^you "Hi")', '(^you say-to.v ^me "Test")']
  test = TTReasonTopDownTransducer('agents/test/rules')
  new_facts = test(step, [parse_eventuality(f) for f in facts])
  for f in new_facts:
    print(f)


def test3():
  test = TTGistTransducer(['agents/sophie-gpt/rules', 'agents/sophie-gpt/day1/rules'])

  clog = []
  utt = Utterance('^you', 'where is your pain ?')
  print(test(utt, clog))

  clog = [
    DialogueTurn(Utterance('^me', 'do i really need chemotherapy ?'), gists=['do i need chemotherapy ?']),
    DialogueTurn(Utterance('^you', 'hmm ...'))
  ]
  utt = Utterance('^you', 'yes , i would recommend it . did you come here with anyone today ?')
  print(test(utt, clog))

  clog = [
    DialogueTurn(Utterance('^me', "hi , doctor . i'm meeting with you today to help get some questions answered about my condition .")),
    DialogueTurn(Utterance('^me', "i wanted to talk to you about the recent increase in my pain . i'm not sure why it's been getting worse lately , and i was hoping you could provide some insight ."),
                 gists=['why has my pain been getting worse recently ?']),
  ]
  utt = Utterance('^you', 'unfortunately sophie your cancer has spread .')
  print(test(utt, clog))

  clog = [
    DialogueTurn(Utterance('^me', 'hello sophie .'))
  ]
  utt = Utterance('^you', 'how frequently do you drink beer ?')
  print(test(utt, clog))

  clog = [
    DialogueTurn(Utterance('^me', "i don't see how you could possibly know that prediction for sure ! can you provide any more information or insights into my prognosis ?"),
                 gists=["can you provide more information or insights into my prognosis ?",
                        "i don't see how you could possibly know that prediction for sure !",
                        "nil question ?"])
  ]
  utt = Utterance('^you', "yes , it's very important to prepare for the future accordingly and i'm really sorry to have to give you this news .")
  print(test(utt, clog))


def test4():
  test = TTParaphraseTransducer('agents/sophie/rules')

  clog = []
  gist = 'this is an out of domain gist clause .'
  print(test(gist, clog, [], []))

  clog = [
    DialogueTurn(Utterance('^me', 'is it possible for my cancer to be cured ?'), gists=['can my cancer be cured ?']),
    DialogueTurn(Utterance('^you', 'nope i am afraid not .'), gists=['the prognosis is that i cannot be cured .'])
  ]
  gist = 'what is my prognosis ?'
  print(test(gist, clog, [], []))

  gist = 'i drove here today .'
  print(test(gist, clog, [], []))


def test5():
  test = TTPragmaticTransducer('agents/sophie-gpt/rules')

  gist = "there is some chance i could outlive my prognosis ."
  print(test(gist))


def test6():
  test = TTReactionTransducer('agents/sophie-gpt/rules')

  observation = parse_eventuality(['^you', 'paraphrase-to.v', '^me', '"when does my grandson graduate ?"'])
  print(test(observation))


def main():
  # test1()
  # test2()
  # test3()
  # test4()
  # test5()
  test6()


if __name__ == '__main__':
  main()