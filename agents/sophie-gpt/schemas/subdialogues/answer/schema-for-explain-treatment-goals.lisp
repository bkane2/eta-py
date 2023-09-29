;; *explain-treatment-goals*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-treatment-goals.v

'(dial-schema :header (((set-of ^me ^you) explain-treatment-goals.v) ** ?e)
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
  ; Sophie has a grandson
  ?s2 (^me ((pres have.v) (grandson.n)))
)

:preconds (
  ; Sophie's treatment goal is spending more time with her grandson.
  ?p1 (((^me 's) (treatment.n goal.n)) ((pres be.v) (= (to (spend.v (more.d time.n) (with.p-arg ((^me 's) grandson.n)))))))
  ; Sophie's treatment goal is high quality of life.
  ?p2 (((^me 's) (treatment.n goal.n)) ((pres be.v) (= (to (have.v (a.d (n+preds (high.a quality.n) (of.p (k life.n)))))))))
)

:goals (
  ; Sophie wants the user to know treatment goals.
  ?g1 (^me ((pres want.v) ^you (to (know.v ((^me 's) (plur (k (treatment.n goal.n))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(My treatment goals are to spend time with my grandson and to maintain a high quality of life \.))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates (^you be.v empowering.a))
)

)) ; END explain-treatment-goals.v