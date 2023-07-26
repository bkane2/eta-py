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


(READRULES '*bigger-example-input*
'(
  ; User replies with some form of 'no'
  1 (1 .NEG 4)
    2 ((You do not want to make a bigger example of the concept \.)) (0 :gist)
))