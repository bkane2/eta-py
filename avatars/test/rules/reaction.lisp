(READRULES '*reaction*
'(
  1 (^you paraphrase-to.v ^me !expr)
    2 (*reaction-gist* (quote-to-list! 4)) (0 :subtree+clause)
))

(READRULES '*reaction-gist*
'(
  1 (0 test gist clause 0)
    2 (^me test.v (the.d system.n)) (0 :ulf)
))