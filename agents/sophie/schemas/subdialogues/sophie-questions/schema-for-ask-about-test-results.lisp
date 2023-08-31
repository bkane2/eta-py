;; *ask-about-test-results*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-test-results.v

'(dial-schema :header (((set-of ^me ^you) ask-about-test-results.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:goals (
  ?g1 (^me want.v (that (^me know.v (ans-to '(What do my test results mean ?)))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(What do my test results mean ?))
 
?e2 (^you reply-to.v ?e1)

?e3 (^me react-to.v ?e2)

)

)) ; END ask-about-test-results.v