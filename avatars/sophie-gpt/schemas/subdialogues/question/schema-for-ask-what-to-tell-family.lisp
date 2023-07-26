;; *ask-what-to-tell-family*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-what-to-tell-family.v

'(dial-schema :header (((set-of ^me ^you) ask-what-to-tell-family.v) ** ?e)
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
  ; Sophie hasn't told her family about her cancer yet
  ?p1 (^me ((pres perf) not (tell.v ((^me 's) family.n) (about.p-arg ((^me 's) cancer.n)) yet.adv-e)))
)

:goals (
  ; Sophie wants to know what she should tell her family
  ?g1 (^me ((pres want.v) (to (know.v (ans-to (sub what.pro
        (^me ((pres should.aux-s) (tell.v ((^me 's) family.n) *h)))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(What should I tell my family ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-what-to-tell-family.v