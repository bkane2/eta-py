(READRULES '*reaction-to-input*
'(
  ;; 1 (An input was found 0)
  ;;   2 (You gave an input \.) (0 :out)
  1 (question-suggestion \: 0)
    2 (Question-suggestion \: 3) (0 :out)
  1 (empathy-suggestion \: 0)
    2 (Empathy-suggestion \: 3) (0 :out)
;; 1 (The doctor asked an open ended question \.)
;;   2 (Excellent! You asked an open ended question !) (0 :out)
))