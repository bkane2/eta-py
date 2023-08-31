;; *ask-question*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-question.v

'(dial-schema :header (((set-of ^me ^you) ask-question.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:types (
  !t1 (^me person.n)
  !t2 (^you person.n)
)

:rigid-conds (
  ; Lissa is a woman
  !r1 (^me ((pres be.v) (= (a.d woman.n))))
  ; Lissa is 25 years old
  !r2 (^me ((pres be.v) ((mod-a (25.a (plur year.n))) old.a)))
)

:static-conds (
)

:preconds (
  ; The user told Lissa some statement
  ?p1 (^you ((past tell.v) ^me (some.d statement.n)))
)

:goals (
  ; Lissa wants to ask the user a question to express interest
  ?g1 (^me ((pres want.v) (to (ask.v ^you (a.d question.n) (adv-a ({for}.p (to (express.v (k interest.n)))))))))
)

:episodes (

;; ?e1 (^me say-to.v ^you ?words)
?e2 (^me ask.v ^you ?some-question)

?e3 (^you reply-to.v ?e2)

)

)) ; END ask-question.v