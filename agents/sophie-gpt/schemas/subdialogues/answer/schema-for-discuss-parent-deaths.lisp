;; *discuss-parent-deaths*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'discuss-parent-deaths.v

'(dial-schema :header (((set-of ^me ^you) discuss-parent-deaths.v) ** ?e)
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
  ; Sophie's mother died from diabetes
  ?p1 (((^me 's) mother.n) ((past die.v) (adv-a (from.p (k diabetes.n)))))
  ; Sophie's father died from prostate cancer
  ?p2 (((^me 's) father.n) ((past die.v) (adv-a (from.p (k (prostate.n cancer.n))))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(My mother died from diabetes and my father died from prostate cancer \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END discuss-parent-deaths.v