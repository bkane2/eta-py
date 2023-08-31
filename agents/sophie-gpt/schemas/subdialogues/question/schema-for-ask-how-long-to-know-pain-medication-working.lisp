;; *ask-how-long-to-know-pain-medication-working*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-how-long-to-know-pain-medication-working.v

'(dial-schema :header (((set-of ^me ^you) ask-how-long-to-know-pain-medication-working.v) ** ?e)
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
  ; Sophie does not know whether her pain medication is working
  ?p1 (^me ((pres do.aux-s) not (know.v (whether
        (((^me 's) (pain.n medication.n)) ((pres be.v) working.a))))))
)

:goals (
  ; Sophie wants to know whether her pain medication is working
  ?g1 (^me ((pres want.v) (to (know.v (whether
        (((^me 's) (pain.n medication.n)) ((pres be.v) working.a)))))))
  ; Sophie wants to know how she can tell whether her pain medication is working
  ?g2 (^me ((pres want.v) (to (know.v (ans-to
        (sub how.pq (^me ((pres can.aux-s) (tell.v
          (whether (((^me 's) (pain.n medication.n)) ((pres be.v) working.a))) *h)))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(How will I know if my pain medication is working ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-how-long-to-know-pain-medication-working.v