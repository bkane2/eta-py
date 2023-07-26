;; *say-how-to-help*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-how-to-help.v

'(dial-schema :header (((set-of ^me ^you) say-how-to-help.v) ** ?e)
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
  ; Sophie wants the user to know that they can help by answering all of her questions
  ?g1 (^me ((pres want.v) ^you (to (know.v (that (^you ((pres can.aux-s)
        (help.v (by.p-arg (ka (answer.v (all_of.d ((^me 's) (plur question.n))))))))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(You can help me by answering all of my questions \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-how-to-help.v