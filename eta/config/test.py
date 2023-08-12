from eta.transducers.tt import *
from eta.transducers.gpt import *

def config():
  return {
    'avatar': 'test',
    'avatar_name': 'Test',
    'schema_dirs': 'avatars/test/schemas',
    'start_schema': 'test-repeat.v',
    'perception_servers': ['speech', 'world'],
    'specialist_servers': [],
    'transducers': {
        'reasoning' : TTReasoningTransducer('avatars/test/rules'),
        # 'gist' : [TTGistTransducer('avatars/test/rules'), GPTGistTransducer()],
        'gist' : TTGistTransducer('avatars/test/rules'),
        'semantic' : TTSemanticTransducer('avatars/test/rules'),
        'pragmatic' : TTPragmaticTransducer('avatars/test/rules'),
        'reaction' : TTReactionTransducer('avatars/test/rules'),
        'expand-step' : TTExpandStepTransducer('avatars/test/rules')
    },
    'session_number': 1
  }