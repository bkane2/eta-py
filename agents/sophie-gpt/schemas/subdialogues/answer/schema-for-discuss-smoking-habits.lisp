;; *discuss-smoking-habits*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'discuss-smoking-habits.v

'(dial-schema :header (((set-of ^me ^you) discuss-smoking-habits.v) ** ?e)
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
  ; Sophie has a history of heavy smoking
  ?p1 (^me ((pres have.v) (a.d (n+preds history.n (of.p (ka (heavy.adv-a smoke.v)))))))
  ; Sophie quit smoking six months ago
  ?p2 (^me ((past quit.v) (ka smoke.v) (adv-e (sub (six.d (plur month.n)) (ago.p *h)))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I have a history of smoking but quit six months ago \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END discuss-smoking-habits.v