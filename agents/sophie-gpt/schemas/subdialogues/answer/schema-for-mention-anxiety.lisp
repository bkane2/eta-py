;; *mention-anxiety*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'mention-anxiety.v

'(dial-schema :header (((set-of ^me ^you) mention-anxiety.v) ** ?e)
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
  ; Sophie feels anxious about her future
  ?p1 (^me ((pres feel.v) anxious.a (about.p-arg ((^me 's) future.n))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I feel anxious about my future \.))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates (^you be.v empathetic.a))
)

)) ; END mention-anxiety.v