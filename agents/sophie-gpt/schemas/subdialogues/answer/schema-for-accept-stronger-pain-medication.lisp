;; *accept-stronger-pain-medication*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'accept-stronger-pain-medication.v

'(dial-schema :header (((set-of ^me ^you) accept-stronger-pain-medication.v) ** ?e)
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
  ; The user agreed to give Sophie stronger pain medication
  ?p1 (^you ((past agree.v) (to (give.v ^me (k (stronger.a (pain.n medication.n)))))))
  ; Sophie accepts stronger pain medication
  ?p2 (^me ((pres accept.v) (k (stronger.a (pain.n medication.n)))))
)

:goals (
  ; Sophie wants to take stronger pain medication
  ?g1 (^me ((pres want.v) (to (take.v (k (stronger.a (pain.n medication.n)))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I want to start taking the stronger pain medication \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END accept-stronger-pain-medication.v