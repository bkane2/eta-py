; This is a small trial pattern base for reacting to the user's
; answer concerning what s/he likes about Rochester.
; We also provide features, supplementing the generic ones in
; "general-word-data.lisp", relevant to the topic here.
(MAPC 'ATTACHFEAT
'(
  (NATURE PARK parks green tree trees hiking hike trail trails)
  (SOCIAL-ENVIRONMENT people community university)
  (WEATHER cold snow snows snowy winter)
  (URBAN-LIFE streets)
  (MUCH MANY)
  (CULTURE art MUSEUM music)
  (NICE good great NICE-FOOD)
  (NICE-FOOD delicious tasty)
  (CUISINE FOOD RESTAURANT eating)
  (RESTAURANT restaurants diner diners)
  (FOOD foods GARBAGE)
))
;; N.B.: FOR THE DECLARATIVE GIST CLAUSES OBTAINED FROM THE USER'S 
;;       RESPONSE TO A LISSA QUESTION, EACH OUTPUT FROM THE CORRESPONDING 
;;       CHOICE PACKETS (DIRECTLY BELOW) MUST BE OF FORM 
;;          (WORD-DIGIT-LIST KEY-LIST), E.G.,
;;          ((My favorite class was 2 3 \.) (favorite-class))
;;       BY CONTRAST, QUESTIONS OBTAINED FROM THE USER RESPONSES,
;;       AND LISSA REACTIONS TO USER RESPONSES, CURRENTLY CONSIST
;;       JUST OF A WORD-DIGIT LIST, WITHOUT A KEY LIST.
(READRULES '*like-about-rochester-input*
'(
  ; Reciprocal questions
  1 (0 what 0 you 0 ?)
    2 (What do I like about rochester ?) (0 :gist)
  1 (0 how 0 you 0 ?)
    2 (What do I like about rochester ?) (0 :gist)
  1 (0 what 0 you .LIKE 0 ?)
    2 (What do I like about rochester ?) (0 :gist)
  ; Specific answers
  1 (0 .LIKE 3 .WEATHER 0)
    2 ((You like the weather in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .WEATHER 2 .NICE 0)
    2 ((You like the weather in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .WEATHER 0)
    2 ((You like the weather in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 not 5 .MUCH 0)
    2 ((No opinion about what you like in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .MUCH 3 city 0)
    2 ((No opinion about what you like in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 not 1 around 0)
    2 ((No opinion about what you like in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .LIKE 3 .CUISINE 0) ;;;;;;;;;;;;;;;
    2 ((You like eating in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .CUISINE 3 .NICE 0)
    2 (0 .RESTAURANT 0)
      3 ((You like some restaurants in rochester \.) (Like-rochester)) (0 :gist)
    2 (0 .FOOD 0)
      3 ((You like some foods in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .NICE 3 .CUISINE 0)
    2 (0 .RESTAURANT 0)
      3 ((You like some restaurants in rochester \.) (Like-rochester)) (0 :gist)
    2 (0 .FOOD 0)
      3 ((You like some foods in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .SOCIAL-ENVIRONMENT 0)
    2 ((You like 2 in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .CULTURE 0)
    2 ((You like 2 in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .URBAN-LIFE 0)
    2 ((You like 2 in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 festivals 0)
    2 ((You like festivals in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .NATURE 0)
    2 ((You like the nature in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .NEG 2 traffic 0)
    2 ((You like that there is no traffic in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .NEG 2 traffic 0)
    2 ((You like that there is no traffic in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 amenities 0)
    2 ((You like that there are all amenities in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 .LIKE everything 0)
    2 ((You like everything in rochester \.) (Like-rochester)) (0 :gist)
  1 (0 everything 2 .NICE 0)
    2 ((You like everything in rochester \.) (Like-rochester)) (0 :gist)
  ; Unbidden answers
  1 (0 not .LIKE 3 .WEATHER)
    2 ((You do not like the weather in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 .WEATHER 2 not .NICE 0)
    2 ((You do not like the weather in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what you like in rochester \.) (Like-rochester)) (0 :gist)
))


(READRULES '*reaction-to-like-about-rochester-input*
'(
  1 (0 you .LIKE 0 \.)
    2 (0 .WEATHER 0)
      3 (Really \? I wish it would be warmer in the winter \.) (100 :out)
    2 (0 .CUISINE 0)
      3 (So you should be a fan of eating \.) (100 :out) ; Aren't we all!
    2 (0 .CULTURE 0)
      3 (So you care about culture \, rochester is good for that \.) (100 :out)
    2 (0 .SOCIAL-ENVIRONMENT 0)
      3 (I also like the social environment \.) (100 :out)
    2 (0 .URBAN-LIFE 0)
      3 (I also like the city and streets \.) (100 :out)
    2 (0 festivals 0)
      3 (I love festivals too \. They are so fun \.) (100 :out)
    2 (0 .NATURE 0)
      3 (I also like that every place is so green during summer and colorful during winter \. It is just so beatiful \.) (100 :out)
  1 (0 no traffic 0)
    2 (Having not much traffic in rochester is just great \. I lived in new york city for a few months and the traffic made me nuts \!) (100 :out)
  1 (0 all amenities 0)
    2 (I agree that rochester is a nice city to live \. You can find whatever amenity you would want for life \.) (100 :out)
  1 (0 .LIKE everything 0)
    2 (I agree that rochester is a nice city to live \. You can find whatever amenity you would want for life \.) (100 :out)
  1 (0 no opinion 0)
    2 (I am sure you would find many interesting things here if you go around \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I see \!) (100 :out)
)) ; end of *reaction-to-like-about-rochester-input*