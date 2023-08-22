from eta.util.buffer import *

def main():
  test = []
  enqueue('alfalfa', test)
  enqueue('zeta', test)
  enqueue('rota', test, importance=2)
  print(iterate(test))
  print(iterate(test, func=lambda str: str + '_1'))
  print(pop_item(test))
  print(pop_item(test))
  clear(test)
  
  enqueue_ordered(['x', 'y', 'z', 'd', 'c', 'b', 'a'], test)
  print(get_item(test, importance=True))
  print(iterate(test))
  print(pop_all(test))
  print(test)


if __name__ == '__main__':
  main()