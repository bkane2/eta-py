;; *ask-how-chemotherapy-works*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-how-chemotherapy-works.v

'(dial-schema :header (((set-of ^me ^you) ask-how-chemotherapy-works.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(How does chemotherapy work ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(How does chemotherapy work ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-how-chemotherapy-works.v