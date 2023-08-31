;; *respond-to-statement*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'respond-to-statement.v

'(dial-schema :header (((set-of ^me ^you) respond-to-statement.v) ** ?e)
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
  ; The user made some statement to Lissa
  ?p1 (^you ((past make.v) (some.d statement.n) (adv-a (to.p ^me))))
)

:goals (
  ; Lissa wants to react to the user's statement to express interest
  ?g1 (^me ((pres want.v) (to (respond.v (to.p-arg ((^you 's) statement.n)) (adv-a ({for}.p (to (express.v (k interest.n)))))))))
)

:episodes (

;; ?e1 (^me say-to.v ^you ?words)
?e1 (^me tell.v ^you ?some-fact)

)

)) ; END respond-to-statement.v