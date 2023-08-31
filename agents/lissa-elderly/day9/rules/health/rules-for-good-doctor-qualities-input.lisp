;; 	What are the qualities of a good doctor? 
;; (0 a good doctor 0)
;; good-doctor-qualities
;; (What are the qualities of a good doctor ?) 
;; (3 what 2 qualities of a good doctor 3) 
(MAPC 'ATTACHFEAT
'(
))


(READRULES '*good-doctor-qualities-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (What are the qualities of a good doctor ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What are the qualities of a good doctor ?) (0 :gist)
  1 (0 .DO 1 you 1 .HAVE 2 doctor 0 ?)
    2 (Do I have a doctor ?) (0 :gist)
  ; Specific answers
  1 (0 concerns 2 seriously 0)
    2 ((A good doctor takes your concerns seriously \.) (Good-doctor-qualities)) (0 :gist)
  1 (0 .VERY 2 .HELPFUL 0)
    2 ((A good doctor is very helpful \.) (Good-doctor-qualities)) (0 :gist)
  1 (0 .GOODPROP 0)
    2 ((A good doctor is 2 \.) (Good-doctor-qualities)) (0 :gist)
  1 (0 .GOODREL 0)
    2 ((A good doctor is one that 2 \.) (Good-doctor-qualities)) (0 :gist)
  1 (0 .QUICK 0)
    2 ((A good doctor is quick \.) (Good-doctor-qualities)) (0 :gist)
  1 (0 .LISTEN 0)
    2 ((A good doctor is a good listener \.) (Good-doctor-qualities)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what are the qualities of a good doctor \.) (Good-doctor-qualities)) (0 :gist)
))


(READRULES '*reaction-to-good-doctor-qualities-input*
'(
  1 (0 good doctor takes your concerns seriously 0)
    2 (It\'s always important to feel like you\'re being taken seriously when discussing your own health \.) (100 :out)
  1 (0 good doctor is .VERY .HELPFUL 0)
    2 (It\'s super helpful to have a doctor who always knows just the right treatments \.) (100 :out)
  1 (0 good doctor is .GOODPROP 0)
    2 (I would love to have a doctor that\'s 5 \, one day \.) (100 :out)
  1 (0 good doctor is .ONE that .GOODREL 0)
    2 (Respect and support are extremely important in the relationship with your doctor \.) (100 :out)
  1 (0 good doctor is .QUICK 0)
    2 (It\'s convenient to not spend too long on annoying treatments \. A good doctor gets it over with quickly \.) (100 :out)
  1 (0 good doctor is a good listener 0)
    2 (Having a doctor who can listen to your concerns is important \, since it\'s the very first step in solving a problem \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I would like to have a doctor with those good qualities \.) (100 :out)
))