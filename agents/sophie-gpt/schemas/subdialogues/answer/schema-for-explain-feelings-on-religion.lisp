;; *explain-feelings-on-religion*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(store-schema 'explain-feelings-on-religion.v

'(dial-schema :header (((set-of ^me ^you) explain-feelings-on-religion.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

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
  ; Sophie was a part of the Protestant church.
  ; Sophie grew apart from the church after her children grew up.

  ; Sophie has lung cancer
  ?s2 (^me ((pres have.v) (k (lung.n cancer.n))))

)

:preconds (
  ; Sophie believes in a heaven but still finds death scary.
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I was a part of the Protestant church until my kids grew up and I do believe in a heaven \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END explain-feelings-on-religion.v