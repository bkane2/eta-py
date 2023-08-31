;; (what did you have for breakfast ?)
;; (name)
;; from-name-input
;; (0 my name is 0) 
;;     gist-question: (2 what is your name 1)
(MAPC 'ATTACHFEAT
'(
  (AMERICAN-NAMES american-male-names american-female-names)
))


(READRULES '*name-input*
'(
  ; Reciprocal questions
  1 (0 what 2 you 0 ?)
    2 (What is my name ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What is my name ?) (0 :gist)
  1 (0 .WH_ 1 your name 0 ?)
    2 (What is my name ?) (0 :gist)
  ; Specific answer
  1 (0 .AMERICAN-NAMES american-family-names 0)
    2 ((Your name is 2 3 \.) (Name)) (0 :gist)
  1 (0 .AMERICAN-NAMES 0)
    2 ((Your name is 2 \.) (Name)) (0 :gist)
  1 (0)
    2 ((Lissa could not understand what your name is \.) (Name)) (0 :gist)
))


(READRULES '*reaction-to-name-input*
'(
  1 (0 your name is .AMERICAN-NAMES 0)
    2 (It is so nice to see you 5 \. I hope we have great interactions during the coming sessions \.) (100 :out)
  1 (0)
    2 (It is so nice to see you \. I hope we have great interactions during the coming sessions \.) (100 :out)
))