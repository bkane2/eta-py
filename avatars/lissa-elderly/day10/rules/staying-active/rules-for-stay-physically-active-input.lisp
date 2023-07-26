;;	What ways have you found to stay physically active as you get older?
;;	(0 to stay physically active 0)
;;	stay-physically-active
;;	(How would you stay physically active ?)
;;	(3 How 2 stay physically active 3)
;; MEETING WITH KIM NOTES (8/8/2017)
;; All the stuff we said in the exercise one
;; Walking
;; Gardening
;; Golf
;; Walking pet
(MAPC 'ATTACHFEAT
'(
  (ALT-FACILITY jcc ymca)
  (ALT-SWIMMING swimming swim pool)
  (ALT-WALKING walking walk walks hiking hike hikes)
  (ALT-RUNNING running run runs)
  (ALT-PET pet pets PET-DOG)
  (PET-DOG dog dogs puppy puppies pup mutt mutts hound hounds lab labs labrador husky huskies pug pugs beagle beagles poodle poodles bulldog bulldogs terrier terriers chihuahua chihuahuas retriever retrievers)
))


(READRULES '*stay-physically-active-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (How would I stay physically active ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (How would I stay physically active ?) (0 :gist)
  ; Specific answers
  1 (0 .ALT-WALKING .ALT-PET 0)
    2 ((To stay physically active you walk your pet \.) (Stay-physically-active)) (0 :gist)
  1 (0 gardening 0)
    2 ((To stay physically active you do gardening \.) (Stay-physically-active)) (0 :gist)
  1 (0 golf 0)
    2 ((To stay physically active you do golf \.) (Stay-physically-active)) (0 :gist)
  1 (0 yoga 0)
    2 ((To stay physically active you do yoga \.) (Exercises-you-do)) (0 :gist)
  1 (0 treadmill 0)
    2 ((To stay physically active you use the treadmill \.) (Exercises-you-do)) (0 :gist)
  1 (0 .ALT-RUNNING 0)
    2 ((To stay physically active you go for a run \.) (Exercises-you-do)) (0 :gist)
  1 (0 .ALT-WALKING 0)
    2 ((To stay physically active you go for a walk \.) (Exercises-you-do)) (0 :gist)
  1 (0 .ALT-SWIMMING 0)
    2 ((To stay physically active you go for a swim \.) (Exercises-you-do)) (0 :gist)
  1 (0 water aerobics 0)
    2 ((To stay physically active you go for a swim \.) (Exercises-you-do)) (0 :gist)
  1 (0 gym 0)
    2 ((To stay physically active you go to the gym \.) (Exercises-you-do)) (0 :gist)
  1 (0 living center 0)
    2 ((To stay physically active you go to an exercise program at a senior living center \.) (Exercises-you-do)) (0 :gist)
  1 (0 program 0)
    2 ((To stay physically active you go to a recreation facility \.) (Exercises-you-do)) (0 :gist)
  1 (0 silver sneakers 0)
    2 ((To stay physically active you go to silver sneakers \.) (Exercises-you-do)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how to stay physically active \.) (Exercises-you-do)) (0 :gist)
))


(READRULES '*reaction-to-stay-physically-active-input*
'(
  1 (0 walk your pet 0)
    2 (It\'s good to give your pet exercise as well \. I sometimes wish I had a pet I could walk \.) (100 :out)
  1 (0 .DO gardening 0)
    2 (I love to walk through pretty gardens \. It sounds like a fun activity to take care of them \.) (100 :out)
  1 (0 .DO golf 0)
    2 (I am horrible at golf \. I imagine it\'s a fun way to get activity if you are good at it though \.) (100 :out)
  1 (0 .DO yoga 0)
    2 (I do yoga a lot between work \, it\'s a great way to get the blood moving \.) (100 :out)
  1 (0 use the treadmill 0)
    2 (I wanted a treadmill but it was too expensive \. It\'s a good way to stay in shape though \.) (100 :out)
  1 (0 go for a run 0)
    2 (Going for runs at your age is impressive \. It sounds like you are still quite active \!) (100 :out)
  1 (0 go for a walk 0)
    2 (Sometimes when I have been sitting for too long it\'s very refreshing to go for a walk \.) (100 :out)
  1 (0 go for a swim 0)
    2 (Swimming is a great way to stay cool as well \. It\'s too bad I can\'t swim \.) (100 :out)
  1 (0 go to the gym 0)
    2 (It\'s good to get out of the house to get activity \. Going to the gym is a good way to make friends too \.) (100 :out)
  1 (0 exercise program 2 senior living center 0)
    2 (It sounds very convenient to be offered an exercise program right where you live \. I am jealous \!) (100 :out)
  1 (0 recreation facility 0)
    2 (Recreation facilities can offer a lot of fun opportunities for activity \.) (100 :out)
  1 (0 silver sneakers 0)
    2 (I don\'t know much about silver sneakers \, but I will look into it \. It\'s good knowledge to have for the future \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I personally like to find creative new ways to get activity \. It helps me get motivated \.) (100 :out)
))