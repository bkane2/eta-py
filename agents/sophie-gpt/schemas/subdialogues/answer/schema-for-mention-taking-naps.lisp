;; *mention-taking-naps*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'mention-taking-naps.v

'(dial-schema :header (((set-of ^me ^you) mention-taking-naps.v) ** ?e)
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
  ; Sophie usually takes a nap during the day
  ?p1 (^me usually.adv-e ((pres take.v) (a.d nap.n) (adv-e (during.p (the.d day.n)))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I usually take a nap during the day \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END mention-taking-naps.v