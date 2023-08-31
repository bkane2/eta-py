;; *discuss-sleep-routine*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'discuss-sleep-routine.v

'(dial-schema :header (((set-of ^me ^you) discuss-sleep-routine.v) ** ?e)
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
  ; Sophie takes some pain medication and reads a book before she sleeps
  ?p1 (^me ((((pres take.v) (some.d (pain.n medication.n))) and.cc ((pres read.v) (a.d book.n)))
        (adv-e (before.p (ke (^me sleep.v))))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I take some pain medication and read a book before I sleep \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END discuss-sleep-routine.v