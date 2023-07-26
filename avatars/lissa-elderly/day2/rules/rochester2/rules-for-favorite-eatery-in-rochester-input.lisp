(MAPC 'ATTACHFEAT
'(
  (ROCHESTER-RESTAURANT-T tahou tahou\'s tahoe tahoe\'s plate BARBECUE bbq luck rosita\'s town star)
  (RESTAURANT-TYPE RESTAURANT-TYPE-ONE RESTAURANT-TYPE-TWO)
  (RESTAURANT-TYPE-ONE asian chinese mexican japanese italian korean peruvian thai ethiopian indian mediterranean greek cambodian german polish spanish belgian)
  (RESTAURANT-TYPE-TWO burger pizza grill grills)
  (RESTAURANT-TYPE-THREE diner cafe)
))


(READRULES '*favorite-eatery-input*
'(
  ; Reciprocal questions
  1 (0 .WH_ 1 you 0 ?)
    2 (What is my favorite eatery in rochester ?) (0 :gist)
  1 (0 you heard 0 ?)
    2 (Have I heard of that restaurant ?) (0 :gist)
  1 (0 you been 0 ?)
    2 (Have I been to that restaurant ?) (0 :gist)
  ; Specific answers
  1 (0 .ROCHESTER-RESTAURANT .ROCHESTER-RESTAURANT-T 0)
    2 (0 dinosaur .BARBECUE 0)
      3 ((Your favorite place to eat is dinosaur barbecue \.) (Rochester-eateries dinosaur)) (0 :gist)
    2 ((Your favorite place to eat is 2 3 \.) (Rochester-eateries)) (0 :gist)
  1 (0 .ROCHESTER-RESTAURANT 0)
    2 (0 dinosaur 0)
      3 ((Your favorite place to eat is dinosaur barbecue \.) (Rochester-eateries dinosaur)) (0 :gist)
    2 ((Your favorite place to eat is 2 \.) (Rochester-eateries)) (0 :gist)
  1 (0 .RESTAURANT-TYPE 0)
    2 ((Your favorite place to eat is an 2 restaurant \.) (Rochester-eateries)) (0 :gist)
  ; Unbidden answers
  ;; 1 (0 dinosaur 0)
  ;;    2 ((You have been to dinosaur barbecue \.) (Dinosaur)) (0 :gist)
  ;; 1 (0 garbage plate 0)
  ;;    2 ((You have had a garbage plate \.) (Garbage-plate)) (0 :gist)
  ;; 1 (0 Nick Tahou\'s 0)
  ;;    2 ((You have had a garbage plate \.) (Garbage-plate)) (0 :gist)
  ;; 1 (0 Steve T\'s 0)
  ;;    2 ((You have had a garbage plate \.) (Garbage-plate)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for where your favorite place to eat is \.) (Rochester-eateries)) (0 :gist)
))


(READRULES '*reaction-to-favorite-eatery-input*
'(
  1 (0 .ROCHESTER-RESTAURANT 0)
    2 (I have not been there \, but it sounds nice \.) (100 :out)
  1 (0 .RESTAURANT-TYPE 0)
    2 (0 .RESTAURANT-TYPE-ONE 0) ;; international
      3 (That\'s great \. I love 2 food \.) (100 :out)
    2 (0 .RESTAURANT-TYPE-TWO 0) ;; grill pizza etc
      3 (0 grill 0)
        4 (I am actually a fan of grills \.) (100 :out)
      3 (I am actually a fan of 2 \.) (100 :out)
    2 (0 .RESTAURANT-TYPE-THREE 0) ;; 
      3 (I like that kind of food too \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I love to experience new places and new tastes \.) (100 :out)
))