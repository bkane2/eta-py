;; *say-preference-for-no-chemotherapy*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-preference-for-no-chemotherapy.v

'(dial-schema :header (((set-of ^me ^you) say-preference-for-no-chemotherapy.v) ** ?e)
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
    ;; Sophie thinks chemotherapy would be painful.
    ?p1 (^me ((pres think.v) (that (chemotherapy.n (pres be.v) painful.n))))
    ;; Sophie thinks chemotherapy would be exhausting.
    ?p2 (^me ((pres think.v) (that (chemotherapy.n (pres be.v) exhausting.n))))

)

:goals (
 ; Sophie wants the doctor to know she doesn't want chemotherapy.
  ?g1 (^me ((pres want.v) (^you (to (know.v (that (^me (not (pres want.v) chemotherapy.n))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Chemotherapy sounds too unpleasant and exhausting for me at this stage of my cancer \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-preference-for-no-chemotherapy.v