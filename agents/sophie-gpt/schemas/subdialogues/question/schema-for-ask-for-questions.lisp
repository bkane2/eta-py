;; *ask-for-questions*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-for-questions.v

'(dial-schema :header (((set-of ^me ^you) ask-for-questions.v) ** ?e)
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
)

:goals (
  ; Sophie wants to know what questions the user has
  ?g1 (^me ((pres want.v) (to (know.v (ans-to (sub (what.d (plur question.n)) (^you ((pres have.v) *h))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(What are your questions ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-for-questions.v