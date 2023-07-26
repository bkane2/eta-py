;; *ask-if-cancer-worse*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-if-cancer-worse.v

'(dial-schema :header (((set-of ^me ^you) ask-if-cancer-worse.v) ** ?e)
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
  ; Sophie does not understand her condition
  ?p1 (^me ((pres do.aux-s) not (understand.v ((^me 's) condition.n))))
)

:goals (
  ; Sophie wants to know whether her cancer has gotten worse
  ?g1 (^me ((pres want.v) (to (know.v (whether (((^me 's) cancer.n) ((pres perf) (got.v worse.a))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Has the cancer gotten worse ?))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) condition.n)))))
)

)) ; END ask-if-cancer-worse.v