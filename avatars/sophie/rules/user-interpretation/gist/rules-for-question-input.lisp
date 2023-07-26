; The rules defined in this file are checked if no specific-input rules (in the context of SOPHIE's question)
; are previously matched. As such, these rules generally check general questions from the user.
;
; NOTE: some specific-input rules might redirect here using a :subtree+clause directive, if an equivalent
; question is asked by the user in the context of SOPHIE's question, in which case context will first be added
; to the clause provided to these trees.
;
; All trees defined in this file should be named using format *<topic-key>-question*.
;
; Current list of topics:
; - cancer-worse
; - medical-history
; - medicine-side-effects
; - appointment
; - chemotherapy-details
; - diagnosis-details
; - energy
; - medicine
; - pain
; - radiation
; - sleep
; - chemotherapy
; - comfort-care
; - medicine-request
; - medicine-working
; - prognosis
; - sleep-poorly
; - tell-family
; - test-results
; - treatment-option
; - treatment-goals
; - open-ended-question
(READRULES '*cancer-worse-question*
'(
)) ; END *cancer-worse-question*


(READRULES '*medical-history-question*
; (0 medical-history 0)
'(
  ; How often do you drink?
  1 (0 how 1 .FREQUENTLY 5 .DRINK 0)
    2 ((What is my history with alcohol ?) (Medical-history)) (0 :gist)
  1 (0 .DO 1 .PRON 5 .DRINK 0)
    2 ((What is my history with alcohol ?) (Medical-history)) (0 :gist)
  1 (0 .AUX-BASE 1 .PRON 5 .DRINK 0)
    2 ((What is my history with alcohol ?) (Medical-history)) (0 :gist)
  ; How often do you smoke?
  1 (0 how 1 .FREQUENTLY 5 .SMOKE 0)
    2 ((What is my history with smoking ?) (Medical-history)) (0 :gist)
  1 (0 .DO 1 .PRON 5 .SMOKE 0)
    2 ((What is my history with smoking ?) (Medical-history)) (0 :gist)
  1 (0 .AUX-BASE 1 .PRON 5 .SMOKE 0)
    2 ((What is my history with smoking ?) (Medical-history)) (0 :gist)
  ; What is your family's history with mental health ?
  1 (0 .AUX-BASE 1 .FAMILY 5 .HISTORY 5 .MENT-HEALTH 0)
    2 ((Does my family have a history of mental illness ?) (Medical-history)) (0 :gist)
  1 (0 .HAVE 8 .FAMILY 3 .EXPERIENCED 5 .MENT-HEALTH 0)
    2 ((Does my family have a history of mental illness ?) (Medical-history)) (0 :gist)
  1 (0 .HISTORY 3 .MENT-HEALTH 0)
    2 ((Does my family have a history of mental illness ?) (Medical-history)) (0 :gist)
  1 (0 .FAMILY 1 .AUX-BASE 5 .HISTORY 5 .MENT-HEALTH 0)
    2 ((Does my family have a history of mental illness ?) (Medical-history)) (0 :gist)
  ; Are your parents still alive?
  1 (0 .AUX-BASE 1 .PARENT 3 alive 0)
    2 ((How did my parents die ?) (Medical-history)) (0 :gist)
  1 (0 .AUX-BASE 1 .PARENT 3 .DIE 0)
    2 ((How did my parents die ?) (Medical-history)) (0 :gist)
  1 (0 .WH_ 2 .AUX-BASE 3 .PARENT 3 .DIE 0)
    2 ((How did my parents die ?) (Medical-history)) (0 :gist)
  ; Have you ever taken any other drugs?
  1 (0 .AUX-BASE 1 .PRON 3 .RECREATIONAL 0)
    2 ((Have I ever taken any other drugs ?) (Medical-history)) (0 :gist)
  1 (0 .PRON 1 .AUX-BASE 3 .RECREATIONAL 0)
    2 ((Have I ever taken any other drugs ?) (Medical-history)) (0 :gist)
  1 (0 .PRON 3 .HISTORY 3 .RECREATIONAL 0)
    2 ((Have I ever taken any other drugs ?) (Medical-history)) (0 :gist)
)) ; END *medical-history-question*


(READRULES '*medicine-side-effects-question*
'(
)) ; END *medicine-side-effects-question*


(READRULES '*appointment-question*
; (0 here anyone-here-with-you 0)
; (0 come anyone-here-with-you 0)
; (0 drive 0)
; (0 child 0)
; (0 married 0)
'(
  ; Did you drive here?
  1 (0 .DRIVE 0)
    2 ((Did I drive here ?)) (0 :gist)
  ; Is anyone here with you?
  1 (0 .BE you here 1 with 0)
    2 ((Is anyone here with me ?)) (0 :gist)
  1 (0 anyone .BE here 1 with you 0)
    2 ((Is anyone here with me ?)) (0 :gist)
  1 (0 who .BE here 1 with you 0)
    2 ((Is anyone here with me ?)) (0 :gist)
  1 (0 did you .COME with 0)
    2 ((Is anyone here with me ?)) (0 :gist)
  1 (0 .BE 1 here 1 with you 0)
    2 ((Is anyone here with me ?)) (0 :gist)
  1 (0 .BE you here .ALONE 0)
    2 ((Is anyone here with me ?)) (0 :gist)
  1 (0 did you .COME by yourself 0)
    2 ((Is anyone here with me ?)) (0 :gist)
  1 (0 who came with you 0)
    2 ((Is anyone here with me ?)) (0 :gist)
  1 (0 .COME here with 0)
    2 ((Is anyone here with me ?)) (0 :gist)
  ; Asking about where your daughter works
  1 (0 where does 3 .WORK 0)
    2 (0 she 0)
      3 ((Where does my daughter work ?) (Anyone-here-with-you)) (0 :gist)
    2 (0 your .DAUGHTER 0)
      3 ((Where does my daughter work ?) (Anyone-here-with-you)) (0 :gist)
    2 (0 he 0)
      3 ((Where does my son work ?) (Anyone-here-with-you)) (0 :gist)
    2 (0 your .SON 0)
      3 ((Where does my son work ?) (Anyone-here-with-you)) (0 :gist)
  1 (0 how old .BE 0)
    2 (0 she 0)
      3 ((How old is my daughter ?)) (0 :gist)
    2 (0 your .DAUGHTER 0)
      3 ((How old is my daughter ?)) (0 :gist)
    2 (0 he 0)
      3 ((How old is my son ?)) (0 :gist)
    2 (0 your .SON 0)
      3 ((How old is my son ?)) (0 :gist)
  ; Do you have grandchildren or children?
  1 (0 grandchildren 0)
    2 ((Do I have any grandchildren ?) (Anyone-here-with-you)) (0 :gist)
  1 (0 grandchild 0)
    2 ((Do I have any grandchildren ?) (Anyone-here-with-you)) (0 :gist)
  1 (0 children 0)
    2 ((Do I have any children ?) (Anyone-here-with-you)) (0 :gist)
  1 (0 .CHILD 0)
    2 ((Do I have any children ?) (Anyone-here-with-you)) (0 :gist)
  ; Were you ever married?
  1 (0 .MARRIED 0)
    2 ((Am I married ?) (Anyone-here-with-you)) (0 :gist)
  ; Do you live alone?
  1 (0 .AUX 1 you 2 live 2 .ALONE 0)
    2 ((Do I live alone ?)) (0 :gist)
;; 1 (0)
;;   2 ((NIL Gist)) (0 :gist)
)) ; END *appointment-question*


(READRULES '*chemotherapy-details-question*
'(
)) ; END *chemotherapy-details-question*


