"""Transducers

This package contains classes that perform various types of pattern transduction (i.e., transforming
from one structured representation to another), to be used throughout Eta's processes.

Each transducer class extends both a base transducer class (defining the call signature of that transducer),
as well as the transducer type class (defining the internal operation of that transducer, e.g., whether it
uses TT or GPT).

Modules
-------
base : Contains abstract base transducer classes for each supported transducer.
tt : Contains implementations for TT-based transducers.
gpt : Contains implementations for GPT-based transducers.
"""