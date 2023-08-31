;; What do you like to do to wind down before bed? 
;; gist:What do you do to wind down before bed? 
;; (0 I 4 to wind down before bed 0) 
;; wind-down-before-bed
;; (2 What 2 do 3 wind down before bed 2)
(MAPC 'ATTACHFEAT
'(
  (READ reading)
  (MEDITATE meditating meditation)
  (GRATITUDE grateful)
  (SHOWER)
  (REFLECT reflecting reflection)
  (STRETCH stretching)
  (FAMILY grandchildren GRANDCHILD children CHILD DAUGHTER daughters SON sons SPOUSE wife husband siblings brother brothers sister sisters parents MOTHER FATHER grandparents GRANDMOTHER GRANDFATHER)
  (CHATTING talking CHAT talk)
  (WRITE diary diaries)
  (PLAN planning)
  (SLEEP bed)
))


(READRULES '*wind-down-before-bed-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (What do I like to do to wind down before bed ?) (0 :gist)
  1 (0 how 2 you 2 .SLEEP 0 ?) ;; e.g. how can you go to bed
    2 (How can I sleep ?) (0 :gist)
  1 (0 .WH_ 4 .WIND down 2 bed 0 ?)
    2 (What do I like to do to wind down before bed ?) (0 :gist)
  ; Specific answers
  1 (0 .READ 0)
    2 ((You like to 2 to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
  1 (0 .MEDITATE 0)
    2 ((You like to 2 to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
  1 (0 .SHOWER 0)
    2 ((You like to 2 to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
  1 (0 .REFLECT 0)
    2 ((You like to 2 to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
  1 (0 .STRETCH 0)
    2 ((You like to 2 to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
  1 (0 .FAMILY 0) ;; e.g. I like to talk to family to wind down before bed (but don't have enough space for that)
    2 ((You like to 2 to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
  1 (0 .CHAT 0)
    2 ((You like to 2 to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
  1 (0 .PLAN 0)
    2 ((You like to 2 to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
  1 (0 .WRITE diary 0)
    2 ((You like to 2 3 to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
  1 (0 .GRATITUDE 0)
    2 ((You like to practice gratitude to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what you like to do to wind down before bed \.) (Wind-down-before-bed)) (0 :gist)
))


(READRULES '*reaction-to-wind-down-before-bed-input*
'(
  1 (0 .READ 0)
    2 (Reading is a wonderful habit \. I personally love reading a light novel in bed \.) (100 :out)
  1 (0 .MEDITATE 0)
    2 (Nice to hear that you practice mediation \. Iditating can really calm you down and improve your sleep quality \.) (100 :out)
  1 (0 .SHOWER 0)
    2 (Showering can relax you quickly \, especially after a busy day \.) (100 :out)
  1 (0 .REFLECT 0)
    2 (Not many people reflect their day before sleep \. That is a helpful little habbit to have \.) (100 :out)
  1 (0 .STRETCH 0)
    2 (Stretching will definitely prepare your body for a good sleep \.) (100 :out)
  1 (0 .FAMILY 0)
    2 (Spending time with family before bed warms your heart \. I might want to do that sometimes too \.) (100 :out)
  1 (0 .CHAT 0)
    2 (I remember talking to my best friend until late night \. Not my best activty to do to wind down \, but sounds a wonderful thing to do \.) (100 :out)
  1 (0 .PLAN 0)
    2 (It is great to plan beforehand so that you don\'t have to worry about it the next day \.) (100 :out)
  1 (0 .WRITE diary 0)
    2 (It is nice to keep records of events that have happened to you \.) (100 :out)
  1 (0 .GRATITUDE 0)
    2 (Practicing gratitude sounds lovely \. We should always be grateful to people who have been good to us \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (It\'s important to have a way to relax before sleeping \.) (100 :out)
))