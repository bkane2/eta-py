;; *mention-lortab-frequency*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'test-cond.v

'(dial-schema :header (((set-of ?s ?h) test-cond.v ?words) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:types (
  !t1 (?s person.n)
  !t2 (?h person.n)
)

:rigid-conds (
  !r1 (?s ((pres be.v) (= (a.d man.n))))
  !r2 (?s ((pres be.v) ((mod-a (26.a (plur year.n))) old.a)))
)

:static-conds (
  ?s1 (?s ((pres have.v) (a.d computer.n)))
)

:preconds (
  ?p1 (?s ((pres turn_on.v) ((?s 's) computer.n)))
)

:goals (
)

:episodes (

?e1 (?s paraphrase-to.v ?h '(This is a test string \.))
 
?e2 (:repeat-until (?h say-bye.v)

  ?e3 (?s say-to.v ?h '(Test \.))

  ?e4 (?h say-to.v ?s ?response)

  ?e5 (:try-in-sequence

    (:if (?h do-nothing.v)

      ?e6 (?s say-to.v ?h '(Bye \.))
      ?e7 (?s commit-to-STM.v (that (?h say-bye.v))))

    (:else

      ?e8 (?s say-to.v ?h ?h '(Okay \.))))

)

?e9 (?s say-to.v ?h ?words)

)

:certainties (
  !c1 (!e1 0.4)
  !c2 (!e4 0.7)
)

:necessities (
  !n1 (!r2 0.6)
)

)) ; END test-cond.v