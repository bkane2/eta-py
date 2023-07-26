; This is a small trial pattern base for reacting to the user's
; answer concerning what s/he doesn't like about Rochester.
; We also provide features, supplementing the generic ones in
; "general-word-data.lisp", relevant to the topic here.
(MAPC 'ATTACHFEAT
'(
  (OLD rundown)
  (SAFETY CRIME dangerous safe neighborhood neighborhoods ward safer)
  (ANYTHING nothing)
  (TRANSPORTATION bus buses)
  (WEATHER cold snow snows snowy winter warmer)
))


(READRULES '*not-like-about-rochester-input*
'(
  ; Reciprocal questions
  1 (0 what 0 you 0 ?)
    2 (What do I not like about rochester ?) (0 :gist)
  1 (0 how 0 you 0 ?)
    2 (What do I not like about rochester ?) (0 :gist)
  1 (0 what 2 you not .LIKE 0 ?)
    2 (What do I not like about rochester ?) (0 :gist)
  ; Specific answers
  1 (0 not 2 .MUCH to .DO 0)
    2 ((You do not like that there is not much to do in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 nothing 2 to .DO 0)
    2 ((You do not like that there is not much to do in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 .WEATHER 0)
    2 ((You do not like the weather in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 .SAFETY 0)
    2 ((You do not like that some places are not safe in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 .TRANSPORTATION 0)
    2 ((You do not like the transportation in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 .ANYTHING 0)
    2 ((There is nothing that you do not like in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 .OLD 0)
    2 ((You do not like old places in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 not 1 really 0)
    2 ((No opinion about what you do not like in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 I wish 1 the 1 0)
    2 ((You do not like 4 in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 .LIKE everything 0)
    2 ((There is nothing that you do not like in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0 everything 2 .NICE 0)
    2 ((There is nothing that you do not like in rochester \.) (Not-like-rochester)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what you do not like in rochester \.) (Not-like-rochester)) (0 :gist)
))


(READRULES '*reaction-to-not-like-about-rochester-input*
'(
  1 (0 not .LIKE 0 not .MUCH to .DO 0)
    2 (That bothers me too \.) (100 :out)
  1 (0 .WEATHER 0)
    2 (Yeah \, I find it cold here too \.) (100 :out)
  1 (0 not safe 0)
    2 (Yeah \, I also find it bothering \.) (100 :out)
  1 (0 .TRANSPORTATION 0)
    2 (Yeah \, I wish that there were more frequent buses in the city \.) (100 :out)
  1 (0 .ANYTHING 0)
    2 (It seems you are kind of content \.) (100 :out)
  1 (0 .OLD 0)
    2 (Right \, I have the same feeling \.) (100 :out)
  1 (0 no opinion 0)
    2 (That is great that you like living here \. I just wish it was a little warmer during the winter \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I think rochester is generally a nice place to live !) (100 :out)
)) ; end of *reaction-to-not-like-about-rochester-input*