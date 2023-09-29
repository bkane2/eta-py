;; *redirect-to-options*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'redirect-to-options.v

'(dial-schema :header (((set-of ^me ^you) redirect-to-options.v) ** ?e)
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
  ; The user is not currently talking about Sophie's options
  ?p1 (^you ((pres prog) not currently.adv-e (talk.v (adv-a (about.p ((^me 's) options.n))))))
  ; Sophie already understands her prognosis, but not her options
  ?p2 (^me (already.adv-s ((pres understand.v) (((^me 's) prognosis.n) but.cc (not ((^me 's) (plur option.n)))))))
)

:goals (
  ; Sophie wants to talk about her treatment options
  ?g1 (^me ((pres want.v) (to (talk.v (adv-a (about.p ((^me 's) (plur (treatment.n option.n)))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I want to talk about my options today \.))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) (plur option.n))))))
)

)) ; END redirect-to-options.v