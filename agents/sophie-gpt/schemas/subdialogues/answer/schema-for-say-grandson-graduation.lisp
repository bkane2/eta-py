;; *say-grandson-graduation*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(store-schema 'say-grandson-graduation.v

'(dial-schema :header (((set-of ^me ^you) say-grandson-graduation.v) ** ?e)
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
  ; Sophie has a grandson
  ?s1 (^me ((pres have.v) (k grandson.n)))
  ; Sophie has lung cancer
  ?s2 (^me ((pres have.v) (k (lung.n cancer.n))))
  

)

:preconds (
  ; Sophie's grandson will graduate from middle school in 6 months.
  ?p1 (((^me 's) grandson.n) ((pres will.aux-s) (graduate.v
        (adv-a (from.p (k (middle.n school.n)))) (adv-e (in.p (six.d (plur month.n)))))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(My grandson will graduate from middle school in six months \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-grandson-graduation.v