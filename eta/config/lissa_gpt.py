from eta.transducers.gpt import GPTReasoningTransducer

def config():
  return {
    'avatar': 'lissa-gpt',
    'avatar_name': 'Lissa',
    'perception_servers': ['audio', 'world'],
    'specialist_servers': [],
    'emotion_tags': False,
    # 'model_names': {'information_retrieval': {'model': 'sentence-transformers/all-distilroberta-v1', 'api': True}},
    'transducers': {
        'reasoning' : GPTReasoningTransducer()
    },
    'session_number': 1
  }