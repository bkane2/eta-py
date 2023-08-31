;; *explain-understanding-of-condition*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-understanding-of-condition.v

'(dial-schema :header (((set-of ^me ^you) explain-understanding-of-condition.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:episodes (

?e1 (^me paraphrase-to.v ^you '(I know that my cancer has gotten worse\, but I\'m not sure how bad it is \.))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END explain-understanding-of-condition.v