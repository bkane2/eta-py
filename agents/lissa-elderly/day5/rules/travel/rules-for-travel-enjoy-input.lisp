;; 	What types of travel do you enjoy?
;;	(0 enjoy 2 travel 0)
;;	travel-enjoy
;;	(2 What types of travel 2 enjoy 2)
(MAPC 'ATTACHFEAT
'(
  (SOLO alone)
  (FRIEND FRIENDS)
  (FAMILY grandchildren GRANDCHILD children CHILD DAUGHTER daughters SON sons SPOUSE wife husband siblings brother brothers sister sisters parents MOTHER FATHER grandparents GRANDMOTHER GRANDFATHER cousin cousins uncle aunt)
  (SHORT weekend multiday days)
  (LONG months years)
  (TERM time period)
  (PACKAGE group)
  (BACKPACKING hiking camping camp adventure)
  (EVENT bussiness)
  (SIGHTSEEING tourism relaxing tour)
))


(READRULES '*travel-enjoy-input*
'(
  ; Questions
  1 (0 how 2 you 1 travel ?)
    2 (How can I take a vacation ?) (0 :gist)
  1 (0 how 2 you 1 .HAVE 1 .VACATION 0 ?)
    2 (How can I take a vacation ?) (0 :gist)
  1 (0 how 2 you 1 take 1 .VACATION 0 ?)
    2 (How can I take a vacation ?) (0 :gist)
  1 (0 what 2 travel 2 you 1 .ENJOY 0 ?)
    2 (What types of travel do I enjoy ?) (0 :gist)
  1 (0 how 2 travel 2 you 1 .ENJOY 0 ?)
    2 (What types of travel do I enjoy ?) (0 :gist)
  ; Specific answers
  1 (0 .NEG .SOLO 0)
    2 ((You do not enjoy to travel alone \.) (Travel-enjoy)) (0 :gist)
  1 (0 .SOLO 0)
    2 ((You enjoy travel alone \.) (Travel-enjoy)) (0 :gist)
  1 (0 with .FRIEND 0)
    2 ((You enjoy travel with 3 \.) (Travel-enjoy)) (0 :gist)
  1 (0 visiting .FRIEND 0)
    2 ((You enjoy travel to visit friends \.) (Travel-enjoy)) (0 :gist)
  1 (0 with .FAMILY 0)
    2 ((You enjoy travel with 3 \.) (Travel-enjoy)) (0 :gist)
  1 (0 visiting .FAMILY 0)
    2 ((You enjoy travel to visit family \.) (Travel-enjoy)) (0 :gist)
  1 (0 .SHORT .TERM 0)
    2 ((You enjoy travel in 2 time \.) (Travel-enjoy)) (0 :gist)
  1 (0 .LONG 0)
    2 ((You enjoy travel in 2 time \.) (Travel-enjoy)) (0 :gist)
  1 (0 .PACKAGE 0)
    2 ((You enjoy 2 travel \.) (Travel-enjoy)) (0 :gist)
  1 (0 .BACKPACKING 0)
    2 ((You enjoy 2 travel \.) (Travel-enjoy)) (0 :gist)
  1 (0 .EVENT 0)
    2 ((You enjoy 2 travel \.) (Travel-enjoy)) (0 :gist)
  1 (0 .SIGHTSEEING 0)
    2 ((You enjoy travel for 2 \.) (Travel-enjoy)) (0 :gist)
  1 (0 .NEG .LIKE 2 road trip 0)
    2 ((You do not enjoy road trip travel \.) (Travel-enjoy)) (0 :gist)
  1 (0 road trip 0)
    2 ((You enjoy road trip travel \.) (Travel-enjoy)) (0 :gist)
  1 (0 .NEG 2 .LIKE 2 travel 0)
    2 ((You do not enjoy to travel \.) (Travel-enjoy)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for if you enjoy travel \.) (Travel-enjoy)) (0 :gist)
))


(READRULES '*reaction-to-travel-enjoy-input*
'(
  1 (0 .NEG .LIKE to travel 0)
    2 (Well \, some people do not really enjoy traveling \.) (100 :out)
  1 (0 .NEG 3 travel alone 0)
    2 (I \, personally \, prefer silence but I understand if you like to have people around to travel with \.) (100 :out)
  1 (0 .ENJOY travel .SOLO 0)
    2 (Solo travel is cool \. You don’t need to consult anyone else and can go any place you want \.) (100 :out)
  1 (0 .FRIEND 0)
    2 (Traveling with friends is sweet \.) (100 :out)
  1 (0 visiting .FRIENDS 0)
    2 (It is great to visiting friends \. Also they can help you to have a great time \.) (100 :out)
  1 (0 .FAMILY 0)
    2 (Traveling with 5 is sweet \.) (100 :out)
  1 (0 visiting .FAMILY 0)
    2 (It is great to visiting family \. Also they can help you to have a great time \.) (100 :out)
  1 (0 .SHORT 0)
    2 (It can relax myself to have a trip for several days \.) (100 :out)
  1 (0 .LONG 0)
    2 (Staying in a place for a long term helps you to experience the local culture \.) (100 :out)
  1 (0 .PACKAGE 0)
    2 (You don\'t need to arrange everything in your trip when you travel with others \.) (100 :out)
  1 (0 .BACKPACKING 0)
    2 (It sounds like you love nature \, that\'s pretty cool \.) (100 :out)
  1 (0 .EVENT 0)
    2 (Travelling for a specific target is meaningful \.) (100 :out)
  1 (0 .SIGHTSEEING 0)
    2 (Travelling for 5 is great \. What you need to do is relaxing myself and enjoying a happy time \.) (100 :out)
  1 (0 road trip 0)
    2 (Road trip means much more freedom \. You can decide the time and the desitination by yourself \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (That sounds like a fun way to travel \. I like seeing other cities with friends \.) (100 :out)
))