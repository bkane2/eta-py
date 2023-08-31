;; 	Do you think that naps during the day are helpful? 
;;	(0 I think that naps 0)
;;	opinion-about-nap
;;	(Do you think that naps during the day are helpful ?) 
;;	(3 do you think 2 naps 5 helpful 3) 
;; Yes, they're relaxing
;; Yes, they make me feel less tired
;; No, they don't help
(MAPC 'ATTACHFEAT
'(
  (ALT-GROGGY groggy TIRED bad disoriented worse)
))


(READRULES '*opinion-about-nap-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (Do I think that naps during the day are helpful ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (Do I think that naps during the day are helpful ?) (0 :gist)
  ; Specific answers
  1 (0 .POS 4 relaxing 0)
    2 ((You think that naps are relaxing \.) (Opinion-about-nap)) (0 :gist)
  1 (0 .POS 6 less 1 .TIRED 0)
    2 ((You think that naps make you less tired \.) (Opinion-about-nap)) (0 :gist)
  1 (0 .NEG 4 feel 1 .ALT-GROGGY 0)
    2 ((You think that naps make you feel worse \.) (Opinion-about-nap)) (0 :gist)
  1 (0 .POS 0)
    2 ((You think that naps are helpful \.) (Opinion-about-nap)) (0 :gist)
  1 (0 .NEG 0)
    2 ((You think that naps are not helpful \.) (Opinion-about-nap)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for if you think that naps are helpful \.) (Opinion-about-nap)) (0 :gist)
))


(READRULES '*reaction-to-opinion-about-nap-input*
'(
  1 (0 think that naps 2 relaxing 0)
    2 (Naps can be very relaxing \. They\'re a good way to calm down if you are feeling stressed \.) (100 :out)
  1 (0 think that naps 2 less .TIRED 0)
    2 (Naps definitely help with exhaustion \, especially if you didn\'t get enough sleep the night before \.) (100 :out)
  1 (0 think that naps 2 feel worse 0)
    2 (It sounds weird that a nap would make someone feel worse \. I kind of get it though \, it disrupts your sleep schedule \.) (100 :out)
  1 (0 think that naps 2 .NEG .HELPFUL 0)
    2 (You don\'t think naps are helpful \? That\'s too bad \.) (100 :out)
  1 (0 think that naps 2 .HELPFUL 0)
    2 (I don\'t have to nap very often \, but it\'s very refreshing when I do \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I don\'t have to nap very often \, but it\'s very refreshing when I do \.) (100 :out)
))