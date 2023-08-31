;; *ETA-SCHEMA*: development version 6
;;
;; TODO
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'have-eta-dialog.v

'(dial-schema :header (((set-of ^me ^you) have-eta-dialog.v) ** ?e)
;`````````````````````````````````````````````````````````````````````
; An Eta dialogue focused around a simple doctor-patient discussion, intended to test the integration
; of GPT-3 with response generation.
;
; Empowering module
;

:types (
  !t1 (^me person.n)
  !t2 (^you person.n)
)

:rigid-conds (
  ; Sophie is a woman
  !r1 (^me ((pres be.v) (= (a.d woman.n))))
  ; Sophie is 65 years old
  !r2 (^me ((pres be.v) ((mod-a (65.a (plur year.n))) old.a)))
)

:static-conds (
  ; Sophie has lung cancer
  ?s1 (^me ((pres have.v) (k (lung.n cancer.n))))
)

:episodes (

?e1 (^me say-to.v ^you '(Hi\, doctor\. I\'m meeting with you today to help get some questions answered about my condition\.))

;; (options)
?e2 ((set-of ^me ^you) ask-about-options.v)

)

)) ; END have-eta-dialog.v


; TODO REFACTOR : store following topic keys:
;; (?e2 (Options))