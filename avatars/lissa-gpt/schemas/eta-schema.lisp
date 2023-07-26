;; *ETA-SCHEMA*: development version 6
;;
;; TODO
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'have-eta-dialog.v

'(dial-schema :header (((set-of ^me ^you) have-eta-dialog.v) ** ?e)
;`````````````````````````````````````````````````````````````````````
; Lissa elderly dialogue

:types (
  !t1 (^me person.n)
  !t2 (^you person.n)
)

:episodes (

;; ?e1 ((set-of ^me ^you) have-getting-to-know-dialog.v)

;; ?e2 ((set-of ^me ^you) have-where-are-you-from-dialog.v)

?e3 ((set-of ^me ^you) discuss-activities.v)

?e4 ((set-of ^me ^you) exchange-goodbyes.v)

)

)) ; END have-eta-dialog.v