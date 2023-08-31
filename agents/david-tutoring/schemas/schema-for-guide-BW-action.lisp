;; *guide-BW-action*
;;
;; Dialogue for guiding the user through making a particular BW action.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'guide-BW-action.v

'(dial-schema :header ((^me guide-BW-action.v ^you ?ka1) ** ?e)
;`````````````````````````````````````````````````````````````````````````````
; Blocks world action instruction; consists of the BW agent guiding the
; user through making a specific action (e.g., a block move). Consists of
; monitoring the user's actions, and checking whether the user's action is
; an instance of ?ka1; otherwise, the agent should issue a correction. The
; agent should allow for the possibility of a question, pause request, or
; termination request during this process as well.

:episodes (

  ; David proposes the action to the user.
  ?e1 (^me propose1-to.v ^you ?ka1)

  ; The system tries to guide the user
  ; through a move until they do it successfully.
  ; TODO: if this should be more flexible, i.e. giving the user the power
  ; to 'suggest' or try a different move (for instance, if multiple valid
  ; paths exist towards the goal), the schema will need to be revised.
  ?e2 (:repeat-until (?e2 finished2.a)

    ; The user responds to the proposal (could be silent acknowledgement).
    ; TODO: in principle, a response could be anything, potentially subsuming
    ; the "try to do move" action below. For now, I keep these separate.
    ?e3 (^you reply-to.v ?e1)

    ; The user attempts to make the proposed move.
    ?e10 (^you try1.v ?ka1)

    ; TODO: I'm unsure here as to whether corrections to the user (in the case
    ; that they make a wrong move) should be handled as a separate episode
    ; in the schema (as in the commented section below), or if they should
    ; be handled "implicitly" by the next planner proposal, as is the case
    ; currently.
    ?e11 (^me commit-to-STM.v (that (?e2 finished2.a)))

    ;; ; Either the move made by the user was a (successful) instance
    ;; ; of ?ka1 or the move was a failure to match the proposed move.
    ;; ?e11 (:if ((pair ^you ?e10) instance-of.p ?ka1)
      
    ;;     ; Store that the user has done the proposed action in context.
    ;;     ?e12 (^me commit-to-STM.v (that (?e2 finished2.a)))

    ;;     :else (

    ;;       ; Find and issue a correction.
    ;;       ?e13 (^me find4.v (some.d ?correction (:l (?x) (?x step1-toward.p ?goal-rep))))
    ;;       ?e14 (^me propose1-to.v ^you ?correction)))

  )

)

:certainties (
  !c1 (!e3 0.4)
)

)) ; END guide-BW-action.v