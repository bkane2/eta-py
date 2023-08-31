;; *ETA-SCHEMA*: development version 6
;;
;; TODO
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'have-eta-dialog.v

'(dial-schema :header (((set-of ^me ^you) have-eta-dialog.v) ** ?e)
;`````````````````````````````````````````````````````````````````````
; Toy greeting dialogue

:types (
  !t1 (^me person.n)
  !t2 (^you person.n)
)

:episodes (

?e1 (^me exchange-greetings.v ^you)

?e10 ((set-of ^me ^you) exchange-goodbyes.v)

)

)) ; END have-eta-dialog.v