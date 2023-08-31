;;  What is the hardest part about advances in technology these days? 
;;	(0 the hardest part of advances in technology is 0)
;;	technology-hardest-part
;;	(What is the hardest part about advances in technology ?)
;;	(3 What 3 hardest part of advances in technology 3)
;; MEETING WITH KIM NOTES (8/4/2017)
;; Keeping up with it
;; How quickly it changes
;; Don't know how to use it / hard to use
;; Don't know what it's for
;; Grandkids have to teach them
;; People not going outside as much / texting too much
(MAPC 'ATTACHFEAT
'(
  (CATCH keep)
  (DEVELOP development developed change improve blossom evolve)
  (FAST quickly QUICK)
  (DIFFICULT difficulty hard TROUBLE)
  (DEPEND teach HELP)
  (LEARN learned)
  (GET getting gotten got)
))


(READRULES '*technology-hardest-part-input*
'(
  ; Questions
  1 (0 what 4 hardest part 0 ?)
    2 (What is the hardest part about advances in technology these days ?) (0 :gist)
  1 (0 .WH_ 2 hardest part 0 ?)
    2 (What is the hardest part about advances in technology these days ?) (0 :gist)
  ; Specific answers
  1 (0 .CATCH up with 0)
    2 ((The hardest part of advances in technology is to catch up with new things \.) (Technology-hardest-part)) (0 :gist)
  1 (0 .DEVELOP 1 .FAST 0)
    2 ((The hardest part of advances in technology is that it developed so fast \.) (Technology-hardest-part)) (0 :gist)
  1 (0 .DIFFICULT 0)
    2 ((The hardest part of advances in technology is that it is hard to learn \.) (Technology-hardest-part)) (0 :gist)
  1 (0 .DEPEND 0)
    2 ((The hardest part of advances in technology is that you need help to learn it \.) (Technology-hardest-part)) (0 :gist)
  1 (0 .LEARN 0)
    2 ((The hardest part of advances in technology is that it is hard to learn \.) (Technology-hardest-part)) (0 :gist)
  1 (0 .GET used 0)
    2 ((The hardest part of advances in technology is to get used to it \.) (Technology-hardest-part)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what the hardest part of advances in technology is \.) (Technology-hardest-part)) (0 :gist)
))


(READRULES '*reaction-to-technology-hardest-part-input*
'(
  1 (0 .CATCH up with 0)
    2 (Technology definitely evolves very fast \. It\'s even hard for me to keep up sometimes \! But the effort in learning new technology does pay off \.) (100 :out)
  1 (0 developed 2 .FAST 0)
    2 (Technology definitely evolves very fast \. It\'s even hard for me to keep up sometimes \! But the effort in learning new technology does pay off \.) (100 :out)
  1 (0 hard to .LEARN 0)
    2 (Many types of technology can be very difficult to learn \. I like to look for easy tutorials or ask a friend when this happens \.) (100 :out)
  1 (0 need .HELP to .LEARN 0)
    2 (Asking for help from a friend or family is normal \! It helps save time and effort when learning to use new technology \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I think technology evolves too fast sometimes \. It\'s understandable that many people have trouble with it \.) (100 :out)
))