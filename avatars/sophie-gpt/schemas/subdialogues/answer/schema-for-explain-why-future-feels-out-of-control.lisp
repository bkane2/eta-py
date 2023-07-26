;; *explain-why-future-feels-out-of-control*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-why-future-feels-out-of-control.v

'(dial-schema :header (((set-of ^me ^you) explain-why-future-feels-out-of-control.v) ** ?e)
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
  ; Sophie's future feels out of control
  ?p1 (((^me 's) future.n) ((pres feel.v) (out_of.p-arg (k control.n))))
  ; Sophie does not know how much time she has remaining to live
  ?p2 (^me ((pres do.aux-s) not (know.v (ans-to (sub (how_much.d time.n)
        (^me ((pres have.v) *h (remaining.p-arg (to live.v)))))))))
)

:goals (
  ; Sophie wants the user to know why her future feels out of control
  ?g1 (^me ((pres want.v) ^you (to (know.v (ans-to (sub why.pq (((^me 's) future.n)
        ((pres feel.v) (out_of.p-arg (k control.n))))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(My future feels out of my control because I do not know how much time I have remaining to live \.))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates (^you be.v empathetic.a))
)

)) ; END explain-why-future-feels-out-of-control.v