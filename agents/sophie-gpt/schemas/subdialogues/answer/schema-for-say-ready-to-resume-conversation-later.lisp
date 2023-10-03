;; *say-ready-to-resume-conversation-later*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-ready-to-resume-conversation-later.v

'(dial-schema :header (((set-of ^me ^you) say-ready-to-resume-conversation-later.v) ** ?e)
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
    ;; SOPHIE is willing to continue the conversation at a later appointment.

)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I am willing to continue the conversation at a later appointment \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-ready-to-resume-conversation-later.v