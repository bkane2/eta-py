from eta.transducers.tt import *
from eta.transducers.gpt import *
from eta.embedding import *

def config():
  return {
    'agent': 'test',
    'agent_name': 'Test',
    'schema_dirs': 'agents/test/schemas',
    'knowledge_dirs': 'agents/test/knowledge',
    'start_schema': 'test.v',
    'perception_servers': ['speech', 'world'],
    'specialist_servers': [],
    'transducers': {
        'reason-top-down' : TTReasonTopDownTransducer('agents/test/rules'),
        'reason-bottom-up' : TTReasonBottomUpTransducer('agents/test/rules'),
        # 'gist' : [TTGistTransducer('agents/test/rules'), GPTGistTransducer()],
        'gist' : TTGistTransducer('agents/test/rules'),
        'semantic' : TTSemanticTransducer('agents/test/rules'),
        'pragmatic' : TTPragmaticTransducer('agents/test/rules'),
        'reaction' : TTReactionTransducer('agents/test/rules'),
        'subplan' : TTSubplanTransducer('agents/test/rules'),
        'affect' : GPTAffectTransducer()
    },
    'embedder': STEmbedder(),
    'session_number': 1
  }