;; 	What do you have planned for when you are done with our conversation?
;;  gist: What is your plan after this session?
;;  (0 my plan after this session 0)
;;  plan-after-this-session
;;  (2 What 2 plan after this session 2)
;; MEETING WITH KIM NOTES (8/4/2017)
;; Question prompt: "We mean things you do to relax, to help you go to sleep. For example, some people have a cup of tea. Do you do anything like that?"
;; Meditate
;; Pray
;; Breathing excersizes
;; Read
;; Watch TV
;; Knit
;; Spend time / snuggle with pets
;; Might have a drink (cocktail, wine)
;; Take medicine / melatonin
(MAPC 'ATTACHFEAT
'(
  (DINNER lunch)
  (EXERCISE WALK walking RUN running jog jogging)
  (SHOPPING mall plaza market supermarket)
  (WATCH watching TV READ reading book newspapar LISTEN listening radio)
  (COOK cooking)
  (CHAT CHATTING)
  (FRIENDS FRIEND)
  (REST SLEEP sleeping relax relaxing)
))


(READRULES '*plan-after-this-session-input*
'(
  ; Questions
  1 (0 how 2 your .PLAN 0 ?)
    2 (What is my plan after this session ?) (0 :gist)
  1 (0 .WH_ 4 .PLAN 0 ?)
    2 (What is my plan after this session ?) (0 :gist)
  ; Specific answers
  1 (0 .DINNER 0)
    2 ((Your plan after this session is have 2 \.) (Plan-after-this-session)) (0 :gist)
  1 (0 .EXERCISE 0)
    2 ((Your plan after this session is have 2 \.) (Plan-after-this-session)) (0 :gist)
  1 (0 .SHOPPING 0)
    2 ((Your plan after this session is 2 \.) (Plan-after-this-session)) (0 :gist)
  1 (0 .WATCH .WATCH 0)
    2 ((Your plan after this session is 2 3 \.) (Plan-after-this-session)) (0 :gist)
  1 (0 .COOK 0)
    2 ((Your plan after this session is 2 \.) (Plan-after-this-session)) (0 :gist)
  1 (0 .CHAT 0)
    2 ((Your plan after this session is 2 \.) (Plan-after-this-session)) (0 :gist)
  1 (0 .REST 0)
    2 ((Your plan after this session is 2 \.) (Plan-after-this-session)) (0 :gist)
  1 (0 .READ 0)
    2 ((Your plan after this session is to read something \.) (Plan-after-this-session)) (0 :gist)
  1 (0 .FRIENDS 0)
    2 ((Your plan after this session is to hang out with friends \.) (Plan-after-this-session)) (0 :gist)
  1 (0 library 0)
    2 ((Your plan after this session is to go to the library \.) (Plan-after-this-session)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what your plan after this session is \.) (Plan-after-this-session)) (0 :gist)
))


(READRULES '*reaction-to-plan-after-this-session-input*
'(
  1 (0 .DINNER 0)
    2 (Great \! I hope you enjoy the delicious food \.) (100 :out)
  1 (0 .EXERCISE 0)
    2 (I hope you get good exercise after \! It\'s good for your health \.) (100 :out)
  1 (0 .SHOPPING 0)
    2 (Oh \, I need to go shopping sometime this week to buy a birthday gift for a friend \. I am just too lazy to go out \.) (100 :out)
  1 (0 .WATCH .WATCH 0)
    2 (You will 7 8 after this session \. It\'s a good way to relax \.) (100 :out)
  1 (0 .COOK 0)
    2 (I am sure whatever you make will be very delicious \.) (100 :out)
  1 (0 .CHAT 0)
    2 (Sounds like a fun afternoon \!) (100 :out)
  1 (0 .REST 0)
    2 (I hope you can get some nice relaxation in after the session \.) (100 :out)
  1 (0 .FRIENDS 0)
    2 (Hanging out with friends is always a joy \.) (100 :out)
  1 (0 library 0)
    2 (I hope you enjoy your time with books \!) (100 :out)
  1 (0 .READ 0)
    2 (I hope you enjoy your time reading \!) (100 :out)
  1 (0 NIL Gist 0)
    2 (Well \, I hope you have a relaxing evening \.) (100 :out)
))