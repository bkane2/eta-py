(MAPC 'ATTACHFEAT
'(
  (SPECIAL-REQUEST bye goodbye pause stop exit MOMENT quit resume david)
))


(READRULES '*clause-semantics-tree*
'(
  1 (spatial-question 0)
    2 (*spatial-question-ulf-tree* (2)) (0 :ulf-coref)
  1 (your name is 0)
    2 (*name-ulf-tree* (1 2 3 4)) (0 :ulf-coref)
  1 (0 .SPECIAL-REQUEST 0)
    2 (*request-ulf-tree* (1 2 3)) (0 :ulf-coref)
))