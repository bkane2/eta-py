;; *ask-what-to-tell-family*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-what-to-tell-family.v

'(dial-schema :header (((set-of ^me ^you) ask-what-to-tell-family.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(What should I tell my family ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(What should I tell my family ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-what-to-tell-family.v