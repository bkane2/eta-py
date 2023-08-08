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

# A list of supported speech acts
SPEECH_ACTS = ['say-to.v', 'paraphrase-to.v', 'reply-to.v', 'react-to.v']

# A list of emotions supported by Eta, where the first element is assumed to be the default.
EMOTIONS_LIST = ['neutral', 'sad', 'happy', 'worried', 'angry']

# Path for input/outputs to be written to and read from
IO_PATH = 'io/'

# The default start schema if none is provided in agent-config
DEFAULT_START = 'have-eta-dialog.v'

# The default importance for new facts stored in memory
DEFAULT_IMPORTANCE = 0.5