;; *discuss-radiation-symptoms*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'discuss-radiation-symptoms.v

'(dial-schema :header (((set-of ^me ^you) discuss-radiation-symptoms.v) ** ?e)
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
  ; Sophie had some hair loss and redness at the site of radiation
  ?p1 (^me ((past have.v) ((some.d (hair.n loss.n)) and.cc (k redness.n))
        (at.p-arg (the.d (n+preds site.n (of.p (k radiation.n)))))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I had some hair loss and redness at the site of radiation \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END discuss-radiation-symptoms.v