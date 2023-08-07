from eta.transducers.gpt import GPTReasoningTransducer

def config():
  return {
    'avatar': 'lissa-gpt',
    'avatar_name': 'Lissa',
    'schema_dirs': 'avatars/lissa-gpt/schemas',
    'start_schema': 'discuss-activities.v',
    'perception_servers': ['audio', 'world'],
    'specialist_servers': [],
    'emotion_tags': False,
    # 'model_names': {'information_retrieval': {'model': 'sentence-transformers/all-distilroberta-v1', 'api': True}},
    'transducers': {
        'reasoning' : GPTReasoningTransducer()
    },
    'session_number': 1
  }