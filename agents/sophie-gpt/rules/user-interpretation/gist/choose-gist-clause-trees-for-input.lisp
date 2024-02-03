; This is the top-level gist-clause interpretation rule tree, used to select an appropriate choice packet using
; the context of SOPHIE's previous question or statement. If a match fails here, the system falls back to a
; general subtree intended to match generic questions from the user.
;

(READRULES '*gist*
'(
  1 (!expr !expr) ; previous gist clause + utterance
    2 ((*gist-clause-trees-for-input* 1) (split-sentences! 2)) (0 :subtrees-permute)
))


(READRULES '*gist-clause-trees-for-input*
'(
  ; It's assumed that Sophie only answers these questions in the very beginning,
  ; so they should redirect back to the topic of the first schema in the dialogue.
  1 (:or
    (3 .NICE 1 .MEET you 3 \.)
    (you .CAN .CALL me sophie \.)
    (.SELF .CAN 1 .HEAR 1 \.))
    2 (*pain-input*
       *general-input*) (0 :raw)

  1 (:or
    (.BE 1 .REASON 3 .PAIN 3 .MAKE-WORSE 1 ?)
    (why 3 .PAIN 3 .MAKE-WORSE 1 ?)
    (what 2 .CAUSE 2 .PAIN 2 .MAKE-WORSE 1 ?)
    (2 .PAIN 3 getting worse \.)
    (3 cancer 2 .MAKE-WORSE .BECAUSE 2 .PAIN 3 .MAKE-WORSE \.))
    2 (*pain-input*
       *general-input*) (0 :raw)

  1 (:or
    (3 what 2 .MY-REF .PROGNOSIS-WORD 3 ?)
    (3 what 3 .DIAGNOSIS-INDICATE for 1 .PROGNOSIS-WORD ?)
    (3 .SELF .KNOW 3 .CANCER-ILLNESS 2 .MAKE-WORSE 1 .BUT 2 .NEG sure 2 how .BAD 3 \.)
    (2 .WANT 3 .DISCUSS 2 .PROGNOSIS-WORD 2 \.)
    (3 how 1 .PROGNOSIS-MORE 3 .SELF have 3 ?)
    (3 .KNOW 2 my .PROGNOSIS-WORD 2 \.)
    (3 what 2 .CANCER-ILLNESS 1 .DIAGNOSIS-INDICATE 3 .PROGNOSIS-WORD ?)
    (3 how bad 2 .PROGNOSIS-WORD 2 ?)
    (4 .NEG 2 understand 1 .PROGNOSIS-WORD \.))
    2 (*prognosis-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .WH_ 2 .BE 5 .TREATMENT-OPTION 2 ?)
    (4 .WH_ 2 .TREATMENT-OPTION 3 do 2 .SELF 8 ?)
    (4 .WH_ 2 .BE 5 .TREATMENT-OPTION 3 .SELF 3 .NEG 3 .CHEMOTHERAPY 2 ?)
    (4 .WH_ 2 .BE 5 .CANCER-GOALS 5 ?)
    (4 .THINK-GEN 2 .ANXIETY-WORD 5 .WH_ 1 .TREATMENT-OPTION 0)
    (4 .SELF 2 .WANT-GEN 3 .UNDERSTAND-GEN 5 .TREATMENT-OPTION 1 .HELP 6 .CANCER-GOALS 0)
    (0 .NEG 1 .ADDRESS 4 .CANCER-GOALS 0)
    (0 .WH_ 2 .TREATMENT-OPTION 5 .BE 3 .BENEFICIAL 0)
    (0 .WH_ 2 .TREATMENT-OPTION 5 .SOUND 3 .BENEFICIAL 0)
    (0 .SELF 2 .NEG 1 .UNDERSTAND-GEN 3 .WH_ 2 do 3)
    (0 .SELF 2 feel lost \. 3 so much to handle 0))
    2 (*treatment-option-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 why 1 .SELF .NEG 2 .SLEEP 1 .OKAY 2 ?)
    (4 why 1 .SELF 3 .SLEEP 5 ?)
    (3 .SELF 1 .HAVE 3 .NEG 2 .SLEEP 1 .OKAY 2 \.)
    (3 .SELF 1 .HAVE 3 .SLEEP 5 \.))
    2 (*sleep-poorly-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 how 2 .SELF 1 .KNOW-GEN 3 .INTEROG 5 .MEDICINE-GEN 3 .MED-HELP 3 ?)
    (4 why 4 .MEDICINE-GEN 2 .MED-HELP 3 ?)
    (3 .SELF 4 .MEDICINE-GEN 2 .NEG 2 .MED-HELP 3 \.))
    2 (*medicine-working-input*
        *general-input*) (0 :raw)

  1 (:or
    (2 .MODAL 2 .SELF 1 .MED-TAKE 2 .MED-BETTER 2 .MEDICINE-GEN 2 ?)
    (2 .MODAL 3 .MED-GIVE 2 .MED-BETTER 2 .MEDICINE-GEN 2 ?)
    (3 .SELF 2 .WANT-GEN 5 .MED-BETTER 2 .MEDICINE-GEN 2 \.))
    2 (*medicine-stronger-request-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .WH_ 1 .DO 2 .SELF 3 .DIAGNOSIS-TESTS 2 .DIAGNOSIS-INDICATE 2 ?)
    (3 .ANXIETY-WORD 5 .CANCER-ILLNESS 2 \.)
    (3 .SELF 2 .THINK-GEN 2 you 3 .KNOW-GEN 3 how 1 .DIFFICULT 8)
    (3 .SELF 2 .THINK-GEN 2 .SELF 2 .HANDLE 4 now 0)
    (0 you 1 .TELL 2 .SELF 6 .CANCER-ILLNESS 4 ?)
    (0 you 1 .TELL 2 .SELF 6 .DIAGNOSIS-TESTS 4 ?)
    (0 .WH_ 1 .DO 2 you 3 .KNOW-GEN 2 .SELF 2 .CANCER-ILLNESS 4 ?)
    (0 .SELF 6 .DIAGNOSIS-TESTS 8 they .DIAGNOSIS-INDICATE 2 ?))
    2 (*test-results-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 why 2 .SELF 2 .HAVE 1 .CANCER-ILLNESS 2 ?))
    2 (*reason-for-cancer-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .WH_ 2 .MODAL 3 .TELL 3 .FAMILY 8 ?))
    2 (*tell-family-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .AUX-BASE 3 .SELF 2 need 2 .CHEMOTHERAPY 5 ?)
    (4 .MODAL 3 .CHEMOTHERAPY 3 .HELP 5 ?)
    (4 .MODAL 3 .SELF 3 .CHEMOTHERAPY 5 ?)
    (4 .DO 2 .THINK-GEN 3 .CHEMOTHERAPY 3 .HELP 5 ?)
    (4 .DO 2 .THINK-GEN 3 .SELF 2 need 2 .CHEMOTHERAPY 5 ?)
    (4 .DO 2 .THINK-GEN 3 .CHEMOTHERAPY 2 .BE 4 .TREATMENT-OPTION 5 ?))
    2 (*chemotherapy-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 how 4 .COMFORT-CARE-WORD 2 .WORK 5 ?)
    (4 .AUX-BASE 3 .SELF 2 need 2 .COMFORT-CARE-WORD 5 ?)
    (4 .MODAL 3 .COMFORT-CARE-WORD 3 .HELP 5 ?)
    (4 .MODAL 3 .SELF 3 .COMFORT-CARE-WORD 5 ?)
    (4 .DO 2 .THINK-GEN 3 .COMFORT-CARE-WORD 3 .HELP 5 ?)
    (4 .DO 2 .THINK-GEN 3 .SELF 2 need 2 .COMFORT-CARE-WORD 5 ?)
    (4 .DO 2 .THINK-GEN 3 .COMFORT-CARE-WORD 2 .BE 4 .TREATMENT-OPTION 5 ?)
    (5 .HEAR 3 about 5 .COMFORT-CARE-WORD 0))
    2 (*comfort-care-input*
       *general-input*) (0 :raw)

  1 (:or
    (2 .BE 1 you .CERTAIN 3 .SELF 1 .NEG 1 need 3 .COMFORT-CARE-WORD 5 ?))
    2 (*comfort-care-verification-input*
       *general-input*) (0 :raw)

  1 (:or
    (.SELF 2 .BE here 2 .ALONE 3 \.))
    2 (*appointment-input*
       *general-input*) (0 :raw)

  1 (:or
    (.SELF 3 .DIAGNOSIS-TESTS 2 after 3 .LUNG doctor 3 \.)
    (.SELF 2 .HAVE 2 .LOSE 3 weight 3 \.))
    2 (*diagnosis-details-input*
       *general-input*) (0 :raw)

  1 (:or
    (.SELF 2 .MED-PAST 2 .RADIATION-TREATMENT 5 \.)
    (.SELF 2 was 1 .FEELING 3 .RADIATION-HELP 3 .RADIATION-TREATMENT 5 \.))
    2 (*radiation-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .DO 1 .THINK-GEN 3 radiation 3 .HELP 5 ?))
    2 (*radiation-verification-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .WH_ .BE 4 .RESULT 1 of 2 .CHEMOTHERAPY 5 ?)
    (0 side .EFFECT 3 .CHEMOTHERAPY 0)
    (4 how 3 .CHEMOTHERAPY 3 .WORK 5 ?))
    2 (*chemotherapy-details-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .DO 1 .THINK-GEN 2 .EXPERIMENTAL .TREATMENT 4 .HELP 5 ?))
    2 (*experimental-therapy-input*
       *general-input*) (0 :raw)

  1 (:or
    (.SELF 3 .SIDE-EFFECT-FATIGUE 2 \.)
    (.SELF 3 .TROUBLE .CONCENTRATE 2 \.)
    (.SELF 3 .FEELING 2 .MENT-HEALTH 5 \.)
    (3 .MODAL 3 .ANTIDEPRESSANT 2 .HELP 5 ?)
    (3 .MODAL 2 .SELF .TRY 3 .MEDICINE-GEN 3 .BEFORE 3 .THERAPY 3 ?)
    (3 .SELF 2 future 3 out of 2 control 0))
    2 (*energy-input*
       *general-input*) (0 :raw)

  1 (:or
    (.SELF 2 .HAVE 1 .ALLERGY 3 .MEDICINE-GEN 5 \.)
    (.SELF 4 .MED-TAKE 1 .MEDICINE-GEN 5 \.)
    (3 .MED-TAKE 3 .MEDICINE-TAKING 3 .FREQUENTLY 5 \.)
    (3 .MED-TAKE 3 .MEDICINE-TAKING 5 .MED-TIME 5 \.)
    (3 .NEG 2 .HISTORY 3 .MED-ADDICTION 5 \.))
    2 (*medicine-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .WH_ 1 .BE 4 .RESULT 1 of 2 .MED-BETTER 2 .MEDICINE-GEN 5 ?))
    2 (*medicine-side-effects-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .MODAL 1 .SELF 3 .MED-ADDICTION 5 ?))
    2 (*medicine-side-effects-addiction-input*
       *general-input*) (0 :raw)

  1 (:or
    (.SELF 2 .HISTORY 3 .MED-ADDICTION 0)
    (.SELF 2 .NEG .DRINK 2 .NOW 0)
    (.SELF 2 .HISTORY 3 .SMOKE 0)
    (.SELF 2 .QUIT 1 .SMOKE 0)
    (8 .FAMILY 4 .HISTORY 2 .MENT-HEALTH 5 \.)
    (4 .MOTHER 8 diabetes 5 \.)
    (4 .FATHER 8 prostate 5 \.))
    2 (*medical-history-input*
       *general-input*) (0 :raw)

  1 (:or
    (5 refill 2 .MEDICINE-GEN 5 \.))
    2 (*medicine-refill-request-input*
       *general-input*) (0 :raw)

  1 (:or
    (5 .CANCER-ILLNESS 2 .CANCER-WORSE 5 ?))
    2 (*cancer-worse-input*
       *general-input*) (0 :raw)
  
  1 (:or
    (4 you .CERTAIN 4 .CANCER-ILLNESS 3 .NEG 2 .CANCER-WORSE 5 ?)
    (4 you .CERTAIN 4 .CANCER-ILLNESS 3 isn\'t 2 .CANCER-WORSE 5 ?))
    2 (*cancer-worse-verification-input*
       *general-input*) (0 :raw)
  
  1 (:or
    (4 .MODAL 2 .MED-BETTER 3 .MEDICINE-GEN 1 .HELP 2 .SLEEP 5 ?))
    2 (*stronger-medicine-help-sleep-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .MODAL 2 .SELF 3 .SECOND 1 .OPINION-GEN 3 .PROGNOSIS-WORD 5 ?))
    2 (*prognosis-second-opinion-input*
       *prognosis-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .MODAL 2 .SELF 2 .TRUST 3 .PROGNOSIS-WORD 5 ?)
    (4 .NEG 1 .CERTAIN 1 .SELF 2 .TRUST 3 .PROGNOSIS-WORD 5 \.)
    (0 .NEG way 2 .PROGNOSIS-WORD 2 .BE 1 .ACCURATE 0)
    (0 .SELF 2 .NEG 2 .TRUST 3 .PROGNOSIS-WORD 0)
    (0 .SELF 2 don\'t 2 .TRUST 3 .PROGNOSIS-WORD 0)
    (0 .SELF 2 .NEG see 1 you 3 .KNOW 0)
    (0 .SELF 2 don\'t see 1 you 3 .KNOW 0)
    (0 .NEG way 3 .CANCER-ILLNESS 2 .BE 1 terminal 0)
    (0 .SELF 1 .KNOW-GEN 4 .PROGNOSIS-MORE 1 .TIME-WORDS 0))
    2 (*prognosis-trust-input*
       *prognosis-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .MODAL 1 .SELF 2 .OUTLIVE 2 .PROGNOSIS-WORD 3 .UNCLE 5 ?)
    (4 any chance 3 .SELF 2 .OUTLIVE 2 .PROGNOSIS-WORD 3 .UNCLE 5 ?)
    (0 .SELF 3 .UNCLE 5 .OUTLIVE 2 .PROGNOSIS-WORD 0))
    2 (*prognosis-bargaining-uncle-input*
       *prognosis-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .MODAL 1 .SELF 2 .OUTLIVE 2 .PROGNOSIS-WORD 4 .GOOD-HEALTH .HABIT 5 ?))
    2 (*prognosis-bargaining-habits-input*
       *prognosis-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .MODAL 1 .SELF 2 .OUTLIVE 2 .PROGNOSIS-WORD 4 .QUIT .SMOKE 5 ?))
    2 (*prognosis-bargaining-quit-smoke-input*
       *prognosis-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .MODAL 1 .SELF 2 .OUTLIVE 2 .PROGNOSIS-WORD 4 .GOOD-HEALTH 1 .NOW 5 ?)
    (0 .SELF .FEELING 1 .OKAY 1 other than 2 .PAIN 5 \.))
    2 (*prognosis-bargaining-now-input*
       *prognosis-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .MODAL 1 .SELF 2 .OUTLIVE 2 .PROGNOSIS-WORD 5 .GRAD-WORDS 5 ?)
    (6 .OUTLIVE 4 .BE there 4 .FAMILY 5 \.)
    (0 .SELF 4 .KNOW-GEN 3 .INTEROG 8 .GRAD-WORDS 0)
    (0 .BE 3 chance 8 .GRAD-WORDS 0)
    (0 .SELF 4 .WANT-GEN 9 .GRAD-WORDS 0)
    (4 .BE 1 .ANYTHING 5 .IMPROVE 1 .PROGNOSIS-WORD 8 .GRAD-WORDS 5 ?))
    2 (*prognosis-bargaining-graduation-input*
       *prognosis-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .MODAL 1 .SELF 2 .OUTLIVE 2 .PROGNOSIS-WORD 0)
    (0 how 1 you 4 .KNOW-GEN 2 .PROGNOSIS-WORD 3 .CERTAIN 0))
    2 (*prognosis-bargaining-input*
       *prognosis-input*
       *general-input*) (0 :raw)

  1 (:or
    (4 .MODAL you 2 .REPHRASE 2 .QUESTION 5 ?)
    (4 .WH_ .BE 2 .QUESTION 5 ?))
    2 (*ask-for-questions-input*
       *general-input*) (0 :raw)

  1 (:or
    (.BYE 3 \.))
    2 (*say-bye-input*
       *general-input*) (0 :raw)

  1 (0)
    2 (*general-input*) (0 :raw)
))