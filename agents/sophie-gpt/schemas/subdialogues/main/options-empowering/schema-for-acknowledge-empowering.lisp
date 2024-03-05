;; *acknowledge-empowering*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'acknowledge-empowering.v

'(dial-schema :header (((set-of ^me ^you) acknowledge-empowering.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:types (
  !t1 (^me person.n)
  !t2 (^you person.n)
)

:rigid-conds (
  ; Sophie's name is Sophie
  !r0 (((^me 's) name.n) ((pres be.v) (= |Sophie|)))
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
  ; Sophie is not currently getting treatment
  ?p1 (^me ((pres prog) not currently.adv-e (get.v (k treatment.n))))
  ; The user was empowering towards Sophie
  ?p2 (^you ((past be.v) empowering.a (adv-a (towards.p ^me))))
)

:goals (
)

:episodes (

?e1 (:try-in-sequence

  (:if (^you ask.v ^me (about.p-arg ((^me 's) (plur value.n))))
  
    ?e2 (^me paraphrase-to.v ^you '(Knowing that you have my values in mind helps make me more confident about my options \.
                                    I appreciate that \.))
    ?e3 (^you reply-to.v ?e2))
  
  (:else
  
    ?e2 (^me paraphrase-to.v ^you '(Thank you for giving me the chance to speak and be a part of the conversation \.))
    ?e3 (^you reply-to.v ?e2)))
    
)

)) ; END acknowledge-empowering.v