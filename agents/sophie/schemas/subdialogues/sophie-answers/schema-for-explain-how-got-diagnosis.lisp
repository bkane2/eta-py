;; *explain-how-got-diagnosis*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-how-got-diagnosis.v

'(dial-schema :header (((set-of ^me ^you) explain-how-got-diagnosis.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:episodes (

?e1 (^me paraphrase-to.v ^you '(I got my diagnosis after visiting a lung doctor \.))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END explain-how-got-diagnosis.v