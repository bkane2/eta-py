;; *deny-symptom*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'deny-symptom.v

'(dial-schema :header (((set-of ^me ^you) deny-symptom.v) ** ?e)
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
  ; Sophie doesn't have the symptom that the user mentioned
  ?p1 (^me ((pres do.aux-s) not (have.v (the.d (n+preds symptom.n (sub that.rel (^you ((past mention.v) *h))))))))
)

:goals (
  ; The user wants to know whether Sophie has a particular symptom
  ?g1 (^you ((pres want.v) (to (know.v (whether (^me ((pres have.v) (a.d (particular.a symptom.n)))))))))
)

:episodes (

;; ?e1 (^me paraphrase-to.v ^you '(I do not have the symptom you mentioned \.))
?e1 (^me say-to.v ^you ?words)
 
?e2 (^you reply-to.v ?e1)

)

)) ; END deny-symptom.v