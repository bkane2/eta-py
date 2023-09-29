; The rules defined in this file contain reactions to specific gist clause questions from the user, in the form of either
; subschemas to instantiate or direct templatic outputs. Note that, in general, GPT-3 generation will be able to
; handle response generation in cases where a specific reaction is not selected here, so these rules are mainly
; used for subschema selection.
;
; The rules are grouped into various subtopics corresponding to topics that
; appear in schemas:
;
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
;

; Define any useful predicates here:


(READRULES '*reaction-to-chemotherapy-question*
;``````````````````````````````````````````````````
; Reactions to chemotherapy will differ between modules, so this rule tree
; will be overridden by the rule files defined within each session subdirectory.
;
'(
  1 (0 what are my feelings about .CHEMOTHERAPY 0)
    2 ask-if-need-chemotherapy.v (100 :schema)
    2 say-preference-for-no-chemotherapy.v (100 :schema)

  1 (0 did my doctor .MENTION .CHEMOTHERAPY 0)
    2 explain-how-doctor-mention-chemotherapy.v (100 :schema)

  1 (:or
    (0 .DO I .UNDERSTAND how .CHEMOTHERAPY works 0)
    (0 what .CHEMOTHERAPY details are you .ASKING about 0)
    )
    2 ask-how-chemotherapy-works.v (100 :schema)
  1 (0 .DO I .HAVE a .QUESTION about .CHEMOTHERAPY 0)
    2 ask-about-chemotherapy-side-effects.v (100 :schema)

)) ; END *reaction-to-chemotherapy-question*



(READRULES '*reaction-to-comfort-care-question*
;``````````````````````````````````````````````````
; Reactions to comfort care will differ between modules, so this rule tree
; will be overridden by the rule files defined within each session subdirectory.
;
'(
  1 (:or
    (0 .HAVE I considered comfort .CARE 0)
    (0 .DO I .UNDERSTAND how comfort .CARE works 0)
    (0 .DO I .HAVE a .QUESTION about comfort .CARE 0)
    )
    2 ask-how-comfort-care-works.v (100 :schema)

)) ; END *reaction-to-comfort-care-question*



(READRULES '*reaction-to-treatment-options-question*
;``````````````````````````````````````````````````````
; Reactions to treatment options will differ between modules, so this rule tree
; will be overridden by the rule files defined within each session subdirectory.
;
'(
  1 (:or
    (0 what .DO I .UNDERSTAND about my .TREATMENT options 0)
    )
    2 ask-about-treatment-options.v (100 :schema)
  1 (0 .DO I .HAVE a .QUESTION about my .TREATMENT options 0)
    2 ask-about-will-experimental-therapies-help.v (100 :schema)

)) ; END *reaction-to-treatment-options-question*



(READRULES '*reaction-to-prognosis-question*
;``````````````````````````````````````````````````````
; Reactions to prognosis will differ between modules, so this rule tree
; will be overridden by the rule files defined within each session subdirectory.
;
'(
  1 (0 how .DO I feel about my prognosis 0)
    2 mention-sadness-about-prognosis.v (100 :schema)
  1 (:or
    (0 how .SPECIFIC .DO I .WANT you to .BE about my prognosis 0)
    (0 how .MUCH information .DO I .WANT about my prognosis 0)
    )
    2 request-all-of-information-about-prognosis.v (100 :schema)

  1 (0 .AUX 2 .WANT-GEN .DOCTOR-PRON 1 .CONCENTRATE 2 .PROGNOSIS-WORD 2 or 2 .EMOTION ?)
    2 say-preference-facts-over-emotions.v (100 :schema)
  ;; TODO:
  ;; 1 (0 what scares me about my prognosis 0)
  ;;   2 ask-about-prognosis.v (100 :schema)
  ;; 1 (0 .DO I .HAVE a .QUESTION about my prognosis 0)
  ;;   2 ask-about-prognosis.v (100 :schema)
  ;; 1 (0 what is the prognosis that was given to me previously 0)
  ;;   2 ask-about-treatment-options.v (100 :schema)
  ;; 1 (0 .DO I .UNDERSTAND my prognosis 0)
  ;;   2 ask-about-prognosis.v (100 :schema)
  ;;   2 ask-if-can-trust-prognosis.v (0 :schema)
  ;; 1 (0 .DO I .WANT my .FAMILY to .BE present when you .TELL me about the prognosis 0)
  ;;   2 ask-about-prognosis.v (100 :schema)
  ;; 1 (0 .DO I .WANT anyone to .BE present when you .TELL me about the prognosis 0)
  ;;   2 ask-about-prognosis.v (100 :schema)
  ;; 1 (0 how prepared for the prognosis are my .FAMILY 0)
  ;;   2 ask-about-prognosis.v (100 :schema)

)) ; END *reaction-to-prognosis-question*





