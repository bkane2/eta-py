;; *explain-future-goals*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-future-goals.v

'(dial-schema :header (((set-of ^me ^you) explain-future-goals.v) ** ?e)
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
  ; Sophie wants to be able to watch her grandson graduate
  ?s2 (^me ((pres want.v) (to (be.v able.a (to (watch.v ((^me 's) grandson.n) (ke graduate.v)))))))
)

:preconds (
  ; Sophie's goal is to survive for enough time to be there for her family
  ?p1 (((^me 's) goal.n) ((pres be.v) (to.p-arg (ke (survive.v
        (adv-e (for.p (enough.d (n+preds time.n
          ({for}.p (to (be.v there.adv-e (adv-a (for.p ((^me 's) family.n)))))))))))))))
)

:goals (
  ; Sophie wants to explain her goals to the user
  ?g1 (^me ((pres want.v) (to (explain.v ((^me 's) (plur goal.n)) (to.p-arg ^you)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(My goal is to survive long enough to be there for my family \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END explain-future-goals.v