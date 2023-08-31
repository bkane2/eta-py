;; *respond-to-question*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'respond-to-question.v

'(dial-schema :header (((set-of ^me ^you) respond-to-question.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:types (
  !t1 (^me person.n)
  !t2 (^you person.n)
)

:rigid-conds (
  ; Sophie is a woman
  !r1 (^me ((pres be.v) (= (a.d woman.n))))
  ; Sophie is 65 years old
  !r2 (^me ((pres be.v) ((mod-a (65.a (plur year.n))) old.a)))
)

:static-conds (
  ; Sophie has lung cancer
  ?s1 (^me ((pres have.v) (k (lung.n cancer.n))))
)

:preconds (
  ; The user asked Sophie a question
  ?p1 (^you ((past ask.v) ^me (a.d question.n)))
)

:goals (
  ; Sophie wants to respond to the user's question with a short answer
  ?g1 (^me ((pres want.v) (to (respond.v (to.p-arg ((^you 's) question.n)) (with.p-arg (a.d (short.a answer.n)))))))
  ; Sophie wants to get the conversation back on track if the user's question is not relevant to her condition.
  ?g2 (^me ((pres want.v) (to (get.v (the.d conversation.n) (back.adv-a (on.p-arg (k track.n)))))
        (if.ps (((^you 's) question.n) ((pres be.v) not relevant.a (to.p-arg ((^me 's) condition.n)))))))
)

:episodes (

?e1 (^me say-to.v ^you ?words)

?e2 (^you reply-to.v ?e1)

)

)) ; END respond-to-question.v