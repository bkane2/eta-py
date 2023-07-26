;; (How long have you lived there ?)
;;	(how-long-lived-there)
;;		from-how-long-lived-there-input
;;			(0 I lived there for 0)
;;			gist-question:(3 how long 1 you lived 0)
(MAPC 'ATTACHFEAT
'(
  (NUM a ONE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN ELEVEN couple)
  (MANY TWELVE THIRTEEN FOURTEEN FIFTEEN SIXTEEN SEVENTEEN EIGHTEEN NINETEEN)
  (LOTS TWENTY THIRTY FORTY FIFTY SIXTY SEVENTY EIGHTY NINETY hundred)
  (MONTH-NAME january february march april may june july august september october november december)
))


(READRULES '*how-long-lived-there-input*
'(
  ; Specific answers
  1 (0 since 1 .MONTH-NAME 0)
    2 ((You lived there for a few months \.) (How-long-lived-there)) (0 :gist)
  1 (0 years 0)
    2 (0 .LOTS 1 years 0)
      3 ((You lived there for more than 2 years \.) (How-long-lived-there)) (0 :gist)
    2 (0 .MANY years 0)
      3 ((You lived there for 2 years \.) (How-long-lived-there)) (0 :gist)
    2 (0 .NUM years 0)
      3 ((You lived there for 2 years \.) (How-long-lived-there)) (0 :gist)
    2 ((You lived there for some years \.) (How-long-lived-there)) (0 :gist)
  1 (0 .NUM months 0)
    2 ((You lived there for some months \.) (How-long-lived-there)) (0 :gist)
  1 (0 whole life 0)
    2 ((You lived there your whole life \.) (How-long-lived-there)) (0 :gist)
  1 (0 .NEG 2 long 0)
    2 ((You lived there for not a long time \.) (How-long-lived-there)) (0 :gist)
  1 (0 long 0)
    2 ((You lived there for long time \.) (How-long-lived-there)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how long you lived there for \.) (How-long-lived-there)) (0 :gist)
))


(READRULES '*reaction-to-how-long-lived-there-input*
'(
  1 (0 whole life 0)
    2 (Wow \, that\'s amazing \! It must really be your home \.) (100 :out)
  1 (0 .FEW months 0)
    2 (Oh \, okay \. So you are new in this place \.) (100 :out)
  1 (0 .MANY 0)
    2 (That\'s a long time \. I haven\'t lived anywhere that long \.) (100 :out)
  1 (0 .LOTS 0)
    2 (Wow \! You must really feel at home there \, having lived there for so long \.) (100 :out)
  1 (0 some years 0)
    2 (Oh \, okay \. So you should have been feeling like home after some years \.) (100 :out)
  1 (0 some months 0)
    2 (Oh \, okay \. So you still need time to feel like home there \.) (100 :out)
  1 (0 long time 0)
    2 (0 not long 0)
      3 (Oh \, okay \, I never have been in a place for a long time \. I have moved a lot during my life \.) (100 :out)
    2 (Wow \! You must really feel at home there \, having lived there for so long \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Okay \.) (100 :out)
))