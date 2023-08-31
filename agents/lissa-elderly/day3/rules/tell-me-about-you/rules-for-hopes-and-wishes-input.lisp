;;	What are your hopes and wishes ?
;; 	(hopes-and-wishes)
;; 	from-hopes-and-wishes-input 
;;	(0 my wish is 0)
;;	gist-question: (1 what 2 hopes and wishes 1)
;; MEETING WITH KIM NOTES (8/4/2017)
;; Don't want to end up in a nursing home / assisted living
;; Want to stay in their home as long as possible
;; Stay independent
;; Seeing granddaughter graduate from high school/college
;; Seeing granddaughter/kid getting married
;; See new places
;; Learn a new language
;; Peaceful death / control over death
;; Response: (Sounds like autonomy is important to you / Sounds like you have some clear
;;            ideas as to where you want your end of life to go / Have you thought about
;;            discussing your end of life thoughts more with your family/doctor/etc. ?)
(MAPC 'ATTACHFEAT
'(
  (WISHES-HEALTH health healthy healthier weight active exercise productive engaged)
  (WISHES-TRAVEL TRAVEL traveling MOVE moving)
  (WISHES-HAPPY happy happiness joy relax relaxed relaxing successful content contented)
  (WISHES-TWO-SPENDTIME SPEND spending time being with)
  (WISHES-TWO-MONEY make making get getting MONEY)
  (WISHES-TWO-EXPERIENCE new experiences EXPERIENCE living LIVE life)
  (WISHES-OBJECT children CHILD DAUGHTER SON BOY GIRL parents FATHER husband wife MOTHER friends FAMILY granddaughter grandson GRANDCHILD grandchildren)
  (MOVE moving)
  (SPEND spending)
  (RETIRE retires)
))


(READRULES '*hopes-and-wishes-input*
'(
  ; Reciprocal questions
  1 (0 what 2 you 0 ?)
    2 (What are my hopes and wishes ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What are my hopes and wishes ?) (0 :gist)
  1 (0 .WH_ 3 your hopes 0 ?)
    2 (What are my hopes and wishes ?) (0 :gist)
  1 (0 .WH_ 3 your wishes 0 ?)
    2 (What are my hopes and wishes ?) (0 :gist)
  ; Specific answers
  1 (0 .WISHES-TWO-SPENDTIME 2 .WISHES-TWO-SPENDTIME 2 .WISHES-OBJECT 0)
    2 ((Your wish is to spend time with your 6 \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 meet 2 .WISHES-OBJECT 0)
    2 ((Your wish is to spend time with your 4 \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 .WISHES-TWO-MONEY 1 .WISHES-TWO-MONEY 0)
    2 ((Your wish is to make more money \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 .WISHES-TWO-EXPERIENCE 1 .WISHES-TWO-EXPERIENCE 0)
    2 ((Your wish is to get new experiences \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 .WISHES-TRAVEL 2 .WISHES-OBJECT 0)
    2 ((Your wish is to travel with your 4 \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 .WISHES-TRAVEL 0)
    2 (0 .MOVE 0)
      3 ((Your wish is to move to a new place \.) (Hopes-and-wishes)) (0 :gist)
    2 ((Your wish is to travel \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 .WISHES-HEALTH 0)
    2 ((Your wish is to be healthy \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 .WISHES-HAPPY 0)
    2 ((Your wish is to be happy \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 learn 0)
    2 ((Your wish is to learn something \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 I 2 .RETIRE 0)
    2 ((Your wish is to retire and do stuff \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 my .SPOUSE 2 .RETIRE 0)
    2 ((Your wish is that your husband retires and you do stuff \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 I 2 .NEG 2 know 0)
    2 ((You do not know what your wish is \.) (Hopes-and-wishes)) (0 :gist)
  1 (0 I 2 .NEG 2 sure 0)
    2 ((You do not know what your wish is \.) (Hopes-and-wishes)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what your wish is \.) (Hopes-and-wishes)) (0 :gist)
))


(READRULES '*reaction-to-hopes-and-wishes-input*
'(
  1 (0 .SPEND time 2 .WISHES-OBJECT 0)
    2 (Hopefully \, you will be able to spend plenty of time in the future being with your 5 !) (100 :out)
  1 (0 make more .MONEY 0)
    2 (If making more money will make you happier \, I hope you can do just that \!) (100 :out)
  1 (0 get more experiences 0)
    2 (Well \, it\'s never too late to experience new things \!) (100 :out)
  1 (0 .TRAVEL 2 .WISHES-OBJECT 0)
    2 (Travelling with your 4 sounds fun \, I hope you can do that soon \.) (100 :out)
  1 (0 .TRAVEL 0)
    2 (Travelling is always nice \, I hope you can do that soon \.) (100 :out)
  1 (0 .MOVE 0)
    2 (Moving to a new place is always exciting \. You hope I can do that soon \.) (100 :gist)
  1 (0 .BE healthy 0)
    2 (I hope you can be healthy and get good exercise in the future \!) (100 :out)
  1 (0 .BE happy 0)
    2 (I hope you can be happy and content with your future \.) (100 :out)
  1 (0 learn 0)
    2 (It would be great to keep your brain active by learning new things \, especially in senior age \.) (100 :out)
  1 (0 .RETIRE 0)
    2 (Retirement is great \. You would get to do a lot of fun stuff that you have always wished to \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I hope your wishes come true \.) (100 :out)
))