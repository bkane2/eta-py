;; *say-preference-facts-over-emotions*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-preference-facts-over-emotions.v

'(dial-schema :header (((set-of ^me ^you) say-preference-facts-over-emotions.v) ** ?e)
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

)

:goals (
  ; Sophie wants the doctor to not concentrate on emotions.
  ?g1 (^me ((pres want.v) (^you (not (to (concentrate.v ({on}.p-args ((^me 's) (plur emotion.n)) ) ))))))
  ; Sophie wants the doctor to concentrate on facts.
  ?g2 (^me ((pres want.v) (^you (to (concentrate.v ({on}.p-args ((^me 's) (plur emotion.n)) ) )))))


)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I prefer that you concetrate on facts rather than my emotions right now \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-preference-facts-over-emotions.v