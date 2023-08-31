;; *confirm-no-comfort-care*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'confirm-no-comfort-care.v

'(dial-schema :header (((set-of ^me ^you) confirm-no-comfort-care.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:episodes (

?e1 (^me paraphrase-to.v ^you '(Are you sure that I do not need comfort care ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END confirm-no-comfort-care.v