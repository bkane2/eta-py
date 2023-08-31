;; *discuss-radiation-symptoms*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'discuss-radiation-symptoms.v

'(dial-schema :header (((set-of ^me ^you) discuss-radiation-symptoms.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:episodes (

?e1 (^me paraphrase-to.v ^you '(I had some hair loss and redness at the site of radiation \.))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END discuss-radiation-symptoms.v