(READRULES '*diagnosis-details-question*
; (0 diagnosis-tests 0)
; (0 diagnosis-symptom 0)
; (0 diagnosis-non-symptom 0)
; (0 cancer-illness 0)
'(
  ; How much weight have you lost?
  1 (0 how .MUCH .SYMPTOM-WEIGHT 0 .LOSE 0)
    2 ((How much weight have I lost ?) (Weight-loss)) (0 :gist)
  1 (0 .DO .PRON 2 .LOSE 3 .MUCH 0 .SYMPTOM-WEIGHT 0)
    2 ((How much weight have I lost ?) (Weight-loss)) (0 :gist)
  1 (0 .HAVE .PRON 2 .LOSE 3 .MUCH 0 .SYMPTOM-WEIGHT 0)
    2 ((How much weight have I lost ?) (Weight-loss)) (0 :gist)
  ; What symptoms do you have?
  1 (0 .WH_ 1 .SYMPTOM 0)
    2 ((What symptoms do I have ?) (Symptoms)) (0 :gist)
  1 (0 .DO .PRON 3 .SYMPTOM 0)
    2 ((What symptoms do I have ?) (Symptoms)) (0 :gist)
  1 (0 .MORE-INFO 4 .SYMPTOM 0)
    2 ((What symptoms do I have ?) (Symptoms)) (0 :gist)
  1 (0 .HAVE .PRON 5 .DIAGNOSIS-SYMPTOM 0)
    2 (0 .SYMPTOM-WEIGHT 0)
      3 ((Have I changed weight ?) (Symptoms)) (0 :gist)
    2 (0 .SYMPTOM-APPETITE 0)
      3 ((Have I changed appetite ?) (Symptoms)) (0 :gist)
  1 (0 .BE there 2 .SYMPTOM 0)
    2 ((What symptoms do I have ?) (Symptoms)) (0 :gist)
  1 (0 .BE you 2 .FEELING 2 .SYMPTOM 0)
    2 ((What symptoms do I have ?) (Symptoms)) (0 :gist)
  ; Do you have [non-symptom]?
  1 (1 .DO 0 .DIAGNOSIS-NON-SYMPTOM 0)
    2 ((Do I have the symptom of 4 ?) (Symptoms)) (0 :gist)
  1 (1 .HAVE 0 .DIAGNOSIS-NON-SYMPTOM 0)
    2 ((Do I have the symptom of 4 ?) (Symptoms)) (0 :gist)
  1 (0 any .DIAGNOSIS-NON-SYMPTOM 0)
    2 ((Do I have the symptom of 3 ?) (Symptoms)) (0 :gist)
  ; Do you understand your test results?
  1 (8 .WH_ .DIAGNOSIS-TESTS .DIAGNOSIS-TESTS 6)
    2 ((What test results am I referring to ?) (Test-results)) (0 :gist)
  1 (8 .WH_ .DIAGNOSIS-TESTS 6)
    2 ((What test results am I referring to ?) (Test-results)) (0 :gist)
  1 (8 .AUX-BASE 2 you .UNDERSTAND-GEN 3 .DIAGNOSIS-TESTS 0)
    2 ((Do I know what the tests say ?) (Test-results)) (0 :gist)
  1 (0 .CAN 2 you 6 .UNDERSTAND-GEN 0)
    2 ((Do I know what the tests say ?) (Test-results)) (0 :gist)
  1 (0 .WH_ 6 .BE 2 your 2 understanding 0)
    2 ((Do I know what the tests say ?) (Test-results)) (0 :gist)
  ; Can you explain your test results?
  1 (0 .CAN 2 you .SUMMARIZE 3 .DIAGNOSIS-TESTS 0)
    2 ((Can I summarize my test results ?) (Test-results)) (0 :gist)
  1 (0 .GIVE 1 me 2 .SUMMARY 3 .DIAGNOSIS-TESTS 0)
    2 ((Can I summarize my test results ?) (Test-results)) (0 :gist)
  1 (0 .TELL 1 me 3 more 2 about 3 .DIAGNOSIS-TESTS 0)
    2 ((Can I summarize my test results ?) (Test-results)) (0 :gist)
  ; You had tests recently, right?
  1 (0 you 3 .DIAGNOSIS-TESTS 3 .RECENTLY 0)
    2 ((What test results am I referring to ?) (Test-results)) (0 :gist)
  ; How did you get your diagnosis?
  1 (0 what 2 .BRING you 0)
    2 ((How did I get my diagnosis ?) (Diagnosis-details)) (0 :gist)
  1 (0 what 1 .BEFORE 1 to 2 diagnosis 0)
    2 ((How did I get my diagnosis ?) (Diagnosis-details)) (0 :gist)
  1 (0 what 2 .BEFORE 0 diagnosis 0)
    2 ((How did I get my diagnosis ?) (Diagnosis-details)) (0 :gist)
  1 (0 how .DO 3 .KNOW 0 diagnosis 0)
    2 ((How did I get my diagnosis ?) (Diagnosis-details)) (0 :gist)
  1 (0 how 0 find out 0 diagnosis 0)
    2 ((How did I get my diagnosis ?) (Diagnosis-details)) (0 :gist)
  ; How has your condition gotten worse?
  1 (0 .WH_ 1 you mean 10 .CANCER-ILLNESS 3 worse 0)
    2 ((How has my condition gotten worse ?) (Diagnosis-details)) (0 :gist)
  1 (0 .WH_ 1 .BE worse 3 your .CANCER-ILLNESS 0)
    2 ((How has my condition gotten worse ?) (Diagnosis-details)) (0 :gist)
  1 (0 how 3 .CANCER-ILLNESS 3 worse 0)
    2 ((How has my condition gotten worse ?) (Diagnosis-details)) (0 :gist)
)) ; END *diagnosis-details-question*


(READRULES '*energy-question*
; (0 energy 0)
'(
  1 (0 .AUX-BASE 2 you 2 .MENT-HEALTH 2 about 0)
    2 (- 0 .WH_ 0)
      3 ((Is something harming my mental health ?) (Energy)) (0 :gist)
  1 (0 .AUX-BASE 5 .MENT-HEALTH 5)
    2 (- 0 .WH_ 0)
      3 ((How is my mental health ?) (Energy)) (0 :gist)
  1 (0 .TROUBLE 1 .CONCENTRATE 0)
    2 ((Have I had trouble concentrating ?) (Energy)) (0 :gist)
  1 (0 you 1 .HAVE 1 .ENERGY 0)
    2 ((How is my energy ?) (Energy)) (0 :gist)
  1 (0 .TROUBLE 1 .ENERGY 0)
    2 ((How is my energy ?) (Energy)) (0 :gist)
  1 (0 .MED-TAKE 5 .ANTIDEPRESSANT)
    2 ((I should take an antidepressant \.) (Medicine-request)) (0 :gist)
  1 (0 .THERAPY 0)
    2 ((I should see a therapist \.) (Energy)) (0 :gist)
  ;; What parts of your future feel out of your control?
  1 (0 .WH_ 4 sounds 3 unknown 0)
    2 ((What parts of my future feel out of my control ?) (Energy)) (0 :gist)
  1 (0 .WH_ 4 .FEELING 3 unknown 0)
    2 ((What parts of my future feel out of my control ?) (Energy)) (0 :gist)
  1 (0 .WH_ 4 future 4 .THINK-GEN 2 about 0)
    2 ((What parts of my future feel out of my control ?) (Energy)) (0 :gist)
  1 (0 .WH_ 4 future 4 .MENT-HEALTH 2 about 0)
    2 ((What parts of my future feel out of my control ?) (Energy)) (0 :gist)
  1 (0 .WH_ 2 .BE 2 .MOST 3 .FRIGHTENING 0)
    2 ((What parts of my future feel out of my control ?) (Energy)) (0 :gist)
  1 (0 .WH_ 4 .FRIGHTENS 2 you 0)
    2 ((What parts of my future feel out of my control ?) (Energy)) (0 :gist)
  1 (0 .WH_ 4 you 4 .MOST 2 .FRIGHTENED 0)
    2 ((What parts of my future feel out of my control ?) (Energy)) (0 :gist)
  1 (0 .WH_ 4 you 4 .FRIGHTENED 3 about 0)
    2 ((What parts of my future feel out of my control ?) (Energy)) (0 :gist)
  1 (0 .TELL 5 .FEAR-WORDS 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .ELABORATE 4 .FEAR-WORDS 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ 1 make 1 you 3 .FRIGHTENED 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ 1 .FRIGHTENS 1 you 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ .BE 3 .FRIGHTENING 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ 1 you 1 .THINK-GEN 3 .FRIGHTENING 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ .BE 3 .FEAR-WORDS 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ .CAUSE you 4 .FEAR-WORDS 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ 2 your future 3 .ANXIETY-WORD 0)
    2 ((What scares me about my condition ?)) (0 :gist)
;; 1 (0)
;;   2 ((NIL Gist)) (0 :gist)
)) ; END *energy-question*


