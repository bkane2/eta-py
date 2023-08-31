;; *ask-if-can-outlive-prognosis-health-practices*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-if-can-outlive-prognosis-health-practices.v

'(dial-schema :header (((set-of ^me ^you) ask-if-can-outlive-prognosis-health-practices.v) ** ?e)
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
  ; Sophie wants to be able to watch her grandson graduate
  ?s3 (^me ((pres want.v) (to (be.v able.a (to (watch.v ((^me 's) grandson.n) (ke graduate.v)))))))
)

:preconds (
  ; Sophie doesn't fully accept her prognosis
  ?p1 (^me ((pres do.aux-s) not fully.adv-a (accept.v ((^me 's) prognosis.n))))
)

:goals (
  ; Sophie wants to know more about her prognosis
  ?g1 (^me ((pres want.v) (to (know.v (more.d
        (n+preds {information}.n (about.p ((^me 's) prognosis.n))))))))
  ; Sophie wants to know whether she can outlive the user's prognosis if she has healthy habits
  ?g2 (^me ((pres want.v) (to (know.v (whether (^me ((pres can.aux-s) (outlive.v ((^you 's) prognosis.n)
        (if.ps (^me ((pres have.v) (k (healthy.a (plur habit.n))))))))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Can I outlive your prognosis if I have healthy habits ?))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n)))))
)

)) ; END ask-if-can-outlive-prognosis-health-practices.v