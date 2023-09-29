;; *explain-how-doctor-mention-chemotherapy*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-how-doctor-mention-chemotherapy.v

'(dial-schema :header (((set-of ^me ^you) explain-how-doctor-mention-chemotherapy.v) ** ?e)
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
  ; Sophie's doctor talked about chemotherapy.
  ?p1 (((^me 's) doctor.n) ((past talk.v) (about.p-arg chemotherapy.n)))
  ; Sophie's doctor advised her to wait to see how the radiation worked.
  ?p2 (((^me 's) doctor.n) ((past advise.v) ^me (to (wait.v (to (see.v (sub how.pq (radiation.n (past work.v)))))))))
)

:goals (
  ; Sophie wants the user to know how she got her diagnosis
  ?g1 (^me ((pres want.v) ^you (to (know.v (ans-to (sub whether.pq (^me ((past heard.v) (about.p-arg chemotherapy.n) *h))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(My old doctor talked about chemotherapy a little but advised me to wait and see whether the radiation worked\.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END explain-how-doctor-mention-chemotherapy.v