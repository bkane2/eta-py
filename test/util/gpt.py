from eta.util.gpt import *

def main():
  result, cost = generate_gpt('test:')
  print(result)
  print(cost)


if __name__ == "__main__":
  main()