;;	I have many memories of the home I grew up in. Could you tell me about a positive memory you have of one of your homes?
;;	(0 memory I have of one of my homes 0)
;;	memory-from-home
;;	(What is a memory you have of one of your homes ?)
;;	(3 What 2 memory 6 your homes 3)
;; MEETING WITH KIM NOTES (8/8/2017)
;; They don’t have any memories
;; Everything in the past was awful
;; Don’t have positive memories
;; Maybe detect a couple common things, but other than that responses might
;; be pretty open ended, so just make a general "oh, that's nice" type comment
(MAPC 'ATTACHFEAT
'(
  (ALT-PET pet pets cat cats dog dogs fish bird birds)
))


(READRULES '*memory-from-home-input*
; NOTE: New Gist Clause: "I do not have memory of any of my homes"
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (What is a memory I have of one of my homes ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What is a memory I have of one of my homes ?) (0 :gist)
  1 (0 .DO 2 you 0 ?)
    2 (What is a memory I have of one of my homes ?) (0 :gist)
  1 (0 is there 2 positive memory 1 you 0 ?)
    2 (What is a memory I have of one of my homes ?) (0 :gist)
  ; Specific answers
  1 (0 .ALT-FAMILY 0)
    2 ((A memory you have of one of your homes is being with family \.) (Memory-from-home)) (0 :gist)
  1 (0 .ALT-SITTING 2 kitchen table 0)
    2 ((A memory you have of one of your homes is sitting around the kitchen table \.) (Memory-from-home)) (0 :gist)
  1 (0 porch 0)
    2 ((A memory you have of one of your homes is sitting on the porch \.) (Memory-from-home)) (0 :gist)
  1 (0 .ALT-FIREPLACE 0)
    2 ((A memory you have of one of your homes is sitting by the fireplace \.) (Memory-from-home)) (0 :gist)
  1 (0 .ALT-PET 0)
    2 ((A memory you have of one of your homes is being with pets \.) (Memory-from-home)) (0 :gist)
  1 (0 .NEG 1 .HAVE any memories 0)
    2 ((You do not have memory of any of your homes \.) (Memory-from-home)) (0 :gist)
  1 (0 .NEG 1 .REMEMBER 2 anything 0)
    2 ((You do not have memory of any of your homes \.) (Memory-from-home)) (0 :gist)
  1 (0 everything 3 was .BADQUALITY 0)
    2 ((The memory you have of one of your homes is it was bad \.) (Memory-from-home)) (0 :gist)
  1 (0 it 3 was .BADQUALITY 0)
    2 ((The memory you have of one of your homes is it was bad \.) (Memory-from-home)) (0 :gist)
  1 (0 .NEG 3 positive memories 0)
    2 ((The memory you have of one of your homes is it was bad \.) (Memory-from-home)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for memory you have of one of your homes \.) (Memory-from-home)) (0 :gist)
))


(READRULES '*reaction-to-memory-from-home-input*
'(
  1 (0 memory you .HAVE of .ONE of your homes 2 being with .FAMILY 0)
    2 (The time you spend with family can leave the most permanent memories \.) (100 :out)
  1 (0 memory you .HAVE of .ONE of your homes 2 sitting around the kitchen table 0)
    2 (Sitting around the kitchen table sounds like a very warm memory \.) (100 :out)
  1 (0 memory you .HAVE of .ONE of your homes 2 sitting on the porch 0)
    2 (I\'m sure the time you spent on the porch was very relaxing \.) (100 :out)
  1 (0 memory you .HAVE of .ONE of your homes 2 sitting by the fireplace 0)
    2 (Sitting by the fireplace sounds like a very comfortable memory \. I hope I can get a house with a fireplace one day \.) (100 :out)
  1 (0 memory you .HAVE of .ONE of your homes 2 being with pets 0)
    2 (I\'m sure your pets were very cute \.) (100 :out)
  1 (0 memory you .HAVE of .ONE of your homes 2 was bad 0)
    2 (Sometimes past homes can bring back bad memories \. Best to just not think of it \.) (100 :out)
  1 (0 .NEG .HAVE memory of any 2 homes 0)
    2 (Sometimes it\'s easy to forget what happened in the past \. It\'s a good thing to not dwell too much in the past though \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Thank you for telling me about your memories \.) (100 :out)
))