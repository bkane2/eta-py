# Default models/embedding URLs
EMBEDDING_DEFAULT_API = "https://api-inference.huggingface.co/pipeline/feature-extraction/"
EMBEDDING_DEFAULT_MODEL = "sentence-transformers/all-distilroberta-v1"

# Directory for API keys
KEY_PATH = '_keys/'

# Coreference mode
# 0 : simply reconstruct the original ulf
# 1 : mode 2 but excluding i.pro and you.pro from resolved references
# 2 : substitute most specific referents only for anaphora and indexical np's (e.g. that block)
# 3 : substitute most specific referents for all references
COREFERENCE_MODE = 1

# Recency cutoff used when attempting coreference (i.e. the coreference
# module will only look this far back, in terms of turns, in the discourse
# history to find possible referents).
RECENCY_CUTOFF = 2

# The certainty of an episode determines the timer period (in seconds) that must be
# passed for Eta to consider an expected episode failed and move on in the plan.
# This is a function on the certainty of the episode, with a certainty of 1 having
# an infinite period, and a certainty of 0 having a period of 0. This constant determines
# the coefficient on the certainty-to-period function.
# Currently, this coefficient makes a certainty of ~0.632 correspond to 30 seconds.
EXPECTED_STEP_FAILURE_PERIOD_COEFFICIENT = 30

# Certainty cutoff used to generate responses given a list of relations+certainties from the blocks world
CERTAINTY_THRESHOLD = 0.7

# A list of emotions supported by Eta, where the first element is assumed to be the default.
EMOTIONS_LIST = ['neutral', 'sad', 'happy', 'worried', 'angry']

# Path for input/outputs to be written to and read from
IO_PATH = 'io/'

# The default start schema if none is provided in agent-config
DEFAULT_START = 'have-eta-dialog.v'

# The default importance for new facts stored in memory
DEFAULT_IMPORTANCE = 0.5

# Common indexical variables
ME = '^me'
YOU = '^you'
NOW = '^now'
HERE = '^here'

# Common predicates
SAY_TO = 'say-to.v'
PARAPHRASE_TO = 'paraphrase-to.v'
RESPOND_TO = 'respond-to.v'
REPLY_TO = 'reply-to.v'
ANSWER = 'answer.v'
ASK = 'ask.v'
REACT_TO = 'react-to.v'
ARTICULATE_TO = 'articulate-to.v'
SAY_BYE = 'say-bye.v'

# A list of supported speech acts
SPEECH_ACTS = [SAY_TO, PARAPHRASE_TO, RESPOND_TO, REPLY_TO, ANSWER, ASK, REACT_TO, ARTICULATE_TO, SAY_BYE]

# Telic predicates, i.e., predicates that denote events that are assumed to be "instantaneous".
# TODO: create a more systematic classification
TELIC_VERBS = SPEECH_ACTS + ['move.v']

# Special "no-op" WFFs used to characterize failed episodes
NOOP_YOU = [YOU, 'do.v', ['no.d', 'thing.n']]
NOOP_GEN = [['no.d', 'thing.n'], 'happen.v']
NOOP = [NOOP_YOU, NOOP_GEN]