(READRULES '*reaction-to-question*
'(
; ````````````````````     cancer-worse      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````    medical-history    ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 what is my .HISTORY with alcohol 0)
    2 discuss-drinking-habits.v (100 :schema)
  1 (0 what is my .HISTORY with smoking 0)
    2 discuss-smoking-habits.v (100 :schema)
  1 (0 does my .FAMILY .HAVE a .HISTORY of mental illness 0)
    2 discuss-history-mental-illness.v (100 :schema)
  1 (0 how did my parents .DIE 0)
    2 discuss-parent-deaths.v (100 :schema)

; ```````````````````` medicine-side-effects ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````      appointment      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 did I .DRIVE here 0)
    2 explain-drove-today.v (100 :schema)
  1 (0 is anyone here with me 0)
    2 explain-here-alone.v (100 :schema)

; ```````````````````` chemotherapy-details  ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````   diagnosis-details   ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 how did I get my diagnosis 0)
    2 explain-how-got-diagnosis.v (100 :schema)
  1 (0 what symptoms .DO I .HAVE 0)
    2 explain-symptoms.v (100 :schema)
  1 (:or
      (0 .HAVE I changed weight 0)
      (0 how .MUCH weight .HAVE I lost 0)
    )
    2 mention-lost-weight.v (100 :schema)
  1 (0 .HAVE I changed appetite 0)
    2 mention-lost-appetite.v (100 :schema)
  1 (0 .DO I .HAVE the .SYMPTOM of 2 0)
    2 deny-symptom.v (100 :schema)

; ````````````````````        energy         ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 how is my .ENERGY 0)
    2 mention-fatigue.v (100 :schema)
  1 (0 .HAVE I had .TROUBLE concentrating 0)
    2 mention-trouble-concentrating.v (100 :schema)
  1 (0 how is my mental health 0)
    2 mention-mild-depression.v (100 :schema)
  1 (:or
    (0 is something harming my mental health 0)
    (0 was I nervous for this .APPOINTMENT 0)
    (0 how .HAVE I been .FEELING since the cancer metastasized 0)
    )
    2 mention-anxiety.v (100 :schema)
  1 (0 what parts of my future feel out of my control 0)
    2 explain-why-future-feels-out-of-control.v (100 :schema)

; ````````````````````       medicine        ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 .DO I .HAVE allergies to any .MEDICINE 0)
    2 deny-allergies.v (100 :schema)
  1 (:or
    (0 what is my .HISTORY with .MED-NARCOTIC 0)
    (0 what .MEDICINE am I taking 0)
    (0 how were you prescribed your current .PAIN medication 0)
    (0 what dosage of .PAIN medication am I taking 0)
    (0 am I taking .PAIN-MED 0)
    (0 am I taking .MEDICINE for my .PAIN 0)
    (0 am I taking .PAIN-MED-OTHER 0)
    (0 am I taking .MED-NARCOTIC 0)
    )
    2 mention-taking-lortab.v (100 :schema)
  1 (:or
    (0 how often am I taking medication 0)
    (0 does taking medication more .FREQUENTLY .HELP 0)
    )
    2 mention-lortab-frequency.v (100 :schema)
  1 (0 am I taking .BLOOD-PRESSURE-MED 0)
    2 mention-blood-medication.v (100 :schema)
  1 (:or
    (0 is the .PAIN medication working at all 0)
    (0 is the .PAIN medication working 0)
    (0 how is the .PAIN medication working 0)
    (0 .DO I .HAVE a .QUESTION about my .MEDICINE 0)
    )
    2 ask-why-pain-medication-not-working.v (100 :schema)
  1 (0 .DO I .WANT stronger .PAIN medication 0)
    2 ask-about-pain-medication-side-effects.v (100 :schema)
  1 (0 .DO I need more .MEDICINE 0)
    2 ask-for-lortab-refill.v (100 :schema)

; ````````````````````         pain          ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (:or
    (0 .CAN I .TELL you about my .PAIN 1)
    (0 .WH_ 2 .PAIN feel like 0)
    (0 describe 2 .YOUR-REF 2 .PAIN 0)
    (0 did my .PAIN .COME back 0)
    (0 has the .PAIN .BECOME worse 0)
    (0 how has my condition gotten worse 0)
    )
    2 say-pain-worse.v (100 :schema)

  1 (:or 
    (0 does it hurt to 0)
    (0 .DO you .HAVE the .PAIN .FREQUENTLY 0)
    )
    2 say-when-have-pain.v (100 :schema)

  1 (0 how .DO I rate my .PAIN 0) 
    2 say-pain-rating.v (100 :schema)

  1 (0 what causes me to .BELIEVE that my cancer has gotten worse 0)
    2 say-reason-cancer-worse.v (100 :schema)
  
  1 (0 where is the .PAIN located 0)
    2 say-pain-location.v (100 :schema)

