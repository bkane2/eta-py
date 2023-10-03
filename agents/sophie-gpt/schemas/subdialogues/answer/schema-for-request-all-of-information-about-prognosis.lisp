;; *request-all-of-information-about-prognosis*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'request-all-of-information-about-prognosis.v

'(dial-schema :header (((set-of ^me ^you) request-all-of-information-about-prognosis.v) ** ?e)
;``````````````````````````````````````````````````````````````````````````````````````````````````

:types (
  !t1 (^me person.n)
  !t2 (^you person.n)
)

:rigid-conds (
  ; Sophie's name is Sophie
  !r0 (((^me 's) name.n) ((pres be.v) (= |Sophie|)))
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
  ; Sophie wants to hear all available information about her prognosis
  ?g1 (^me ((pres want.v) (to (hear.v (all.d (n+preds (available.a information.n) (about.p ((^me 's) prognosis.n))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I want to know as much information about my prognosis as you can tell me \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END request-all-of-information-about-prognosis.v