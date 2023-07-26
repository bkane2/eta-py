;; *ask-about-antidepressant*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-antidepressant.v

'(dial-schema :header (((set-of ^me ^you) ask-about-antidepressant.v) ** ?e)
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
  ; Sophie is not currently taking antidepressants
  ?p1 (^me ((pres prog) not currently.adv-e (take.v (k (plur antidepressant.n)))))
)

:goals (
  ; Sophie wants to lessen her pain
  ?g1 (^me ((pres want.v) (to (lessen.v ((^me 's) pain.n)))))
  ; Sophie wants to know whether taking an antidepressant will help with her pain
  ?g2 (^me ((pres want.v) (to (know.v (whether ((ka (take.v (an.d antidepressant.n)))
        ((pres will.aux-s) (help.v (with.p-arg ((^me 's) pain.n))))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Will an antidepressant help with my pain ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-about-antidepressant.v