; ````````````````````       radiation       ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 did I get radiation .TREATMENT 0)
    2 mention-radiation-time.v (100 :schema)
  1 (0 did I get any hair loss or .REDNESS during radiation .TREATMENT 0)
    2 discuss-radiation-symptoms.v (100 :schema)
  1 (0 did the .PAIN .RESPOND to radiation .TREATMENT 0)
    2 mention-feeling-better-after-radiation.v (100 :schema)

; ````````````````````         sleep         ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (:or
    (0 .HAVE I been sleeping .OKAY 0)
    (0 how often am I waking up at night 0)
    (0 what is on my mind when I .TRY to .SLEEP 0)
    (0 what happens when I .TRY to .SLEEP 0)
    (0 is my mental health keeping me awake 0)
    (0 is .COFFEE keeping me awake 0)
    (0 .CAN I .TELL you about my .SLEEP instead of test results 0)
    )
    2 explain-not-sleeping-well.v (100 :schema)
  1 (0 .DO I .SLEEP during the .DAY 0)
    2 mention-taking-naps.v (100 :schema)
  1 (0 what is my .SLEEP routine 0)
    2 discuss-sleep-routine.v (100 :schema)

; ````````````````````     chemotherapy      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 .CHEMOTHERAPY 0)
    2 *reaction-to-chemotherapy-question* (0 :subtree)

; ````````````````````     comfort-care      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 .COMFORT-CARE-WORD 0)
    2 *reaction-to-comfort-care-question* (0 :subtree)

