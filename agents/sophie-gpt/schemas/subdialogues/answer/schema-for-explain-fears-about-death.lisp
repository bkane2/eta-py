;; *explain-fears-about-death*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(store-schema 'explain-fears-about-death.v

'(dial-schema :header (((set-of ^me ^you) explain-fears-about-death.v) ** ?e)
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
  ; Sophie has a grandson.
  ?s2 (^me ((pres have.v) (k grandson.n)))
  ; Sophie has a son.
  ?s3 (^me ((pres have.v) (k son.n)))

  ; Sophie has lung cancer
  ?s4 (^me ((pres have.v) (k (lung.n cancer.n))))

)

:preconds (
  ; TODO: Sophie is less afraid of death than not being able to spend time with her family during her last months.
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I am not so concerned about death as about being unable to spend time with my family during my last months \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END explain-fears-about-death.v