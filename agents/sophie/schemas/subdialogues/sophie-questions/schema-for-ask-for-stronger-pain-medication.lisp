;; *ask-for-stronger-pain-medication*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-for-stronger-pain-medication.v

'(dial-schema :header (((set-of ^me ^you) ask-for-stronger-pain-medication.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(Can I have a stronger pain medication ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Can I have a stronger pain medication ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-for-stronger-pain-medication.v