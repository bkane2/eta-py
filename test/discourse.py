from eta.discourse import *

def main():
  print(swap_duals("i told you that i think you know that's not true ."))
  print(swap_duals("but you said that i think you know that's not true ."))

  print(decompress("i'm gonna go to the store tomorrow, what're you doing?"))
  print(compress("you are not going to do that. you can not do that."))

  print(parse_utt_str('[sad] test string .'))


if __name__ == '__main__':
  main()