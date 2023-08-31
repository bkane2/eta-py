;; *ask-about-will-experimental-therapies-help*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-will-experimental-therapies-help.v

'(dial-schema :header (((set-of ^me ^you) ask-about-will-experimental-therapies-help.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````


:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(Do you think experimental therapies will help ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Do you think experimental therapies will help ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-about-will-experimental-therapies-help.v