;;	Do you like to exercise outdoors or in a gym? 
;;	(0 I like to exercise outdoors 0) ;; one can extend the gist clause by adding some reason and make the appropriate reaction
;;	(0 I like to exercise in gym 0)
;;	exercise-outdoors-vs-gym
;;	(Do you like to exercise outdoors or in a gym ?)
;;	(3 Do you 2 exercise outdoors or 2 gym 3)
;; MEETING WITH KIM NOTES (8/8/2017)
;; Weather outside / winter
;; JCC / YMCA
;; Swimming / water aerobics
;; Treadmill
;; Walking
;; Don't like exercising in winter / afraid of falling
(MAPC 'ATTACHFEAT
'(
  (ALT-FALLING falling trip tripping slip slipping)
  (ALT-WEATHER-HOT hot heat humid sunny sun warm warmth muggy)
  (ALT-WEATHER-COLD COLD chilly freezing cool icy ice snowy snow frigid)
  (ALT-OUTDOORS outdoors outdoor outside nature)
  (ALT-GYM gym indoor indoors)
  (ALT-LIKE LIKE ENJOY typically usually prefer)
  (ALT-SWIMMING swimming swim pool)
  (ALT-WALKING walking walk walks hiking hike hikes)
  (ALT-RUNNING running run runs)
  (ALT-WALK-RUN ALT-WALKING ALT-RUNNING)
))


(READRULES '*exercise-outdoors-vs-gym-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (Do I like to exercise outdoors or in a gym ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (Do I like to exercise outdoors or in a gym ?) (0 :gist)
  ; Specific answers
  1 (0 .ALT-GYM 5 .ALT-FALLING 0)
    2 ((You like to exercise in the gym because you are afraid of slipping outside \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-GYM 5 .ALT-WEATHER-COLD 0)
    2 ((You like to exercise in the gym because it is cold outside \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-GYM 5 .ALT-WEATHER-HOT 0)
    2 ((You like to exercise in the gym because it is hot outside \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-OUTDOORS 5 .ALT-WEATHER-COLD 0)
    2 ((You like to exercise outdoors because it is cool outside \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-OUTDOORS 5 .ALT-WEATHER-HOT 0)
    2 ((You like to exercise outdoors because it is warm outside \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-SWIMMING 0)
    2 ((You like to exercise in the gym because you use the swimming pool \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 water aerobics 0)
    2 ((You like to exercise in the gym because you use the swimming pool \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 treadmill 0)
    2 ((You like to exercise in the gym because you use the treadmill \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-WALK-RUN 2 .ALT-OUTDOORS 0)
    2 ((You like to exercise outdoors because you go for outdoor walks \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-OUTDOORS 4 .ALT-WALK-RUN 0)
    2 ((You like to exercise outdoors because you go for outdoor walks \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-WALK-RUN 2 .ALT-GYM 0)
    2 ((You like to exercise in the gym because you go for indoor walks \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-GYM 4 .ALT-WALK-RUN 0)
    2 ((You like to exercise in the gym because you go for indoor walks \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-LIKE 4 .ALT-GYM 0)
    2 ((You like to exercise in the gym \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0 .ALT-LIKE 4 .ALT-OUTDOORS 0)
    2 ((You like to exercise outdoors \.) (Exercise-outdoors-vs-gym)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for if you like to exercise outdoors \.) (Exercise-outdoors-vs-gym)) (0 :gist)
))


(READRULES '*reaction-to-exercise-outdoors-vs-gym-input*
'(
  1 (0 .LIKE to exercise 2 gym 3 afraid of slipping outside 0)
    2 (It seems much safer to exercise inside \. Less likely to slip and fall \.) (100 :out)
  1 (0 .LIKE to exercise 2 gym 3 .COLD outside 0)
    2 (I personally hate exercising when it\'s cold outside \, it makes me get a bad cough \.) (100 :out)
  1 (0 .LIKE to exercise 2 gym 3 hot outside 0)
    2 (Exercising when it\'s too hot and humid out can make you feel like you are suffocating \.) (100 :out)
  1 (0 .LIKE to exercise 2 outdoors 3 cool outside 0)
    2 (I don\'t like exercising when it\'s cold out \, but it is nice to not worry about being overheated \.) (100 :out)
  1 (0 .LIKE to exercise 2 outdoors 3 warm outside 0)
    2 (Exercising when it\'s warm and sunny outside can be very pleasant \.) (100 :out)
  1 (0 .LIKE to exercise 2 gym 4 swimming pool 0)
    2 (Swimming indoors is convenient \, though going in an outdoor pool is nice once in a while \.) (100 :out)
  1 (0 .LIKE to exercise 2 gym 4 treadmill 0)
    2 (Using the treadmill is a good way to exercise your legs no matter the weather outside \.) (100 :out)
  1 (0 .LIKE to exercise 2 outdoors 4 outdoor walks 0)
    2 (I love going for walks outside \, it\'s very pleasant \.) (100 :out)
  1 (0 .LIKE to exercise 2 gym 4 indoor walks 0)
    2 (Going for a walk indoors \, like on an indoor track \, is very convenient if there\'s bad weather outside \.) (100 :out)
  1 (0 .LIKE to exercise 2 gym 0)
    2 (Going to the gym is very convenient \, it\'s nice to have everything you need to exercise available in one place \.) (100 :out)
  1 (0 .LIKE to exercise 2 outdoors 0)
    2 (Going outside to exercise is nice \, it feels very refreshing to exercise and enjoy nature at the same time \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I like to exercise outside whenever I can \, though the weather is often bad in rochester so I end up exercising in the gym most of the time \.) (100 :out)
))