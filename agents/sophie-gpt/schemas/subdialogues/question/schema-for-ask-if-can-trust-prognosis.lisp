;; *ask-if-can-trust-prognosis*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-if-can-trust-prognosis.v

'(dial-schema :header (((set-of ^me ^you) ask-if-can-trust-prognosis.v) ** ?e)
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
  ; Sophie has an uncle Fred who outlived his prognosis
  ?s2 (^me ((pres have.v) (an.d (n+preds uncle.n (= |Fred|) (who.rel ((past outlive.v) (his.d prognosis.n)))))))
)

:preconds (
  ; Sophie doesn't fully accept her prognosis
  ?p1 (^me ((pres do.aux-s) not fully.adv-a (accept.v ((^me 's) prognosis.n))))
  ; Sophie doesn't trust the user's prognosis
  ?p2 (^me ((pres do.aux-s) not (trust.v ((^you 's) prognosis.n))))
)

:goals (
  ; Sophie wants to know more about her prognosis
  ?g1 (^me ((pres want.v) (to (know.v (more.d
        (n+preds {information}.n (about.p ((^me 's) prognosis.n))))))))
  ; Sophie wants to know whether she can trust the user's prognosis
  ?g2 (^me ((pres want.v) (to (know.v (whether (^me ((pres can.aux-s) (trust.v ((^you 's) prognosis.n)))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Can I trust your prognosis ?))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n)))))
)

)) ; END ask-if-can-trust-prognosis.v