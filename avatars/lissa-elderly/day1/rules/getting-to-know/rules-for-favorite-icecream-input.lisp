;;  (what is your favorite flavor of ice cream ?)
;;	(favorite-icecream)
;; 	from-favorite-icecream-input
;;  (0 ice cream flavor I like 0) (0 I do not have a favorite ice cream flavor 0)
;;  	gist-question: (1 what 2 favorite 2 icecream 1) 
(MAPC 'ATTACHFEAT
'(
  (ICECREAM-TYPES gelato sherbet sorbet custard)
  (ICECREAM-FLAVORS vanilla chocolate chip swirl mint peppermint fudge cookie dough raspberry strawberry coffee scotch cherry maple walnut pecan pistachio tea banana mango coconut rocky road chunky monkey grape melon orange lemon blue moon rainbow cotton candy salted caramel)
  ;Two-word: cookie dough, maple walnut, french vanilla, chocolate chip,
  ;chunky monkey, rocky road, blue moon, cotton candy
  ;Three-word: mint chocolate chip, cookies and cream
))


(READRULES '*favorite-icecream-input*
'(
  ; Reciprocal question
  1 (0 what 2 you 0 ?)
    2 (What is my favorite flavor of ice cream ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What is my favorite flavor of ice cream ?) (0 :gist)
  1 (0 your favorite 0 ?)
    2 (What is my favorite flavor of ice cream ?) (0 :gist)
  1 (0 .DO you 2 eat 0 ?)
    2 (How can I eat ?) (0 :gist)
  1 (0 can you 2 eat 0 ?)
    2 (How can I eat ?) (0 :gist)
  ; Specific answer
  1 (0 .ICECREAM-FLAVORS .ICECREAM-FLAVORS .ICECREAM-FLAVORS .ICECREAM-TYPES 0)
    2 ((The ice cream flavor you like is 2 3 4 5 \.) (Favorite-icecream)) (0 :gist)
  1 (0 cookies and cream .ICECREAM-TYPES 0) ;; cookies and cream is the only specific ice cream flavor I know that's joined by an "and".
    ;; doing "icecream-flavors and icecream-flavors" would mistakenly match when people name two different flavors, e.g. "I like vanilla and strawberry"
    2 ((The ice cream flavor you like is cookies and cream 5 \.) (Favorite-icecream)) (0 :gist)
  1 (0 .ICECREAM-FLAVORS .ICECREAM-FLAVORS .ICECREAM-TYPES 0)
    2 ((The ice cream flavor you like is 2 3 4 \.) (Favorite-icecream)) (0 :gist)
  1 (0 .ICECREAM-FLAVORS .ICECREAM-TYPES 0)
    2 ((The ice cream flavor you like is 2 3 \.) (Favorite-icecream)) (0 :gist)
  1 (0 .ICECREAM-FLAVORS .ICECREAM-FLAVORS .ICECREAM-FLAVORS 0)
    2 ((The ice cream flavor you like is 2 3 4 \.) (Favorite-icecream)) (0 :gist)
  1 (0 cookies and cream 0) ;; See above
    2 ((The ice cream flavor you like is cookies and cream \.) (Favorite-icecream)) (0 :gist)
  1 (0 .ICECREAM-FLAVORS .ICECREAM-FLAVORS 0)
    2 ((The ice cream flavor you like is 2 3 \.) (Favorite-icecream)) (0 :gist)
  1 (0 .ICECREAM-FLAVORS 0)
    2 ((The ice cream flavor you like is 2 \.) (Favorite-icecream)) (0 :gist)
  1 (0 .DO not 2 ice cream 0)
    2 ((You do not have a favorite ice cream flavor \.) (Favorite-icecream)) (0 :gist)
  1 (0 .DO not 2 favorite 0)
    2 ((You do not have a favorite ice cream flavor \.) (Favorite-icecream)) (0 :gist)
  ; Unbidden answer
  1 (0 favorite food 0)
    2 ((The food you like is ice cream \.) (Favorite-food)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for the ice cream flavor you like \.) (Favorite-icecream)) (0 :gist)
))


(READRULES '*reaction-to-favorite-icecream-input*
'(
  1 (0 .ICECREAM-FLAVORS .ICECREAM-FLAVORS .ICECREAM-FLAVORS .ICECREAM-TYPES 0)
    2 (I like 5 \. I will have to try 2 3 4 sometime \.) (100 :out)
  1 (0 cookies and cream .ICECREAM-TYPES 0) ;; See above
    2 (I like 5 \. I will have to try cookies and cream sometime \.) (100 :out)
  1 (0 .ICECREAM-FLAVORS .ICECREAM-FLAVORS .ICECREAM-TYPES 0)
    2 (I like 4 \. I will have to try 2 3 sometime \.) (100 :out)
  1 (0 .ICECREAM-FLAVORS .ICECREAM-TYPES 0)
    2 (I like 3 \. I will have to try 2 3 sometime \.) (100 :out)
  1 (0 .ICECREAM-FLAVORS .ICECREAM-FLAVORS .ICECREAM-FLAVORS 0)
    2 (0 mint chocolate chip 0)
      3 (Oh \, interesting \! I am a huge fan of mint chocolate chip \.) (100 :out)
    2 (0 .ICECREAM-FLAVORS .ICECREAM-FLAVORS .ICECREAM-FLAVORS 0)
      3 (I think 2 3 4 is pretty tasty \. Though I am a big fan of mint chocolate chip \.) (100 :out)
  1 (0 cookies and cream 0) ;; 
    2 (I think cookies and cream is pretty tasty \. Though I am a big fan of mint chocolate chip \.) (100 :out)
  1 (0 .ICECREAM-FLAVORS .ICECREAM-FLAVORS 0)
    2 (I think 2 3 is pretty tasty \. Though I am a big fan of mint chocolate chip \.) (100 :out)
  1 (0 .ICECREAM-FLAVORS 0)
    2 (I think 2 ice cream is pretty tasty \. Though I am a big fan of mint chocolate chip \.) (100 :out)
  1 (0 .NEG 2 favorite ice cream 0)
    2 (I definitely should have ice cream at least once a week \. Even during the cold season \. It is the best thing \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I love ice cream a lot \. There are so many of them to enjoy \.) (100 :out)
))