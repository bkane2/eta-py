;; *discuss-history-mental-illness*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'discuss-history-mental-illness.v

'(dial-schema :header (((set-of ^me ^you) discuss-history-mental-illness.v) ** ?e)
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
  ; Nobody in Sophie's family has a history of mental illness
  ?p1 ((np+preds nobody.pro (in.p ((^me 's) family.n))) ((pres have.v) (a.d (n+preds history.n (of.p (mental.a illness.n))))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Nobody in my family has a history of mental illness \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END discuss-history-mental-illness.v