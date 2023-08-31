;; *ask-if-stronger-medication-will-help-sleep*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-if-stronger-medication-will-help-sleep.v

'(dial-schema :header (((set-of ^me ^you) ask-if-stronger-medication-will-help-sleep.v) ** ?e)
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
  ; Sophie is having trouble with sleeping
  ?p1 (^me ((pres perf) ((prog have.v) trouble.a (with.p-arg (ka sleep.v)))))
)

:goals (
  ; Sophie wants to know whether stronger pain medication will help her sleep
  ?g1 (^me ((pres want.v) (to (know.v (whether ((k (stronger.a (pain.n medication.n)))
        ((pres will.aux-s) (help.v ^me (ke sleep.v)))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Will stronger pain medication help me sleep ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-if-stronger-medication-will-help-sleep.v