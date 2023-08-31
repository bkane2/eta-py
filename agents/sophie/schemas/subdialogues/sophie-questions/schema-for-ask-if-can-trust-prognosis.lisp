;; *ask-if-can-trust-prognosis*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-if-can-trust-prognosis.v

'(dial-schema :header (((set-of ^me ^you) ask-if-can-trust-prognosis.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````


:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(Can I trust your prognosis ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Can I trust your prognosis ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-if-can-trust-prognosis.v