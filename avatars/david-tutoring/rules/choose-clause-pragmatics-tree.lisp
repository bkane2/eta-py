(MAPC 'ATTACHFEAT
'(
  (STRUCTURE concept)
  (BIGGER larger taller wider longer)
  (SMALLER shorter narrower)
))


(READRULES '*clause-pragmatics-tree*
; TODO: It seems that the ungainly 'spatial-question' in the gist clause here can
; now be removed, since we can resolve such a gist clause to an ask-question.v action,
; adding an appropriate conditional in the tutoring/QA schemas.
'(
  1 (spatial-question 0)
    2 (^you ask-question.v) (0 :ulf)
  1 (goodbye 0)
    2 (^you say-bye.v) (0 :ulf)
  1 (pause for 1 .MOMENT 0)
    2 (^you ask-to-pause.v) (0 :ulf)
  1 (1 I .MAKE 1 .CORRECT .MOVE 1)
    2 (^you verify-correctness.v) (0 :ulf)
  1 (1 I .UNDERSTAND 1 concept 1)
    2 (^you say-yes.v) (0 :ulf)
  1 (0 I .DO not 2 .MAKE 1 .BIGGER .EXAMPLE of 1 .STRUCTURE 1)
    2 (^you say-no.v) (0 :ulf)
  1 (0 I 2 .MAKE 1 .BIGGER .EXAMPLE of 1 .STRUCTURE 0)
    2 (^you ask-to-make-structure-bigger.v) (0 :ulf)
  1 (0 I 2 .MAKE 1 .SMALLER .EXAMPLE of 1 .STRUCTURE 0)
    2 (^you ask-to-make-structure-smaller.v) (0 :ulf)
  1 (NIL Gist \: 0)
    2 (^you (make.v (a.d (unknown.a request.n)))) (0 :ulf)
))