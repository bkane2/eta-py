;;  What are things you would do to make you feel comfortable in your home?
;;	(0 I would 6 at home to make me feel comfortable 0)
;;	things-comfortable-home
;;	(What would you do to make you feel comfortable in your home ?)
;;	(3 What 2 you do 2 make you feel comfortable 2 home 3)
;; MEETING WITH KIM NOTES (8/8/2017)
;; Relational:
;; Parts of the home that remind them of their family
;; Sitting around kitchen table
;; Porch
;; spending time with people
;; Complaining: everything was awful, don’t have positive memory
(MAPC 'ATTACHFEAT
'(
  (ALT-SITTING sitting sit seat)
  (ALT-SPENDING spending spend being BE hang hanging talk talking invite inviting)
  (ALT-PEOPLE people person FRIEND friends ALT-FAMILY)
  (ALT-FAMILY FAMILY children grandchildren CHILD grandchild SON DAUGHTER grandson granddaughter niece nephew)
  (ALT-SLEEPWARE bed mattress pillow pillows blanket blankets comforter quilt bedding sheets)
  (ALT-COMFORTABLE comfortable soft cozy snug warm pleasant comfy smooth)
  (ALT-FURNITURE furniture sofa sofas couch couches chair chairs)
  (ALT-FIREPLACE fireplace furnace stove hearth)
))


(READRULES '*things-comfortable-home-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (What would I do to make me feel comfortable in my home ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What would I do to make me feel comfortable in my home ?) (0 :gist)
  ; Specific answers
  1 (0 remind 2 of 2 .ALT-FAMILY 0)
    2 ((You would be reminded of family at home to make you feel comfortable \.) (Things-comfortable-home)) (0 :gist)
  1 (0 .ALT-SITTING 2 kitchen table 0)
    2 ((You would sit around the kitchen table at home to make you feel comfortable \.) (Things-comfortable-home)) (0 :gist)
  1 (0 porch 0)
    2 ((You would spend time on the porch at home to make you feel comfortable \.) (Things-comfortable-home)) (0 :gist)
  1 (0 .ALT-FIREPLACE 0)
    2 ((You would use the fireplace at home to make you feel more comfortable \.) (Things-comfortable-home)) (0 :gist)
  1 (0 .ALT-SPENDING 3 .ALT-PEOPLE 0)
    2 ((You would spend time with people at home to make you feel comfortable \.) (Things-comfortable-home)) (0 :gist)
  1 (0 decorations 0)
    2 ((You would have decorations at home to make you feel more comfortable \.) (Things-comfortable-home)) (0 :gist)
  1 (0 .ALT-SLEEPWARE 0)
    2 ((You would use good sleepware at home to make you feel more comfortable \.) (Things-comfortable-home)) (0 :gist)
  1 (0 .ALT-COMFORTABLE 3 .ALT-FURNITURE 0)
    2 ((You would use good furniture at home to make you feel more comfortable \.) (Things-comfortable-home)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for things you would do at home to make you feel comfortable \.) (Things-comfortable-home)) (0 :gist)
))


(READRULES '*reaction-to-things-comfortable-home-input*
'(
  1 (0 you would .BE reminded of .FAMILY at home to make you feel comfortable 0)
    2 (Having good memories of a place can make it feel very warm and cozy \.) (100 :out)
  1 (0 you would sit around the kitchen table at home to make you feel comfortable 0)
    2 (I can imagine having a common spot to sit and spend your evening would be very relaxing \.) (100 :out)
  1 (0 you would spend time on the porch at home to make you feel comfortable 0)
    2 (It\'s very nice to just be able to sit on the porch and watch things happen outside \.) (100 :out)
  1 (0 you would use the fireplace at home to make you feel more comfortable 0)
    2 (I really love sitting by the fireplace and getting warm \, especially in the freezing winters here \.) (100 :out)
  1 (0 you would spend time with people at home to make you feel comfortable 0)
    2 (Inviting friends often is one way to keep your home comfortable \. It helps prevent loneliness as well \!) (100 :out)
  1 (0 you would .HAVE decorations at home to make you feel comfortable 0)
    2 (I have a lot of fun decorating my own spaces in a way that reflects my personality \.) (100 :out)
  1 (0 you would use good sleepware at home to make you feel comfortable 0)
    2 (Good bedding is important \, part of a house being comfortable is being able to sleep well at night \.) (100 :out)
  1 (0 you would use good furniture at home to make you feel comfortable 0)
    2 (I sometimes think that furniture can be too comfortable \! It is nice having soft couches to relax on though \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I think that being comfortable in your home can come even from simple changes \, like nice decorations and cozy furniture \.) (100 :out)
))