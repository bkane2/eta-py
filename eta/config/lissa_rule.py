from eta.transducers.tt import TTReasoningTransducer

def config():
  return {
    'avatar': 'lissa-gpt',
    'avatar_name': 'Lissa',
    'perception_servers': ['audio', 'world'],
    'specialist_servers': [],
    'emotion_tags': False,
    'transducers': {
        'reasoning' : TTReasoningTransducer()
    },
    'session_number': 1
  }