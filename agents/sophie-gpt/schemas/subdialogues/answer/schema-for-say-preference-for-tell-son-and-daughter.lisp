;; *say-preference-for-tell-son-and-daughter*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-preference-for-tell-son-and-daughter.v

'(dial-schema :header (((set-of ^me ^you) say-preference-for-tell-son-and-daughter.v) ** ?e)
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
  ; Sophie accepts her prognosis.
  ?p1 (^me ((pres do.aux-v) (accept.v ((^me 's) prognosis.n))))
  ; Sophie hasn't told her family about her prognosis yet
  ?p2 (^me ((pres perf) not (tell.v ((^me 's) family.n) (about.p-arg ((^me 's) prognosis.n)) yet.adv-e)))
)

:goals (
  ; Sophie wants to tell her daughter about the prognosis
  ?g1 (^me ((pres want.v) (to (tell.v ((^me 's) daughter.n) (about.p-arg ((^me 's) prognosis.n)) (because.ps (^me ((pres live.v) with.p ((^me 's) daughter.n))))))))
  ; Sophie wants to tell her son about the prognosis
  ?g2 (^me ((pres want.v) (to (tell.v ((^me 's) son.n) (about.p-arg ((^me 's) prognosis.n))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I want to tell my son and daughter about my prognosis\, especially my daughter because I live with her \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-preference-for-tell-son-and-daughter.v