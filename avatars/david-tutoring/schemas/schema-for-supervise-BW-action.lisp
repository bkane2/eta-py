;; *supervise-BW-action*
;;
;; Dialogue for supervising the user through making a particular BW action.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'supervise-BW-action.v

'(dial-schema :header ((^me supervise-BW-action.v ^you ?ka1) ** ?e)
;`````````````````````````````````````````````````````````````````````````````
; Blocks world action supervision; consists of the BW agent listening for any
; questions (or other requests) by the user, watching them try to make a move
; towards the goal structure (possibly followed by a follow-up like "is that
; correct?"), and issuing a correction in the case that the user's action isn't
; an instance of ?ka1. The correction simply entails vocalizing ?ka1 with
; corrective phrasing (however, this is suppressed in the case where ?ka1
; involves undoing the previous action, since the user may technically get
; undoing something "wrong" if they don't move a block to exactly the original
; location, but this usually isn't actually an issue in need of correction).

:episodes (

  ?e1 (:repeat-until (?e1 finished2.a)
  
    ; The user may say something to David before attempting to make a move -
    ; namely, a spatial question, or a termination/pause request.
    ?e2 (^you say-to.v ^me ?words1)
      
    ; The user attempts to make the proposed move.
    ?e9 (^you try1.v ?ka1)

    ; The user might follow up with a verification question,
    ; like "how's that"?
    ?e10 (^you say-to.v ^me ?words2)

    ; If the user made the correct move...
    ?e11 (:if ((pair ^you ?e9) instance-of.p ?ka1)

      ; If the user explicitly asked about correctness...
      ?e12 (:if ((^you verify-correctness.v) * ?e10)
      
        ; Inform them that their move was correct.
        ?e13 (^me say-to.v ^you '(Good\, that\'s correct\.)))

      ; Exit loop and move on to next step in the plan.
      ?e14 (^me commit-to-STM.v (that (?e1 finished2.a)))

      ; Otherwise, if the user made an incorrect move...
      :else (

        ; Issue a correction by explicitly informing
        ; the user what the correct move should have been.
        ?e20 (^me issue-correction-to.v ^you ?ka1)

        ; Exit loop and move on to next step in the plan
        ; (which, in the case of an incorrect move by the user,
        ; will be the correction/adjustment to that move).
        ; TODO: see note in 'schema-for-guide-BW-action.lisp' - I'm unsure
        ; of whether clarifications should be dealt with in this way (i.e.,
        ; modifications to the subsequent planner inputs), but this is the way
        ; it's done currently with the existing planner capabilities.
        ?e21 (^me commit-to-STM.v (that (?e1 finished2.a))))))

)

:certainties (
  !c1 (!e2 0.4)
)

)) ; END supervise-BW-action.v