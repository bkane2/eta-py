(READRULES '*gist*
'(
  1 (!expr !expr) ; previous gist clause + utterance
    2 ((*gist-clause-trees-for-input* 1) (split-sentences! 2)) (0 :subtrees-permute)
))


(READRULES '*gist-clause-trees-for-input*
'(
  1 (2 what 1 your name 1)
    2 (*name-input*) (0 :raw)
  1 (2 .DO 1 .HAVE 2 spatial .QUESTION 3)
    2 (*spatial-question-input*) (0 :raw)
  1 (0 .DO 1 .WANT 2 resume 1)
    2 (*request-input*) (0 :raw)
  1 (0)
    2 (*request-input*) (0 :raw)
))