;; *pause-conversation*: development version 6
;;
;; Dialogue for blocks world conversation 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'pause-conversation.v

'(dial-schema :header (((set-of ^me ^you) pause-conversation.v) ** ?e)
;````````````````````````````````````````````````````````````````````````
; The user and the agent suspend dialogue until the user says something
; interpreted as a resumption request.
;

:episodes (

  ; David "pauses" by repeatedly listening to the user say something, and ignoring it
  ; unless it is interpreted as a resumption request, in which case the loop is broken.
  ?e1 (^me say-to.v ^you '(Sure \, let me know when you want to continue \.))
  ?e13 (:repeat-until (?e13 finished2.a)

    ; User says something which is either smalltalk (ignored by David),
    ; or is a special request.
    ?e15 (^you say-to.v ^me ?words)

    ; If user makes 'resume' special request, store the fact that ?e12 is finished.
    ?e16 (:if (^you paraphrase-to.v ^me '(Resume \.))
      ?e17 (^me commit-to-STM.v (that (?e13 finished2.a)))
      ?e18 (^me say-to.v ^you '(Hello again \.))))
)

)) ; END pause-conversation.v