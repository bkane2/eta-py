"""A simple script for reading terminal inputs in dialogue with Eta.

First start Eta using the following command:
`python3 -m eta.core.eta --agent sophie_gpt --user test`

Then start this script using one of the following commands, depending on
whether the specific Eta agent begins with a user turn or agent turn:
`python3 terminal.py sophie-gpt _test`
`python3 terminal.py sophie-gpt _test --agent_start`

In the terminal.py arguments, `sophie-gpt` and `_test` are the agent and
user IDs as defined in the respective config files.
"""

import argparse
import os
from time import sleep

def read_eta(fname_in_words, fname_in_affect):
    with open(fname_in_words, 'r') as f:
      words = f.read()
    with open(fname_in_affect, 'r') as f:
      affect = f.read()
    os.remove(fname_in_words)
    os.remove(fname_in_affect)
    
    if words:
      return f'[{affect}] {words}'
    else:
      return ''
    

def block_until_eta_response(fname_in_words, fname_in_affect):
  utt = ''
  while not utt:
    while not os.path.isfile(fname_in_words) or not os.path.isfile(fname_in_affect):
      sleep(.1)
    str = read_eta(fname_in_words, fname_in_affect)
    utt = str if str else ''
  return utt


def main(args):
  fname_out = f'io/{args.agent_id}/{args.user_id}/in/speech.txt'
  fname_in_words = f'io/{args.agent_id}/{args.user_id}/turn-output.txt'
  fname_in_affect = f'io/{args.agent_id}/{args.user_id}/turn-affect.txt'

  # Remove initial contents of Eta files
  if os.path.isfile(fname_in_words) and os.path.isfile(fname_in_affect):
    os.remove(fname_in_words)
    os.remove(fname_in_affect)

  # If agent is supposed to start, block until an utterance is obtained
  if args.agent_start:
    print(block_until_eta_response(fname_in_words, fname_in_affect))

  # Listen for user input
  while True:
    sleep(.1)
    utt = input()
    with open(fname_out, 'w+') as f:
      f.write(utt)
    if utt == ':q':
      break

    print(block_until_eta_response(fname_in_words, fname_in_affect))
    

if __name__ == '__main__':
  parser = argparse.ArgumentParser(description='Eta terminal.')
  parser.add_argument('agent_id', type=str)
  parser.add_argument('user_id', type=str)
  parser.add_argument('--agent_start', action='store_true')
  args = parser.parse_args()
  main(args)