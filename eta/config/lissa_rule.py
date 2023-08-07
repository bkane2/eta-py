from eta.transducers.tt import TTReasoningTransducer

def config():
  return {
    'avatar': 'lissa-gpt',
    'avatar_name': 'Lissa',
    'schema_dirs': 'avatars/test/schemas',
    'start_schema': 'test.v',
    'perception_servers': ['audio', 'world'],
    'specialist_servers': [],
    'emotion_tags': False,
    'transducers': {
        'reasoning' : [TTReasoningTransducer('avatars/test/rules', 'reasoning-split', split=True),
                       TTReasoningTransducer('avatars/test/rules', 'reasoning')]
    },
    'session_number': 1
  }