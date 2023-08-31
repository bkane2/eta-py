;; *ask-why-pain-medication-not-working*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-why-pain-medication-not-working.v

'(dial-schema :header (((set-of ^me ^you) ask-why-pain-medication-not-working.v) ** ?e)
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
  ; Sophie's pain medication isn't working anymore
  ?p1 (((^me 's) (pain.n medication.n)) ((pres prog) not (work.v anymore.adv-e)))
)

:goals (
  ; Sophie wants to know why her pain medication isn't working anymore
  ?g1 (^me ((pres want.v) (to (know.v (ans-to (sub why.pq (((^me 's) (pain.n medication.n))
        ((pres prog) not (work.v anymore.adv-e *h)))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Why isn\'t the pain medication working anymore ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-why-pain-medication-not-working.v