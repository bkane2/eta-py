from eta.transducers.misc import *
from eta.lf import *

def test1():

  test = SkillTransducer()

  pragmatics = test("I am really sorry Sophie.")
  print(pragmatics)

  pragmatics = test("Unfortunately your cancer has spread.")
  print(pragmatics)

  pragmatics = test("What are your goals?")
  print(pragmatics)

  pragmatics = test("Where does your daughter live?")
  print(pragmatics)


def main():
  test1()


if __name__ == '__main__':
  main()