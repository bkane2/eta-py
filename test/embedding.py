from eta.embedding import *

def main():
  print(sim([1., .5], [1., .3]))
  print(sim([[1., .5], [.3, .2], [.9, .01]], [1., .3]))
  print(sim([], []))
  print(sim([[], [], []], []))

  test = Embedder()

  print(len(test.embed('test sentence 1')))
  print(len(test.embed(['test sentence 2', 'test sentence 3'])))

  test_set1 = ['how to test systems', 'this is a sentence for testing', 'have you ever tested code before', 'debugging code']
  print(test.score('test sentence', test_set1))


if __name__ == '__main__':
  main()
