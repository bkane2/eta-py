;;  What kinds of exercise do you do these days?
;;	(0 I do not do any exercise 0)
;;	(0 As exercise I 0) 
;;	exercises-you-do
;;	(What kinds of exercise do you do ?)
;;	(3 what 2 exercises 2 you do 3) 
;; MEETING WITH KIM NOTES (8/8/2017)
;; None
;; Response: "What have you done in the past?"
;; Silver Sneakers (exercise program)
;; Exercise programs at senior living center
;; JCC / YMCA
;; Going for walks / runs
;; Treadmill
;; Swimming
;; Don't like exercising in winter / afraid of falling
;; Yoga / chair yoga
;; Weights
(MAPC 'ATTACHFEAT
'(
  (ALT-FACILITY jcc ymca)
  (ALT-WEIGHTS weights weightlifting)
  (COLD cool windy wind)
  (HEALTH-CONDITION heart lung feet foot knee knees)
  (EXCERCISE excercises)
))


(READRULES '*exercises-you-do-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (What kinds of exercise do I do ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What kinds of exercise do I do ?) (0 :gist)
  1 (0 .DO 2 you 2 .DO 0 ?)
    2 (What kinds of exercise do I do ?) (0 :gist)
  ; Specific answer
  1 (0 .NEG 2 exercise 4 winter 0)
    2 ((You do not do any exercise because it is winter \.) (Exercises-you-do)) (0 :gist)
  1 (0 .NEG 2 exercise 4 .COLD 0)
    2 ((You do not do any exercise because it is cold \.) (Exercises-you-do)) (0 :gist)
  1 (0 .NEG 2 exercise 4 time 0)
    2 ((You do not do any exercise because you do not have time \.) (Exercises-you-do)) (0 :gist)
  1 (0 .NEG 2 exercise 4 weak 0)
    2 ((You do not do any exercise because you are too weak to do that \.) (Exercises-you-do)) (0 :gist)
  1 (0 .NEG 2 exercise 4 .NEG 3 gym 0)
    2 ((You do not do any exercise because there is no gym nearby \.) (Exercises-you-do)) (0 :gist)
  1 (0 .NEG 2 exercise 4 doctor 0)
    2 ((You do not do any exercise because your doctor said so \.) (Exercises-you-do)) (0 :gist)
  1 (0 .NEG 6 .HEALTH-CONDITION 0)
    2 ((You do not do any exercise because of your health condition \.) (Exercises-you-do)) (0 :gist)
  1 (0 .NEG 8 .ALT-FALLING 0)
    2 ((You do not do exercise because you are afraid of falling \.) (Exercises-you-do)) (0 :gist)
  1 (0 .NEG 2 exercise 0)
    2 ((You do not do any exercise \.) (Exercises-you-do)) (0 :gist)
  1 (0 yoga 0)
    2 ((As exercise you do yoga \.) (Exercises-you-do)) (0 :gist)
  1 (0 treadmill 0)
    2 ((As exercise you use the treadmill \.) (Exercises-you-do)) (0 :gist)
  1 (0 .ALT-RUNNING 0)
    2 ((As exercise you go for a run \.) (Exercises-you-do)) (0 :gist)
  1 (0 .ALT-WALKING 0)
    2 ((As exercise you go for a walk \.) (Exercises-you-do)) (0 :gist)
  1 (0 .ALT-SWIMMING 0)
    2 ((As exercise you go for a swim \.) (Exercises-you-do)) (0 :gist)
  1 (0 water aerobics 0)
    2 ((As exercise you go for a swim \.) (Exercises-you-do)) (0 :gist)
  1 (0 .ALT-WEIGHTS 0)
    2 ((As exercise you use weight machines \.) (Exercises-you-do)) (0 :gist)
  1 (0 living center 0)
    2 ((As exercise you go to an exercise program at a senior living center \.) (Exercises-you-do)) (0 :gist)
  1 (0 program 0)
    2 ((As exercise you go to a recreation facility \.) (Exercises-you-do)) (0 :gist)
  1 (0 silver sneakers 0)
    2 ((As exercise you go to silver sneakers \.) (Exercises-you-do)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what you do as exercise you \.) (Exercises-you-do)) (0 :gist)
))


(READRULES '*reaction-to-exercises-you-do-input*
'(
  1 (0 .NEG .DO any exercise 0)
    2 (0 winter 0)
      3 (It is more difficult to exercise in the winter \. It cuts out a lot of options \.) (100 :out)
    2 (0 afraid of falling 0)
      3 (Being afraid of falling is understandable \. Safety is important \! Maybe try exercise such as yoga though \.) (100 :out)
    2 (0 .COLD 0)
      3 (It is more difficult to exercise in the winter \. It cuts out a lot of options \.) (100 :out)
    2 (0 not .HAVE time 0)
      3 (I try to do at least some light exercises everyday \. We need it even more considering our age \.) (100 :out)
    2 (0 weak 0)
      3 (I also find it hard to be as active as I was before \.) (100 :out)
    2 (0 no gym nearby 0)
      3 (I know a lot of exercise activities that one can do indoors \.) (100 :out)
    2 (0 doctor said so 0)
      3 (I understand \. You should be more careful about the kind of exercises you do if you have specific health issues \.) (100 :out)
    2 (0 .HEALTH-CONDITION 0)
      3 (I understand \. You should be more careful about the kind of exercises you do if you have specific health issues \.) (100 :out)
    2 (0)
      3 (It is important to spend some time in the day doing exercise \. We need it even more considering our age \.) (100 :out)
  1 (0 .DO yoga 0)
    2 (Yoga seems like a great way to get exercise in your own home \, if you want to \.) (100 :out)
  1 (0 use the treadmill 0)
    2 (It\'s nice to be able to set your own pace on the treadmill \.) (100 :out)
  1 (0 go for a run 0)
    2 (It\'s awesome that you still have the endurance to go running \!) (100 :out)
  1 (0 for a walk 0)
    2 (Going for a walk is great \. Being able to be outside in nice weather helps motivate me to go for walks \.) (100 :out)
  1 (0 go for a swim 0)
    2 (I hate getting wet \! But going for a swim does sound nice \, if you enjoy it \.) (100 :out)
  1 (0 use weight machines 0)
    2 (Still using weights at this point is pretty impressive \. You must be quite strong \.) (100 :out)
  1 (0 go to an exercise program 2 senior living center 0)
    2 (It\'s very nice of the living center to offer exercise programs \!) (100 :out)
  1 (0 go to a recreation facility 0)
    2 (I have been to such places a couple times before \. They offer a lot of great resources \.) (100 :out)
  1 (0 go to silver sneakers 0)
    2 (I have heard of that before but don\'t know much about it \. It sounds nice though \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (There\'s a lot of interesting ways people figure out to get exercise \. It\'s pretty important to staying healthy \!) (100 :out)
))