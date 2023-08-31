(MAPC 'ATTACHFEAT
'(
  (GP-INGREDIENTS sauce macaroni potato cheese mustard ketchup burger hamburger fries)
))
; Since the question is open-ended, we're not really looking for specific answer.
; Gist clauses will be derived from the thematic answer rules.
(READRULES '*garbage-plate-input*
'(
  ; Reciprocal questions
  1 (0 .HAVE you 2 tried it 0 ?)
    2 ((Have I tried garbage plate yet ?) (Garbage-plate)) (0 :gist)
  1 (0 .HAVE you 2 tried 2 .GARBAGE plate 0 ?)
    2 ((Have I tried garbage plate yet ?) (Garbage-plate)) (0 :gist)
  ; Specific answers
  1 (0 .NEG idea 0)
    2 ((You do not know about garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .HAVE .NEG tried 0)
    2 ((You have not tried garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .HAVE never tried 0)
    2 ((You have not tried garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .HAVE 3 .NEG 3 .HAD 0)
    2 ((You have not tried garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .HAVE 3 never 3 .HAD 0)
    2 ((You have not tried garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .NEG tested 0)
    2 ((You have not tried garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .HAVE never tested 0)
    2 ((You have not tried garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .HAVE 3 .NEG 3 been 0)
    2 ((You have not tried garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .GP-INGREDIENTS 0)
    2 ((You told me garbage plate ingredients \.) (Garbage-plate)) (0 :gist)
  1 (0 .NEG know 0)
    2 ((You do not know about garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .NEG .LIKE 0)
    2 ((You do not like garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what garbage plate is \.) (Garbage-plate)) (0 :gist)
))


(READRULES '*thematic-garbage-plate-input*
'(
  1 (0 .BADPRED 0)
    2 ((You do not like garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .NEG .GOODPRED 0)
    2 ((You do not like garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .NEG 1 .GOODPRED 0)
    2 ((You do not like garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0 .GOODPRED 0)
    2 ((You like garbage plate \.) (Garbage-plate)) (0 :gist)
))


(READRULES '*reaction-to-garbage-plate-input*
'(
  1 (0 you .DO not know 0)
    2 (Well \, you should try it at least once \. I will definitely check it out some time \.) (100 :out)
  1 (0 you .HAVE not tried 0)
    2 (Well \, you should try it at least once \. I will definitely check it out some time \.) (100 :out)
  1 (0 you told me 0 ingredients 0)
    2 (Wow \, that sounds like a funny idea \. I will definitely try it some time \.) (100 :out)
  1 (0 .NEG .LIKE 0)
    2 (I do not know if I like it but I am actually curious to try it \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I love try new stuff \. I should give it a try \.) (100 :out)
)) ; end of *reaction-to-garbage-plate-input*