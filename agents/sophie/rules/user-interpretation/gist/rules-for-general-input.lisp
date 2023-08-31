; This rule tree is called in the case where no specific-input pattern is matched;
; this will first try to branch to a topical question-input tree based on generic keywords,
; and if that fails, the system will try to match general question forms, with the aim of
; allowing the system to ask for a clarification.
(READRULES '*general-input*
'(
  ; Generic remarks
  1 (0 nice to .MEET you 0)
    2 ((It is nice to meet me \.)) (0 :gist)
  1 (0 I 1 .APPRECIATE 2 .AVATAR-ITEMS 0)
    2 ((You like my 6 \.)) (0 :gist)
  1 (0 thank 2 you 0)
    2 ((You are glad that I came to this appointment \.)) (0 :gist)
  1 (0 .HAPPY-WORDS 3 you 2 here 0)
    2 ((You are glad that I came to this appointment \.)) (0 :gist)
  ; If asked if family know about cancer
  1 (0 .FAMILY 2 .KNOW-GEN 0)
    2 *tell-family-question* (0 :subtree)
  1 (0 .FAMILY 3 .TELL 0)
    2 *tell-family-question* (0 :subtree)
  1 (0 .CONTACT 3 .FAMILY 0)
    2 *tell-family-question* (0 :subtree)
  ; If asked to elaborate about pain
  1 (0 .PAIN 0)
    2 *pain-question* (0 :subtree)
  ; If asked about diagnosis details
  1 (0 .DIAGNOSIS-TESTS 0)
    2 *diagnosis-details-question* (0 :subtree)
  1 (0 .DIAGNOSIS-SYMPTOM 0)
    2 *diagnosis-details-question* (0 :subtree)
  1 (0 .DIAGNOSIS-NON-SYMPTOM 0)
    2 *diagnosis-details-question* (0 :subtree)
  1 (0 .CANCER-ILLNESS 0)
    2 *diagnosis-details-question* (0 :subtree)
  ; If asked about radiation treatment
  1 (0 radiation 0)
    2 *radiation-question* (0 :subtree)
  ; If doctor mentions possibility of chemotherapy
  1 (0 .CHEMOTHERAPY 0)
    2 *chemotherapy-question* (0 :subtree)
  ; If doctor asks something about sleep
  1 (0 .SLEEP 0)
    2 *sleep-question* (0 :subtree)
  ; If doctor asks something about medicine
  1 (0 .MEDICINE-GEN 0)
    2 *medicine-question* (0 :subtree)
  ; If the doctor asks about your medical history
  1 (0 .MEDICAL-HISTORY 0)
    2 *medical-history-question* (0 :subtree)
  ; If doctor asks something about patient's energy (or mood)
  1 (0 .ENERGY 0)
    2 *energy-question* (0 :subtree)
  ; If doctor asks something about prognosis
  1 (0 prognosis 0)
    2 *prognosis-question* (0 :subtree)
  ; If asked if anyone is here with you
  1 (0 here .ANYONE-HERE-WITH-YOU 0)
    2 *appointment-question* (0 :subtree)
  1 (0 .COME .ANYONE-HERE-WITH-YOU 0)
    2 *appointment-question* (0 :subtree)
  1 (0 .DRIVE 0)
    2 *appointment-question* (0 :subtree)
  1 (0 .CHILD 0)
    2 *appointment-question* (0 :subtree)
  1 (0 .MARRIED 0)
    2 *appointment-question* (0 :subtree)
  1 (0 live 3 .ALONE 0)
    2 *appointment-question* (0 :subtree)
  ; If doctor says something about comfort care/hospice/pal
  1 (0 .PALLIATIVE .CARE 0)
    2 *comfort-care-question* (0 :subtree)
  1 (0 hospice 0)
    2 *comfort-care-question* (0 :subtree)
  ; Treatment options (general)
  1 (0 .TREATMENT-OPTION 0)
    2 *treatment-option-question* (0 :subtree)
  ; If asked about general treatment goals/priorities
  1 (0 .CANCER-FIGHT 0)
    2 *treatment-goals-question* (0 :subtree)
  1 (0 .CANCER-LIVE 0)
    2 *treatment-goals-question* (0 :subtree)
  1 (0 .CANCER-GOALS 0)
    2 *treatment-goals-question* (0 :subtree)
  ; 1 (0 positive-words 0)
  ;   2 ((Doctor expresses positive sentiment \.)) (0 :gist)
  ; Questions about SOPHIE's abilities/preferences
  1 (0)
    2 *open-ended-question* (0 :subtree)
  ; Interjections/prompts to continue
  ;; 1 (2 okay 2)
  ;;   2 ((Continue talking \.)) (0 :gist)
  ;; 1 (2 go on 2)
  ;;   2 ((Continue talking \.)) (0 :gist)
  ;; 1 (2 uh huh 2)
  ;;   2 ((Continue talking \.)) (0 :gist)
  ;; 1 (2 sure 2)
  ;;   2 ((Continue talking \.)) (0 :gist)
  1 (0 ?)
    2 ((NIL Question ?)) (0 :gist)
  1 (1 .WH_ 2 .BE 0)
    2 ((NIL Question ?)) (0 :gist)
  1 (1 .WH_ .AUX 0)
    2 ((NIL Question ?)) (0 :gist)
  1 (.AUX .NP_ 0)
    2 ((NIL Question ?)) (0 :gist)
  1 (0 .AUX .NP_ 1) ; tag question
    2 ((NIL Question ?)) (0 :gist)
  1 (0 .TAG-QUESTION) ; tag question
    2 ((NIL Question ?)) (0 :gist)
  1 (0 .TELL me 0) ; declarative question
    2 ((NIL Question ?)) (0 :gist)
;; 1 (0)
;;   2 ((NIL Gist)) (0 :gist)
))