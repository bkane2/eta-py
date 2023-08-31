;; How one can cope with giving up driving ?   
;;	(0 way 1 cope with giving up driving 0) (0 do not know 2 deal with giving up driving 0)
;;	giving-up-driving
;;	(1 how 2 cope 1 giving up driving 3)
(MAPC 'ATTACHFEAT
'(
  (BUS buses shuttle shuttles subway underground)
  (TAXI taxis uber lyft cab cabs)
  (SHOPPING shop banking service services online)
  (INTEREST interests)
  (DEVELOPE developes develop find)
  (BIKE biking bicycle walking)
  (SHARE ride lift)
  (IMAGINE stand idea)
  (WALK walking)
))


(READRULES '*giving-up-driving-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (How one can cope with giving up driving ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (How one can cope with giving up driving ?) (0 :gist)
  ; Specific answers
  1 (0 .SHARE 0)
    2 ((Way to cope with giving up driving is to share ride with others \.) (Giving-up-driving)) (0 :gist)
  1 (0 .BUS 0)
    2 ((Way to cope with giving up driving is to use bus \.) (Giving-up-driving)) (0 :gist)
  1 (0 .TAXI 0)
    2 ((Way to cope with giving up driving is to take taxi \.) (Giving-up-driving)) (0 :gist)
  1 (0 online 0)
    2 ((Way to cope with giving up driving is online shopping \.) (Giving-up-driving)) (0 :gist)
  1 (0 .BIKE 0)
    2 ((Way to cope with giving up driving is to bike \.) (Giving-up-driving)) (0 :gist)
  1 (0 .WALK 0)
    2 ((Way to cope with giving up driving is to walk \.) (Giving-up-driving)) (0 :gist)
  1 (0 .NEG 1 .IMAGINE 0)
    2 ((You do not know how to deal with giving up driving \.) (Giving-up-driving)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for a way to cope with giving up driving \.) (Giving-up-driving)) (0 :gist)
))


(READRULES '*reaction-to-giving-up-driving-input*
'(
  1 (0 .DO not know 0)
    2 (If your health situation is fine \, I recommend walking when possible \. Or there are lots of public transportations you can consider \.) (100 :out)
  1 (0 .SHARE 1 with others 0)
    2 (That\'s very nice that you obtain help from others \.) (100 :out)
  1 (0 .BUS 0)
    2 (2 is a good chioce \. Public transportation around here is faily good \.) (100 :out)
  1 (0 .TAXI 0)
    2 (2 is a good chioce \. If you are pressed for time \, it\'s better to make a plan in advance \. Then they pick up you in front of your home \. That\'s convenient \.) (100 :out)
  1 (0 online .SHOPPING 0)
    2 (That\'s right \. You can do lots of things on the internet \.) (100 :out)
  1 (0 .BIKE 0)
    2 (Sounds you have a good health \. That\'s great \. You must enjoy the fresh air and exercise \.) (100 :out)
  1 (0 .WALK 0)
    2 (Sounds you have a good health \. That\'s great \. You must enjoy the fresh air and exercise \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Although giving up driving is a tough decision \, I believe there are many ways to get used to that \.) (100 :out)
))