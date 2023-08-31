;; *mention-radiation-time*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'mention-radiation-time.v

'(dial-schema :header (((set-of ^me ^you) mention-radiation-time.v) ** ?e)
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
  ; Sophie had radiation treatment for five weeks
  ?p1 (^me ((past have.v) (k (radiation.n treatment.n)) (adv-e (for.p (five.d (plur week.n))))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I had radiation treatment for five weeks \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END mention-radiation-time.v