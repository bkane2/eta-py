;; *ask-about-second-opinion*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-second-opinion.v

'(dial-schema :header (((set-of ^me ^you) ask-about-second-opinion.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````


:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(Should I get a second opinion on my prognosis ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Should I get a second opinion on my prognosis ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-about-second-opinion.v