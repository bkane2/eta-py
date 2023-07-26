;; *mention-trouble-concentrating*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'mention-trouble-concentrating.v

'(dial-schema :header (((set-of ^me ^you) mention-trouble-concentrating.v) ** ?e)
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
  ; Sophie has trouble concentrating
  ?p1 (^me ((pres have.v) trouble.a ({with}.p-arg (ka concentrate.v))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I have had trouble concentrating \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END mention-trouble-concentrating.v