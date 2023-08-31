;;  (How did you get here ?)
;;	(how-you-got-here)
;; 	from-how-you-got-here-input
;;  (0 to get here 0)
;;  	gist-question: (1 How 2 get here 1)
(MAPC 'ATTACHFEAT
'(
  (DRIVE drove dropped drops drop)
  (RIDE rode)
  (TAKE took)
))


(READRULES '*how-you-got-here-input*
'(
  ; Reciprocal questions
  1 (0 what 2 you 0 ?)
    2 (How did I get here ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (How did I get here ?) (0 :gist)
  1 (0 did you .DRIVE 0 ?)
    2 (How did I get here ?) (0 :gist)
  1 (0 .DO you .DRIVE 0 ?)
    2 (How did I get here ?) (0 :gist)
  1 (0 can you .DRIVE 0 ?)
    2 (How did I get here ?) (0 :gist)
  ; Specific answer
  1 (0 I 1 .DRIVE 0)
    2 ((To get here you drove a car \.) (How-you-got-here)) (0 :gist)
  1 (0 I .HAVE 2 vehicle 0)
    2 ((To get here you drove a car \.) (How-you-got-here)) (0 :gist)
  1 (0 .TAKE 2 bus 0)
    2 ((To get here you took the bus \.) (How-you-got-here)) (0 :gist)
  1 (0 I 3 bus 0)
    2 ((To get here you took the bus \.) (How-you-got-here)) (0 :gist)
  1 (0 .RIDE 3 bus 0)
    2 ((To get here you took the bus \.) (How-you-got-here)) (0 :gist)
  1 (0 drove me 0)
    2 ((To get here someone drove you \.) (How-you-got-here)) (0 :gist)
  1 (0 I came with 0)
    2 ((To get here someone drove you \.) (How-you-got-here)) (0 :gist)
  1 (0 I was driven 0)
    2 ((To get here someone drove you \.) (How-you-got-here)) (0 :gist)
  1 (0 got a .RIDE 0)
    2 ((To get here someone drove you \.) (How-you-got-here)) (0 :gist)
  1 (0 rode with 0)
    2 ((To get here someone drove you \.) (How-you-got-here)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how to get here \.) (How-you-got-here)) (0 :gist)
))


(READRULES '*reaction-to-how-you-got-here-input*
'(
  1 (0 you drove 0)
    2 (That\'s good that you drive \! It must be nice to have the freedom to go somewhere when you want to \.) (100 :out)
  1 (0 you took the bus 0)
    2 (That\'s nice \! Buses can be a very efficient way to get around \.) (100 :out)
  1 (0 someone drove you 0)
    2 (It must be nice to go for a drive with someone you know \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Well \, I am glad you could make it here today \.) (100 :out)
))