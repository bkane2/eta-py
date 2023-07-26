;; *mention-feeling-better-after-radiation*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'mention-feeling-better-after-radiation.v

'(dial-schema :header (((set-of ^me ^you) mention-feeling-better-after-radiation.v) ** ?e)
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
  ; Sophie was feeling a little better after radiation
  ?p1 (^me ((past prog) (feel.v (a_little.mod-a better.a) (adv-e (after.p (k radiation.n))))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I was feeling a little better after radiation \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END mention-feeling-better-after-radiation.v