(READRULES '*medicine-question*
; (0 medicine-gen 0)
'(
  ; Do you have allergies?
  1 (0 .HAVE 0 allergies 0)
    2 ((Do I have allergies to any medicine ?) (Medicine-allergies)) (0 :gist)
  ; How often are you taking medication?
  1 (0 how 1 .FREQUENTLY 3 .MED-TAKE 0)
    2 ((How often am I taking medication ?) (Medicine-frequency)) (0 :gist)
  1 (0 .BE 0 .MED-TAKE 2 .FREQUENTLY 0)
    2 ((How often am I taking medication ?) (Medicine-frequency)) (0 :gist)
  1 (0 .BE 0 .MED-TAKE 2 .MED-TIME 0)
    2 ((How often am I taking medication ?) (Medicine-frequency)) (0 :gist)
  ; How are you on the [medication]?
  1 (0 how 1 .BE you 2 .FEELING 2 .MED-TAKE 2 .MEDICINE-TAKING 0)
    2 ((How is the pain medication working ?) (Medicine-working)) (0 :gist)
  1 (0 how 1 .BE you 2 .FEELING 2 .RECENTLY 0)
    2 ((How is the pain medication working ?) (Medicine-working)) (0 :gist)
  1 (0 .AUX-BASE 1 you 3 .THINK-GEN 3 .MEDICINE-TAKING 3 .MED-HELP 0)
    2 ((How is the pain medication working ?) (Medicine-working)) (0 :gist)
  ; Does taking the medicine more frequently help?
  1 (0 .MEDICINE-TAKING 3 .FREQUENTLY 5 .MED-HELP 0)
    2 ((Does taking medication more frequently help ?) (Medicine-frequency)) (0 :gist)
  1 (0 .MED-HELP 5 .MEDICINE-TAKING 3 .FREQUENTLY 0)
    2 ((Does taking medication more frequently help ?) (Medicine-frequency)) (0 :gist)
  1 (0 .MEDICINE-TAKING 5 .MED-HELP 5 .FREQUENTLY 0)
    2 ((Does taking medication more frequently help ?) (Medicine-frequency)) (0 :gist)
  ; What is your dosage?
  1 (0 .WH_ 3 .DOSE 0)
    2 ((What dosage of pain medication am I taking ?) (Medicine)) (0 :gist)
  1 (0 how 1 .MED-DOSAGE 3 .BE 3 .MED-TAKE 0)
    2 ((What dosage of pain medication am I taking ?) (Medicine)) (0 :gist)
  ; Are you taking [some med]?
  1 (0 .BE 2 you 8 .MED-TAKE 0 .MEDICINE-PARTICULAR 0)
    2 ((Am I taking 8 ?) (Medicine)) (0 :gist)
  1 (0 what .MEDICINE 3 you 2 .MED-TAKE 0)
    2 ((What medicine am I taking ?) (Medicine)) (0 :gist)
  1 (0 what other .MEDICINE 3 you 2 .MED-TAKE 0)
    2 ((What medicine am I taking ?) (Medicine)) (0 :gist)
  ; How have you tried the new pain medication already? 
  1 (0 how 1 .HAVE 1 you 5 .MEDICINE-TAKING 0)
    2 ((How were you prescribed your current pain medication ?) (Medicine-working)) (0 :gist)
  ; Is the pain medication working?
  1 (0 .AUX-BASE 3 .MEDICINE-TAKING 3 .MED-HELP 3 .PAIN 0)
    2 ((Is the pain medication working at all ?) (Medicine-working)) (0 :gist)
  1 (0 .AUX-BASE 0 .MEDICINE-TAKING 3 .DO .ANYTHING 0)
    2 ((Is the pain medication working at all ?) (Medicine-working)) (0 :gist)
  1 (0 .AUX-BASE 0 .MEDICINE-TAKING 0 .MED-HELP 3 at all 0)
    2 ((Is the pain medication working at all ?) (Medicine-working)) (0 :gist)
  1 (0 .AUX-BASE 0 .MEDICINE-TAKING 0 .MED-HELP 0)
    2 ((Is the pain medication working ?) (Medicine-working)) (0 :gist)
  1 (0 how 0 .MEDICINE-TAKING 0 .MED-HELP 0)
    2 ((How is the pain medication working ?) (Medicine-working)) (0 :gist)
  ; Do you want stronger pain medication?
  1 (0 .AUX-BASE 1 you 3 .WANT-GEN 3 .MED-BETTER 1 .MEDICINE-TAKING 0)
    2 ((Do I want stronger pain medication ?) (Medicine-request)) (0 :gist)
  1 (0 .AUX-BASE 1 you 3 .WANT-GEN 3 .MED-NARCOTIC 0)
    2 ((Do I want stronger pain medication ?) (Medicine-request)) (0 :gist)
  1 (0 .AUX-BASE 1 you 3 .THINK-GEN 5 .MED-BETTER 1 .MEDICINE-TAKING 0)
    2 ((Do I want stronger pain medication ?) (Medicine-request)) (0 :gist)
  1 (0 .AUX-BASE 1 you 3 .THINK-GEN 5 .MED-NARCOTIC 0)
    2 ((Do I want stronger pain medication ?) (Medicine-request)) (0 :gist)
  1 (0 .WH_ 5 .THINK-GEN 5 .MED-TAKE 1 .MED-BETTER 1 .MEDICINE-TAKING 0)
    2 ((Do I want stronger pain medication ?) (Medicine-request)) (0 :gist)
  1 (0 .WH_ 5 .THINK-GEN 5 .MED-TAKE 1 .MED-NARCOTIC 0)
    2 ((Do I want stronger pain medication ?) (Medicine-request)) (0 :gist)
  1 (0 how 3 you 5 .THINK-GEN 5 .MED-TAKE 1 .MED-BETTER 1 .MEDICINE-TAKING 0)
    2 ((Do I want stronger pain medication ?) (Medicine-request)) (0 :gist)
  1 (0 how 3 you 5 .THINK-GEN 5 .MED-TAKE 1 .MED-NARCOTIC)
    2 ((Do I want stronger pain medication ?) (Medicine-request)) (0 :gist)
  ; Do you need more medicine?
  1 (0 .DO 1 you 3 .WANT-GEN 2 .MEDICINE-TAKING 0)
    2 ((Do I need more medicine ?) (Medicine-refill)) (0 :gist)
  1 (0 how are you 1 .MEDICINE-TAKING 0) ; e.g., how are you on medicine?
    2 ((Do I need more medicine ?) (Medicine-refill)) (0 :gist)
  1 (0 .DO 1 you 3 .WANT-GEN 2 refill 3 .MEDICINE-TAKING 0)
    2 ((Do I need more medicine ?) (Medicine-refill)) (0 :gist)
  ; You should take a narcotic.
  1 (0 you 3 .MED-TAKE 5 .MED-NARCOTIC 0)
    2 ((I should take a narcotic \.) (Medicine-request)) (0 :gist)
  ; How are you feeling after taking the medication?
  1 (0 .WH_ 1 you 3 .FEELING 4 medication 0)
    2 ((How is the pain medication working ?) (Medicine-working)) (0 :gist)
  ; Do you have a history with narcotics?
  1 (0 .AUX-BASE 3 .MED-PAST 3 .MED-NARCOTIC 0)
    2 ((What is my history with med-narcotic ?) (Medical-history)) (0 :gist)
  1 (0 .AUX-BASE 3 .HISTORY 3 .MED-NARCOTIC 0)
    2 ((What is my history with med-narcotic ?) (Medical-history)) (0 :gist)
  ; asking if system has any questions
  1 (0 you 2 .HAVE 2 .QUESTION-WORD 0)
    2 ((Do I have a question about my medicine ?) (Medicine)) (0 :gist)
  1 (0 .QUESTION-WORD 2 you 2 .HAVE 0)
    2 ((Do I have a question about my medicine ?) (Medicine)) (0 :gist)
  1 (0 .ANYTHING 1 you 2 .WANT-GEN 2 .ASK-GEN 0)
    2 ((Do I have a question about my medicine ?) (Medicine)) (0 :gist)
)) ; END *medicine-question*


(READRULES '*pain-question*
; (0 pain 0)
'(
  ; Did the pain come back?
  1 (0 .DO 1 .PAIN 1 .PAIN-RETURN 0)
    2 ((Did my pain come back ?) (Pain-return)) (0 :gist)
  ; How do you rate your pain?
  1 (0 .SCALE 0)
    2 ((How do I rate my pain ?) (Pain-description)) (0 :gist)
  1 (0 how .PAIN-BAD 0)
    2 ((How do I rate my pain ?) (Pain-description)) (0 :gist)
  ; Can you tell me about your pain?
  1 (0 how .BE 2 .PAIN 0)
    2 (- 0 .MEDICINE-GEN 0)
      3 ((Can I tell you about my pain ?) (Pain-description)) (0 :gist)
    2 (*medicine-question* (what medication are you taking ?)) (0 :subtree+clause)
  1 (0 .MORE-INFO 1 about 2 .PAIN 0)
    2 (- 0 .MEDICINE-GEN 0)
      3 ((Can I tell you about my pain ?) (Pain-description)) (0 :gist)
    2 (*medicine-question* (what medication are you taking ?)) (0 :subtree+clause)
  1 (0 .CAN 2 you 2 describe 2 .PAIN 0)
    2 (- 0 .MEDICINE-GEN 0)
      3 ((Can I tell you about my pain ?) (Pain-description)) (0 :gist)
    2 (*medicine-question* (what medication are you taking ?)) (0 :subtree+clause)
  1 (0 what 2 .MEDICINE-GEN 0)
    2 (- 0 .DOSE 0)
      3 (*medicine-question* (what medication are you taking ?)) (0 :subtree+clause)
  1 (0 .MED-BETTER 1 .MEDICINE-TAKING 0)
    2 (*medicine-question* (do you want a stronger pain medication ?)) (0 :subtree+clause)
  1 (0 .MEDICINE-TAKING 0 .MED-HELP 0)
    2 (*medicine-question* (is your pain medication working ?)) (0 :subtree+clause)
  1 (0 what .PAIN 1 .BE you 0)
    2 (- 0 .MEDICINE-GEN 0)
      3 ((Can I tell you about my pain ?) (Pain-description)) (0 :gist)
    2 (*medicine-question* (what medication are you taking ?)) (0 :subtree+clause)
  ; Where does it hurt?
  1 (0 where it 3 .PAIN 0)
    2 ((Where is the pain located ?) (Pain-description)) (0 :gist)
  1 (0 where .DO 3 .PAIN 0)
    2 ((Where is the pain located ?) (Pain-description)) (0 :gist)
  1 (0 where .BE 3 .PAIN 0)
    2 ((Where is the pain located ?) (Pain-description)) (0 :gist)
  1 (0 what .PART 3 .PAIN 0)
    2 ((Where is the pain located ?) (Pain-description)) (0 :gist)
  ; Does it hurt to [...]
  1 (0 .DO 2 .PAIN to 0)
    2 (0 breath 0)
      3 ((Does it hurt to breath ?) (Pain-description)) (0 :gist)
    2 (0)
      3 ((Does it hurt to do anything ?) (Pain-description)) (0 :gist)
  ; Is the pain worse?
  1 (0 .AUX-BASE 3 .PAIN 3 worse 0)
    2 ((Has the pain become worse ?) (Pain-description)) (0 :gist)
  ; Do you have the pain frequently?
  1 (0 .AUX-BASE 3 .PAIN 3 .FREQUENTLY 0)
    2 ((Do you have the pain frequently ?) (Pain-description)) (0 :gist)
  1 (0 .AUX-BASE 3 .PAIN 3 all 1 time 0)
    2 ((Do you have the pain frequently ?) (Pain-description)) (0 :gist)
)) ; END *pain-question*


