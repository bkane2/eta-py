;; *explain-here-alone*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-here-alone.v

'(dial-schema :header (((set-of ^me ^you) explain-here-alone.v) ** ?e)
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
  ; Sophie is here alone
  ?p1 (^me ((pres be.v) here.adv-e alone.adv-a))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I am here alone \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END explain-here-alone.v