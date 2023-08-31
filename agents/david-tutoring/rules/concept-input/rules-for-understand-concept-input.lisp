;;
;; User response to system asking if they understand a concept
;; 
(MAPC 'ATTACHFEAT
'(
  (YES yeah yup)
  (THINK BELIEVE)
  (BIGGER larger taller wider longer)
  (SMALLER shorter narrower)
  (EXAMPLE ONE)
  (BUILD MAKE create)
))


(READRULES '*understand-concept-input*
'(
  ; User asks to make a bigger example
  1 (0 .BIGGER 0)
    2 ((You want to make a bigger example of the concept \.)) (0 :gist)
  1 (0 .BUILD 2 another 1 .EXAMPLE 0)
    2 ((You want to make a bigger example of the concept \.)) (0 :gist)
  ; User asks to make a smaller example
  1 (0 .SMALLER 0)
    2 ((You want to make a smaller example of the concept \.)) (0 :gist)
  ; User replies with some form of 'yes'
  1 (1 .YES 5)
    2 ((You understand the concept \.)) (0 :gist)
  1 (1 I .THINK 2)
    2 ((You understand the concept \.)) (0 :gist)
  1 (1 I .DO 2)
    2 ((You understand the concept \.)) (0 :gist)
  ; User replies with some form of 'no'
  1 (1 .NEG 0)
    2 ((you do not understand the concept |.|))
))