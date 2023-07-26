;; *ask-for-clarification*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-for-clarification.v

'(dial-schema :header (((set-of ^me ^you) ask-for-clarification.v) ** ?e)
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
  ; Sophie did not understand the user's question
  ?p1 (^me ((past do.aux-s) not (understand.v ((^you 's) question.n))))
)

:goals (
  ; Sophie wants the user to rephrase their question
  ?g1 (^me ((pres want.v) ^you (to (rephrase.v ((^you 's) question.n)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Can you rephrase your question ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-for-clarification.v