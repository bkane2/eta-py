;; *state-understanding-test-results*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'state-understanding-test-results.v

'(dial-schema :header (((set-of ^me ^you) state-understanding-test-results.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````

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
)

:preconds (
  ; Sophie knows she received a second CT scan.
  ?p1 (^me ((pres know.v) (that (^me ((past receive.v) (a.d (second.a (|CT|.n scan.n))))))))
  ; Sophie knows the CT scan shows that her tumor is still there.
  ?p2 (^me ((pres know.v) (that ((the.d (|CT|.n scan.n)) ((pres show.v) (that (((^me 's) tumor.n) (pres remain.v))))))))
  ; Sophie knows the CT scan mentioned metastasis.
  ?p3 (^me ((pres know.v) (that ((the.d (plur (test.n result.n))) ((past mention.v) (k metastasis.n))))))
  ; Sophie does not know what metastasis means.
  ?p4 (^me ((pres do.aux-s) not (know.v (ans-to (sub what.pq ((k metastasis.n) ((pres mean.v) *h)))))))
)

:goals (
  ; Sophie wants the user to know her understanding of her test results
  ?g1 (^me ((pres want.v) ^you (to (know.v ((^me 's) (n+preds understanding.n (of.p ((^me 's) (plur (test.n result.n))))))))))
)

:episodes (

    ?e1 (^me paraphrase-to.v ^you '(I know that my CT scan shows the tumor is still there\, but I do not know what the results mean \.))
 
    ?e2 (^you reply-to.v ?e1)

)

)) ; END state-understanding-test-results.v