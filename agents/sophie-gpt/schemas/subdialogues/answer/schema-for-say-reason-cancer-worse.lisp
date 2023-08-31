;; *say-reason-cancer-worse*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-reason-cancer-worse.v

'(dial-schema :header (((set-of ^me ^you) say-reason-cancer-worse.v) ** ?e)
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
)

:preconds (
  ; Sophie believes her cancer has become worse because her pain has been becoming worse
  ?p1 (^me ((pres believe.v) (tht (((^me 's) cancer.n) ((pres perf) (become.v worse.a
        (because.ps (((^me 's) pain.n) ((pres perf) ((prog become.v) worse.a))))))))))
)

:goals (
  ; Sophie wants the user to know why she believes her cancer has become worse
  ?g1 (^me ((pres want.v) ^you (to (know.v (ans-to (sub why.pq
        (^me ((pres believe.v) (tht (((^me 's) cancer.n) ((pres perf)
          (become.v worse.a ({because}.ps *h)))))))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I believe my cancer has gotten worse because my pain has also gotten worse \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-reason-cancer-worse.v