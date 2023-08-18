from eta.transducers.tt import *
from eta.transducers.gpt import *
from eta.embedding import *

def config():
  return {
    'avatar': 'test',
    'avatar_name': 'Test',
    'schema_dirs': 'avatars/test/schemas',
    'knowledge_dirs': 'avatars/test/knowledge',
    'start_schema': 'test.v',
    'perception_servers': ['speech', 'world'],
    'specialist_servers': [],
    'transducers': {
        'reasoning' : TTReasoningTransducer('avatars/test/rules'),
        # 'gist' : [TTGistTransducer('avatars/test/rules'), GPTGistTransducer()],
        'gist' : TTGistTransducer('avatars/test/rules'),
        'semantic' : TTSemanticTransducer('avatars/test/rules'),
        'pragmatic' : TTPragmaticTransducer('avatars/test/rules'),
        'reaction' : TTReactionTransducer('avatars/test/rules'),
        'expand-step' : TTExpandStepTransducer('avatars/test/rules'),
        'affect' : GPTAffectTransducer()
    },
    'embedder': Embedder(),
    'session_number': 1
  }