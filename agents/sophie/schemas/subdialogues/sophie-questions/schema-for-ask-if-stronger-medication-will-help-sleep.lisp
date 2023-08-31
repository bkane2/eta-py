;; *ask-if-stronger-medication-will-help-sleep*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-if-stronger-medication-will-help-sleep.v

'(dial-schema :header (((set-of ^me ^you) ask-if-stronger-medication-will-help-sleep.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

; TODO: although inquiring about a stronger pain medication might be the ultimate goal of the agent
; pursuing this line of questioning, it isn't the immediate goal, and so shouldn't be the immediate
; goal of this schema. However, this is currently necessary (until Eta is modified to support multiple
; inferences from the same gist clause) to prevent the agent from asking this question in the case where
; the agent already has "stronger" knowledge that they're being prescribed a stronger pain medication.
:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(Can I have a stronger pain medication ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Will stronger pain medication help me sleep ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-if-stronger-medication-will-help-sleep.v