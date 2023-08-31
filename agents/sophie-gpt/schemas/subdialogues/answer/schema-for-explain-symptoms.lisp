;; *explain-symptoms*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-symptoms.v

'(dial-schema :header (((set-of ^me ^you) explain-symptoms.v) ** ?e)
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
  ; Sophie has pain
  ?s2 (^me ((pres have.v) (k pain.n)))
  ; Sophie has constipation
  ?s3 (^me ((pres have.v) (k constipation.n)))
  ; Sophie's appetite is worse
  ?s4 (((^me 's) appetite.n) ((pres be.v) worse.a))
)

:preconds (
)

:goals (
  ; Sophie wants the user to know her symptoms
  ?g1 (^me ((pres want.v) ^you (to (know.v ((^me 's) (plur symptom.n))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I have pain and constipation and my appetite is worse \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END explain-symptoms.v