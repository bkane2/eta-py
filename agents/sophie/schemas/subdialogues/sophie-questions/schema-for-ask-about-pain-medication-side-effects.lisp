;; *ask-about-pain-medication-side-effects*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-pain-medication-side-effects.v

'(dial-schema :header (((set-of ^me ^you) ask-about-pain-medication-side-effects.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:episodes (

?e1 (^me paraphrase-to.v ^you '(What are the side effects of stronger pain medication ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-about-pain-medication-side-effects.v