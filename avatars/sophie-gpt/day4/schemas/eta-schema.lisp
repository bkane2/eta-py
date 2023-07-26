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
; The dialogue follows a simple sequence of phases:
; 1. The patient asks about her pain (proceeds once doctor is sufficiently empathetic)
; 2. The patient asks about her prognosis (proceeds once doctor is sufficiently explicit)
; 3. The patient asks about her treatment options (proceeds once the doctor is sufficiently empowering)
; 4. The patient tries to close the conversation (ends once the doctor says some variant of "goodbye")
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


;; (pain)
?e2 ((set-of ^me ^you) ask-about-pain.v)


;; (prognosis)
?e3 ((set-of ^me ^you) ask-about-prognosis.v)


;; (options)
?e4 ((set-of ^me ^you) ask-about-options.v)


;; (exchange-goodbyes)
?e5 ((set-of ^me ^you) exchange-goodbyes.v)

)

)) ; END have-eta-dialog.v


; TODO REFACTOR : store following topic keys:
;; (?e2 (Pain))
;; (?e3 (Prognosis))
;; (?e4 (Options))
;; (?e5 (Exchange-goodbyes))