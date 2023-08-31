;;	How is the weather outside ?
;;	how-is-weather
;; (0 the weather outside is 0)
;;	gist question: (2 how 2 weather 3)
(MAPC 'ATTACHFEAT
'(
  (WEATHER-TYPES RAIN THUNDER STORM SNOW SUN WIND WEATHER-OTHER WEATHER-EXTREME)
  (RAIN rainy raining drizzling sprinkling pouring wetness)
  (THUNDER thunderstorm lightning)
  (STORM stormy stormy hurricanes typhoon typhoons sandstorm tornado)
  (SNOW snowy snowing snowstorm cold freezing blizzard hail hailing sleet ice icy)
  (SUN sunny warm hot pleasant sunshine clear)
  (WIND windy breeze breezy gusty)
  (WEATHER-OTHER fog FOGGY humid cloudy drought dry mist)
  (WEATHER-EXTREME THUNDER STORM)
  (HAVE take bring)
))


(READRULES '*how-is-weather-input*
'(
  ; Questions
  1 (0 how 2 you 1 .HAVE 1 umbrella ?)
    ;;new question
    2 (How can I have an umbrella ?) (0 :gist)
  1 (0 what 2 you 0 ?)
    2 (How is the weather outside ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (How is the weather outside ?) (0 :gist)
  1 (0 ? 0)
    2 (How is the weather outside ?) (0 :gist)
  ; "If subject gives a descriptive answer" "If subject says only a few words" ?
  ; should I try to detect specific words, i.e. if it's raining out LISSA responds
  ; "good thing I brought an umbrella" ?
  ; Specific answer
  1 (0 .RAIN 0)
    2 ((The weather outside is 2 \.) (How-is-weather)) (0 :gist)
  1 (0 .WEATHER-EXTREME 0)
    2 ((The weather outside is 2 \.) (How-is-weather)) (0 :gist)
  1 (0 .SNOW 0)
    2 ((The weather outside is 2 \.) (How-is-weather)) (0 :gist)
  1 (0 .SUN 0)
    2 ((The weather outside is 2 \.) (How-is-weather)) (0 :gist)
  1 (0 .WIND 0)
    2 ((The weather outside is 2 \.) (How-is-weather)) (0 :gist)
  1 (0 .WEATHER-OTHER 0)
    2 ((The weather outside is 2 \.) (How-is-weather)) (0 :gist)
  1 (0 no 1 idea 0)
    2 ((You do not know what the weather outside is \.) (How-is-weather)) (0 :gist)
  1 (0 not 1 really 0)
    2 ((You do not know what the weather outside is \.) (How-is-weather)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how the weather outside is \.) (How-is-weather)) (0 :gist)
))


(READRULES '*reaction-to-how-is-weather-input*
'(
  1 (0 weather outside is .WEATHER-TYPES 0)
    2 (0 .RAIN 0)
      3 (Oh \, here you should always have your umbrella with you \.) (100 :out)
    2 (0 .WEATHER-EXTREME 0)
      3 (Sounds terrible \. I hope this bad weather will be gone very soon \.) (100 :out)
    2 (0 .SNOW 0)
      3 (So it must be very cold outside \. Just stay inside and try to stay warm \.) (100 :out)
    2 (0 .SUN 0)
      3 (Great \, that means we can spend more time enjoying the weather \. It\'s good to spend time outside on such a lovely day \.) (100 :out)
    2 (0 .WIND 0)
      3 (Sometimes wind is fine \, but I don\'t like strong wind because it scares me \.) (100 :out)
    2 (0 .WEATHER-OTHER 0)
      3 (I think 2 is acceptable for me \. I don\'t need to worry the weather affecting my work \.) (100 :out)
  1 (0 .NEG know 2 weather outside 0)
    2 (It\'s good to pay attention to the weather outside so you are not caught off guard \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (It\'s good to pay attention to the weather outside so you are not caught off guard \.) (100 :out)
))