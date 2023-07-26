;; *ask-why-have-cancer*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-why-have-cancer.v

'(dial-schema :header (((set-of ^me ^you) ask-why-have-cancer.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(Why do I have cancer ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Why do I have cancer ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-why-have-cancer.v