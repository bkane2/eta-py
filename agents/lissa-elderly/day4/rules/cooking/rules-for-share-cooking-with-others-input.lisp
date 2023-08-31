;;	How have you shared cooking with people in your life? 
;;	(0 I have shared cooking with 0)
;;	share-cooking-with-others
;;		gist-question:	(1 how 2 shared cooking 1 people 3)
(MAPC 'ATTACHFEAT
'(
  (FRIEND friends)
  (FAMILY grandchildren grandchild children CHILD DAUGHTER daughters SON sons SPOUSE wife husband siblings brother brothers sister sisters niece nephew PARENTS MOTHER FATHER grandparents GRANDMOTHER GRANDFATHER)
  (NEIGHBOUR neighbours)
  (COLLEAGUE colleagues coworker coworkers partner partners cofounder cofounders)
  (STRANGER strangers)
  (UNFORGETTABLE amazing enjoyable happy incredible hospitable best good NICE memorable lovely wonderful welcoming)
))


(READRULES '*share-cooking-with-others-input*
'(
  ; Questions
  1 (0 how 2 you shared cooking 0 ?)
    2 (How have I shared cooking with people in my life ?) (0 :gist)
  1 (0 who 2 you shared cooking 0 ?)
    2 (How have I shared cooking with people in my life ?) (0 :gist)
  1 (0 .WH_ 4 shared cooking 0 ?)
    2 (How have I shared cooking with people in my life ?) (0 :gist)
  ; Specific answers
  1 (0 .FAMILY 0) ;; I think the gist clause format doesn't correspond with the question here
    2 ((You have shared cooking with your 2 \.) (Share-cooking-with-others)) (0 :gist)
  1 (0 .FRIEND 0)
    2 ((You have shared cooking with your 2 \.) (Share-cooking-with-others)) (0 :gist)
  1 (0 .NEIGHBOUR 0)
    2 ((You have shared cooking with your 2 \.) (Share-cooking-with-others)) (0 :gist)
  1 (0 .COLLEAGUE 0)
    2 ((You have shared cooking with your 2 \.) (Share-cooking-with-others)) (0 :gist)
  1 (0 .STRANGER 0)
    2 ((You have shared cooking with 2 \.) (Share-cooking-with-others)) (0 :gist)
  1 (0 .NEG 2 .UNFORGETTABLE 0)
    2 ((Your experiences of shared cooking is not 3 4 \.) (Share-cooking-with-others)) (0 :gist)
  1 (0 .UNFORGETTABLE 0)
    2 ((Your experiences of shared cooking is 2 \.) (Share-cooking-with-others)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for whom you have shared cooking with \.) (Share-cooking-with-others)) (0 :gist)
))


(READRULES '*reaction-to-share-cooking-with-others-input*
'(
  1 (0 .NEG 3 .UNFORGETTABLE 0) ; it's risky to cover words describing emotions, but I feel like it's necessary since if they talk about
    ; some bad memories then it is strange to respond something like "I'm glad that you had fun".
    2 (I am sorry to hear that you didn\'t particularly like your meal \.) (100 :out)
  1 (0 .UNFORGETTABLE 0)
    2 (It sounds adorable that you shared an 2 meal \. I have had some wonderful meals with my best friend \. Her name is sarah \.) (100 :out)
  1 (0 .FAMILY 0)
    2 (I used to cook for my family at weekends \. It feels good to spend time with family after work \.) (100 :out)
  1 (0 .FRIEND 0)
    2 (I am glad to hear that you had fun \.) (100 :out)
  1 (0 .NEIGHBOUR 0)
    2 (I remember cooking with my neighbour \. We used to have barbecue together \.) (100 :out)
  1 (0 .COLLEAGUE 0)
    2 (I used to eat with my work friends \. It\'s a great way to enhance relationships \.) (100 :out)
  1 (0 .STRANGER 0)
    2 (Sharing cooking with 2 sounds great \! Talking to people you don\'t know before can always give you a fresh perspective \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I find cooking to be a pretty good way to hang out with people \.) (100 :out)
))