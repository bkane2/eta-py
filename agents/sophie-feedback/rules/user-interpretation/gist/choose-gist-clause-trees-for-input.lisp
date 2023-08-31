; This is the top-level gist-clause interpretation rule tree, used to select an appropriate choice packet using
; the context of SOPHIE's previous question or statement. If a match fails here, the system falls back to a
; general subtree intended to match generic questions from the user.
(READRULES '*gist*
'(
  1 (!expr !expr) ; previous gist clause + utterance
    2 ((*gist-clause-trees-for-input* 1) (split-sentences! 2)) (0 :subtrees-permute)
))


(READRULES '*gist-clause-trees-for-input*
'(
  1 (0)
    2 (*feedback-input*) (0 :raw)
))