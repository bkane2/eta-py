;; *confirm-no-comfort-care*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'confirm-no-comfort-care.v

'(dial-schema :header (((set-of ^me ^you) confirm-no-comfort-care.v) ** ?e)
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
  ; The user doesn't think Sophie needs comfort care
  ?p1 (^you ((pres do.aux-s) not (think.v (tht (^me ((pres need.v) (k (comfort.n care.n))))))))
)

:goals (
  ; Sophie wants to know more about her treatment options
  ?g1 (^me ((pres want.v) (to (know.v more.a (about.p-arg ((^me 's) (treatment.n (plur option.n))))))))
  ; Sophie wants to confirm that the user does not think she needs comfort care
  ?g2 (^me ((pres want.v) (to (confirm.v (that (^you ((pres do.aux-s) not (think.v
        (tht (^me ((pres need.v) (k (comfort.n care.n)))))))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Are you sure that I do not need comfort care ?))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg (k (comfort.n care.n))))))
)

)) ; END confirm-no-comfort-care.v