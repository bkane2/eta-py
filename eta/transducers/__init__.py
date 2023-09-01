"""Classes that perform various types of pattern transduction (i.e., mapping from one structured representation to another).

Each transducer class extends both a base transducer class (defining the call signature of that transducer),
as well as the transducer type class (defining the internal operation of that transducer, e.g., whether it
uses TT or GPT).
"""