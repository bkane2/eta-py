;; *answer-question*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'answer-question.v

'(dial-schema :header (((set-of ^me ^you) answer-question.v) ** ?e)
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
  ; The user asked Lissa a question
  ?p1 (^you ((past ask.v) ^me (a.d question.n)))
)

:goals (
  ; Lissa wants to respond to the user's question with a casual answer
  ?g1 (^me ((pres want.v) (to (respond.v (to.p-arg ((^you 's) question.n)) (with.p-arg (a.d (casual.a answer.n)))))))
)

:episodes (

;; ?e1 (^me say-to.v ^you ?words)
?e1 (^me answer.v ^you ?some-answer)

)

)) ; END answer-question.v