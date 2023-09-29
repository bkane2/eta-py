;; *thank-for-explain-test-results*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'thank-for-explain-test-results.v

'(dial-schema :header (((set-of ^me ^you) thank-for-explain-test-results.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````

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
  ; The user explained Sophie's test results
  ?p1 (^you ((past explain.v) ((^me 's) (plur (test.n result.n)))))
)

:goals (
  ; Sophie wants the user to know that she's thankful that the user explained her test results
  ?g1 (^me ((pres want.v) ^you (to (know.v (that (^me ((pres be.v) thankful.a
        (adv-a ({for}.p (that (^you ((past explain.v) ((^me 's) (plur (test.n result.n)))))))))))))))
)

:episodes (

    ?e1 (^me paraphrase-to.v ^you '(I am thankful that you've taken the time to explain my test results to me \.))
 
    ?e2 (^you reply-to.v ?e1)

)

)) ; END thank-for-explain-test-results.v