;; *mention-taking-lortab*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'mention-taking-lortab.v

'(dial-schema :header (((set-of ^me ^you) mention-taking-lortab.v) ** ?e)
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
  ; Sophie is only taking Lortab to treat her pain
  ?p1 (^me ((pres prog) (take.v only.adv-s |Lortab| (adv-a ({for}.p (to (treat.v (their.d pain.n))))))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I am only taking Lortab to treat my pain \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END mention-taking-lortab.v