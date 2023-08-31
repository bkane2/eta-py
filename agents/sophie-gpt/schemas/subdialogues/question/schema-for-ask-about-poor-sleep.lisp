;; *ask-about-poor-sleep*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-poor-sleep.v

'(dial-schema :header (((set-of ^me ^you) ask-about-poor-sleep.v) ** ?e)
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
  ; Sophie hasn't been sleeping well
  ?p1 (^me ((pres perf) not ((prog sleep.v) well.a)))
)

:goals (
  ; Sophie wants to know why she hasn't been sleeping well
  ?g1 (^me ((pres want.v) (to (know.v (ans-to
        (sub why.pq (^me ((pres perf) not ((prog sleep.v) well.a *h)))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Why have I not been sleeping well ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-about-poor-sleep.v