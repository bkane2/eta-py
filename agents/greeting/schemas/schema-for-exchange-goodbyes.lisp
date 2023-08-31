;; *exchange-goodbyes*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'exchange-goodbyes.v

'(dial-schema :header (((set-of ?s ?h) exchange-goodbyes.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:types (
  !t1 (?s person.n)
  !t2 (?h person.n)
)

:rigid-conds (
)

:static-conds (
)

:preconds (
)

:goals (
  ; Eta wants to finish the conversation
  ?g1 (?s ((pres want.v) (to (finish.v (the.d conversation.n)))))
)

:episodes (

  ;; ?e1 (?s paraphrase-to.v ?h '(Goodbye \.))
  ;; ?e1 (?s say-to.v ?h ?words)
  
  ?e2 (:repeat-until ((the.d conversation.n) be.v over.a)
  
    ;; ?e3 (?h reply-to.v ?e1)

    ;; ?e4 (?s react-to.v ?e3)

    ?e3 (?s say-to.v ?h ?words)

    ?e4 (?h reply-to.v ?e3)

  )

  ?e3 (?s paraphrase-to.v ?h '(Thank you for talking with me today \. Bye \.))
  ?e4 (?s say-bye.v)

)

;; :certainties (
;;   !c1 (!e4 0.1)
;; )

:obligations (
  !o1 (?e3 obligates (?h say-bye-to.v ?s))
)

)) ; END exchange-goodbyes.v