;; *ask-for-stronger-pain-medication*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-for-stronger-pain-medication.v

'(dial-schema :header (((set-of ^me ^you) ask-for-stronger-pain-medication.v) ** ?e)
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
  ; Sophie's current pain medication isn't working well
  ?p1 (((^me 's) (current.a (pain.n medication.n))) ((pres prog) not (work.v well.a)))
)

:goals (
  ; Sophie wants a stronger pain medication
  ?g1 (^me ((pres want.v) (a.d (stronger.a (pain.n medication.n)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Can I have a stronger pain medication ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-for-stronger-pain-medication.v