(READRULES '*radiation-question*
; (0 radiation 0)
'(
  ; Did the pain respond to [...]?
  1 (0 .RESPOND 1 to 1 radiation 0)
    2 ((Did the pain respond to radiation treatment ?) (Radiation-treatment)) (0 :gist)
  1 (0 .DO 2 radiation 5 .RADIATION-HELP 0)
    2 ((Did the pain respond to radiation treatment ?) (Radiation-treatment)) (0 :gist)
  ; Did you get [...]?
  1 (0 .REDNESS 0)
    2 ((Did I get any hair loss or redness during radiation treatment ?) (Radiation-treatment)) (0 :gist)
  1 (0 hair loss 0)
    2 ((Did I get any hair loss or redness during radiation treatment ?) (Radiation-treatment)) (0 :gist)
  1 (0 .DO you 3 radiation 0)
    2 ((Did I get radiation treatment ?) (Radiation-treatment)) (0 :gist)
  1 (0 radiation .TREATMENT 0)
    2 ((Did I get radiation treatment ?) (Radiation-treatment)) (0 :gist)
)) ; END *radiation-question*


(READRULES '*sleep-question*
; (0 sleep 0)
'(
  ; What's going through your head while you're sleeping?
  1 (0 .WH_ 5 .SLEEP-THOUGHT 5 .SLEEP 0)
    2 ((What is on my mind when I try to sleep ?) (Sleep)) (0 :gist)
  ; Have you been sleeping okay?
  1 (0 .BE you 2 .SLEEP 1 .OKAY 0)
    2 ((Have I been sleeping okay ?) (Sleep)) (0 :gist)
  1 (0 .HAVE you 2 .SLEEP 1 .OKAY 0)
    2 ((Have I been sleeping okay ?) (Sleep)) (0 :gist)
  1 (0 you 3 .TROUBLE .SLEEP 0)
    2 ((Have I been sleeping okay ?) (Sleep)) (0 :gist)
  1 (0 you 2 .SLEEP 1 .MUCH 0)
    2 ((Have I been sleeping okay ?) (Sleep)) (0 :gist)
  ; How often are you waking up at night?
  1 (0 how .FREQUENTLY 0)
    2 ((How often am I waking up at night ?) (Waking-frequency)) (0 :gist)
  ; Do you sleep during the day?
  1 (0 .SLEEP 2 during 3 .DAY 0)
    2 ((Do I sleep during the day ?) (Sleep)) (0 :gist)
  ; What happens when you try to sleep?
  1 (0 .WH_ 2 .HAPPEN 4 .SLEEP 0)
    2 ((What happens when I try to sleep ?) (Sleep)) (0 :gist)
  1 (0 .WH_ 2 you 1 .MED-NOTICE 4 .SLEEP 0)
    2 ((What happens when I try to sleep ?) (Sleep)) (0 :gist)
  ; What do you do before bed?
  1 (0 .WH_ 2 you 2 .BEFORE 3 .SLEEP 0)
    2 ((What is my sleep routine ?) (Sleep)) (0 :gist)
  1 (0 .WH_ 2 your 1 .SLEEP routine 0)
    2 ((What is my sleep routine ?) (Sleep)) (0 :gist)
  1 (0 .WH_ 2 .SLEEP routine 2 you 1 .HAVE 0)
    2 ((What is my sleep routine ?) (Sleep)) (0 :gist)
  ; Is worrying keeping you up at night?
  1 (0 .BE 3 .MENT-HEALTH 4 you 2 .SLEEP-AWAKE 0)
    2 ((Is my mental health keeping me awake ?) (Sleep)) (0 :gist)
  1 (0 your 2 .MENT-HEALTH 4 you 2 .SLEEP-AWAKE 0)
    2 ((Is my mental health keeping me awake ?) (Sleep)) (0 :gist)
  ; Is coffee keeping you up at night?
  1 (0 .BE 3 .COFFEE 4 you 2 .SLEEP-AWAKE 0)
    2 ((Is coffee keeping me awake ?) (Sleep)) (0 :gist)
  1 (0 .COFFEE 4 .CAUSE 2 you 2 .SLEEP-AWAKE 0)
    2 ((Is coffee keeping me awake ?) (Sleep)) (0 :gist)
  1 (0 .SLEEP-AWAKE 4 .BECAUSE 4 .COFFEE 0)
    2 ((Is coffee keeping me awake ?) (Sleep)) (0 :gist)
  1 (0 .SLEEP-AWAKE 4 .CAUSE 4 .COFFEE)
    2 ((Is coffee keeping me awake ?) (Sleep)) (0 :gist)
  1 (0 .AUX-BASE 3 .FREQUENTLY 6 .COFFEE 0)
    2 ((Is coffee keeping me awake ?) (Sleep)) (0 :gist)
)) ; END *sleep-question*


(READRULES '*chemotherapy-question*
; (0 chemotherapy 0)
'(
  ; Did your doctor mention chemotherapy?
  1 (0 did 4 .TELL 4 you 4 need .CHEMOTHERAPY 0)
    2 ((Did my doctor mention chemotherapy ?) (Chemotherapy)) (0 :gist)
  1 (0 did 8 you 4 about .CHEMOTHERAPY 0)
    2 ((Did my doctor mention chemotherapy ?) (Chemotherapy)) (0 :gist)
  1 (0 .MENTION 3 .CHEMOTHERAPY 0)
    2 ((Did my doctor mention chemotherapy ?) (Chemotherapy)) (0 :gist)
  ; What do you think about chemotherapy?
  1 (0 .WH_ 4 .THINK-GEN 4 .CHEMOTHERAPY 0)
    2 ((What are my feelings about chemotherapy ?) (Chemotherapy)) (0 :gist)
  1 (0 .AUX-BASE 4 .WANT-GEN 4 .CHEMOTHERAPY 0)
    2 ((What are my feelings about chemotherapy ?) (Chemotherapy)) (0 :gist)
  1 (0 .OPINION-GEN 2 on 2 .CHEMOTHERAPY 0)
    2 ((What are my feelings about chemotherapy ?) (Chemotherapy)) (0 :gist)
  1 (0 .AUX-BASE 3 you 2 .UNDERSTAND-GEN 4 .CHEMOTHERAPY 0)
    2 ((Do I understand how chemotherapy works ?) (Chemotherapy)) (0 :gist)
  ; asking if system has any questions
  1 (0 you 2 .HAVE 2 .QUESTION-WORD 0)
    2 ((Do I have a question about chemotherapy ?) (Chemotherapy)) (0 :gist)
  1 (0 .QUESTION-WORD 2 you 2 .HAVE 0)
    2 ((Do I have a question about chemotherapy ?) (Chemotherapy)) (0 :gist)
  1 (0 .ANYTHING 1 you 2 .WANT-GEN 2 .ASK-GEN 0)
    2 ((Do I have a question about chemotherapy ?) (Chemotherapy)) (0 :gist)
)) ; END *chemotherapy-question*


(READRULES '*comfort-care-question*
; (0 palliative care 0)
; (0 hospice 0)
'(
  ; Do I understand how comfort care works ?
  1 (0 .AUX-BASE 2 .KNOW-GEN 3 .COMFORT-CARE-WORD 0)
    2 ((Do I understand how comfort care works ?) (Comfort-care)) (0 :gist)
  1 (0 .BE 2 .KNOW 3 .COMFORT-CARE-WORD 0)
    2 ((Do I understand how comfort care works ?) (Comfort-care)) (0 :gist)
  1 (0 .AUX-BASE 2 heard 3 .COMFORT-CARE-WORD)
    2 ((Do I understand how comfort care works ?) (Comfort-care)) (0 :gist)
  1 (0 .WH_ 4 .KNOW-GEN 3 .COMFORT-CARE-WORD 0)
    2 ((Do I understand how comfort care works ?) (Comfort-care)) (0 :gist)
  1 (0 .WH_ 3 heard 3 .COMFORT-CARE-WORD 0)
    2 ((Do I understand how comfort care works ?) (Comfort-care)) (0 :gist)
  1 (0 .AUX-BASE 4 .MENTION 4 .COMFORT-CARE-WORD 0)
    2 ((Do I understand how comfort care works ?) (Comfort-care)) (0 :gist)
  1 (0 .AUX-BASE 3 .TELL 3 .COMFORT-CARE-WORD 0)
    2 ((Do I understand how comfort care works ?) (Comfort-care)) (0 :gist)
  1 (0 .AUX-BASE 3 you 2 .UNDERSTAND-GEN 6 .COMFORT-CARE-WORD 0)
    2 ((Do I understand how comfort care works ?) (Comfort-care)) (0 :gist)
  ; Have you considered comfort care?
  1 (1 .AUX-BASE .PRON 4 .THOUGHT 4 .COMFORT-CARE-WORD 0)
    2 ((Have I considered comfort care ?) (Comfort-care)) (0 :gist)
  1 (1 .AUX-BASE 4 you 1 .FEELING 4 .COMFORT-CARE-WORD 0)
    2 ((Have I considered comfort care ?) (Comfort-care)) (0 :gist)
  ; asking if system has any questions
  1 (0 you 2 .HAVE 2 .QUESTION-WORD 0)
    2 ((Do I have a question about comfort care ?) (Comfort-care)) (0 :gist)
  1 (0 .QUESTION-WORD 2 you 2 .HAVE 0)
    2 ((Do I have a question about comfort care ?) (Comfort-care)) (0 :gist)
  1 (0 .ANYTHING 1 you 2 .WANT-GEN 2 .ASK-GEN 0)
    2 ((Do I have a question about comfort care ?) (Comfort-care)) (0 :gist)
)) ; END *comfort-care-question*


