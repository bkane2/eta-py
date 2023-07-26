;; *ETA-SCHEMA*: development version 6
;;
;; TODO
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'have-eta-dialog.v

'(dial-schema :header (((set-of ^me ^you) have-eta-dialog.v) ** ?e)
;`````````````````````````````````````````````````````````````````````
; An Eta dialogue where a "suggester" listens to patient-doctor utterance,
; and provides feedback/suggestions to the doctor.
;

:episodes (

  ; Repeat prompting the user for a spatial question until finished.
  ?e1 (:repeat-until (?e1 finished2.a)

    ; Prompt the user for a spatial question.
    ?e2 (^you say-to.v ^me ?input)

    ; Either (3a) user requests goodbye, (3b) user gives some other input.
    ?e3 (:try-in-sequence

      ; (3a)
      (:if (^you say-bye.v)

        ; Store the fact that ?e1 is finished.
        ?e4 (^me commit-to-STM.v (that (?e1 finished2.a))))

      ; (3b)
      (:else

        ; Provide suggestion based on the input.
        ?e5 (^me react-to.v ?e2))))
)

)) ; END have-eta-dialog.v