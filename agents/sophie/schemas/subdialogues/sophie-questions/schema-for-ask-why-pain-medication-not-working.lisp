;; *ask-why-pain-medication-not-working*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-why-pain-medication-not-working.v

'(dial-schema :header (((set-of ^me ^you) ask-why-pain-medication-not-working.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:episodes (

?e1 (^me paraphrase-to.v ^you '(Why isn\'t the pain medication working anymore ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-why-pain-medication-not-working.v