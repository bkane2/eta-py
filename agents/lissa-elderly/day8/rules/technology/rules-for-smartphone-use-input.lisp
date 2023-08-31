;;	Do you have a smartphone? What do you use it for?
;;	(0 I do not have a smartphone 0) 
;;	(0 I have a smartphone 0)
;;	(0 I use my smartphone for 0)
;;	smartphone-use
;;	(What do you use your smartphone if you have one ?)
;;	(3 What 2 use your smartphone 6) 
;; MEETING WITH KIM NOTES (8/4/2017)
;; Don't want to have one
;; Response: "What do your kids/grandkids use it for?"
;; Kids have them
;; Grandkids use them all the time
;; Staying/keeping in touch with family & friends
;; Skype / facetime
;; Text people
;; Have one but don't know how to use it
;; Kids wanted them to have it
;; No idea how to use it, just make phone calls
;; Games / apps
;; Watch videos (youtube)
;; Facebook (usually look at photos)
;; Take pictures
;; Helps keep independent (assistive technology)
(MAPC 'ATTACHFEAT
'(
  (KID kids SON DAUGHTER grandchild grandchildren grandkids grandkid grandson granddaughter FAMILY friends friends)
  (CONTACT touch)
  (CALL-APPS skype skyping facetime)
  (SOCIAL-NETWORKS twitter facebook instagram messenger)
  (GAME entertain entertainment music video videos applictions appliction)
  (CAMERA picture pictures photos photo video videos)
  (TEXT texting call calling message messaging)
  (INDEPENDENT assistive assist)
))


(READRULES '*smartphone-use-input*
'(
  ; Questions
  1 (0 what 2 use your smartphone 0 ?)
    2 (What do I use my smartphone if I have one ?) (0 :gist)
  1 (0 how 2 use your smartphone 0 ?)
    2 (What do I use my smartphone if I have one ?) (0 :gist)
  1 (0 .DO 2 need 2 smartphone 0 ?)
    2 (Do I need a smartphone ?) (0 :gist)
  ; Specific answers
  1 (0 .CALL-APPS 0)
    2 ((You use your smartphone for 2 \.) (Smartphone-use)) (0 :gist)
  1 (0 .SOCIAL-NETWORKS 0)
    2 ((You use your smartphone for 2 \.) (Smartphone-use)) (0 :gist)
  1 (0 .CONTACT 2 .KID 0)
    2 ((You use your smartphone for contact with 4 \.) (Smartphone-use)) (0 :gist)
  1 (0 .GAME 0)
    2 ((You use your smartphone for 2 \.) (Smartphone-use)) (0 :gist)
  1 (0 .CAMERA 0)
    2 ((You use your smartphone for taking or seeing pictures \.) (Smartphone-use)) (0 :gist)
  1 (0 .TEXT 0)
    2 ((You use your smartphone for calling and texting \.) (Smartphone-use)) (0 :gist)
  1 (0 .INDEPENDENT 0)
    2 ((You use your smartphone for 2 \.) (Smartphone-use)) (0 :gist)
  1 (0 .NEG 3 idea 3 use 0)
    2 ((You have a smartphone but do not know how to use it \.) (Smartphone-use)) (0 :gist)
  1 (0 .NEG 1 know 3 use 0)
    2 ((You have a smartphone but do not know how to use it \.) (Smartphone-use)) (0 :gist)
  1 (0 .NEG 1 .HAVE 0)
    2 ((You do not have a smartphone \.) (Smartphone-use)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for if you have a smartphone \.) (Smartphone-use)) (0 :gist)
))


(READRULES '*reaction-to-smartphone-use-input*
'(
  1 (0 .CALL-APPS 0)
    2 (I like to use skype because being able to see the other person\'s face makes the conversation more personal \.) (100 :out)
  1 (0 .SOCIAL-NETWORKS 0)
    2 (That\'s great that you\'re well connected \! It\'s good to be informed about family and friends \.) (100 :out)
  1 (0 .CONTACT with .KID 0)
    2 (It\'s great that you\'re able to stay well connected to your 8 \.) (100 :out)
  1 (0 .GAME 0)
    2 (Smartphone games can be entertaining \. I use them to pass the time when I have to wait for something \.) (100 :out)
  1 (0 .CAMERA 0)
    2 (I think it\'s really nice that people have the ability to save memories easily just by taking pictures \.) (100 :out)
  1 (0 .TEXT 0)
    2 (It sounds like you just use the most basic smartphone features \. That\'s okay though \, it\'s all you really need to communicate with friends and family \.) (100 :out)
  1 (0 .INDEPENDENT 0)
    2 (I think it\'s awesome that your smartphone is helping you be more independent \.) (100 :out)
  1 (0 .DO not know how to use 0)
    2 (Perhaps you can talk to friends or family one day to figure out how to use it one day \. You might find it to be extremely helpful \!) (100 :out)
  1 (0 .DO not .HAVE a smartphone 0)
    2 (I think it\'s very important to have a smartphone these days \. Of course \, the most important thing is that you\'re happy \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Although learning how to use a smartphone can be very confusing \, knowing how to use one helps a lot in daily life \.) (100 :out)
))