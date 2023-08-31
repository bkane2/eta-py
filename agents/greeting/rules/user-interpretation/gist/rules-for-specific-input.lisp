; The rules defined in this file contain context-sensitive responses that might be expected based on the
; question that LISSA previously asked.
; 
; All trees defined in this file should be named using format *<topic-key>-input*.
;

(READRULES '*topic-input*
'(
  ;; 1 (:subtree *match-affirm*)
  ;;   2 ((Test gist \.)) (0 :gist)
  ;; 1 (:subtree *match-unsure*)
  ;;   2 ((Test gist \.)) (0 :gist)
  ;; 1 (:subtree *match-deny*)
  ;;   2 ((Test gist \.)) (0 :gist)
)) ; END *topic-input*



(READRULES '*say-bye-input*
; (Goodbye \.)
'(
  1 (0 .BYE 0)
    2 ((Goodbye \.) (Exchange-goodbyes)) (0 :gist)
  1 (0 talk 2 again 2 soon 0)
    2 ((Goodbye \.) (Exchange-goodbyes)) (0 :gist)
  1 (0 talk to you 1 soon 0)
    2 ((Goodbye \.) (Exchange-goodbyes)) (0 :gist)
  1 (0 until 1 next 0)
    2 ((Goodbye \.) (Exchange-goodbyes)) (0 :gist)
)) ; END *say-bye-input*