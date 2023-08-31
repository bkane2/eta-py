;; *ask-about-narcotic-addiction*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-narcotic-addiction.v

'(dial-schema :header (((set-of ^me ^you) ask-about-narcotic-addiction.v) ** ?e)
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
  ; Sophie has pain in her chest
  ?s2 (^me ((pres have.v) (k (n+preds pain.n (in.p ((^me 's) chest.n))))))
  ; Sophie is taking Lortab for her pain
  ?s3 (^me ((pres take.v) (k |Lortab|.n) (adv-a (for.p ((^me 's) pain.n)))))
)

:preconds (
)

:goals (
  ; Sophie wants to know whether she can get addicted to narcotics
  ?g1 (^me ((pres want.v) (to (know.v (whether
        (^me ((pres can.aux-s) (get.v (addicted.a (to.p-arg (k (plur narcotic.n))))))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Can I get addicted to narcotics ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-about-narcotic-addiction.v