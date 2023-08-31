;; *confirm-doctor-is-audible*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'confirm-doctor-is-audible.v

'(dial-schema :header (((set-of ^me ^you) confirm-doctor-is-audible.v) ** ?e)
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
  ; Sophie can hear the user
  ?p1 (^me ((pres can.aux-v) (hear.v ^you)))
)

:goals (
  ; The user wants to know whether Sophie can hear them
  ?g1 (^you ((pres want.v) (to (know.v (whether (^me ((pres can.aux-v) (hear.v ^you))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I can hear you \.))
;; ?e1 (^me say-to.v ^you ?words)
 
?e2 (^you reply-to.v ?e1)

)

)) ; END confirm-doctor-is-audible.v