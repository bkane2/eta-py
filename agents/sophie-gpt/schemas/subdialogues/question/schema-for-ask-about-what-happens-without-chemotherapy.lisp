;; *ask-about-what-happens-without-chemotherapy*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-what-happens-without-chemotherapy.v

'(dial-schema :header (((set-of ^me ^you) ask-about-what-happens-without-chemotherapy.v) ** ?e)
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
  ; Sophie is unsure about chemotherapy
  ?p1 (^me ((pres be.v) unsure.a (about.p-arg (k chemotherapy.n))))
)

:goals (
  ; Sophie wants to know what her treatment options are without chemotherapy
  ?g1 (^me ((pres want.v) (to (know.v (ans-to
        (sub what.pro (((^me 's) (treatment.n (plur option.n))) ((pres be.v) (= *h)
          (adv-a (without.p (k chemotherapy.n)))))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(What are my treatment options if I do not do chemotherapy ?))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates (^you be.v empowering.a))
)

)) ; END ask-about-what-happens-without-chemotherapy.v