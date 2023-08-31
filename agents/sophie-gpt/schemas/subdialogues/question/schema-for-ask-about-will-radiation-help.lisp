;; *ask-about-will-radiation-help*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-will-radiation-help.v

'(dial-schema :header (((set-of ^me ^you) ask-about-will-radiation-help.v) ** ?e)
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
)

:goals (
  ; Sophie wants to know whether radiation will help her
  ?g1 (^me ((pres want.v) (to (know.v (whether
        ((k radiation.n) ((pres will.aux-s) (help.v ^me))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Do you think radiation will help ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-about-will-radiation-help.v