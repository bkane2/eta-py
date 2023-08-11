# A simple script for allowing terminal inputs to be used for dialogue with Eta.
import argparse
import os
from time import sleep

def main(args):
  fname_out = f'io/{args.agent_id}/{args.user_id}/in/speech.txt'
  fname_in_words = f'io/{args.agent_id}/{args.user_id}/turn-output.txt'
  fname_in_affect = f'io/{args.agent_id}/{args.user_id}/turn-affect.txt'
  while True:
    sleep(.1)
    utt = input()
    with open(fname_out, 'w+') as f:
      f.write(utt)
    if utt == ':q':
      break

    while not os.path.isfile(fname_in_words) or not os.path.isfile(fname_in_affect):
      sleep(.1)
    
    with open(fname_in_words, 'r') as f:
      words = f.read()
    with open(fname_in_affect, 'r') as f:
      affect = f.read()
    os.remove(fname_in_words)
    os.remove(fname_in_affect)
    
    print(f'[{affect}] {words}')


if __name__ == '__main__':
  parser = argparse.ArgumentParser(description='Eta terminal.')
  parser.add_argument('agent_id', type=str)
  parser.add_argument('user_id', type=str)
  args = parser.parse_args()
  main(args)