;;
;; Special requests (e.g. pause, quit)
;; 
(MAPC 'ATTACHFEAT
'(
  (MOMENT SECOND MINUTE bit)
  (FINISHED-WORD it all everything)
))


(READRULES '*request-input*
'(
  1 (bye 0)
    2 ((Goodbye \.)) (0 :gist)
  1 (goodbye 0)
    2 ((Goodbye \.)) (0 :gist)
  1 (david bye 0)
    2 ((Goodbye \.)) (0 :gist)
  1 (david goodbye 0)
    2 ((Goodbye \.)) (0 :gist)
  1 (0 that is finished-quant 0)
    2 ((Goodbye \.)) (0 :gist)
  1 (0 pause 0)
    2 ((Pause for a moment \.)) (0 :gist)
  1 (0 stop for 1 .MOMENT 0)
    2 ((Pause for a moment \.)) (0 :gist)
  1 (0 give 2 .MOMENT 0)
    2 ((Pause for a moment \.)) (0 :gist)
  1 (0 take 1 break 0)
    2 ((Pause for a moment \.)) (0 :gist)
  1 (david 1 stop 0)
    2 ((Pause for a moment \.)) (0 :gist)
  1 (david)
    2 ((Resume \.)) (0 :gist)
  1 (0 resume 0)
    2 ((Resume \.)) (0 :gist)

  1 (0 that is .FINISHED-WORD 0)
    2 ((Goodbye \.)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: request)) (0 :gist)
))