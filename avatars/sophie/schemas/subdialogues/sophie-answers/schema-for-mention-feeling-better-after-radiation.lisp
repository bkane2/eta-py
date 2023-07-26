;; *mention-feeling-better-after-radiation*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'mention-feeling-better-after-radiation.v

'(dial-schema :header (((set-of ^me ^you) mention-feeling-better-after-radiation.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:episodes (

?e1 (^me paraphrase-to.v ^you '(I was feeling a little better after radiation \.))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END mention-feeling-better-after-radiation.v