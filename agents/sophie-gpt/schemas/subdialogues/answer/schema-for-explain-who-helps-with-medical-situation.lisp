;; *explain-who-helps-with-medical-situation*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(store-schema 'explain-who-helps-with-medical-situation.v

'(dial-schema :header (((set-of ^me ^you) explain-who-helps-with-medical-situation.v) ** ?e)
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
  ; Sophie has a daughter
  ?s1 (^me ((pres have.v) (k daughter.n)))
  ; Sophie has lung cancer
  ?s2 (^me ((pres have.v) (k (lung.n cancer.n))))
  
  

)

:preconds (
  ; Sophie's daughter has supported her during her cancer treatment
  ?p1 (((^me 's) daughter.n) (pres perf) ((prog support.v ) ^me) (adv-e (during.p ((^me 's) (k cancer.n treatment.n)))))

)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(My daughter has supported me throughout my cancer treatment \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END explain-who-helps-with-medical-situation.v