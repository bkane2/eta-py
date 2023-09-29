;; *say-preference-for-informal-language*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-preference-for-informal-language.v

'(dial-schema :header (((set-of ^me ^you) say-preference-for-informal-language.v) ** ?e)
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
  ; Sophie wants to tell her family about the prognosis alone
  ?g1 (^me ((pres want.v) (to (tell.v ((^me 's) family.n) (about.p-arg ((^me 's) prognosis.n)) alone.adv))))

  ; Sophie wants the doctor to not speak with technical language.
  ?g2 (^me ((pres want.v) (^you (not (to (speak.v (to.p me.n) ({with}.p-args (technical.a language.n))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I prefer that you not speak to me with technical language \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-preference-for-informal-language.v