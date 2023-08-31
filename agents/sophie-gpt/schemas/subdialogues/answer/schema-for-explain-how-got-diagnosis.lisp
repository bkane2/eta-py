;; *explain-how-got-diagnosis*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-how-got-diagnosis.v

'(dial-schema :header (((set-of ^me ^you) explain-how-got-diagnosis.v) ** ?e)
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
  ; Sophie got her diagnosis after visiting a lung doctor
  ?p1 (^me ((past got.v) ((^me 's) diagnosis.n) (after.ps (^me ((past visit.v) (a.d (lung.n doctor.n)))))))
)

:goals (
  ; Sophie wants the user to know how she got her diagnosis
  ?g1 (^me ((pres want.v) ^you (to (know.v (ans-to (sub how.pq (^me ((past got.v) ((^me 's) diagnosis.n) *h))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I got my diagnosis after visiting a lung doctor \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END explain-how-got-diagnosis.v