; This rule tree is called in the case where no specific-input pattern is matched;
; this will either branch to a tree for detecting general questions, or a tree for
; detecting general statements, depending on whether the sentence has the form of a
; question.
;
(READRULES '*general-input*
'(
  ; Detect question forms
  1 (0 ?) ; anything ending with ?
    2 *question-input* (0 :subtree)
  1 (.WH_ 0) ; wh or how question
    2 *question-input* (0 :subtree)
  1 (.AUX .NP_ 0) ; modal question
    2 *question-input* (0 :subtree)
  1 (0 .AUX you 0) ; modal question
    2 *question-input* (0 :subtree)
  1 (0 .AUX .NP_ 1) ; tag question
    2 *question-input* (0 :subtree)
  1 (0 .COMMUNICATIVE 1 .WH_ 0) ; question imperative
    2 *question-input* (0 :subtree)
  1 (0 .COMMUNICATIVE 1 .INTEROG 0) ; question imperative
    2 *question-input* (0 :subtree)
  ; Otherwise, look for statement
  1 (0)
    2 *statement-input* (0 :subtree)
))