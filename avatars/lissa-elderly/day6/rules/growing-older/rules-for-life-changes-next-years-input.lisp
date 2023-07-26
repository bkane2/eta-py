;; 	What kind of changes or life transitions might happen for you in the next year? For example, changes with your family, your health, or your living situation?
;; 	gist: What changes might happen for you in the next few years ?
;;	(0 change 2 happen 3 next few years 0)
;;	life-changes-next-years
;;	(2 What changes 1 happen 1 you 2 next few years 2)
;; MEETING WITH KIM NOTES (8/4/2017)
;; Grandson getting married
;; Spouse going into nursing home
;; Spouse might die
;; Might get remarried
;; Daughter/son getting divorced
;; One of their kids is having a child / will have a grandchild
;; They're going to change their diet / manage their blood sugar better
;; Get off some of their medicines; taking too many
;; Health getting worse / losing sight/hearing / alzheimers
;; Moving out of their home
;; Moving to retirement community / senior living / assisted living / long term care / nursing home
;; Move in with kids
;; Might retire
;; Might get part time job
;; Might start volunteering
(MAPC 'ATTACHFEAT
'(
  (MOVE moving)
  (TOUR tourism travel trip visit)
  (BODY-PARTS LISTEN ear VISION eye shoulder arm finger knee leg foot feet ankle wrist teeth elbow)
  (WORSE bad)
  (BETTER good)
  (RETIRE freetime time spare)
))


(READRULES '*life-changes-next-years-input*
'(
  ; Questions
  1 (0 what 4 you 0 ?)
    2 (What changes might happen for me in the next few years ?) (0 :gist)
  1 (0 .WH_ 4 chore 1 .ENJOY 0 ?)
    2 (What changes might happen for me in the next few years ?) (0 :gist)
  ; Specific answers
  1 (0 .NEG 2 change 0)
    2 ((No change will happen in the next few years \.) (Life-changes-next-years)) (0 :gist)
  1 (0 stay same 0)
    2 ((No change will happen in the next few years \.) (Life-changes-next-years)) (0 :gist)
  1 (0 .MOVE to 0)
    2 ((Change will happen in the next few years is moving to a new place \.) (Life-changes-next-years)) (0 :gist)
  1 (0 .TOUR 0)
    2 ((Change will happen in the next few years is having a trip \.) (Life-changes-next-years)) (0 :gist)
  1 (0 .BODY-PARTS 3 .WORSE 0)
    2 ((Change will happen in the next few years is 2 getting worse \.) (Life-changes-next-years)) (0 :gist)
  1 (0 .BODY-PARTS 3 .BETTER 0)
    2 ((Change will happen in the next few years is 2 getting better \.) (Life-changes-next-years)) (0 :gist)
  1 (0 .RETIRE 0)
    2 ((Change will happen in the next few years is have more time \.) (Life-changes-next-years)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for the change that might happen in the next few years \.) (Life-changes-next-years)) (0 :gist)
))


(READRULES '*reaction-to-life-changes-next-years-input*
'(
  1 (0 .MOVE 2 a new place 0)
    2 (Moving to a new place is like starting a new life \. A lot of things to explore and be busy with \!) (100 :out)
  1 (0 .HAVE a trip 0)
    2 (It is great to hear that you planning to have a trip \. Hope you have a nice time \.) (100 :out)
  1 (0 .BODY-PARTS getting .WORSE 0)
    2 (I am sorry to hear that your 2 condition bothers you \. I think you need to see a doctor \.) (100 :out)
  1 (0 .BODY-PARTS getting .BETTER 0)
    2 (That is great to hear that your 2 condition is becoming better \.) (100 :out)
  1 (0 .RETIRE 0)
    2 (Then you will have time to do things you are interested in \.) (100 :out)
  1 (0 no change 0)
    2 (Okay \, sounds your life is stable \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Thank you for telling me \, I hope everything turns out well \.) (100 :out)
))