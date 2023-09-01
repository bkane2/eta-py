"""Tree Transduction

This package contains an implementation of the Tree Transduction (TT) algorithm
and choice tree mechanism, translated from the previous LISP versions found here:
https://github.com/bkane2/eta/blob/master/core/tt/
https://github.com/bkane2/eta/blob/master/core/eta.lisp

Modules
-------
choice : Methods for choosing a result from a choice tree given an S-expression.
match : Methods for matching a TT pattern to an S-expression and filling in a corresponding template.
preds : Definitions for custom evaluable predicates used in TT patterns.
parse : Methods for parsing choice trees and word features from LISP definitions.
"""