;; *explain-why-future-feels-out-of-control*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'explain-why-future-feels-out-of-control.v

'(dial-schema :header (((set-of ^me ^you) explain-why-future-feels-out-of-control.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:episodes (

?e1 (^me paraphrase-to.v ^you '(My future feels out of my control because I do not know how much time I have remaining to live \.))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END explain-why-future-feels-out-of-control.v