;;	Tell me about something you do to improve your sleep. 
;;	(0 I improve my sleep 0)
;;	improve-sleep
;;	(What do you do to improve your sleep ?)
;;	(3 What 4 improve your sleep 3)
;; MEETING WITH KIM NOTES (8/8/2017)
;; I don't know
;; Response: "Tell me about something that helps you get to sleep"
;; Nothing helps them
;; Response: "Is there something new you were thinking of trying?"
;; Reading a book
;; Medicine (melatonin)
;; Night cap
;; Drink
;; Not being on the computer
;; Tea
;; Meditation
(MAPC 'ATTACHFEAT
'(
  (ALT-MEDICINE medicine medication medicine pill pills melatonin)
  (ALT-MASK mask cover screen)
  (ALT-FACE face eye)
  (ALT-COMPUTER computer phone)
  (ALT-MEDITATE meditate meditation reflection reflecting prayer praying breathing)
  (ALT-ALCOHOL wine champagne cocktail)
))


(READRULES '*improve-sleep-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (What do I do to improve my sleep ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What do I do to improve my sleep ?) (0 :gist)
  ; Specific answers
  1 (0 read 0)
    2 ((You improve your sleep by reading a book \.) (Improve-sleep)) (0 :gist)
  1 (0 book 0)
    2 ((You improve your sleep by reading a book \.) (Improve-sleep)) (0 :gist)
  1 (0 .ALT-MEDICINE 0)
    2 ((You improve your sleep by using medicine \.) (Improve-sleep)) (0 :gist)
  1 (0 night cap 0)
    2 ((You improve your sleep by using a night cap \.) (Improve-sleep)) (0 :gist)
  1 (0 .ALT-FACE .ALT-MASK 0)
    2 ((You improve your sleep by using an eye mask \.) (Improve-sleep)) (0 :gist)
  1 (0 .NEG 3 .ALT-COMPUTER 0)
    2 ((You improve your sleep by not using the computer \.) (Improve-sleep)) (0 :gist)
  1 (0 tea 0)
    2 ((You improve your sleep by drinking tea \.) (Improve-sleep)) (0 :gist)
  1 (0 .ALT-MEDITATE 0)
    2 ((You improve your sleep by meditating \.) (Improve-sleep)) (0 :gist)
  1 (0 .ALT-ALCOHOL 0)
    2 ((You improve your sleep by having a drink \.) (Improve-sleep)) (0 :gist)
  1 (0 a drink 0)
    2 ((You improve your sleep by having a drink \.) (Improve-sleep)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how you improve your sleep \.) (Improve-sleep)) (0 :gist)
))


(READRULES '*reaction-to-improve-sleep-input*
'(
  1 (0 improve your sleep 2 reading 1 book 0)
    2 (Reading a book before going to bed sounds like a great idea \. You get to learn new things and relax at the same time \.) (100 :out)
  1 (0 improve your sleep 2 using medicine 0)
    2 (Medicine is a good idea if you have bad problems with insomnia \.) (100 :out)
  1 (0 improve your sleep 2 using 1 night cap 0)
    2 (I have never used a night cap \, I have only seen it in pictures \. It seems very comfortable though \.) (100 :out)
  1 (0 improve your sleep 2 using 1 eye mask 0)
    2 (An eye mask can be very helpful if you are sensitive to light \.) (100 :out)
  1 (0 improve your sleep 2 .NEG using 1 computer 0)
    2 (It\'s actually scientifically proven that the light from a computer hurts your ability to sleep \. Not using it before bedtime is a good idea \.) (100 :out)
  1 (0 improve your sleep 2 drinking tea 0)
    2 (Drinking tea is very soothing \, I love how it warms me up inside \.) (100 :out)
  1 (0 improve your sleep 2 meditating 0)
    2 (I think it\'s important to meditate and reflect on my day regardless of whether it helps me sleep or not \.) (100 :out)
  1 (0 improve your sleep 2 having 1 drink 0)
    2 (That\'s an interesting way to relax before bedtime \. Good for you if it works though \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Part of falling asleep well is just gradually putting yourself into a relaxed state of mind \.) (100 :out)
))