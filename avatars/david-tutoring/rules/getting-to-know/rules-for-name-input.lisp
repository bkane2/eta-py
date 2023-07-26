(MAPC 'ATTACHFEAT
'(
  (AMERICAN-NAMES AMERICAN-MALE-NAMES AMERICAN-FEMALE-NAMES)
))
;; (what did you have for breakfast ?)
;; (name)
;; from-name-input
;; (0 my name is 0) 
;;     gist-question: (2 what is your name 1)
(READRULES '*name-input*
'(
  1 (0 ?)
    2 *question-from-name-input* (0 :subtree)
  1 (0)
    2 *specific-answer-from-name-input* (0 :subtree)
))


(READRULES '*specific-answer-from-name-input*
'(
  1 (0 .AMERICAN-NAMES american-family-names 0)
    2 ((Your name is 2 3 \.) (Name)) (0 :gist)
  1 (0 .AMERICAN-NAMES 0)
    2 ((Your name is 2 \.) (Name)) (0 :gist)
  1 (0)
    2 ((Eta could not understand what your name is \.) (Name)) (0 :gist)
))


(READRULES '*question-from-name-input*
'(
  1 (0 what 2 you 0)
    2 (What is my name ?) (0 :gist)
  1 (0 how 2 you 0)
    2 (What is my name ?) (0 :gist)
  1 (0 .WH_ 1 your name 0)
    2 (What is my name ?) (0 :gist)
))


(READRULES '*reaction-to-name-input*
'(
  1 (0 your name is .AMERICAN-NAMES 0)
    2 (It is very nice to meet you 5 \. I hope we have many great interactions in the future \.) (100 :out)
  1 (0)
    2 (It is very nice to meet you \. I hope we have many great interactions in the future \.) (100 :out)
))