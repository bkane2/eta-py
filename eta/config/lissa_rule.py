from eta.transducers.tt import TTReasoningTransducer

def config():
  return {
    'avatar': 'lissa-gpt',
    'avatar_name': 'Lissa',
    'schema_dirs': 'avatars/lissa-gpt/schemas',
    'start_schema': 'discuss-activities.v',
    'perception_servers': ['speech', 'world'],
    'specialist_servers': [],
    'transducers': {
        'reasoning' : TTReasoningTransducer('avatars/lissa-gpt/rules')
    },
    'session_number': 1
  }