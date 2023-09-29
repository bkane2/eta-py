;; *say-preference-for-resuscitation*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-preference-for-resuscitation.v

'(dial-schema :header (((set-of ^me ^you) say-preference-for-resuscitation.v) ** ?e)
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
    ;; Sophie thinks resuscitation would be unnecessary.
    ?p1 (^me ((pres think.v) (that (resuscitation.n (pres be.v) unnecessary.n))))
    ;; Sophie thinks chemotherapy would be exhausting.
    ?p2 (^me ((pres think.v) (that (resuscitation.n (pres be.v) painful.n (adv-a ({for}.p ((^me 's) family.n)))))))

)

:goals (
 ; Sophie wants the doctor to know she doesn't want chemotherapy.
  ?g1 (^me ((pres want.v) (^you (to (know.v (that (^me (not (pres want.v) resuscitation.n))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I think that resuscitation could cause my family pain and is unnecessary \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-preference-for-resuscitation.v