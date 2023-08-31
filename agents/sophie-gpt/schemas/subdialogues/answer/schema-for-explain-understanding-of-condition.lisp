;; *explain-understanding-of-condition*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-understanding-of-condition.v

'(dial-schema :header (((set-of ^me ^you) explain-understanding-of-condition.v) ** ?e)
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
  ; Sophie knows that her cancer got worse
  ?p1 (^me ((pres know.v) (that (((^me 's) cancer.n) ((past got.v) worse.a)))))
  ; Sophie does not know just how bad her cancer is
  ?p2 (^me ((pres do.aux-s) not (know.v (ans-to (sub (just.mod-a (how.mod-a bad.a)) (((^me 's) cancer.n) ((pres be.v) *h)))))))
)

:goals (
  ; Sophie wants the user to know her understanding of her condition
  ?g1 (^me ((pres want.v) ^you (to (know.v (their.d (n+preds understanding.n (of.p ((^me 's) condition.n))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I know that my cancer has gotten worse\, but I\'m not sure how bad it is \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END explain-understanding-of-condition.v