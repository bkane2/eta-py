"""Eta

This is the top-level package for the Eta dialogue manager.

NOTE: throughout this documentation, the special type 's-expr' is introduced to refer to argument or
return values that may be a symbol (string) or recursively nested list structure.

Subpackages
-----------
core : The core dialogue manager processes.
transducers : The transducer classes used for performing various mappings during Eta execution.
util : Utilities that Eta relies on.

Modules
-------
constants : Global constants used by other Eta modules.
discourse : Tools for storing and recording Eta conversations.
embedding : Tools for creating embeddings of Eta objects.
memory : Tools for storing and retrieving eventualities in Eta's semantic memory.
lf : Classes for representing and modifying logical forms and eventualities.
plan : Classes and methods for creating and updating dialogue plans.
schema : Classes and methods for instantiating and modifying schemas.
"""