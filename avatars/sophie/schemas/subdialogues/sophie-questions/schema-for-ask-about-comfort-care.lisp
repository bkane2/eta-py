;; *ask-about-comfort-care*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-comfort-care.v

'(dial-schema :header (((set-of ^me ^you) ask-about-comfort-care.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(Should I get comfort care ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Should I get comfort care ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-about-comfort-care.v