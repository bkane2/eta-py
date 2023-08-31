;;	How is the weather forecast for this evening ?
;;	(0 the weather forecast for this evening is 0)
;;	weather-forecast
;;		gist question: (1 how 3 weather forecast 4)   
(MAPC 'ATTACHFEAT
'(
  (FORECAST-TYPES WEATHER-TYPES beautiful)
  (FAMILY husband wife DAUGHTER SON boy girl CHILD children parent PARENTS)
  (FORECAST-SOURCE NEWS WEB)
  (NEWS paper radio FAMILY tv)
  (WEB online phone app)
  (WATCH vision search)
  (LISTEN hearing)
  (WALK)
  (WAY WATCH LISTEN WALK) ;; different ways to get the forcast
  (BAD worse terrible frustrating frustrate)
  (NICE beautiful great pleasant)
))


(READRULES '*weather-forecast-input*
'(
  ; Questions
  1 (0 what 2 you 0)
    2 (How is the weather forecast for this evening ?) (0 :gist)
  1 (0 how 2 you 0)
    2 (How is the weather forecast for this evening ?) (0 :gist)
  1 (0 you tell me 0)
    2 (How is the weather forecast for this evening ?) (0 :gist)
  ; Specific answers
  1 (0 .NICE 0)
    2 ((The weather forecast for this evening is nice \.) (Weather-forecast)) (0 :gist)
  1 (0 .RAIN 0)
    2 ((The weather forecast for this evening is 2 \.) (Weather-forecast)) (0 :gist)
  1 (0 .WEATHER-EXTREME 0)
    2 ((The weather forecast for this evening is 2 \.) (Weather-forecast)) (0 :gist)
  1 (0 .SNOW 0)
    2 ((The weather forecast for this evening is 2 \.) (Weather-forecast)) (0 :gist)
  1 (0 .SUN 0)
    2 ((The weather forecast for this evening is 2 \.) (Weather-forecast)) (0 :gist)
  1 (0 .WIND 0)
    2 ((The weather forecast for this evening is 2 \.) (Weather-forecast)) (0 :gist)
  1 (0 .NEG 1 know 0)
    2 ((You do not know what the weather forecast for this evening is \.) (Weather-forecast)) (0 :gist)
  1 (0 .NEG 1 .WAY 0)
    2 ((You do not know what the weather forecast for this evening is \.) (Weather-forecast)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what the weather forecast for this evening is \.) (Weather-forecast)) (0 :gist)
))


(READRULES '*reaction-to-weather-forecast-input*
'(
  1 (0 weather forecast 3 is .FORECAST-TYPES 0)
    2 (0 .NICE 0)
      3 (That\'s great \. Going out for walk is a good choice for tonight \.) (100 :out)
    2 (0 .RAIN 0)
      3 (Sounds like it will be wet tonight \. Hopefully you have an umbrella \!) (100 :out)
    2 (0 .WEATHER-EXTREME 0)
      3 (That\'s scary \. Make sure to stay indoors \!) (100 :out)
    2 (0 .SNOW 0)
      3 (It must be very cold outside \. I hope tomorrow will be warmer \.) (100 :out)
    2 (0 .SUN 0)
      3 (That\'s great \. That means I can open the window and enjoy the fresh air at night \.) (100 :out)
    2 (0 .WIND 0)
      3 (A light breeze is comfortable \, but I don\'t like strong wind \. That\'s terrible \.) (100 :out)
  1 (0 .DO not know 0)
    2 (I personally try to make it a habit to check the forecast \. I recommend you do too \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Hopefully the weather this evening will turn out nice \.) (100 :out)
))