;;	Tell me about how you are managing one of your health concerns. 
;;	(0 I manage my health concerns 0)
;;	managing-health-concerns
;;	(how are you managing your health concerns ?)
;;	(3 how 2 you managing 2 health concerns 3)
;; MEETING WITH KIM NOTES (8/8/2017)
;; Totally healthy / I don't have any health problems
;; Response: "Could you give some examples of what you're doing to stay healthy?"
;; Diabetes
;; Arthritis
;; Depression
;; Back pain
;; Heart conditions
;; Breathing problems
;; COPD
;; Exercise 
;; Physical therapy
;; Knee replacements
;; Vision loss
;; Weight loss
;; Sleep
;; Parkinsons
;; Alzheimers
;; It's all too hard / too much
;; I'm not managing anything well
(MAPC 'ATTACHFEAT
'(
  (ALT-COPD copd bronchitis emphysema)
))


(READRULES '*managing-health-concerns-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (How am I managing my health concerns ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (How am I managing my health concerns ?) (0 :gist)
  1 (0 .DO you 4 problems 0 ?)
    2 (How am I managing my health concerns ?) (0 :gist)
  ; Specific answers
  1 (0 diabetes 0)
    2 ((You manage your health concerns by treating your diabetes \.) (Managing-health-concerns)) (0 :gist)
  1 (0 arthritis 0)
    2 ((You manage your health concerns by treating your arthritis \.) (Managing-health-concerns)) (0 :gist)
  1 (0 depression 0)
    2 ((You manage your health concerns by treating your depression \.) (Managing-health-concerns)) (0 :gist)
  1 (0 back pain 0)
    2 ((You manage your health concerns by treating your back pain \.) (Managing-health-concerns)) (0 :gist)
  1 (0 heart conditions 0)
    2 ((You manage your health concerns by treating your heart conditions \.) (Managing-health-concerns)) (0 :gist)
  1 (0 breathing problems 0)
    2 ((You manage your health concerns by treating your breathing problems \.) (Managing-health-concerns)) (0 :gist)
  1 (0 .ALT-COPD 0)
    2 ((You manage your health concerns by treating your breathing problems \.) (Managing-health-concerns)) (0 :gist)
  1 (0 exercise 0)
    2 ((You manage your health concerns by getting exercise \.) (Managing-health-concerns)) (0 :gist)
  1 (0 physical therapy 0)
    2 ((You manage your health concerns by getting physical therapy \.) (Managing-health-concerns)) (0 :gist)
  1 (0 knee replacements 0)
    2 ((You manage your health concerns by getting knee replacements \.) (Managing-health-concerns)) (0 :gist)
  1 (0 vision loss 0)
    2 ((You manage your health concerns by treating your vision loss \.) (Managing-health-concerns)) (0 :gist)
  1 (0 weight loss 0)
    2 ((You manage your health concerns by losing weight \.) (Managing-health-concerns)) (0 :gist)
  1 (0 sleep 0)
    2 ((You manage your health concerns by getting sleep \.) (Managing-health-concerns)) (0 :gist)
  1 (0 parkinsons 0)
    2 ((You manage your health concerns by treating your parkinsons \.) (Managing-health-concerns)) (0 :gist)
  1 (0 alzheimers 0)
    2 ((You manage your health concerns by treating your alzheimers \.) (Managing-health-concerns)) (0 :gist)
  1 (0 it 2 too hard 0)
    2 ((You manage your health concerns badly \.) (Managing-health-concerns)) (0 :gist)
  1 (0 it 2 too .MUCH 0)
    2 ((You manage your health concerns badly \.) (Managing-health-concerns)) (0 :gist)
  1 (0 .NEG managing 0)
    2 ((You manage your health concerns badly \.) (Managing-health-concerns)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how you manage your health concerns \.) (Managing-health-concerns)) (0 :gist)
))


(READRULES '*reaction-to-managing-health-concerns-input*
'(
  1 (0 manage your health concerns 3 diabetes 0)
    2 (Diabetes seems like a major annoyance \. I would hate having to monitor the food I eat \. I hope you can continue to manage it well \.) (100 :out)
  1 (0 manage your health concerns 3 arthritis 0)
    2 (Arthritis sounds painful \. I hope you are successful in keeping it from being a major problem \.) (100 :out)
  1 (0 manage your health concerns 3 depression 0)
    2 (I know some people who struggled with depression \. It can be very hard sometimes \. Just remember that there are always people there for you to talk to if you need it \.) (100 :out)
  1 (0 manage your health concerns 3 back pain 0)
    2 (Back pain sounds awful \. I hope you are successful in keeping it from being a major problem \.) (100 :out)
  1 (0 manage your health concerns 3 heart conditions 0)
    2 (It sounds scary to be having heart conditions \. Hopefully you are getting the help you need with that \, and taking good care of yourself \.) (100 :out)
  1 (0 manage your health concerns 3 breathing problems 0)
    2 (It sounds scary to be having breathing problems \. Hopefully you are getting the help you need with that \, and taking good care of yourself \.) (100 :out)
  1 (0 manage your health concerns 3 exercise 0)
    2 (Getting regular exercise is one of the best ways to avoid common health problems \. It\'s awesome that you are taking care of yourself like that \!) (100 :out)
  1 (0 manage your health concerns 3 physical therapy 0)
    2 (Physical therapy is a great way to get controlled exercise \. It can really help with joint problems \.) (100 :out)
  1 (0 manage your health concerns 3 knee replacements 0)
    2 (Getting a knee replacement sounds like an intensive treatment \. But I am sure it helped a lot \!) (100 :out)
  1 (0 manage your health concerns 3 vision loss 0)
    2 (Vision loss sounds like an awful problem \. Hopefully it doesn\'t get too bad and you can get a nice pair of glasses to help \.) (100 :out)
  1 (0 manage your health concerns 3 losing weight 0)
    2 (Maintaining a healthy weight is super important to health \. Hopefully you can continue to manage your weight well \.) (100 :out)
  1 (0 manage your health concerns 3 getting sleep 0)
    2 (Getting enough sleep is super important to feeling good and healthy \. Hopefully you can continue to manage your sleep well \.) (100 :out)
  1 (0 manage your health concerns 3 parkinsons 0)
    2 (It sounds very sad that you are struggling with parkinson\'s. I hope you are successful in getting treatment for it \.) (100 :out)
  1 (0 manage your health concerns 3 alzheimers 0)
    2 (It sounds very sad that you are struggling with alzheimers\'s. I hope you are successful in getting treatment for it \.) (100 :out)
  1 (0 manage your health concerns badly 0)
    2 (It nearly always helps to talk to a professional about health concerns \. I hope you try to do that \, if you haven\'t already \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I hope you are successful in managing all your health concerns \. Remember that there\'s always people you can talk to if you need them \.) (100 :out)
))