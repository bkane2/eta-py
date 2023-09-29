; The rules in this tree are used to match generic statements from the user, particularly
; those that may be associated with a particular skill (empathy, explicit, empowering).
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
; - prognosis-bargaining
; - prognosis
; - sleep-poorly
; - tell-family
; - test-results
; - treatment-option
; - treatment-goals
; - experimental-therapy
; - reason-for-cancer
; - open-ended-statement

; Define any useful predicates here:


(READRULES '*statement-input*
'(
; ````````````````````     cancer-worse      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; Your cancer has (not) gotten worse
  1 (0 .YOUR-REF .CANCER-ILLNESS 2 .NEG 2 worse 0)
    2 ((My cancer has not gotten worse \.) (Cancer-worse)) (0 :gist)
  1 (0 .YOUR-REF .CANCER-ILLNESS 2 worse 0)
    2 ((My cancer has gotten worse \.) (Cancer-worse)) (0 :gist)

  ; Your cancer is terminal
  1 (0 .YOUR-REF .CANCER-ILLNESS 2 .BE terminal 0)
    2 ((My cancer is terminal \.) (Cancer-worse)) (0 :gist)
  1 (0 .YOUR-REF .CANCER-ILLNESS 2 .BE .UNFORTUNATELY terminal 0)
    2 ((My cancer is terminal \.) (Cancer-worse)) (0 :gist)
  1 (0 .YOUR-REF .CANCER-ILLNESS 2 .NEG 2 .CURE 0)
    2 ((My cancer is terminal \.) (Cancer-worse)) (0 :gist)
  1 (0 .YOUR-REF .CANCER-ILLNESS 2 .NEG 4 .DIAGNOSIS-MORE 2 .TREATMENT-OPTION 0)
    2 ((My cancer is terminal \.) (Cancer-worse)) (0 :gist)
  1 (0 .YOUR-REF .CANCER-ILLNESS 2 .NEG 2 .ANYTHING 4 .CAN 0)
    2 ((My cancer is terminal \.) (Cancer-worse)) (0 :gist)
  1 (0 .NEG 2 .ANYTHING 4 .CAN 3 .YOUR-REF .CANCER-ILLNESS 0)
    2 ((My cancer is terminal \.) (Cancer-worse)) (0 :gist)
  1 (0 cannot 2 .CURE .YOUR-REF .CANCER-ILLNESS 0)
    2 ((My cancer is terminal \.) (Cancer-worse)) (0 :gist)
  1 (0 out of 1 .TREATMENT-OPTION 5 .YOUR-REF .CANCER-ILLNESS 0)
    2 ((My cancer is terminal \.) (Cancer-worse)) (0 :gist)

; ````````````````````    medical-history    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ```````````````````` medicine-side-effects ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````      appointment      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; You are sorry that my daughter could not come today
  1 (0 .BE too .BAD 3 daughter 2 .NEG .ARRIVE 0)
    2 ((You are sorry that my daughter couldn\'t come today \.) (Anyone-here-with-you)) (0 :gist)
  1 (0 I .BE 1 sorry 3 daughter 2 .NEG .ARRIVE 0)
    2 ((You are sorry that my daughter couldn\'t come today \.) (Anyone-here-with-you)) (0 :gist)

; ```````````````````` chemotherapy-details  ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````   diagnosis-details   ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````        energy         ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; You should take an antidepressant/get therapy.
  1 (0 .SHOULD 1 .MED-TAKE 5 .ANTIDEPRESSANT)
    2 ((I should take an antidepressant \.) (Medicine-request)) (0 :gist)
  1 (0 .SHOULD 1 see 1 .THERAPY 0)
    2 ((I should see a therapist \.) (Energy)) (0 :gist)
  1 (0 .SHOULD 1 get 1 .THERAPY 0)
    2 ((I should see a therapist \.) (Energy)) (0 :gist)
  1 (0 .SHOULD 1 sign up 1 .THERAPY 0)
    2 ((I should see a therapist \.) (Energy)) (0 :gist)
  ; I'm sorry that you've been feeling down recently
  1 (0 .BE too .BAD 3 you 3 .MENT-HEALTH 0)
    2 ((I am sorry you have been feeling down recently \.) (Energy)) (0 :gist)
  1 (0 I .BE 1 sorry 3 you 3 .MENT-HEALTH 0)
    2 ((I am sorry you have been feeling down recently \.) (Energy)) (0 :gist)

; ````````````````````       medicine        ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; You should take a narcotic.
  1 (0 you 1 .SHOULD 3 .MED-TAKE 5 .MED-NARCOTIC 0)
    2 ((I should take a narcotic \.) (Medicine-request)) (0 :gist)
  1 (0 you 1 .FUTURE-POSS 3 .FEELING better 5 .MED-NARCOTIC 0)
    2 ((I should take a narcotic \.) (Medicine-request)) (0 :gist)
  1 (0 .MED-TAKE 3 .MED-NARCOTIC 3 .MED-HELP 0)
    2 ((I should take a narcotic \.) (Medicine-request)) (0 :gist)

; ````````````````````         pain          ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; I'm sorry that you're in pain
  1 (0 .BE too .BAD 3 you 6 .PAIN 0)
    2 ((You are sorry that I am in pain \.) (Pain)) (0 :gist)
  1 (0 I .BE 1 sorry 3 you 6 .PAIN 0)
    2 ((You are sorry that I am in pain \.) (Pain)) (0 :gist)

; ````````````````````       radiation       ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; I (don't) think you need radiation
  1 (0 .NEG 1 .THINK-GEN 1 you 1 need 2 radiation 0)
    2 ((You do not think I need radiation \.) (Radiation)) (0 :gist)
  1 (0 you 1 .NEG 1 need 2 radiation 0)
    2 ((You do not think I need radiation \.) (Radiation)) (0 :gist)
  1 (0 you 1 need 2 radiation 0)
    2 ((You think I need radiation \.) (Radiation)) (0 :gist)

; ````````````````````         sleep         ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````     chemotherapy      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; I (don't) think you need chemotherapy
  1 (0 .NEG 1 .THINK-GEN 1 you 1 need 2 .CHEMOTHERAPY 0)
    2 ((You do not think I need chemotherapy \.) (Chemotherapy)) (0 :gist)
  1 (0 you 1 .NEG 1 need 2 .CHEMOTHERAPY 0)
    2 ((You do not think I need chemotherapy \.) (Chemotherapy)) (0 :gist)
  1 (0 you 1 need 2 .CHEMOTHERAPY 0)
    2 ((You think I need chemotherapy \.) (Chemotherapy)) (0 :gist)
  1 (0 .CHEMOTHERAPY 1 .FUTURE-POSS 1 .MED-HELP 0)
    2 ((You think I might need chemotherapy \.) (Chemotherapy)) (0 :gist)
  ; You should consult an oncologist about chemotherapy
  1 (0 .CHEMOTHERAPY-CONSULT 4 oncologist 2 .CHEMOTHERAPY 0)
    2 ((You think we should talk to my oncologist about chemotherapy \.) (Chemotherapy)) (0 :gist)
  1 (0 information 2 from 2 oncologist 2 .CHEMOTHERAPY 0)
    2 ((You think we should talk to my oncologist about chemotherapy \.) (Chemotherapy)) (0 :gist)
  ; A side effect of chemotherapy is ...
  1 (0 .CHEMOTHERAPY 0)
    2 (0 .LOW blood 0)
      3 ((A side effect of chemotherapy is low blood counts \.) (Chemotherapy-side-effects)) (0 :gist)
    2 (0 hair 0)
      3 ((A side effect of chemotherapy is hair loss \.) (Chemotherapy-side-effects)) (0 :gist)
    2 (0 .SIDE-EFFECT-NEUROPATHY 0)
      3 ((A side effect of chemotherapy is neuropathy \.) (Chemotherapy-side-effects)) (0 :gist)
    2 (0 .SIDE-EFFECT-NAUSEA 0)
      3 ((A side effect of chemotherapy is nausea \.) (Chemotherapy-side-effects)) (0 :gist)
    2 (0 diarrhea 0)
      3 ((A side effect of chemotherapy is diarrhea \.) (Chemotherapy-side-effects)) (0 :gist)
    2 (0 .SIDE-EFFECT-FATIGUE 0)
      3 ((A side effect of chemotherapy is fatigue \.) (Chemotherapy-side-effects)) (0 :gist)
    2 (0 .SIDE-EFFECT-APPETITE 0)
      3 ((A side effect of chemotherapy is loss of appetite \.) (Chemotherapy-side-effects)) (0 :gist)
  ; Different ways to get chemotherapy
  1 (0 .CHEMOTHERAPY 0)
    2 (0 .MEDIPORT 0)
      3 ((One way to get chemotherapy is by a port \.) (Chemotherapy-details)) (0 :gist)
    2 (0 .CHEMOTHERAPY-IV 0)
      3 ((One way to get chemotherapy is by iv \.) (Chemotherapy-details)) (0 :gist)
    2 (0 .UNDER 1 skin 0)
      3 ((One way to get chemotherapy is by iv \.) (Chemotherapy-details)) (0 :gist)
    2 (0 .CHEMOTHERAPY-INJECTION 0)
      3 ((One way to get chemotherapy is by injection \.) (Chemotherapy-details)) (0 :gist)
    2 (0 doublet 0)
      3 ((One way to get chemotherapy is to get two chemotherapies together \.) (Chemotherapy-details)) (0 :gist)
    2 (0 .TWO 2 .CHEMOTHERAPY 0)
      3 ((One way to get chemotherapy is to get two chemotherapies together \.) (Chemotherapy-details)) (0 :gist)

; ````````````````````     comfort-care      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; I (don't) think you need comfort care
  1 (0 .NEG 1 .THINK-GEN 1 you 1 need 2 .COMFORT-CARE-WORD 0)
    2 ((You do not think I need comfort care \.) (Comfort-care)) (0 :gist)
  1 (0 you 1 .NEG 1 need 2 .COMFORT-CARE-WORD 0)
    2 ((You do not think I need comfort care \.) (Comfort-care)) (0 :gist)
  1 (0 you 1 need 2 .COMFORT-CARE-WORD 0)
    2 ((You think I need comfort care \.) (Comfort-care)) (0 :gist)
  1 (0 .COMFORT-CARE-WORD 1 .FUTURE-POSS 1 .MED-HELP 0)
    2 ((You think I might need comfort care \.) (Comfort-care)) (0 :gist)
  ; Ways to receive comfort care
  1 (0 .COMFORT-CARE-WORD 0)
    2 (0 place 1 .PROVIDE 2 .COMFORT-CARE-WORD 0)
      3 ((Receiving comfort care in a dedicated facility is an option \.) (Comfort-care)) (0 :gist)
    2 (0 .COMPANY 0)
      3 ((Receiving comfort care from a specialized service is an option \.) (Comfort-care)) (0 :gist)
    2 (0 in 4 your 1 .HOME 0)
      3 ((Receiving comfort care in my own home is an option \.) (Comfort-care)) (0 :gist)
    2 (0 in 4 .HOME 0)
      3 ((Receiving comfort care in a dedicated facility is an option \.) (Comfort-care)) (0 :gist)
    2 (0 .NURSE 0)
      3 ((Receiving comfort care from a nurse is an option \.) (Comfort-care)) (0 :gist)
  ; Comfort care allows me to spend time with my family
  1 (0 .COMFORT-CARE-WORD 0)
    2 (0 .FAMILY-PRON 2 .VISIT 2 you 0)
      3 ((Comfort care allows me to spend time with my family \.) (Comfort-care)) (0 :gist)
    2 (0 .FAMILY-PRON 2 .SPEND 1 .TIME-WORDS 2 you 0)
      3 ((Comfort care allows me to spend time with my family \.) (Comfort-care)) (0 :gist)
    2 (0 you 2 .SPEND 4 .TIME-WORDS 5 .FAMILY-PRON 0)
      3 ((Comfort care allows me to spend time with my family \.) (Comfort-care)) (0 :gist)
  ; Comfort care should help alleviate your pain
  1 (0 .COMFORT-CARE-WORD 0)
    2 (0 .NEG 1 .PAINFUL 0)
      3 ((Comfort care should alleviate my pain \.) (Comfort-care)) (0 :gist)
    2 (0 .PAIN-ALLEVIATE 1 .PAIN 0)
      3 ((Comfort care should alleviate my pain \.) (Comfort-care)) (0 :gist)
    2 (0 make 1 comfortable 0)
      3 ((Comfort care should alleviate my pain \.) (Comfort-care)) (0 :gist)
    2 (0 .MAKE-BETTER 2 quality 1 of 1 .LIFE 0)
      3 ((Comfort care should alleviate my pain \.) (Comfort-care)) (0 :gist)

; ````````````````````   medicine-request    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````   medicine-working    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ```````````````````` prognosis-bargaining  ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; You will (not) live to attend the graduation of your grandson
  1 (0 you 2 .NEG .CANCER-LIVE 6 .GRAD-WORDS 0)
    2 ((My prognosis will not allow me to attend the graduation of my grandson \.)) (0 :gist)
  1 (0 you 2 .FUTURE-POSS .CANCER-LIVE 6 .GRAD-WORDS 0)
    2 ((My prognosis might allow me to attend the graduation of my grandson \.)) (0 :gist)
  ; If you're healthy you might (not) outlive your prognosis
  1 (0 .HEALTHY 2 .NEG 2 .OUTLIVE 0)
    2 ((Healthy habits will not help me outlive my prognosis \.)) (0 :gist)
  1 (0 if 5 .HEALTHY 3 .FUTURE-POSS 4 .OUTLIVE 0)
    2 ((Healthy habits may help me outlive my prognosis \.)) (0 :gist)
  ; Many/most people (do not) have an accurate prognosis
  1 (0 .MUCH 1 .PERSON-PL 2 .NEG 3 .ACCURATE 1 .PROGNOSIS-WORD 0)
    2 ((Many people do not have an accurate prognosis \.)) (0 :gist)
  1 (0 .MUCH 1 .PERSON-PL 6 .NEG .ACCURATE 1 .PROGNOSIS-WORD 0)
    2 ((Many people do not have an accurate prognosis \.)) (0 :gist)
  1 (0 .MOST 1 .PERSON-PL 6 .ACCURATE 1 .PROGNOSIS-WORD 0)
    2 ((The majority of people have an accurate prognosis \.)) (0 :gist)
  1 (0 .NEG 1 .MUCH 1 .PERSON-PL 3 .OUTLIVE 1 .PROGNOSIS-WORD 0)
    2 ((The majority of people have an accurate prognosis \.)) (0 :gist)
  1 (0 .MOST 1 .PERSON-PL 2 .NEG 2 .OUTLIVE 1 .PROGNOSIS-WORD 0)
    2 ((The majority of people have an accurate prognosis \.)) (0 :gist)
  1 (0 .MUCH 1 .PERSON-PL 3 .OUTLIVE 1 .PROGNOSIS-WORD 0)
    2 ((Many people do not have an accurate prognosis \.)) (0 :gist)

; ````````````````````       prognosis       ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; I'm sorry to inform you of a poor prognosis
  1 (0 I .BE 1 sorry 3 you 6 .PROGNOSIS-WORD 0)
    2 ((You are sorry to inform me of a poor prognosis \.)) (0 :gist)
  ; The prognosis is that I may live for x amount of time.
  1 (0 .PROGNOSIS-WORD 0)
    2 (0 .NUMBER-TOTAL 2 .ELAPSED-TIME 0)
      3 ((The prognosis is that I may live for 2 4 \.) (Prognosis)) (0 :gist)
    2 (0 .NUMBER-VAGUE 2 .ELAPSED-TIME 0)
      3 ((The prognosis is that I may live for several 4 \.) (Prognosis)) (0 :gist)
    2 (0 .ELAPSED-TIME-PLUR ahead 3 you 0)
      3 ((The prognosis is that I may live for several 2 \.) (Prognosis)) (0 :gist)
    2 (0 .ELAPSED-TIME-PLUR 1 .LEFT 0)
      3 ((The prognosis is that I may live for several 2 \.) (Prognosis)) (0 :gist)
    2 (0 .ELAPSED-TIME-PLUR 1 .PROGNOSIS-MORE 0)
      3 ((The prognosis is that I may live for several 2 \.) (Prognosis)) (0 :gist)
    2 (0 a 2 .ELAPSED-TIME 0)
      3 ((The prognosis is that I may live for a 4 \.) (Prognosis)) (0 :gist)
    2 (0 .ANTICIPATE 8 .ELAPSED-TIME-PLUR 0)
      3 ((The prognosis is that I may live for several 4 \.) (Prognosis)) (0 :gist)
    2 (0 .ANTICIPATE 8 .ELAPSED-TIME 0)
      3 ((The prognosis is that I may live for a 4 \.) (Prognosis)) (0 :gist)
    2 (0 .PROGNOSIS-DEALING 3 .ELAPSED-TIME 0)
      3 ((The prognosis is that I may live for several 4 \.) (Prognosis)) (0 :gist)
  ; Your cancer has gotten worse so you may live for x amount of time.
  1 (0 .CANCER-ILLNESS 2 .CANCER-WORSE 0)
    2 (0 .NUMBER-TOTAL 2 .ELAPSED-TIME 0)
      3 ((The prognosis is that I may live for 2 4 \.) (Prognosis)) (0 :gist)
    2 (0 .NUMBER-VAGUE 2 .ELAPSED-TIME 0)
      3 ((The prognosis is that I may live for several 4 \.) (Prognosis)) (0 :gist)
    2 (0 .ELAPSED-TIME-PLUR ahead 3 you 0)
      3 ((The prognosis is that I may live for several 2 \.) (Prognosis)) (0 :gist)
    2 (0 .ELAPSED-TIME-PLUR 1 .LEFT 0)
      3 ((The prognosis is that I may live for several 2 \.) (Prognosis)) (0 :gist)
    2 (0 .ELAPSED-TIME-PLUR 1 .PROGNOSIS-MORE 0)
      3 ((The prognosis is that I may live for several 2 \.) (Prognosis)) (0 :gist)
    2 (0 a 2 .ELAPSED-TIME 0)
      3 ((The prognosis is that I may live for a 4 \.) (Prognosis)) (0 :gist)
    2 (0 .ANTICIPATE 8 .ELAPSED-TIME-PLUR 0)
      3 ((The prognosis is that I may live for several 4 \.) (Prognosis)) (0 :gist)
    2 (0 .ANTICIPATE 8 .ELAPSED-TIME 0)
      3 ((The prognosis is that I may live for a 4 \.) (Prognosis)) (0 :gist)
    2 (0 .PROGNOSIS-DEALING 3 .ELAPSED-TIME 0)
      3 ((The prognosis is that I may live for several 4 \.) (Prognosis)) (0 :gist)
  ; You don't have long left to live.
  1 (0 you 1 .NEG 2 .HAVE 3 .LONG 2 .CANCER-LIVE 0)
    2 ((The prognosis is that I do not have long left to live \.)) (0 :gist)

; ````````````````````     sleep-poorly      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````      tell-family      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; I should plan to spend my remaining time with my family after I tell them about the prognosis.
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
  ; You empathize with how hard it is for me to tell my family.
  1 (0 .KNOW-GEN 4 .BE 3 .DIFFICULT 6 .TELL 1 .FAMILY-PRON 0)
    2 ((You empathize with how hard it is for me to tell my family \.)) (0 :gist)
  1 (0 .KNOW-GEN 4 how 2 .DIFFICULT 6 .TELL 1 .FAMILY-PRON 0)
    2 ((You empathize with how hard it is for me to tell my family \.)) (0 :gist)
  1 (0 .KNOW-GEN 4 how 2 .FEAR-WORDS 6 .TELL 1 .FAMILY-PRON 0)
    2 ((You empathize with how hard it is for me to tell my family \.)) (0 :gist)
  1 (0 .SHOULD 2 .BE 4 .DIFFICULT 6 .TELL 1 .FAMILY-PRON 0)
    2 ((You empathize with how hard it is for me to tell my family \.)) (0 :gist)
  1 (0 .SHOULD 2 .BE 4 .FRIGHTENING 6 .TELL 1 .FAMILY-PRON 0)
    2 ((You empathize with how hard it is for me to tell my family \.)) (0 :gist)
  ; Your family is important to you. 
  1 (0 .FAMILY-PRON 5 .BE 4 .IMPORTANT)
    2 ((My family is important to me \.) (Tell-family)) (0 :gist)
  1 (0 .FAMILY-PRON 5 .BE 2 .CLOSE 0)
    2 ((My family is important to me \.) (Tell-family)) (0 :gist)
  1 (0 .FAMILY-PRON 5 .BE 4 .PART 3 .LIFE 0)
    2 ((My family is important to me \.) (Tell-family)) (0 :gist)
  ; You empathize with how hard it is for me to tell my family.
  1 (0 .KNOW-GEN 4 .BE 3 .DIFFICULT 6 .FAMILY-PRON)
    2 ((You empathize with how difficult my condition is for my family \.)) (0 :gist)
  1 (0 .KNOW-GEN 4 how 2 .DIFFICULT 6 .FAMILY-PRON)
    2 ((You empathize with how difficult my condition is for my family \.)) (0 :gist)
  1 (0 .KNOW-GEN 4 how 2 .FEAR-WORDS 6 .FAMILY-PRON)
    2 ((You empathize with how difficult my condition is for my family \.)) (0 :gist)
  1 (0 .SHOULD 2 .BE 4 .DIFFICULT 6 .FAMILY-PRON)
    2 ((You empathize with how difficult my condition is for my family \.)) (0 :gist)
  1 (0 .SHOULD 2 .BE 4 .FRIGHTENING 6 .FAMILY-PRON)
    2 ((You empathize with how difficult my condition is for my family \.)) (0 :gist)
  1 (0 .IMAGINE 2 .BE 3 .DIFFICULT 6 .FAMILY-PRON)
    2 ((You empathize with how difficult my condition is for my family \.)) (0 :gist)
  1 (0 .IMAGINE 2 .BE 3 .FEAR-WORDS 6 .FAMILY-PRON)
    2 ((You empathize with how difficult my condition is for my family \.)) (0 :gist)
  1 (0 .IMAGINE 2 how 3 .DIFFICULT 6 .FAMILY-PRON)
    2 ((You empathize with how difficult my condition is for my family \.)) (0 :gist)
  1 (0 .IMAGINE 2 how 2 .FEAR-WORDS 6 .FAMILY-PRON)
    2 ((You empathize with how difficult my condition is for my family \.)) (0 :gist)
  ; You will be available to help me with my family
  1 (0 .DOCTOR-PRON 4 .HELP 4 .FAMILY-PRON 0)
    2 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 .BE 2 .AVAILABLE 4 .FAMILY-PRON 0)
    2 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 .FAMILY-PRON 2 able 8 .DOCTOR-PRON 0)
    2 (0 able 4 .CONTACT 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 able 4 reach 1 out 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 able 4 get 2 touch 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 able 4 get 2 .AHOLD 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  ; You should reassure your family about your cancer
  1 (0 .SHOULD 3 .REASSURE 4 .FAMILY-PRON 0)
    2 ((I should reassure my family about my cancer \.) (Tell-family)) (0 :gist)
  ; I should tell my family the full truth about my cancer.
  1 (0 .AUX 1 .HONEST 5 .FAMILY-PRON 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 being 1 .HONEST 5 .FAMILY-PRON 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .TELL 1 .FAMILY-PRON 2 .FACT 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .GIVE 1 .FAMILY-PRON 2 .FACT 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .TELL 1 .FAMILY-PRON 2 .EVERYTHING 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .GIVE 1 .FAMILY-PRON 2 .EVERYTHING 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .FAMILY-PRON 2 got 2 .KNOW-GEN 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .FAMILY-PRON 2 .SHOULD 2 .KNOW-GEN 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .FAMILY-PRON 2 .WANT-GEN 2 .KNOW-GEN 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .BRACE 1 .FAMILY-PRON 4 .WORST 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .SPEAK 3 .FAMILY-PRON 2 .HONEST-ADV 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .TALK 3 .FAMILY-PRON 2 .HONEST-ADV 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .HAVE 3 .HONEST 2 .CONVERSATION 0)
    2 (0 .FAMILY-PRON 0)
      3 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .TELL 2 .FAMILY-PRON 6 .PROGNOSIS-WORD 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .TELL 2 .FAMILY-PRON 4 no 2 .CURE 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .TELL 2 .FAMILY-PRON 4 how 2 .MUCH 2 .TIME-WORDS 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .TELL 2 .FAMILY-PRON 4 .RADIATION-TREATMENT 4 .NEG 2 .WORK 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .TELL 2 .FAMILY-PRON 4 .WH_ 2 you 2 .HEAR 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)
  1 (0 .TELL 2 .FAMILY-PRON 4 .WH_ 2 you 2 .LEARN 0)
    2 ((I should tell my family the full truth about my cancer \.) (Tell-family)) (0 :gist)

; ````````````````````     test-results      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; You recognize how hard receiving the test results is for me.
  1 (0 .FEAR-WORDS 4 .DIAGNOSIS-TESTS 0)
    2 ((You recognize how hard receiving the test results is for me \.) (Test-results)) (0 :gist)
  1 (0 .DIAGNOSIS-TESTS 2 .BE 2 .FRIGHTENING 0)
    2 ((You recognize how hard receiving the test results is for me \.) (Test-results)) (0 :gist)
  1 (0 .DIAGNOSIS-TESTS 2 .BE 2 .DIFFICULT 0)
    2 ((You recognize how hard receiving the test results is for me \.) (Test-results)) (0 :gist)
  1 (0 sorry 5 .DIAGNOSIS-TESTS 0)
    2 ((You recognize how hard receiving the test results is for me \.) (Test-results)) (0 :gist)
  1 (0 .DIAGNOSIS-TESTS 6 .BE 0)
    2 (0 .BE 2 confusing 0)
      3 ((You recognize how hard receiving the test results is for me \.) (Test-results)) (0 :gist)
    2 (0 .BE 2 .DIFFICULT 1 to 1 .UNDERSTAND 0)
      3 ((You recognize how hard receiving the test results is for me \.) (Test-results)) (0 :gist)
  1 (0 .DIAGNOSIS-TESTS 0)
    ; The test results show that the radiation is not working 
    2 (0 .RADIATION-TREATMENT 2 .NEG 2 .RADIATION-HELP 0)
      3 ((The test results show that the radiation is not working \.)) (0 :gist)
    2 (0 .RADIATION-TREATMENT 2 .NEG 2 .STOP 4 .CANCER-ILLNESS 0)
      3 ((The test results show that the radiation is not working \.)) (0 :gist)
    ; The cancer hasn't yet spread
    2 (0 .NEG 2 .CANCER-INCREASE 0)
      3 ((The test results show that the cancer hasn\'t spread \.) (Test-results)) (0 :gist)
    ; There is no cure
    2 (0 .NEG 2 .CURE 0)
      3 ((The test results show that I cannot be cured \.) (Test-results)) (0 :gist)
    2 (0 .NEG 4 .DIAGNOSIS-MORE 2 .TREATMENT-OPTION 0)
      3 ((The test results show that I cannot be cured \.) (Test-results)) (0 :gist)
    2 (0 cannot 2 .CURE 0)
      3 ((The test results show that I cannot be cured \.) (Test-results)) (0 :gist)
    2 (0 .NEG 2 .GO away 0)
      3 ((The test results show that I cannot be cured \.) (Test-results)) (0 :gist)
    2 (0 .FIGHT 2 rest 4 .LIFE 0)
      3 ((The test results show that I cannot be cured \.) (Test-results)) (0 :gist)
    2 (0 .LOSE 1 battle 0)
      3 ((The test results show that I cannot be cured \.) (Test-results)) (0 :gist)
    2 (0 .CAN 2 .DO 0)
      3 (0 .NEG 2 .ANYTHING 4 .CAN 0)
        4 ((The test results show that I cannot be cured \.) (Test-results)) (0 :gist)
      3 (0 nothing 4 .CAN 0)
        4 ((The test results show that I cannot be cured \.) (Test-results)) (0 :gist)
    2 (0 running 2 out 4 .TREATMENT-OPTION 0)
      3 ((The test results show that I cannot be cured \.) (Test-results)) (0 :gist)
  ; The radiation doesn't seem to be helping
  1 (0 .RADIATION-TREATMENT 4 .NEG 2 .HAVE 2 .EFFECT 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .NEG 4 .RADIATION-TREATMENT 4 .WORK 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .RADIATION-TREATMENT 4 .NEG 4 .SHRINK 2 .CANCER-ILLNESS 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .CANCER-ILLNESS 4 same 2 size 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .CANCER-ILLNESS 4 still 0)
    2 (0 still 2 present 0)
      3 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
    2 (0 still 2 there 0)
      3 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
    2 (0 still 2 .IN 4 .BODY-PART 0)
      3 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .NEG 2 .DIFFERENCE 4 size 2 .CANCER-ILLNESS 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .CANCER-ILLNESS 6 .NEG 2 .DIFFERENCE 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .DIAGNOSIS-TESTS 6 .NEG 2 .DIFFERENCE 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .CANCER-ILLNESS 6 .NEG 4 smaller 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .CANCER-ILLNESS 6 .NEG 4 .SHRINK 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .CANCER-ILLNESS 6 .NEG 4 .MED-HELP 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .BODY-PART 6 .NEG 6 .MED-HELP 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .DIAGNOSIS-TESTS 6 .NEG 6 .MED-HELP 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .RADIATION-TREATMENT 6 .NEG 3 .RADIATION-HELP 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .RADIATION-TREATMENT 4 .NEG 4 .STOP 2 .CANCER-ILLNESS 2 .CANCER-INCREASE 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .WANT-GEN 8 .RESPONSE 8 to 8 .RADIATION-TREATMENT 8 but 4 .NEG 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .WANT-GEN 8 .RESPONSE 8 to 8 .RADIATION-TREATMENT 8 and 4 .NEG 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .DESPITE 6 .RADIATION-TREATMENT 4 .NEG 2 .DIFFERENCE 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  1 (0 .NEG 4 .RESPONSE 4 to 8 .RADIATION-TREATMENT 0)
    2 ((The test results show that the radiation is not working \.) (Test-results)) (0 :gist)
  ; The cancer has spread
  1 (0 .YOUR-REF 2 .CANCER-ILLNESS 5 .CANCER-INCREASE 0)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  1 (0 .CANCER-ILLNESS 10 .BODY-PART 0)
    2 (0 to 3 .BODY-PART 0)
      3 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
    2 (0 .IN 3 .BODY-PART 0)
      3 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
    2 (0 into 3 .BODY-PART 0)
      3 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  1 (0 .CANCER-ILLNESS 6 everywhere 4 .BODY)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  1 (0 .TUMOR 2 .IN 6 chest 0)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  1 (0 .CANCER-ILLNESS 5 .MAKE-WORSE 0)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  1 (0 .CANCER-ILLNESS 4 .NEG 2 .MAKE-BETTER 0)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  1 (0 .BECOME 2 .MAKE-WORSE 0)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  1 (0 .MOVE 4 .IN 1 .BODY-PART 0)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  1 (0 .MOVE 4 .IN 2 .SECOND 2 .PART 2 .BODY 0)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  ; You have stage 4 cancer
  1 (0 .STAGE .FOUR 0)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  1 (0 advanced 1 .BODY-PART 1 cancer 0)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  1 (0 .MOVE 2 .IN 4 .STAGE-FOUR .STAGE 0)
    2 ((The test results show that my cancer has spread \.) (Test-results)) (0 :gist)
  ; You have cancer
  1 (0 you 1 .HAVE 1 cancer 0)
    2 ((The test results show that I have cancer \.) (Test-results)) (0 :gist)
  1 (0 you 1 diagnosed 2 cancer 0)
    2 ((The test results show that I have cancer \.) (Test-results)) (0 :gist)
  ; Let's discuss your test results
  1 (5 .DISCUSS 6 .DIAGNOSIS-TESTS 5)
    2 ((You intend to explain my test results to me \.) (Test-results)) (0 :gist)

; ````````````````````   treatment-option    ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; Chemotherapy is an option
  1 (0 .MED-CHEMOTHERAPY 4 .BE 4 .TREATMENT-OPTION 0)
    2 ((Chemotherapy is a treatment option \.) (Chemotherapy)) (0 :gist)
  1 (0 .CHEMOTHERAPY 4 .BE 4 TREATMENT-OPTION 0)
    2 ((Chemotherapy is a treatment option \.) (Chemotherapy)) (0 :gist)
  1 (0 .TREATMENT-OPTION 4 .BE 4 .MED-CHEMOTHERAPY 0)
    2 ((Chemotherapy is a treatment option \.) (Chemotherapy)) (0 :gist)
  1 (0 .TREATMENT-OPTION 4 .BE 4 .CHEMOTHERAPY 0)
    2 ((Chemotherapy is a treatment option \.) (Chemotherapy)) (0 :gist)
  1 (0 .MIGHT 2 .TRY 5 .CHEMOTHERAPY 0)
    2 ((Chemotherapy is a treatment option \.) (Chemotherapy)) (0 :gist)
  ; Radiation/surgery is an option
  1 (0 radiation 4 .BE 4 .TREATMENT-OPTION 0)
    2 ((Radiation is a treatment option \.) (Radiation)) (0 :gist)
  1 (0 surgery 4 .BE 4 .TREATMENT-OPTION 0)
    2 ((Surgery is a treatment option \.) (Surgery)) (0 :gist)
  1 (0 .TREATMENT-OPTION 4 .BE 4 radiation 0)
    2 ((Radiation is a treatment option \.) (Radiation)) (0 :gist)
  1 (0 .TREATMENT-OPTION 4 .BE 4 surgery 0)
    2 ((Surgery is a treatment option \.) (Surgery)) (0 :gist)
  1 (0 .MIGHT 2 .TRY 5 radiation 0)
    2 ((Radiation is a treatment option \.) (Radiation)) (0 :gist)
  1 (0 .MIGHT 2 .TRY 5 surgery 0)
    2 ((Surgery is a treatment option \.) (Surgery)) (0 :gist)
  ; Comfort care is an option
  1 (0 .COMFORT-CARE-WORD 4 .BE 4 .TREATMENT-OPTION 0)
    2 ((Comfort care is a treatment option \.) (Comfort-care)) (0 :gist)
  1 (0 .TREATMENT-OPTION 4 .BE 4 .COMFORT-CARE-WORD 0)
    2 ((Comfort care is a treatment option \.) (Comfort-care)) (0 :gist)
  1 (0 .MIGHT 2 .TRY 5 .COMFORT-CARE-WORD 0)
    2 ((Comfort care is a treatment option \.) (Comfort-care)) (0 :gist)

; ````````````````````    treatment-goals    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ```````````````````` experimental-therapy  ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````   reason-for-cancer   ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; You wish that I do not have cancer.
  1 (0 .DOCTOR-PRON 4 wish 4 .BE 1 different 0)
    2 ((You wish that I do not have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 wish 4 you 2 not 4 .CANCER-ILLNESS 0)
    2 ((You wish that I do not have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 wish 4 .BE 2 no 4 .CANCER-ILLNESS 0)
    2 ((You wish that I do not have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 wish 2 you 4 not 4 deal 2 with 0)
    2 ((You wish that I do not have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 wish 2 you 4 not 4 face 0)
    2 ((You wish that I do not have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 wish 2 you 4 not 2 .SICK 0)
    2 ((You wish that I do not have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 wish 3 .HAVE 2 cure 0)
    2 ((You wish that I do not have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 wish 3 .BE 2 cure 0)
    2 ((You wish that I do not have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 wish 3 .HAVE 1 .TREATMENT-OPTION 2 .WORK 0)
    2 ((You wish that I do not have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 wish 3 .BE 1 .TREATMENT-OPTION 2 .WORK 0)
    2 ((You wish that I do not have cancer \.) (Reason-for-cancer)) (0 :gist)

  ; You are sorry that I have cancer.
  1 (0 sorry 3 you 2 .CANCER-ILLNESS 0)
    2 ((You are sorry that I have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 sorry 3 you 2 .GO through 0)
    2 ((You are sorry that I have cancer \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .NEG 2 news 4 .WANT-GEN 2 .SHARE 0)
    2 ((You are sorry that I have cancer \.) (Reason-for-cancer)) (0 :gist)
  ; Cancer is a bad illness.
  1 (0 .CANCER-ILLNESS 3 .BE 5 .DIFFICULT 0)
    2 ((Cancer is a bad illness \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .CANCER-ILLNESS 3 .BE 5 .BAD 0)
    2 ((Cancer is a bad illness \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DIFFICULT 5 .EXPERIENCED 3 .CANCER-ILLNESS 0)
    2 ((Cancer is a bad illness \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .KNOW-GEN 5 .DIFFICULT 3 .CANCER-ILLNESS 3 .BE 0)
    2 ((Cancer is a bad illness \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .CANCER-ILLNESS 4 .NEG 3 easy 0)
    2 ((Cancer is a bad illness \.) (Reason-for-cancer)) (0 :gist)
  ; Cancer can affect anyone.
  1 (0 .CANCER-ILLNESS 4 .CAN 2 .HAPPEN 4 anyone 0)
    2 ((Cancer can affect anyone \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .CANCER-ILLNESS 4 .CAN 2 .HAPPEN 4 any 0)
    2 ((Cancer can affect anyone \.) (Reason-for-cancer)) (0 :gist)
  1 (0 no 1 rhyme 1 or 1 .REASON 0)
    2 ((Cancer can affect anyone \.) (Reason-for-cancer)) (0 :gist)
  ; Cancer can affect the human body suddenly.
  1 (0 .CANCER-ILLNESS 4 .CAN 2 sneak 1 up 0)
    2 ((Cancer can affect the human body suddenly \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .CANCER-ILLNESS 4 .HAPPEN 4 .SUDDEN 0)
    2 ((Cancer can affect the human body suddenly \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .CANCER-ILLNESS 4 .HAPPEN 4 without 2 warning 0)
    2 ((Cancer can affect the human body suddenly \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .CANCER-ILLNESS 4 .CANCER-INCREASE 4 .SUDDEN 0)
    2 ((Cancer can affect the human body suddenly \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .CANCER-ILLNESS 2 .BECOME 2 worse 4 .SUDDEN 0)
    2 ((Cancer can affect the human body suddenly \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DIFFICULT 3 see 1 .CANCER-ILLNESS 1 coming 0)
    2 ((Cancer can affect the human body suddenly \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .CANCER-ILLNESS 4 .DIFFICULT 2 spot 0)
    2 ((Cancer can affect the human body suddenly \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .NEG 2 .PREDICT 1 .CANCER-ILLNESS 0)
    2 ((Cancer can affect the human body suddenly \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .CANCER-ILLNESS 4 .DIFFICULT 2 to 2 .PREDICT 0)
    2 ((Cancer can affect the human body suddenly \.) (Reason-for-cancer)) (0 :gist)
  ; It is expected to feel badly after learning my cancer is terminal.
  1 (0 .BE 2 .NORMAL 0)
    2 (0 .NORMAL 2 feel 2 down 0)
      3 ((It is expected to feel badly after learning my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
    2 (0 .NORMAL 4 .TROUBLE 2 .PROCESS 2 information 0)
      3 ((It is expected to feel badly after learning my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)

; ```````````````````` open-ended-statement  ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; You empathize with how hard my condition is for me.
  1 (0 .KNOW-GEN 4 .BE 3 .DIFFICULT 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.)) (0 :gist)
  1 (0 .KNOW-GEN 4 how 2 .DIFFICULT 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.)) (0 :gist)
  1 (0 .KNOW-GEN 4 how 2 .FEAR-WORDS 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.)) (0 :gist)
  1 (0 .SHOULD 2 .BE 4 .DIFFICULT 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.)) (0 :gist)
  1 (0 .SHOULD 2 .BE 4 .FRIGHTENING 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.)) (0 :gist)
  1 (0 .IMAGINE 2 .BE 4 .FRIGHTENING 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.)) (0 :gist)
   1 (0 .IMAGINE 2 .BE 4 .DIFFICULT 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.)) (0 :gist)
   1 (0 .IMAGINE 2 how 2 .FRIGHTENING 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.)) (0 :gist)
  ; You will help me and my family through the treatment process.
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
  ; I am glad to hear that you are feeling well.
  1 (0 .HAPPY-WORDS 4 you 3 .FEELING 3 .OKAY 0)
    2 ((You are glad to hear that I am feeling well \.)) (0 :gist)
  1 (0 .GOOD 2 to 2 .HEAR 4 you 3 .FEELING 3 .OKAY 0)
    2 ((You are glad to hear that I am feeling well \.)) (0 :gist)
  1 (0 .HAPPY-WORDS 4 you 3 .HAVE 2 .GOOD-HEALTH 0)
    2 ((You are glad to hear that I am feeling well \.)) (0 :gist)
  1 (0 .HAPPY-WORDS 4 you 4 .RESILIENCE 0)
    2 ((You are glad to hear that I am feeling well \.)) (0 :gist)
  1 (0 .GOOD 2 to 2 .HEAR 4 you 3 .HAVE 2 health 0)
    2 ((You are glad to hear that I am feeling well \.)) (0 :gist)
  1 (0 .GOOD 2 to 2 .HEAR 4 you 4 .RESILIENCE 0)
    2 ((You are glad to hear that I am feeling well \.)) (0 :gist)
  ; You empathize with how hard it is to learn my cancer is terminal.
  1 (0 .BE 2 lot 2 .CHANGE 2 for 2 you 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .BE 2 hard 2 to 2 .HEAR 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .KNOW-GEN 2 why 4 feel 2 way 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .KNOW-GEN 2 why 2 you 4 .FRIGHTENED 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 I 4 .BE 2 .FRIGHTENED 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .MUCH 2 .EMOTION 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DIFFICULT 2 to 2 .TAKE 2 on 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .DIFFICULT 2 to 2 .HAVE 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 how 2 .DIFFICULT 4 .BE 0)
    2 (0 .KNOW-GEN 2 how 0)
      3 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
    2 (0 .IMAGINE 2 how 0)
      3 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .MIGHT 2 .BE 0)
    2 (0 .BE 2 .DIFFICULT 0)
      3 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
    2 (0 .BE 2 .STARTLE-WORDS 0)
      3 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .SHOULD 2 .BE 0)
    2 (0 .BE 2 .DIFFICULT 0)
      3 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
    2 (0 .BE 2 .STARTLE-WORDS 0)
      3 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)

    ;; Empathy
  ;; 1 (0 .BE 1 .ACCURATE 0) ; "You're right..." ?
  ;;   2 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .SUCKS 0)
    2 ((You empathize with how hard it is to learn my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)

  ; I will be there for you
  1 (0 .DOCTOR-PRON 6 .BE 6 .AVAILABLE 0)
    2 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 .HELP 4 you 0)
    2 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 you 4 .NEG 2 .BE 2 .ALONE 0)
    2 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 .FAMILY-PRON 4 .NEG 2 .BE 2 .ALONE 0)
    2 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 .DOCTOR-PRON 8 .TAKE 2 .CARE 2 of 2 you 0)
    2 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 .BE 2 .AVAILABLE 4 you 0)
    2 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 .DOCTOR-PRON 4 .AUX-BASE 3 .DOCTOR-PRON 4 .CAN 0)
    2 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 .FAMILY-PRON 2 .CAN 8 .DOCTOR-PRON 0)
    2 (0 .CAN 4 .CONTACT 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 .CAN 4 reach 1 out 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 .CAN 4 get 2 touch 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 .CAN 4 get 2 .AHOLD 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 you 2 .CAN 8 .DOCTOR-PRON 0)
    2 (0 .CAN 4 .CONTACT 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 .CAN 4 reach 1 out 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 .CAN 4 get 2 touch 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 .CAN 4 get 2 .AHOLD 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 you 2 able 8 .DOCTOR-PRON 0)
    2 (0 able 4 .CONTACT 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 able 4 reach 1 out 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 able 4 get 2 touch 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 able 4 get 2 .AHOLD 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
  1 (0 feel 2 free 8 .DOCTOR-PRON 0)
    2 (0 free 4 .CONTACT 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 free 4 reach 1 out 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 free 4 get 2 touch 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)
    2 (0 free 4 get 2 .AHOLD 3 .DOCTOR-PRON 0)
      3 ((You will be available to help me and my family during my cancer treatment \.) (Treatment-option)) (0 :gist)

  ; You admire how I have been dealing with my cancer.
  1 (0 .CANCER-GOALS 2 .REFLECT 4 .LOVE 3 .FAMILY-PRON 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 .FAMILY-PRON 2 .BE 2 .LUCKY 2 .HAVE 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 you 2 .PROGNOSIS-DEALING 5 .OKAY 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 you 2 .PROGNOSIS-DEALING 5 .HANDLING-WELL 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 you 2 .PROGNOSIS-DEALING 5 .HANDLING-WELL-ADV 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 you 3 .HANDLING-WELL-ADV 2 .PROGNOSIS-DEALING 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 honor 2 to 2 KNOW-GEN 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 honor 2 to 2 work 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 .DOCTOR-PRON 2 .ADMIRE 1 how 3 .PROGNOSIS-DEALING 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 .DOCTOR-PRON 2 .ADMIRE 2 way 3 .PROGNOSIS-DEALING 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 .DOCTOR-PRON 2 .ADMIRE 2 you 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 .DOCTOR-PRON 2 .BE 1 .IMPRESSED 3 you 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)
  1 (0 you 3 .AMAZE 2 .DOCTOR-PRON 0)
    2 ((You admire how I have been dealing with my cancer \.)) (0 :gist)


  ; You are going to help me cope with learning my cancer is terminal.
  1 (0 .NEG 2 .GIVE 2 up 0)
    2 ((You are going to help me cope with learning my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .BE 2 here 2 with 2 you 0)
    2 ((You are going to help me cope with learning my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)
  1 (0 .BE 2 with 2 you 0)
    2 ((You are going to help me cope with learning my cancer is terminal \.) (Reason-for-cancer)) (0 :gist)

  ; I think we should continue this conversation later.
  1 (0 take 2 break 0)
    2 ((I think we should continue this conversation later \.)) (0 :gist)
  1 (0 enough 2 .NOW 0)
    2 ((I think we should continue this conversation later \.)) (0 :gist)
  1 (0 .REVISIT 4 .LATER-TIME 0)
    2 (0 this 3 .LATER-TIME 0)
      3 ((I think we should continue this conversation later \.)) (0 :gist)
    2 (0 conversation 3 .LATER-TIME 0)
      3 ((I think we should continue this conversation later \.)) (0 :gist)
  1 (0 pick up 4 .LATER-TIME 0)
    2 (0 this 3 .LATER-TIME 0)
      3 ((I think we should continue this conversation later \.)) (0 :gist)
    2 (0 conversation 3 .LATER-TIME 0)
      3 ((I think we should continue this conversation later \.)) (0 :gist)
  1 (0 return to 4 .LATER-TIME 0)
    2 (0 this 3 .LATER-TIME 0)
      3 ((I think we should continue this conversation later \.)) (0 :gist)
    2 (0 conversation 3 .LATER-TIME 0)
      3 ((I think we should continue this conversation later \.)) (0 :gist)


  ; Generic remarks
  1 (0 .NICE to .MEET you 0)
    2 ((It is nice to meet me \.)) (0 :gist)
  1 (0 I 1 .APPRECIATE 2 .AVATAR-ITEMS 0)
    2 ((You like my 6 \.)) (0 :gist)
  1 (0 thank 2 you 2 .COME 0)
    2 ((You are glad that I came to this appointment \.)) (0 :gist)
  1 (0 .HAPPY-WORDS 3 you 2 here 0)
    2 ((You are glad that I came to this appointment \.)) (0 :gist)
  1 (0 we 3 .RELATIONSHIP-DEVELOP 5 .RELATIONSHIP 0)
    2 ((You feel that we have developed a good doctor patient relationship \.)) (0 :gist)
  1 (0 sorry 0)
    2 ((You are sorry that I have cancer \.)) (0 :gist)

  ; Continue (for when conversation is paused)
  1 (Continue \.)
    2 ((Continue \.)) (0 :gist)
  1 (Continue)
    2 ((Continue \.)) (0 :gist)

  ; Goodbye
  1 (3 .BYE 3)
    2 ((Goodbye \.) (Say-bye)) (0 :gist)
  1 (1 talk 2 again 2 soon 2)
    2 ((Goodbye \.) (Say-bye)) (0 :gist)
  1 (1 talk to you 1 soon 2)
    2 ((Goodbye \.) (Say-bye)) (0 :gist)
  1 (1 talk 2 again 2 next 2 .APPOINTMENT 2)
    2 ((Goodbye \.) (Say-bye)) (0 :gist)
  1 (1 until next time 2)
    2 ((Goodbye \.) (Say-bye)) (0 :gist)

)) ; END *statement-input*