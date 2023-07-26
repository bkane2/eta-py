;;  How well do you sleep at night? Has this changed as you’ve gotten older?
;;	(0 I do not sleep well at night 0) 
;;	(0 I sleep well at night 0)
;;	(0 My sleep quality has gotten 3 as I have gotten older 0)
;;	sleep-quality
;;	(How do you sleep at night ?)
;;	(3 how 2 sleep 2 night 3) 
;; MEETING WITH KIM NOTES (8/8/2017)
;; Notice they need less sleep
;; Sleep getting worse
;; Poor sleep
;; Need to use the bathroom
;; In pain
;; Insomnia / trouble sleeping
;; Trouble falling / staying asleep
;; Waking early
;; Response types:
;; Not getting enough sleep is tough, isn't it?
(MAPC 'ATTACHFEAT
'(
  (ALT-LESS less worse worsening poor TROUBLE)
  (ALT-SLEEP sleep sleeping asleep)
  (ALT-NEED need HAVE)
  (ALT-BATHROOM bathroom toilet pee)
  (ALT-PAIN pain painful hurt hurts hurting)
  (ALT-WELL well good great)
  (ALT-DEEPSLEEP rock stone log) ;; I sleep like a rock
))


(READRULES '*sleep-quality-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (How do I sleep at night ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (How do I sleep at night ?) (0 :gist)
  ; Specific answers
  1 (0 .ALT-NEED 4 .ALT-BATHROOM 0)
    2 ((You do not sleep well at night because you need to use the bathroom \.) (Sleep-quality)) (0 :gist)
  1 (0 .ALT-PAIN 0)
    2 ((You do not sleep well at night because you are in pain \.) (Sleep-quality)) (0 :gist)
  1 (0 insomnia 0)
    2 ((You do not sleep well at night because you have insomnia \.) (Sleep-quality)) (0 :gist)
  1 (0 waking 2 early 0)
    2 ((You do not sleep well at night because you wake up too early \.) (Sleep-quality)) (0 :gist)
  1 (0 .NEG 2 .ALT-SLEEP 1 .ALT-WELL 0)
    2 ((You do not sleep well at night \.) (Sleep-quality)) (0 :gist)
  1 (0 .ALT-LESS 2 .ALT-SLEEP 0)
    2 ((You do not sleep well at night \.) (Sleep-quality)) (0 :gist)
  1 (0 .ALT-SLEEP 2 .ALT-LESS 0)
    2 ((You do not sleep well at night \.) (Sleep-quality)) (0 :gist)
  1 (0 .ALT-SLEEP 2 .ALT-WELL 0)
    2 ((You sleep well at night \.) (Sleep-quality)) (0 :gist)
  1 (0 .LIKE 1 .ALT-DEEPSLEEP 0)
    2 ((You sleep well at night \.) (Sleep-quality)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for if your sleep quality has gotten better or worse as you have gotten older \.) (Sleep-quality)) (0 :gist)
))


(READRULES '*reaction-to-sleep-quality-input*
'(
  1 (0 .NEG sleep well at night 2 need 3 bathroom 0)
    2 (It sounds very annoying to have to use the bathroom in the middle of the night \.) (100 :out)
  1 (0 .NEG sleep well at night 2 am in pain 0)
    2 (Being in pain while trying to sleep sounds awful \. Perhaps a doctor may be able to help you feel better \.) (100 :out)
  1 (0 .NEG sleep well at night 2 .HAVE insomnia 0)
    2 (Having insomnia must be tough to deal with \. You should try sleeping medication \, if you haven\'t yet \.) (100 :out)
  1 (0 .NEG sleep well at night 2 wake up too early 0)
    2 (Waking up earlier than you planned to is quite annoying \. Maybe try going to bed a bit earlier as well \.) (100 :out)
  1 (0 .NEG sleep well at night 0)
    2 (Not getting enough sleep sounds tough \. I hate the feeling of being tired \.) (100 :out)
  1 (0 sleep well at night 0)
    2 (It\'s awesome that I am able to sleep comfortably at night \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I wish you luck in getting enough sleep in the future \.) (100 :out)
))