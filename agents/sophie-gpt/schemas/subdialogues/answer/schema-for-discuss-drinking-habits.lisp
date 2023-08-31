;; *discuss-drinking-habits*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'discuss-drinking-habits.v

'(dial-schema :header (((set-of ^me ^you) discuss-drinking-habits.v) ** ?e)
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
  ; Sophie had a history of alcohol abuse
  ?p1 (^me ((past have.v) (a.d (n+preds history.n (of.p (alcohol.n abuse.n))))))
  ; Sophie does not drink now
  ?p2 (^me ((pres do.aux-s) not (drink.v now.adv-e)))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I have a history of alcohol abuse but do not drink now \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END discuss-drinking-habits.v