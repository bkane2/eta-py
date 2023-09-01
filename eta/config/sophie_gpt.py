"""GPT-based SOPHIE agent."""

from eta.transducers.tt import *
from eta.transducers.gpt import *
from eta.embedding import *

SESSION_NUMBER = 1
DIR_SOPHIE = 'agents/sophie-gpt/'
DIRS_SCHEMA = [DIR_SOPHIE+'schemas', DIR_SOPHIE+f'day{SESSION_NUMBER}/schemas']
DIRS_RULES = [DIR_SOPHIE+'rules', DIR_SOPHIE+f'day{SESSION_NUMBER}/rules']
GIST_EXAMPLES = file.load_json('agents/sophie-gpt/gist_examples.json')
PARAPHRASE_EXAMPLES = file.load_json('agents/sophie-gpt/paraphrase_examples.json')

def config():
  return {
    'agent': 'sophie-gpt',
    'agent_name': 'Sophie',
    'schema_dirs': DIRS_SCHEMA,
    'start_schema': 'have-eta-dialog.v',
    'perception_servers': ['speech'],
    'specialist_servers': [],
    'transducers': {
        # 'reason-top-down' : TTReasonTopDownTransducer(DIRS_RULES),
        # 'reason-bottom-up' : TTReasonBottomUpTransducer(DIRS_RULES),
        'gist' : [TTGistTransducer(DIRS_RULES), GPTGistTransducer(GIST_EXAMPLES)],
        # 'semantic' : TTSemanticTransducer(DIRS_RULES),
        'pragmatic' : TTPragmaticTransducer(DIRS_RULES),
        'reaction' : TTReactionTransducer(DIRS_RULES),
        # 'subplan' : TTSubplanTransducer(DIRS_RULES),
        'paraphrase' : GPTParaphraseTransducer(PARAPHRASE_EXAMPLES),
        'response' : GPTResponseTransducer(),
        'answer' : GPTAnswerTransducer(),
        'ask' : GPTAskTransducer(),
        'affect' : GPTAffectTransducer()
    },
    'embedder': STEmbedder(),
    'session_number': 1
  }