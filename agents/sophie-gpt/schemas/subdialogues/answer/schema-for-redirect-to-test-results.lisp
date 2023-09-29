;; *redirect-to-test-results*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'redirect-to-test-results.v

'(dial-schema :header (((set-of ^me ^you) redirect-to-test-results.v) ** ?e)
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
)

:preconds (
  ; The user is not currently talking about Sophie's test results.
  ?p1 (^you ((pres prog) not currently.adv-e (talk.v (adv-a (about.p ((^me 's) (test.n results.n)))))))
  ; Sophie is not ready to talk about her prognosis or options until she better understands her condition.
  ?p2 (^me ((pres be.v) not ready.a (to (talk.v (about.p-arg (((^me 's) prognosis.n) or.cc ((^me 's) (plur option.n))))))
        (until.ps (^me (better.adv-s ((pres understand.v) ((^me 's) condition.n)))))))
)

:goals (
  ; Sophie wants to talk about her test results.
  ?g1 (^me ((pres want.v) (to (talk.v (adv-a (about.p ((^me 's) (test.n results.n))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I want to talk about my test results today \.))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) condition.n)))))
)

)) ; END redirect-to-test-results.v