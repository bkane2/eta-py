;; *explain-drove-today*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-drove-today.v

'(dial-schema :header (((set-of ^me ^you) explain-drove-today.v) ** ?e)
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
  ; Sophie drove here today
  ?p1 (^me ((past drive.v) here.pro today.adv-e))
)

:goals (
  ; Sophie wants to explain to the user how she travelled here today
  ?g1 (^me ((pres want.v) (to (explain.v (to.p-arg ^you)
        (ans-to (sub how.pq (^me ((past travel.v) here.pro today.adv-e *h))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I drove here today \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END explain-drove-today.v