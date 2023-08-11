from eta.transducers.tt import TTReasoningTransducer, TTGistTransducer, TTPragmaticTransducer, TTSemanticTransducer
from eta.transducers.gpt import GPTGistTransducer

def config():
  return {
    'avatar': 'test',
    'avatar_name': 'Test',
    'schema_dirs': 'avatars/test/schemas',
    'start_schema': 'test.v',
    'perception_servers': ['speech', 'world'],
    'specialist_servers': [],
    'transducers': {
        'reasoning' : TTReasoningTransducer('avatars/test/rules'),
        # 'gist' : [TTGistTransducer('avatars/test/rules'), GPTGistTransducer()],
        'gist' : TTGistTransducer('avatars/test/rules'),
        'semantic' : TTSemanticTransducer('avatars/test/rules'),
        'pragmatic' : TTPragmaticTransducer('avatars/test/rules')
    },
    'session_number': 1
  }