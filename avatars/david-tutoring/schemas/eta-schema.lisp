;; *ETA-SCHEMA*: development version 6
;;
;; Dialogue for blocks world conversation 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'have-eta-dialog.v

'(dial-schema :header (((set-of ^me ^you) have-eta-dialog.v) ** ?e)
;`````````````````````````````````````````````````````````````````````
; Blocks world conversation. An expected blocks world dialogue consists
; of the agent repeatedly asking the user if they have a spatial question
; to ask, followed by a question from the user, followed by an appropriate
; response by the agent. This repeats until the user says something interpreted
; as a goodbye, and is possibly preempted by some "smalltalk" questions
; (currently disabled).
;

:episodes (

  ; David has concept tutoring dialogue.
  ?e1 (^me teach-BW-concept-to.v ^you)

)

)) ; END have-eta-dialog.v