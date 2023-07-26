;; *ask-if-need-chemotherapy*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-if-need-chemotherapy.v

'(dial-schema :header (((set-of ^me ^you) ask-if-need-chemotherapy.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(Do I need chemotherapy ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Do I need chemotherapy ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-if-need-chemotherapy.v