; ````````````````````   medicine-request    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````   medicine-working    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````       prognosis       ```````````````````````
; ``````````````````````````````````````````````````````````````````

1 (0 .PROGNOSIS-WORD 0)
  2 *reaction-to-prognosis-question* (0 :subtree)

; ````````````````````     sleep-poorly      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````      tell-family      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (:or
    (0 how .MUCH .DO I .WANT my .FAMILY to .KNOW about the prognosis 0)
    (0 what .CAN you .DO to .HELP me break the news to my .FAMILY 0)
    )
    2 ask-what-to-tell-family.v (100 :schema)
  
  1 (0 .DO my .FAMILY .KNOW about my cancer 0)
    2 explain-family-understanding-of-prognosis.v (100 :schema)

  1 (0 who .IN my .FAMILY .DO I .WANT to .TELL about the prognosis 0)
    2 say-preference-for-tell-son-and-daughter.v (100 :schema)
  
  1 (:or
    (0 .DO I .WANT you to .BE present when I .TELL my .FAMILY about the prognosis 0)
    (0 .DO I .WANT you to .CONTACT a .FAMILY member .NOW 0)
    )
    2 say-preference-for-tell-family-alone.v (100 :schema)

; ````````````````````     test-results      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (:or
    (0 what test results am I referring to 0)
    (0 .DO I .KNOW what the tests say 0)
    (0 .CAN I .SUMMARIZE my test results 0)
    )
    2 state-understanding-test-results.v (100 :schema)
  1 (0 how .DO I feel about my test results 0)
    2 mention-stress-about-test-results.v (100 :schema)
  1 (0 .DO I .HAVE a .QUESTION about my test results 0)
    2 ask-what-metastasis-means.v (100 :schema)
  1 (:or
    (0 how .MUCH information .DO I .WANT about my test results 0)
    (0 .DO I .WANT my .FAMILY to .BE present when you .TELL me about the test results 0)
    (0 .DO I .WANT anyone to .BE present when you .TELL me about the test results 0)
    )
    2 ask-about-test-results.v (100 :schema)

; ````````````````````   treatment-option    ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 .TREATMENT 0)
    2 *reaction-to-treatment-options-question* (0 :subtree)

; ````````````````````    treatment-goals    ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (:or
    (0 what are my .TREATMENT goals 0)
    (0 .DO I .WANT to .TRY to .FIGHT the cancer 0)
    )
    2 explain-treatment-goals.v (100 :schema)
  1 (0 when does my .GRANDCHILD .GRAD-WORDS 0)
    2 say-grandson-graduation.v (100 :schema)
  1 (0 who .BE my .SUPPORT system 0)
    2 explain-who-helps-with-medical-situation.v (100 :schema)
  1 (0 .WH_ feelings .AUX you .HAVE about .DEATH 0)
    2 explain-fears-about-death.v (100 :schema)
  1 (0 .WH_ .BE 1 feelings 1 about .RELIGION 0)
    2 explain-feelings-on-religion.v (100 :schema)
  1 (0 .WH_ .AUX 1 .WANT-GEN 1 .AVOID 3 .TREATMENT-OPTION 0 )
    2 say-preference-for-no-chemotherapy.v (100 :schema)
  1 (0 .FUTURE-POSS 2 accept 2 .PAIN 2 .CHEMOTHERAPY 1 live longer 0)
    2 say-preference-for-no-chemotherapy.v (100 :schema)

  1 (0 .FUTURE-POSS 2 .WANT-GEN 2 .BE 2 .RESUSCITATE 0)
    2 say-preference-for-resuscitation.v (100 :schema)

  1 (0 .FUTURE-POSS 2 you .WANT-GEN 2 review 2 condition 0)
    2 demonstrate-interest-in-reviewing-condition.v (100 :schema)

; ````````````````````  open-ended-question  ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (:or
    (0 what .DO I .UNDERSTAND 0)
    (0 how am I .FEELING about my condition 0)
    (0 what scares me about my condition 0)
    )
    2 explain-understanding-of-condition.v (100 :schema)
  1 (0 what is the .MOST .IMPORTANT thing for my future 0)
    2 explain-future-goals.v (100 :schema)
  1 (0 .CAN you .CALL me sophie 0)
    2 confirm-name.v (100 :schema)
  1 (0 .CAN I .HEAR you 0)
    2 confirm-doctor-is-audible.v (100 :schema)
  1 (0 what would .HELP me manage my condition 0)
    2 say-how-to-help.v (100 :schema)
  1 (:or
    (0 .CAN you ask me some questions 0)
    (0 you .HAVE a .QUESTION for me 0)
    )
    2 ask-for-questions.v (0 :schema)

  1 (:or
    (0 how .MUCH information .DO I .WANT 0)
    (0 may .DOCTOR-PRON .SHARE .WH_ .DOCTOR-PRON .THINK-GEN 0)
    )
    2 say-preference-for-informal-language.v (100 :schema)

  1 (:or
    (0 how .DO I think this .CONVERSATION is going 0)
    (0 am I following what you say 0)
    )
    2 state-understanding-conversation.v (100 :schema)

  ;; TODO:
  ;; ; Questions about daughter
  ;; 1 (where does my .DAUGHTER .WORK ?)
  ;;   2 (She works as a nurse in the county school system \. She\'s very diligent \. They gave her an award last year \, but i\'m blanking on the name of it \.) (0 :out)
  ;; 1 (where does my .SON .WORK ?)
  ;;   2 (He\'s in construction management \, out over in utica \. He supervised the team that built the new firehouse there last year \.) (0 :out)
  ;; 1 (how old is my .DAUGHTER ?)
  ;;   2 (She\'s thirty four \. Turning thirty five in a few months \.) (0 :out)
  ;; 1 (how old is my .SON ?)
  ;;   2 (He\'ll be celebrating his fortieth this year \, and is not happy about it \.) (0 :out)
  ;; 1 (.DO I .HAVE any grandchildren ?)
  ;;   2 (Yes \, one grandson \. He\'s starting middle school this year and is absolutely thrilled about it \.) (0 :out)
  ;; 1 (.DO I .HAVE any children ?)
  ;;   2 (Yes \, i\'m staying with my daughter and her husband here in rochester \, but I have a son out in utica as well \.) (0 :out)
  ;; 1 (.DO I live .ALONE ?)
  ;;   2 (I live with my daughter and her husband while i\'m here in rochester \.) (0 :out)
  ;; 1 (am I .MARRIED ?)
  ;;   2 (I was for about twenty years \. But as we got older and the kids went off to college \, things just didn\'t work out as well as we thought they would \. We separated about ten years ago and divorced two years later \.) (0 :out)
  ;; 1 (.CAN I .TELL you about my .FAMILY ?)
  ;;   2 (Yes \, certainly \! Let me see \, I was married for twenty years \, but separated with my ex husband when the kids went off to college \. We\'re still on good terms though \, and I was thinking of catching up with him now that i\'m back in new york \. I also have two children \, a son who lives in utica and a daughter who lives here \, in rochester.she has a son \, my grandson \, who just turned twelve and is starting middle school this year \.) (0 :out)
  ;; 1 (how am I doing today ?)
  ;;   2 ([SAD] the pain isn\'t too bad today \. I\'m mostly just anxious \.) (0 :out)

  1 (0 ? 0)
    2 respond-to-question.v (0 :schema)
    
)) ; END *reaction-to-question*