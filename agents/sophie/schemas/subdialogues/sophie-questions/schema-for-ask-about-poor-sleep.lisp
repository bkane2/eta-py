;; *ask-about-poor-sleep*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-poor-sleep.v

'(dial-schema :header (((set-of ^me ^you) ask-about-poor-sleep.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(Why have I not been sleeping well ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Why have I not been sleeping well ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-about-poor-sleep.v