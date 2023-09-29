"""Global constants used by other Eta modules.

This module contains definitions for a variety of global constants that are used by
other Eta modules. Generally, it can be imported using `from eta.constants import *`.
"""

SLEEPTIME = .1
"""float: The time used to sleep between each iteration of Eta's core processes."""

REASONING_DEPTH_LIMIT = 3
"""int: How many 'inference steps' from a direct observation to take during the reasoning process."""

EMBEDDING_DEFAULT_API = "https://api-inference.huggingface.co/pipeline/feature-extraction/"
"""str: Default embedding API URL, used if no other URL is specified in an embedder API."""

EMBEDDING_DEFAULT_MODEL = "sentence-transformers/all-distilroberta-v1"
"""str: Default embedding model, used if no other model is specified in an embedder."""

KEY_PATH = '_keys/'
"""str: Directory to check for API keys."""

SYMTAB_PATH = 'io/symtab.json'
"""str: Path used to create the symbol table (a dict structure maintaining indices for each unique symbol)."""

COREFERENCE_MODE = 1
"""int: The level of coreference to use.

Supported values:
  0: simply reconstruct the original ULF.
  1: the same as level 2, but excluding "I" and "you" from references to resolve.
  2: substitute canonical names only for anaphora and indexical NP's (e.g., "it" or "that block").
  3: substitute canonical names for all references.
"""

RECENCY_CUTOFF = 2
"""int: The coreference module will only look this many turns back in the discourse history to find possible referents."""

EXPECTED_STEP_FAILURE_PERIOD_COEFFICIENT = 30
"""int: The coefficient to use in the function mapping certainty scores to the period for expected step failures.

The certainty of an episode determines the timer period (in seconds) that must be passed for Eta to consider
an expected episode failed and move on in the plan. This is a function on the certainty of the episode, with
a certainty of 1 having an infinite period, and a certainty of 0 having a period of 0. This constant determines
the coefficient on the certainty-to-period function.

A value of "30" makes a certainty of ~0.632 correspond to 30 seconds.
"""

CERTAINTY_THRESHOLD = .7
"""float: A ULF must have a certainty greater than or equal to this score to be used in a response."""

EMOTIONS_LIST = ['neutral', 'sad', 'happy', 'worried', 'angry']
"""list[str]: A list of emotions supported by Eta, where the first element is assumed to be the default."""

IO_PATH = 'io/'
"""str: The path for input/outputs to be written to and read from."""

IO_IN_DIR = 'in/'
"""str: The directory within the IO path to use for inputs."""

IO_OUT_DIR = 'out/'
"""str: The directory within the IO path to use for outputs."""

IO_CLOG_DIR = 'conversation-log/'
"""str: The directory within the IO path to use for writing conversation logs for a session."""

CLOG_FILES = ['text', 'affect', 'gist', 'semantic', 'pragmatic', 'obligations', 'step']
"""list[str]: The list of all supported conversation log files."""

LOG_PATH = 'logs/'
"""str: The path for archived conversation logs to be written to."""

GPT_DEBUG_FILE = 'debug/prompts.txt'
"""str: A filepath to write GPT prompt debugging info to."""

DEFAULT_START = 'have-eta-dialog.v'
"""int: The default start schema if none is provided in agent-config."""

DEFAULT_IMPORTANCE = .25
"""float: The default importance value for new facts stored in memory."""

DEFAULT_IMPORTANCE_THRESHOLD = .5
"""float: The default threshold to place on importance when retrieving facts from memory."""



# Common variables/constants
# ```````````````````````````

ME = '^me'
"""str: Indexical variable to be used for Eta."""

YOU = '^you'
"""str: Indexical variable to be used for the user."""

NOW = '^now'
"""str: Indexical variable to be used for the current time."""

HERE = '^here'
"""str: Indexical variable to be used for the current location."""



# Common predicates/formulas
# ````````````````````````````

SAY_TO = 'say-to.v'
"""str: Predicate for a saying event."""

PARAPHRASE_TO = 'paraphrase-to.v'
"""str: Predicate for a paraphrasing event (i.e., a gist clause attribution)."""

ARTICULATE_TO = 'articulate-to.v'
"""str: Predicate for an articulation event (i.e., a ULF attribution)."""

RESPOND_TO = 'respond-to.v'
"""str: Predicate for a response event."""

REPLY_TO = 'reply-to.v'
"""str: Predicate for a reply event."""

ANSWER = 'answer.v'
"""str: Predicate for an answer event."""

ASK = 'ask.v'
"""str: Predicate for an ask event."""

REACT_TO = 'react-to.v'
"""str: Predicate for a react event."""

SAY_BYE = 'say-bye.v'
"""str: Predicate for a saying goodbye event."""

SPEECH_ACTS = [SAY_TO, PARAPHRASE_TO, RESPOND_TO, REPLY_TO, ANSWER, ASK, REACT_TO, ARTICULATE_TO, SAY_BYE]
"""list[str]: A list of all supported speech acts."""

TELIC_VERBS = SPEECH_ACTS + ['move.v']
"""list[str]: A list of all predicates considered "telic", i.e., that denote events that are assumed to be nearly instantaneous.

TODO: ultimately we need to create a more systemic classification, and provide this as an external resource.
"""

NOOP_YOU = [YOU, 'do.v', ['no.d', 'thing.n']]
"""s-expr: A formula used to denote a "failed" expectation of a user event."""

NOOP_GEN = [['no.d', 'thing.n'], 'happen.v']
"""s-expr: A formula used to denote a "failed" expectation of an external event."""

NOOP = [NOOP_YOU, NOOP_GEN]
"""list[s-expr]: A list of all formulas that are considered to be "no-op" events."""