(READRULES '*medicine-request-question*
'(
)) ; END *medicine-request-question*


(READRULES '*medicine-working-question*
'(
)) ; END *medicine-working-question*


(READRULES '*prognosis-question*
; (0 prognosis 0)
'(
  ; How much do I want to know about my prognosis ?
  1 (0 how .MUCH 3 .INFORMATION-GEN 3 .AUX 1 you 0)
    2 ((How much information do I want about my prognosis ?)) (0 :gist)
  1 (0 how .MUCH 3 .INFORMATION-GEN 3 I 3 you 0)
    2 ((How much information do I want about my prognosis ?)) (0 :gist)
  1 (0 how .MUCH 3 .AUX 3 I 3 .WANT-GEN 3 .KNOW 0)
    2 ((How much information do I want about my prognosis ?)) (0 :gist)
  1 (0 how .MUCH 3 I 3 .TELL 3 you 0)
    2 ((How much information do I want about my prognosis ?)) (0 :gist)
  1 (0 how .MUCH 3 .AUX you 3 .WANT-GEN 1 me 3 .TELL 0)
    2 ((How much information do I want about my prognosis ?)) (0 :gist)
  1 (0 how .MUCH 3 would you 3 .WANT-GEN 0)
    2 ((How much information do I want about my prognosis ?)) (0 :gist)
  1 (0 .AUX-BASE 3 you 2 .FEELING 6 prognosis 0)
    2 ((How do I feel about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .TELL 1 me 7 .FEAR-WORDS 0)
    2 ((What scares me about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .ELABORATE 4 .FEAR-WORDS 0)
    2 ((What scares me about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ 1 make 1 you 3 .FRIGHTENED 0)
    2 ((What scares me about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ 1 .FRIGHTENS 1 you 0)
    2 ((What scares me about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ .BE 3 .FRIGHTENING 0)
    2 ((What scares me about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ 1 you 1 .THINK-GEN 3 .FRIGHTENING 0)
    2 ((What scares me about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ .BE 3 .FEAR-WORDS 0)
    2 ((What scares me about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ .CAUSE you 4 .FEAR-WORDS 0)
    2 ((What scares me about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .AUX-BASE 3 you 2 .KNOW-GEN 6 prognosis 0)
    2 ((Do I understand my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .AUX-BASE 3 you 2 .TELL 6 prognosis 0)
    2 ((Do I understand my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .TELL 4 .KNOW-GEN 6 prognosis 0)
    2 ((Do I understand my prognosis ?) (Prognosis)) (0 :gist)
  ; asking if system has any questions
  1 (0 you 2 .HAVE 2 .QUESTION-WORD 0)
    2 ((Do I have a question about my prognosis ?)) (0 :gist)
  1 (0 .QUESTION-WORD 2 you 2 .HAVE 0)
    2 ((Do I have a question about my prognosis ?)) (0 :gist)
  1 (0 .ANYTHING 1 you 2 .WANT-GEN 2 .ASK-GEN 0)
    2 ((Do I have a question about my prognosis ?)) (0 :gist)
  ; What is the prognosis that was given to me previously ?
  1 (0 .WH_ 4 .BE 4 prognosis 0)
    2 ((What is the prognosis that was given to me previously ?) (Prognosis)) (0 :gist)
  1 (0 .TELL 4 .WH_ 4 prognosis 4 .BE 0)
    2 ((What is the prognosis that was given to me previously ?) (Prognosis)) (0 :gist)
  1 (0 .AUX-BASE 4 .KNOW-GEN 4 prognosis 0)
    2 ((What is the prognosis that was given to me previously ?) (Prognosis)) (0 :gist)
  1 (0 .MODAL 4 .TELL 4 prognosis 0)
    2 ((What is the prognosis that was given to me previously ?) (Prognosis)) (0 :gist)
  1 (0 .NEG 2 .PROGNOSIS-NOTIFICATION-WORDS 4 prognosis 0)
    2 ((What is the prognosis that was given to me previously ?) (Prognosis)) (0 :gist)
  ; How specific do you want me to be about your prognosis ?
  1 (0 would 2 you 3 .WANT-GEN 6 .SPECIFIC 0)
    2 ((How specific do I want you to be about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 how 2 .SPECIFIC 6 .WANT-GEN 0)
    2 ((How specific do I want you to be about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .AUX 2 you 3 .WANT-GEN 6 .SPECIFIC 0)
    2 ((How specific do I want you to be about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 .AUX 2 you 3 .WANT-GEN 6 range 0)
    2 ((How specific do I want you to be about my prognosis ?) (Prognosis)) (0 :gist)
  1 (0 would 2 you 3 .WANT-GEN 6 .SPECIFIC 0)
    2 ((How specific do I want you to be about my prognosis ?) (Prognosis)) (0 :gist)
  ; Are you ready to discuss your treatment goals ?
  1 (0 .WH_ 2 your 5 .CANCER-GOALS 0)
    2 ((Am I ready to discuss my treatment goals ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ 3 .CANCER-GOALS 2 you 2 .HAVE 0)
    2 ((Am I ready to discuss my treatment goals ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ 2 .BE 3 .IMPORTANT 3 you 0)
    2 ((Am I ready to discuss my treatment goals ?) (Prognosis)) (0 :gist)
  1 (0 .DEPEND 7 your 2 .CANCER-GOALS 0)
    2 ((Am I ready to discuss my treatment goals ?) (Prognosis)) (0 :gist)
  1 (0 .DEPEND 7 .CANCER-GOALS 2 you 0)
    2 ((Am I ready to discuss my treatment goals ?) (Prognosis)) (0 :gist)
  1 (0 .BE 2 .READY 4 .DISCUSS 6 .CANCER-GOALS 0)
    2 ((Am I ready to discuss my treatment goals ?) (Prognosis)) (0 :gist)
  1 (0 .WANT-GEN 4 .DISCUSS 6 .CANCER-GOALS 0)
    2 ((Am I ready to discuss my treatment goals ?) (Prognosis)) (0 :gist)
  ; Do I want my family to be present when you tell me about the prognosis ?
  1 (0 .FAMILY-PRON 0)
    2 (0 .WANT-GEN 4 .AVAILABLE 0)
      3 ((Do I want my family to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
    2 (0 .WANT-GEN 4 with 0)
      3 ((Do I want my family to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
    2 (0 .WANT 4 here 0)
      3 ((Do I want my family to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
    2 (0 .TALK 4 to 0)
      3 ((Do I want my family to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
    2 (0 .SHARE 4 with 0)
      3 ((Do I want my family to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
    2 (0 .PROVIDE 4 .INFORMATION-GEN 0)
      3 ((Do I want my family to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
  ; Is there any person you want to be present when I tell you about the results?
  1 (0 .SOMEONE 0)
    2 (0 .WANT-GEN 4 .AVAILABLE 0)
      3 ((Do I want anyone to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
    2 (0 .WANT-GEN 4 with 0)
      3 ((Do I want anyone to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
    2 (0 .WANT 4 here 0)
      3 ((Do I want anyone to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
    2 (0 .WANT-GEN 4 .SHARE 0)
      3 ((Do I want anyone to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
    2 (0 .TALK 4 to 0)
      3 ((Do I want anyone to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
    2 (0 .PROVIDE 4 .INFORMATION-GEN 0)
      3 ((Do I want anyone to be present when you tell me about the prognosis ?) (Prognosis)) (0 :gist)
  ; How prepared for the prognosis are my family ?
  1 (0 .AUX-BASE 3 .FAMILY-PRON 2 .KNOW-GEN 0)
    2 ((How prepared for the prognosis are my family ?) (Prognosis)) (0 :gist)
  1 (0 .AUX-BASE 3 .FAMILY-PRON 3 .TELL 0)
    2 ((How prepared for the prognosis are my family ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ 3 .AUX-BASE 3 .FAMILY-PRON 2 .KNOW-GEN 0)
    2 ((How prepared for the prognosis are my family ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ 3 .AUX-BASE 3 .FAMILY-PRON 3 .TELL 0)
    2 ((How prepared for the prognosis are my family ?) (Prognosis)) (0 :gist)
  1 (0 how 2 .MUCH 2 .INFORMATION-GEN 6 .FAMILY-PRON 0)
    2 ((How prepared for the prognosis are my family ?) (Prognosis)) (0 :gist)
  ;; What causes me to believe that my cancer has gotten worse?
  1 (0 why 2 you 2 .THINK-GEN 8 worse 0)
    2 (0 .THINK-GEN 2 things 5 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 .THINK-GEN 2 .CANCER-ILLNESS 5 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 .THINK-GEN 2 it 5 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
  1 (0 why 2 you 2 .TELL 8 worse 0)
    2 (0 .TELL 2 things 5 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 .TELL 2 .CANCER-ILLNESS 5 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 .TELL 2 it 5 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
  1 (0 .WH_ 2 you 2 .THINK-GEN 8 worse 0)
    2 (0 .THINK-GEN 2 things 5 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 .THINK-GEN 2 .CANCER-ILLNESS 5 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 .THINK-GEN 2 it 5 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
  1 (0 how 2 you 8 worse 0)
    2 (0 you 3 .TELL 2 .CANCER-ILLNESS 2 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 you 3 .TELL 2 it 2 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 you 3 .TELL 2 things 2 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 you 3 .KNOW-GEN 2 things 2 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 you 3 .KNOW-GEN 2 it 2 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
    2 (0 you 3 .KNOW-GEN 2 .CANCER-ILLNESS 2 worse 0)
      3 ((What causes me to believe that my cancer has gotten worse ?) (Prognosis)) (0 :gist)
)) ; END *prognosis-question*


(READRULES '*sleep-poorly-question*
'(
)) ; END *sleep-poorly-question*


(READRULES '*tell-family-question*
; (0 family 2 know-gen 0)
; (0 family 3 tell 0)
'(
  ; Do your family know about your cancer / Have your family been told about your cancer ?
  1 (0 .AUX-BASE 3 .FAMILY-PRON 2 .KNOW-GEN 5 .CANCER-ILLNESS 0)
    2 (- 0 .WANT-GEN 0)
      3 ((Do my family know about my cancer ?) (Tell-family)) (0 :gist)
  1 (0 .AUX-BASE 3 .FAMILY-PRON 3 .TELL 5 .CANCER-ILLNESS 0)
    2 (- 0 .WANT-GEN 0)
      3 ((Do my family know about my cancer ?) (Tell-family)) (0 :gist)
  1 (0 .WH_ 3 .AUX-BASE 3 .FAMILY-PRON 2 .KNOW-GEN 5 .CANCER-ILLNESS 0)
    2 (- 0 .WANT-GEN 0)
      3 ((Do my family know about my cancer ?) (Tell-family)) (0 :gist)
  1 (0 .WH_ 3 .AUX-BASE 3 .FAMILY-PRON 3 .TELL 5 .CANCER-ILLNESS 0)
    2 (- 0 .WANT-GEN 0)
      3 ((Do my family know about my cancer ?) (Tell-family)) (0 :gist)
  ; How much do I want my family to know about the prognosis ?
  1 (0 .WH_ 4 .DO 2 .WANT-GEN 2 .FAMILY-PRON 2 .KNOW-GEN 0)
    2 ((How much do I want my family to know about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 how 1 .MUCH 2 .DO 2 .WANT-GEN 2 .FAMILY-PRON 2 .KNOW-GEN 0)
    2 ((How much do I want my family to know about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 .WH_ 4 .DO 2 .WANT-GEN 2 .TELL 2 .FAMILY-PRON 0)
    2 ((How much do I want my family to know about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 how 1 .MUCH 2 .DO 2 .WANT-GEN 2 .TELL 2 .FAMILY-PRON 0)
    2 ((How much do I want my family to know about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 how 1 .MUCH 2 .DO 2 .WANT-GEN 2 .FAMILY-PRON 2 .KNOW-GEN 0)
    2 ((How much do I want my family to know about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 whatever 4 .DO 2 .WANT-GEN 2 .FAMILY-PRON 2 .KNOW-GEN 0)
    2 ((How much do I want my family to know about the prognosis ?) (Tell-family)) (0 :gist)
  ;; Can I tell you about my family?
  1 (0 .TELL 2 .DOCTOR-PRON 2 about 2 .FAMILY-PRON 0)
    2 ((Can I tell you about my family ?) (Tell-family)) (0 :gist)
  1 (0 .WH_ 2 .BE 2 .FAMILY-PRON 3 .LIKE 0)
    2 ((Can I tell you about my family ?) (Tell-family)) (0 :gist)
  1 (0 .ANYTHING 4 .TELL 2 about 2 .FAMILY-PRON 0)
    2 ((Can I tell you about my family ?) (Tell-family)) (0 :gist)
  1 (0 .TELL 4 .WH_ 2 .FAMILY-PRON 2 .BE 2 .LIKE 0)
    2 ((Can I tell you about my family ?) (Tell-family)) (0 :gist)
  ; Do I want you to be present when I tell my family about the prognosis ?
  1 (0 .WANT-GEN 4 .AVAILABLE 0)
    2 ((Do I want you to be present when I tell my family about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 .WANT-GEN 4 with 0)
    2 ((Do I want you to be present when I tell my family about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 .WANT-GEN 4 joint 2 .APPOINTMENT 0)
    2 ((Do I want you to be present when I tell my family about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 .WANT-GEN 4 .IN 1 person 2 .APPOINTMENT 0)
    2 ((Do I want you to be present when I tell my family about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 .WANT-GEN 4 .APPOINTMENT 2 with 2 .FAMILY 0)
    2 ((Do I want you to be present when I tell my family about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 .WANT-GEN 4 .APPOINTMENT 2 together 0)
    2 ((Do I want you to be present when I tell my family about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 make 2 .APPOINTMENT 0)
    2 ((Do I want you to be present when I tell my family about the prognosis ?) (Tell-family)) (0 :gist)
  ; Who in my family do I want to tell about the prognosis ?
  1 (0 who 3 .BE 3 .TELL 0)
    2 ((Who in my family do I want to tell about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 who 2 .AUX-BASE 4 .WANT-GEN 2 .TELL 0)
    2 ((Who in my family do I want to tell about the prognosis ?) (Tell-family)) (0 :gist)
  1 (0 who 6 .WANT-GEN 3 .TELL 0)
    2 ((Who in my family do I want to tell about the prognosis ?) (Tell-family)) (0 :gist)
  ; How much do I want to know about my test results ?
  1 (0 how .MUCH 3 .INFORMATION-GEN 3 .AUX 1 you 0)
    2 ((How much information do I want about my test results ?)) (0 :gist)
  1 (0 how .MUCH 3 .INFORMATION-GEN 3 I 3 you 0)
    2 ((How much information do I want about my test results ?)) (0 :gist)
  1 (0 how .MUCH 3 .AUX 3 I 3 .WANT-GEN 3 .KNOW 0)
    2 ((How much information do I want about my test results ?)) (0 :gist)
  1 (0 how .MUCH 3 I 3 .TELL 3 you 0)
    2 ((How much information do I want about my test results ?)) (0 :gist)
  1 (0 how .MUCH 3 .AUX 3 you 3 .WANT-GEN 3 .KNOW 0)
    2 ((How much information do I want about my test results ?)) (0 :gist)
  1 (0 how .MUCH 3 .AUX you 3 .WANT-GEN 1 me 3 .TELL 0)
    2 ((How much information do I want about my test results ?)) (0 :gist)
  1 (0 how .MUCH 3 would you 3 .WANT-GEN 1 me 3 .TELL 0)
    2 ((How much information do I want about my test results ?)) (0 :gist)
  ; You will help me and my family through the treatment process \.
  1 (0 .DOCTOR-PRON 4 .BE 2 .AVAILABLE 2 you 4 .CARE 0)
    2 ((You will help me and my family through the treatment process \.)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 .BE 2 .AVAILABLE 2 you 4 .DIFFICULT 1 time 0)
    2 ((You will help me and my family through the treatment process \.)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 .BE 2 .AVAILABLE 2 .FAMILY-PRON 0)
    2 ((You will help me and my family through the treatment process \.)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 .BE 2 .AVAILABLE 2 .HELP 0)
    2 ((You will help me and my family through the treatment process \.)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 .MED-HELP 2 .FAMILY 0)
    2 ((You will help me and my family through the treatment process \.)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 .BE 2 .AVAILABLE 2 every 1 step 2 way 0)
    2 ((You will help me and my family through the treatment process \.)) (0 :gist)
  ; I should plan to spend my remaining time with my family after I tell them about the prognosis \.
  1 (0 make 2 time 4 .FAMILY-PRON 0)
    2 ((I should plan to spend my remaining time with my family after I tell them about the prognosis \.)) (0 :gist)
  1 (0 .GIVE 4 .FAMILY-PRON 4 .VISIT 2 you 0)
    2 ((I should plan to spend my remaining time with my family after I tell them about the prognosis \.)) (0 :gist)
  1 (0 .SPEND 4 time 4 .FAMILY-PRON 0)
    2 ((I should plan to spend my remaining time with my family after I tell them about the prognosis \.)) (0 :gist)
  1 (0 .FAMILY 2 .SPEND 2 time 4 you 0)
    2 ((I should plan to spend my remaining time with my family after I tell them about the prognosis \.)) (0 :gist)
  1 (0 make 2 .MOST 4 time 4 with 2 .FAMILY-PRON 0)
    2 ((I should plan to spend my remaining time with my family after I tell them about the prognosis \.)) (0 :gist)
  ;; Do I want you to contact a family member now ?
  1 (0 you 4 .WANT-GEN 2 me 4 .CONTACT 4 .CHILD 0)
    2 ((Do I want you to contact a family member now ?)) (0 :gist)
  1 (0 you 4 .WANT-GEN 2 me 4 reach 1 out 4 .CHILD 0)
    2 ((Do I want you to contact a family member now ?)) (0 :gist)
  1 (0 you 4 .WANT-GEN 2 me 10 .CHILD 0)
    2 (0 me 4 get 2 touch 4 .CHILD 0)
      3 ((Do I want you to contact a family member now ?)) (0 :gist)
    2 (0 me 4 get 2 .AHOLD 4 .CHILD 0)
      3 ((Do I want you to contact a family member now ?)) (0 :gist)
  1 (0 .SHOULD 2 .DOCTOR-PRON 4 .CONTACT 4 .CHILD 0)
    2 ((Do I want you to contact a family member now ?)) (0 :gist)
  1 (0 .SHOULD 2 .DOCTOR-PRON 4 reach 1 out 4 .CHILD 0)
    2 ((Do I want you to contact a family member now ?)) (0 :gist)
  1 (0 .SHOULD 2 .DOCTOR-PRON 10 .CHILD 0)
    2 (0 .DOCTOR-PRON 4 get 2 touch 4 .CHILD 0)
      3 ((Do I want you to contact a family member now ?)) (0 :gist)
    2 (0 .DOCTOR-PRON 4 get 2 .AHOLD 4 .CHILD 0)
      3 ((Do I want you to contact a family member now ?)) (0 :gist)
  1 (0 .SHOULD 2 .DOCTOR-PRON 4 .CONTACT 4 .CHILD 0)
    2 ((Do I want you to contact a family member now ?)) (0 :gist)
  1 (0 .SHOULD 2 .DOCTOR-PRON 4 reach 1 out 4 .CHILD 0)
    2 ((Do I want you to contact a family member now ?)) (0 :gist)
  1 (0 .SHOULD 2 .DOCTOR-PRON 10 .CHILD 0)
    2 (0 .DOCTOR-PRON 4 get 2 touch 4 .CHILD 0)
      3 ((Do I want you to contact a family member now ?)) (0 :gist)
    2 (0 .DOCTOR-PRON 4 get 2 .AHOLD 4 .CHILD 0)
      3 ((Do I want you to contact a family member now ?)) (0 :gist)
  ; What can you do to help me break the news to my family?
  1 (0 .WH_ 2 .CAN 2 .DOCTOR-PRON 4 .AUX-BASE 2 .HELP 0)
    2 ((What can you do to help me break the news to my family ?)) (0 :gist)
  1 (0 .BE 2 .ANYTHING 4 .DOCTOR-PRON 4 .AUX-BASE 2 .HELP 0)
    2 ((What can you do to help me break the news to my family ?)) (0 :gist)
  1 (0 how 4 .DOCTOR-PRON 4 .HELP 0)
    2 ((What can you do to help me break the news to my family ?)) (0 :gist)
  1 (0 .WH_ 4 would 4 .HELP 0)
    2 ((What can you do to help me break the news to my family ?)) (0 :gist)
  1 (0 .WH_ 4 .MIGHT 4 .HELP 0)
    2 ((What can you do to help me break the news to my family ?)) (0 :gist)
  1 (0 .WH_ 4 .BE 4 .BENEFICIAL 0)
    2 ((What can you do to help me break the news to my family ?)) (0 :gist)
  ; You empathize with how hard it is for me to tell my family.
  1 (0 .KNOW-GEN 4 .BE 3 .DIFFICULT 0)
    2 ((You empathize with how hard it is for me to tell my family \.)) (0 :gist)
  1 (0 .KNOW-GEN 4 how 2 .DIFFICULT 0)
    2 ((You empathize with how hard it is for me to tell my family \.)) (0 :gist)
  1 (0 .KNOW-GEN 4 how 2 .FEAR-WORDS 0)
    2 ((You empathize with how hard it is for me to tell my family \.)) (0 :gist)
  1 (0 .SHOULD 2 .BE 4 .DIFFICULT 0)
    2 ((You empathize with how hard it is for me to tell my family \.)) (0 :gist)
  1 (0 .SHOULD 2 .BE 4 .FRIGHTENING 0)
    2 ((You empathize with how hard it is for me to tell my family \.)) (0 :gist)
)) ; END *tell-family-question*


(READRULES '*test-results-question*
'(
  ; How do you feel about the test results?
  1 (0 .WH_ 4 you 2 .THINK-GEN 4 diagnostic-tests 0)
    2 ((How do I feel about my test results ?) (Test-results)) (0 :gist)
  1 (0 how 4 you 2 .THINK-GEN 4 diagnostic-tests 0)
    2 ((How do I feel about my test results ?) (Test-results)) (0 :gist)
  1 (0 .BE 4 you 2 .THINK-GEN 4 diagnostic-tests 0)
    2 ((How do I feel about my test results ?) (Test-results)) (0 :gist)
  ; Asking if system has any questions
  1 (0 you 2 .HAVE 2 .QUESTION-WORD 0)
    2 ((Do I have a question about my test results ?)) (0 :gist)
  1 (0 .QUESTION-WORD 2 you 2 .HAVE 0)
    2 ((Do I have a question about my test results ?)) (0 :gist)
  1 (0 .ANYTHING 1 you 2 .WANT-GEN 2 .ASK-GEN 0)
    2 ((Do I have a question about my test results ?)) (0 :gist)
  ; Do I want my family to be present when you tell me about the test results ?
  1 (0 .FAMILY-PRON 0)
    2 (0 .WANT-GEN 4 .AVAILABLE 0)
      3 ((Do I want my family to be present when you tell me about the test results ?) (Test-results)) (0 :gist)
    2 (0 .WANT-GEN 4 with 0)
      3 ((Do I want my family to be present when you tell me about the test results ?) (Test-results)) (0 :gist)
    2 (0 .WANT 4 here 0)
      3 ((Do I want my family to be present when you tell me about the test results ?) (Test-results)) (0 :gist)
  ; Is there any person you want to be present when I tell you about the results?
  1 (0 .SOMEONE 0)
    2 (0 .WANT-GEN 4 .AVAILABLE 0)
      3 ((Do I want anyone to be present when you tell me about the test results ?) (Test-results)) (0 :gist)
    2 (0 .WANT-GEN 4 with 0)
      3 ((Do I want anyone to be present when you tell me about the test results ?) (Test-results)) (0 :gist)
    2 (0 .WANT 4 here 0)
      3 ((Do I want anyone to be present when you tell me about the test results ?) (Test-results)) (0 :gist)
    2 (0 .WANT-GEN 4 .SHARE 0)
      3 ((Do I want anyone to be present when you tell me about the test results ?) (Test-results)) (0 :gist)
  ; How much do you want to know about your test results?
  1 (0 how .MUCH 3 information 3 .AUX 1 you 0)
    2 ((How much information do I want about my test results ?) (Test-results)) (0 :gist)
  1 (0 how .MUCH 3 information 3 I 3 you 0)
    2 ((How much information do I want about my test results ?) (Test-results)) (0 :gist)
  1 (0 how .MUCH 3 .AUX 3 I 3 .WANT-GEN 3 .KNOW 0)
    2 ((How much information do I want about my test results ?) (Test-results)) (0 :gist)
  1 (0 how .MUCH 3 .AUX 3 you 3 .WANT-GEN 3 .KNOW 0)
    2 ((How much information do I want about my test results ?) (Test-results)) (0 :gist)
  1 (0 how .MUCH 3 I 3 .TELL 3 you 0)
    2 ((How much information do I want about my test results ?) (Test-results)) (0 :gist)
  1 (0 how .MUCH 3 .AUX you 3 .WANT-GEN 1 me 3 .TELL 0)
    2 ((How much information do I want about my test results ?) (Test-results)) (0 :gist)
  1 (0 how .MUCH 3 would you 3 .WANT-GEN 1 me 3 .TELL 0)
    2 ((How much information do I want about my test results ?) (Test-results)) (0 :gist)
  1 (0 .CAN 4 .GO 2 into 4 detail 0)
    2 ((How much information do I want about my test results ?) (Test-results)) (0 :gist)
)) ; END *test-results-question*


(READRULES '*treatment-option-question*
; (0 treatment-option 0)
'(
  1 (0 how 4 .THINK-GEN 4 .TREATMENT-OPTION 0)
    2 ((What are my treatment goals ?) (Treatment-options)) (0 :gist)
  1 (0 .WH_ 4 you 3 .THINK-GEN 6 .TREATMENT-OPTION 0)
    2 ((What are my treatment goals ?) (Treatment-options)) (0 :gist)
  1 (0 .AUX-BASE 3 you 2 .UNDERSTAND-GEN 6 .TREATMENT-OPTION 0)
    2 ((What do I understand about my treatment options ?) (Treatment-option)) (0 :gist)
  ; asking if system has any questions
  1 (0 you 2 .HAVE 2 .QUESTION-WORD 0)
    2 ((Do I have a question about my treatment options \?)) (0 :gist)
  1 (0 .QUESTION-WORD 2 you 2 .HAVE 0)
    2 ((Do I have a question about my treatment options \?)) (0 :gist)
  1 (0 .ANYTHING 1 you 2 .WANT-GEN 2 .ASK-GEN 0)
    2 ((Do I have a question about my treatment options \?)) (0 :gist)
)) ; END *treatment-option-question*


(READRULES '*treatment-goals-question*
; (0 cancer-fight 0)
; (0 cancer-live 0)
; (0 cancer-goals 0)
'(
  ; Do you want to try to fight the cancer ?
  1 (0 you 2 .HAVE 2 .CANCER-FIGHT 0)
    2 ((Do I want to try to fight the cancer ?) (Treatment-options)) (0 :gist)
  1 (0 you 2 .WANT 3 .CANCER-FIGHT 0)
    2 ((Do I want to try to fight the cancer ?) (Treatment-options)) (0 :gist)
  1 (0 you 2 .WANT 3 .CANCER-LIVE 0)
    2 ((Do I want to try to fight the cancer ?) (Treatment-options)) (0 :gist)
  ; What are your goals ?
  1 (0 .WH_ 2 .BE 3 your 3 .CANCER-GOALS 0)
    2 ((What are my treatment goals ?) (Treatment-options)) (0 :gist)
  1 (0 .WH_ 3 .CANCER-GOALS 3 .AUX-BASE 1 you 0)
    2 ((What are my treatment goals ?) (Treatment-options)) (0 :gist)
  1 (0 .WH_ 3 .BE 3 .IMPORTANT 2 you 0)
    2 ((What are my treatment goals ?) (Treatment-options)) (0 :gist)
  1 (0 .WH_ 3 .AUX-BASE 2 you 3 .CANCER-GOALS 0)
    2 ((What are my treatment goals ?) (Treatment-options)) (0 :gist)
)) ; END *treatment-goals-question*


(READRULES '*open-ended-question*
'(
  ; signalling a question
  1 (0 I 3 ask 1 you 4 .QUESTION 0)
    2 ((Can you ask me some questions ?)) (0 :gist)
  1 (0 .CAN I 3 make 1 sure 3 I .UNDERSTAND 0)
    2 ((Can you ask me some questions ?)) (0 :gist)
  ; asking if system has any questions
  1 (0 you 2 .HAVE 2 .QUESTION-WORD 0)
    2 ((Do I have a question ?)) (0 :gist)
  1 (0 .QUESTION-WORD 2 you 2 .HAVE 0)
    2 ((Do I have a question ?)) (0 :gist)
  1 (0 .ANYTHING 1 you 2 .WANT-GEN 2 .ASK-GEN 0)
    2 ((Do I have a question ?)) (0 :gist)
  ; meta-questions about conversation
  1 (0 how 4 .CONVERSATION 3 going 0)
    2 ((How do I think this conversation is going ?)) (0 :gist)
  1 (0 .AUX-BASE 3 you 2 .UNDERSTAND-GEN 1 me 0)
    2 ((Am I following what you say ?)) (0 :gist)
  1 (0 .AUX-BASE 3 sophie 2 .UNDERSTAND-GEN 0)
    2 ((Am I following what you say ?)) (0 :gist)
  1 (0 .CAN 3 you 2 .UNDERSTAND-GEN 0)
    2 ((Am I following what you say ?)) (0 :gist)
  1 (0 .BE 3 you 2 .UNDERSTANDING-GEN 0)
    2 ((Am I following what you say ?)) (0 :gist)
  1 (0 how 1 .AUX-BASE 1 that .SOUND 0)
    2 ((How does that sound ?)) (0 :gist)
  ; checking the system's understanding
  1 (0 .TELL 0 what 1 you 1 .UNDERSTAND-GEN 0)
    2 ((What do I understand ?)) (0 :gist)
  1 (0 .DO 1 you 1 .UNDERSTAND-GEN 0)
    2 ((What do I understand ?)) (0 :gist)
  1 (0 .WH_ .DO 1 you 1 .UNDERSTAND-GEN 0)
    2 ((What do I understand ?)) (0 :gist)
  1 (0 .WH_ .BE 1 your 1 .UNDERSTAND-GEN 0)
    2 ((What do I understand ?)) (0 :gist)
  ; asking for system's preferences for information
  1 (0 how .MUCH 3 .INFORMATION-GEN 3 .AUX 1 you 0)
    2 ((How much information do I want ?)) (0 :gist)
  1 (0 how .MUCH 3 .INFORMATION-GEN 3 I 3 you 0)
    2 ((How much information do I want ?)) (0 :gist)
  1 (0 how .MUCH 3 .AUX you 3 .WANT-GEN 1 me 3 .TELL 0)
    2 ((How much information do I want ?)) (0 :gist)
  1 (0 how .MUCH 3 would you 3 .WANT-GEN 1 me 3 .TELL 0)
    2 ((How much information do I want ?)) (0 :gist)
  ; questions about system's feelings
  1 (0 .WH_ 2 you 3 .FEELING 2 .NOW 0)
    2 ((How am I doing today ?)) (0 :gist)
  1 (0 how are you 3)
    2 ((How am I doing today ?)) (0 :gist)
  1 (0 how 1 you 3 .FEELING 0)
    2 ((How am I feeling about my condition ?)) (0 :gist)
  1 (0 how .HAVE you 1 been 0)
    2 ((How am I feeling about my condition ?)) (0 :gist)
  1 (0 .TELL 5 .FEAR-WORDS 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .ELABORATE 4 .FEAR-WORDS 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ 1 make 1 you 3 .FRIGHTENED 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ 1 .FRIGHTENS 1 you 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ .BE 3 .FRIGHTENING 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ 1 you 1 .THINK-GEN 3 .FRIGHTENING 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ .BE 3 .FEAR-WORDS 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ .CAUSE you 4 .FEAR-WORDS 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .WH_ 2 your future 3 .ANXIETY-WORD 0)
    2 ((What scares me about my condition ?)) (0 :gist)
  1 (0 .BE 1 you 1 .ANXIETY-WORD 5 .APPOINTMENT 0)
    2 ((Was I nervous for this appointment ?)) (0 :gist)
  1 (0 .BE 3 .APPOINTMENT 1 .ANXIETY-WORD 0)
    2 ((Was I nervous for this appointment ?)) (0 :gist)
  1 (0 .AUX 3 .APPOINTMENT 1 .ANXIETY-WORD 1 you 0)
    2 ((Was I nervous for this appointment ?)) (0 :gist)
  ; what is the most important thing for your future ?
  1 (0 .WH_ .BE 3 .IMPORTANT 3 your future 0)
    2 ((What is the most important thing for my future ?)) (0 :gist)
  1 (0 .WH_ .BE 3 .IMPORTANT 2 for you 0)
    2 ((What is the most important thing for my future ?)) (0 :gist)
  1 (0 .WH_ 1 .DO 1 you 3 .IMPORTANT 0)
    2 ((What is the most important thing for my future ?)) (0 :gist)
  1 (0 .WH_ 1 .DO 1 you 3 .CANCER-GOALS 0)
    2 ((What is the most important thing for my future ?)) (0 :gist)
  1 (0 .WH_ .BE 1 your 3 .CANCER-GOALS 0)
    2 ((What is the most important thing for my future ?)) (0 :gist)
  ;; Questions on whether the system can hear the user
  1 (0 .AUX 3 you 3 .HEAR 2 .DOCTOR-PRON 0)
    2 ((Can I hear you ?)) (0 :gist)
  1 (0 you 2 able 3 .HEAR 2 .DOCTOR-PRON 0)
    2 ((Can I hear you ?)) (0 :gist)
  ;; How can I help you ?
  1 (0 how 3 .AUX 2 .DOCTOR-PRON 3 .HELP 0)
    2 ((What would help me manage my condition ?)) (0 :gist)
  1 (0 any 2 way 2 .DOCTOR-PRON 3 .HELP 0)
    2 ((What would help me manage my condition ?)) (0 :gist)
  1 (0 .WH_ 3 .CAN 2 .DOCTOR-PRON 0)
    2 (0 .DOCTOR-PRON 3 .HELP 2 you 0)
      3 ((What would help me manage my condition ?)) (0 :gist)
    2 (0 .DOCTOR-PRON 3 .AUX 2 for 2 you 0)
      3 ((What would help me manage my condition ?)) (0 :gist)
  1 (0 .WH_ 3 .BE 3 .BENEFICIAL 0)
    2 ((What would help me manage my condition ?)) (0 :gist)
  1 (0 .WH_ 3 .DIAGNOSIS-SYMPTOM 3 .FRIGHTEN 3 you 0)
    2 ((What would help me manage my condition ?)) (0 :gist)
  1 (0 .WH_ 3 .DIAGNOSIS-SYMPTOM 3 .FRIGHTENS 3 you 0)
    2 ((What would help me manage my condition ?)) (0 :gist)
  1 (0 .DOCTOR-PRON 3 .WANT-GEN 6 .HELP 0)
    2 ((What would help me manage my condition ?)) (0 :gist)
  ; questions about how to refer to the system
  1 (0 .AUX I 1 .CALL 1 you 1 sophie 0)
    2 ((Can you call me sophie ?)) (0 :gist)
  1 (0 .WH_ 1 I 2 .CALL 1 you 0)
    2 ((Can you call me sophie ?)) (0 :gist)
  1 (0 .BE 2 .ALRIGHT 2 .CALL 1 you 1 sophie 0)
    2 ((Can you call me sophie ?)) (0 :gist)
))