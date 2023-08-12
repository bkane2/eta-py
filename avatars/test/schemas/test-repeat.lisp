;; *mention-lortab-frequency*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'test-repeat.v

'(dial-schema :header (((set-of ?s ?h) test-repeat.v ?words) ** ?e)
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
 
?e2 (:repeat-until (not (?h ((pres prog) test.v (the.d system.n))))

  ?e3 (?s say-to.v ?h '(Test one \.))

  ?e4 (?s say-to.v ?h '(Test two \.))

)

)

:certainties (
)

:necessities (
)

)) ; END test-repeat.v