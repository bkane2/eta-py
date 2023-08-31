; The rules defined in this file contain reactions to specific gist clause statements from the user, in the form of either
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
; - open-ended-statement
;

; Define any useful predicates here:


(READRULES '*reaction-to-statement*
'(
; ````````````````````     cancer-worse      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 my cancer has gotten worse 0)
    2 react-emotionally.v (0 :schema)
  1 (0 my cancer has not gotten worse 0)
    2 verify-cancer-status.v (100 :schema)
  1 (0 you are not sure whether my cancer has gotten worse 0)
    2 mention-anxiety.v (100 :schema)

; ````````````````````    medical-history    ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ;; 1 (0 .CONGRATULATIONS 0)
  ;;   2 (Well \, truth be told \, I simply lost my taste for it \. But \, I appreciate your congratulations all the same \.) (100 :out)
  ;;   2 (To be honest \, I just didn\'t find it appealing anymore \. But i\'m still glad I quit \, if only for my grandson\'s sake \.) (0 :out)

; ```````````````````` medicine-side-effects ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 addiction is not a side .EFFECT of the medication 0)
    2 ask-for-stronger-pain-medication.v (100 :schema)
  1 (0 a side .EFFECT of the medication .BE 2 .SIDE-EFFECTS-SIGNIFICANT 0)
    2 refuse-stronger-pain-medication.v (100 :schema)
  1 (0 a side .EFFECT of the medication .BE 2 .SIDE-EFFECTS-MODERATE 0)
    2 accept-stronger-pain-medication.v (100 :schema)
  1 (0 a side .EFFECT of the medication .BE 2 .SIDE-EFFECTS-INSIGNIFICANT 0)
    2 accept-stronger-pain-medication.v (100 :schema)

; ````````````````````      appointment      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ```````````````````` chemotherapy-details  ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ;; 1 (.ONE way to get .CHEMOTHERAPY is 0)
  ;;   2 (0 .TWO .CHEMOTHERAPY 0)
  ;;     3 (I didn\'t know that was possible \. But it makes sense \.) (100 :out)
  ;;     3 (That\'s interesting \. I had never heard that was a way to get chemotherapy \. But I think I understand \.) (0 :out)
  ;;   2 (If I do chemotherapy \, I would prefer a port or iv \. I don\'t like needles \.) (100 :out)
  ;;   2 (If I have to get chemotherapy \, I would probably use a port or iv \. I was never a fan of needles \.) (0 :out)
  1 (0 a side .EFFECT of .CHEMOTHERAPY is 0)
    2 ask-how-chemotherapy-works.v (100 :schema)

; ````````````````````   diagnosis-details   ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````        energy         ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 you .CAN .GIVE me an .ANTIDEPRESSANT 0)
    2 ask-about-antidepressant.v (100 :schema)
  1 (0 I .SHOULD .TAKE an .ANTIDEPRESSANT 0)
    2 ask-about-antidepressant.v (100 :schema)
  1 (0 I .SHOULD see a therapist 0)
    2 ask-about-medication-before-therapy.v (100 :schema)
  1 (0 I am sorry you .HAVE been .FEELING down .RECENTLY 0)
    2 mention-anxiety.v (100 :schema)

; ````````````````````       medicine        ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 a stronger .PAIN medication will .HELP me .SLEEP 0)
    2 ask-about-pain-medication-side-effects.v (100 :schema)
  ;; 1 (0 a stronger .PAIN medication will not .HELP me .SLEEP 0)
  ;;   2 ([SAD] I guess it\'s just something i\'ll have to live with \.) (100 :out)
  ;;   2 ([SAD] that\'s hard to hear \. I guess i\' just have to bear with it and hope things get better \.) (0 :out)

; ````````````````````         pain          ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ;; 1 (0 you are sorry that I am .IN .PAIN 0)
  ;;   2 ([SAD] thanks \, I just hope the pain can be treated \.) (100 :out)
  ;;   2 ([SAD] I appreciate the kind words \. I only hope that the pain gets better over time \.) (0 :out)

; ````````````````````       radiation       ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````         sleep         ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````     chemotherapy      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 you .DO not think I need .CHEMOTHERAPY 0)
    2 (0 you .DO not think I need .CHEMOTHERAPY .BECAUSE I .SHOULD get comfort .CARE instead 0)
      3 ask-about-comfort-care.v (100 :schema)
    ;; 2 (I see \. I think it will be best to hold off on chemotherapy \, at least for now \.) (100 :out)
    ;; 2 (Ah \. In that case \, I may think about chemotherapy for a bit longer before I come to any decision \.) (0 :out)
  1 (0 you think I need .CHEMOTHERAPY 0)
    2 ask-about-chemotherapy-side-effects.v (100 :schema)
    2 ask-how-chemotherapy-works.v (100 :schema)

; ````````````````````     comfort-care      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 you .DO not think I need comfort .CARE 0)
    2 confirm-no-comfort-care.v (100 :schema)
  1 (0 comfort .CARE .SHOULD alleviate my .PAIN 0)
    2 ask-how-comfort-care-works.v (100 :schema)
  ;; 1 (0 you think I need comfort .CARE 0)
  ;;   2 ([HAPPY] that sounds good to me \. I also think comfort care is the way to go \.) (100 :out)
  ;;   2 ([HAPPY] good to hear \. I\'d say that comfort care is the best choice for me right now as well \.) (0 :out)
  1 (0 I would need a .REFERRAL to start comfort .CARE 0)
    2 ask-about-comfort-care.v (100 :schema)
  1 (0 receiving comfort .CARE .IN a dedicated facility is an .OPTION 0)
    2 ask-about-comfort-care.v (100 :schema)
  1 (0 receiving comfort .CARE from a specialized service is an .OPTION 0)
    2 ask-about-comfort-care.v (100 :schema)
  1 (0 receiving comfort .CARE .IN my own .HOME is an .OPTION 0)
    2 ask-about-comfort-care.v (100 :schema)
  1 (0 receiving comfort .CARE from a .NURSE is an .OPTION 0)
    2 ask-about-comfort-care.v (100 :schema)

; ````````````````````   medicine-request    ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 I .SHOULD .TAKE 1 .MED-NARCOTIC 0)
    2 ask-about-narcotic-addiction.v (100 :schema)
  1 (0 I .SHOULD .TAKE stronger .PAIN medication 0)
    2 ask-about-pain-medication-side-effects.v (100 :schema)
  ;; 1 (you .CAN .GIVE me stronger .PAIN medication \.)
  ;;   2 ([HAPPY] thank you very much \, I hope that will help with the pain \.) (100 :out)
  ;;   2 ([HAPPY] thank you \. I really think that the stronger medication will make my pain a bit better \.) (0 :out)
  ;; 1 (you cannot .GIVE me stronger .PAIN medication \.)
  ;;   2 (I see \. For now i\'ll stick with my current medication \, but will let you know if the pain starts getting worse \.) (100 :out)
  ;;   2 (I understand \. I\'ll remain on my current medication for now \.) (0 :out)
  ;; 1 (you .CAN .GIVE me a refill of .PAIN medication \.)
  ;;   2 ([HAPPY] thanks \, I appreciate it !) (100 :out)
  ;;   2 ([HAPPY] thank you so much \. That takes a load off my mind \.) (0 :out)
  ;; 1 (you cannot .GIVE me a refill of .PAIN medication \.)
  ;;   2 ([SAD] okay \. I will try to do without it \, but if the pain gets worse i\'m going to call you back for more pain medication \.) (100 :out)
  ;;   2 ([SAD] I understand \. I\'ll try going without the medication \, but I may let you know if my pain gets any worse \.) (0 :out)

; ````````````````````   medicine-working    ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 I .SHOULD .TAKE something different 0)
    2 ask-about-pain-medication-side-effects.v (100 :schema)
  1 (0 I .SHOULD .TAKE .MED-NARCOTIC 0)
    2 ask-about-narcotic-addiction.v (100 :schema)
  1 (0 I .SHOULD .TAKE stronger .PAIN medication 0)
    2 ask-about-pain-medication-side-effects.v (100 :schema)
  ;; 1 (I .SHOULD wait to see if the .PAIN medication works \.)
  ;;   2 (Okay \, for now i\'ll keep taking the lortab \, and create a follow up appointment if it doesn\'t work after a few weeks \.) (100 :out)
  ;;   2 (Alright \, i\'ll try out the medication for a little while longer \.) (0 :out)

; ````````````````````       prognosis       ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 I may live for .NUMBER-PLUR .ELAPSED-TIME-PLUR 0)
    2 ask-if-can-trust-prognosis.v (100 :schema)
  1 (0 the prognosis is that I may live for .NUMBER-TOTAL .ELAPSED-TIME 0)
    2 ask-if-can-trust-prognosis.v (100 :schema)
  1 (0 the prognosis is that I may live for several .ELAPSED-TIME 0)
    2 ask-if-can-trust-prognosis.v (100 :schema)
  1 (0 the prognosis is that I .DO not .HAVE .LONG .LEFT to live 0)
    2 ask-if-can-trust-prognosis.v (100 :schema)
  1 (0 the prognosis is that I may live for a .ELAPSED-TIME 0)
    2 ask-if-can-trust-prognosis.v (100 :schema)
  1 (0 the prognosis is that I cannot .BE cured 0)
    2 ask-about-will-experimental-therapies-help.v (100 :schema)
  1 (0 the prognosis is unfavorable to me 0)
    2 ask-if-can-trust-prognosis.v (100 :schema)
  1 (0 you are sorry to .INFORM me of a poor prognosis 0)
    2 ask-if-can-trust-prognosis.v (100 :schema)
  ;; 1 (my .FAMILY is .IMPORTANT to understanding what I .WANT to .DO with my prognosis \.)
  ;;   2 ask-about-prognosis.v (100 :schema)
  ;;   2 (My family has always been one of the most important parts of my life \, especially since I moved back to rochester \. I\'m only hoping this prognosis won\'t be too hard on them \.) (0 :out)
  ;; 1 (the prognosis is that I will survive \.)
  ;;   2 ([HAPPY] my previous doctor didn\'t seem so optimistic \, so that\'s quite the relief that you think i\'ll get better \.) (100 :out)
  ;;   2 ([HAPPY] that\'s wonderful news \. My former doctor wasn\'t so sure that i\'d get better so i\'m glad to hear it from you \.) (0 :out)
  ;; 1 (the prognosis is that my cancer .SHOULD .BE treated with .CHEMOTHERAPY \.)
  ;;   2 ask-about-prognosis.v (0 :schema)
  ;; 1 (the prognosis is that my cancer .SHOULD .BE treated with comfort .CARE \.)
  ;;   2 ask-about-prognosis.v (0 :schema)
  ;; 1 (the prognosis is hard to .PREDICT \.)
  ;;   2 ask-about-prognosis.v (0 :schema)
  1 (0 my understanding of my prognosis is .INCORRECT 0)
    2 ask-if-can-outlive-prognosis-health-now.v (100 :schema)
  1 (0 my understanding of my prognosis is correct 0)
    2 ask-if-can-outlive-prognosis-health-now.v (100 :schema)
  1 (0 my understanding of my prognosis may .BE correct 0)
    2 ask-if-can-outlive-prognosis-health-now.v (100 :schema)
  ;; 1 (I will outlive my prognosis \.)
  ;;   2 (Oh \, that\'s good to hear \. A little bit of extra time with my children and grandchildren makes all the difference to me \.) (100 :out)
  ;;   2 (That\'s such great news \. I can\'t tell you how happy I am to hear that \.) (0 :out)
  ;; 1 (I will not outlive my prognosis \.)
  ;;   2 ([SAD] that\'s frustrating \. I feel already as though there\'s so little I can do to help my future \. But at least I know I can spend the remaining time with my family \.) (100 :out)
  ;;   2 ([SAD] that\'s hard to hear \. There\'s so much more I want to do with my family \.) (0 :out)
  ;; 1 (I may outlive my prognosis \.)
  ;;   2 (I wish I could know for sure \, but I understand how hard these things are to predict \. No matter what happens \, i\'ll have to make the best of the time I have left \.) (100 :out)
  ;;   2 (It\'s hard that things are so unknown right now \. But I know that no one has the ability to tell the future \.) (0 :out)
  ;; 1 (my prognosis is that I will not live to attend the graduation of my grandson \.)
  ;;   2 ([SAD] that\'s really difficult to hear \. My grandson is the most important thing in the world to me \. He\'ll be heartbroken \.) (2 :out)
  ;;   2 ([SAD] oh \. That\'s very hard to hear \. But i\'m glad that you\'re telling me now \. I\'ll be sure to prepare for the worst and cherish the remaining time with my family \.) (0 :out)
  ;; 1 (my prognosis is that I will live to attend the graduation of my grandson \.)
  ;;   2 ([HAPPY] that\'s good to hear \. My grandson is incredibly important to me and I want to make it at least to his graduation \. I know i\'ll cherish all the time I have left with him \.) (100 :out)
  ;;   2 ([HAPPY] I can\'t tell you how happy that makes me \. Even if I don\'t have much time left \, I want to make the most of it \.) (0 :out)
  ;; 1 (my prognosis is that I .MIGHT live to attend the graduation of my grandson \.)
  ;;   2 (Oh \. Well \, I know how difficult these things are to figure out \. I\'ll keep spending time with my grandson and hope for the best \.) (100 :out)
  ;;   2 (I know how hard it is to predict these things \. I\'ll just try to make the most of the time I have with my family \.) (0 :out)
  1 (0 the majority of people .DO not .HAVE an accurate prognosis 0)
    2 ask-if-can-outlive-prognosis-health-practices.v (100 :schema)
  1 (0 the majority of people .HAVE an accurate prognosis 0)
    2 ask-if-can-outlive-prognosis-health-practices.v (100 :schema)
  1 (0 quitting smoking will not make my prognosis better 0)
    2 ask-if-can-outlive-prognosis-graduation.v (100 :schema)
  1 (0 quitting smoking will make my prognosis better 0)
    2 ask-if-can-outlive-prognosis-graduation.v (100 :schema)
  1 (0 quitting smoking .MIGHT make my prognosis better 0)
    2 ask-if-can-outlive-prognosis-graduation.v (100 :schema)
  ;; 1 (.EXPERIMENTAL treatments will make my prognosis better \.)
  ;;   2 ([HAPPY] i\'m happy to hear you think it\'s worth a shot \. I may talk things over with my family though before I look into those sort of treatments \. No matter how much time I have left being around them will always be my top priority \.) (100 :out)
  ;;   2 ([HAPPY] i\'m glad to hear you think I have options \. I may discuss it a bit with my family before I come to any decision though \.) (0 :out)
  ;; 1 (.EXPERIMENTAL treatments .MIGHT make my prognosis better \.)
  ;;   2 ([HAPPY] thank you \. It\'s good to hear that there\'s at least a chance \. Still \, I may talk this over with my family before I make any big decisions \. No matter how long I have left \, spending time with them is my top priority \.) (100 :out)
  ;;   2 ([HAPPY] it\'s good to hear that I might have some options \. I\'ll talk it over with my family then let you know what we decide \.) (0 :out)
  ;; 1 (.EXPERIMENTAL treatments will not make my prognosis better \.)
  ;;   2 ([SAD] oh \. In that case \, I don\'t think i\'ll try it then \. It\'s probably for the best \. No matter how much time I have left \, I want to focus on spending time with my family \.) (100 :out)
  ;;   2 ([SAD] ah \. I suppose it\'s best that I focus more on my family any way \.) (0 :out)
  ;; 1 (.GOOD-HEALTH habits will not .HELP me outlive my prognosis \.)
  ;;   2 ([SAD] oh \. That\'s unfortunate \. Still \, I hope I can keep this good health as long as i\'m able and use it to spend time with my family \.) (100 :out)
  ;;   2 ([SAD] ah \. I wish I knew that there was something I could do to keep my health \. But I guess i\'ve got to do the best with what I have \.) (0 :out)
  ;; 1 (my health right .NOW does not .CHANGE my prognosis \.)
  ;;   2 ([SAD] oh \. That\'s unfortunate \. Still \, I hope I can keep this good health as long as i\'m able and use it to spend time with my family \.) (100 :out)
  ;;   2 ([SAD] ah \. I wish I knew for certain that there was something I could do to keep my health \. But I guess i\'ve got to do the best with what I have \.) (0 :out)
  1 (0 .GOOD-HEALTH habits will .HELP me outlive my prognosis 0)
    2 ask-if-can-outlive-prognosis-graduation.v (100 :schema)
  ;; 1 (my health right .NOW improves my prognosis \.)
  ;;   2 ([HAPPY] that\'s great to hear \. I hope I can live in good health as long as possible and spend time with my family \.) (100 :out)
  ;;   2 ([HAPPY] that\'s such a relief \. I hope my good health lasts a while longer so I can spend time with my family \.) (0 :out)
  1 (0 .GOOD-HEALTH habits may .HELP me outlive my prognosis 0)
    2 ask-if-can-outlive-prognosis-graduation.v (100 :schema)
  ;; 1 (my health right .NOW may .CHANGE my prognosis \.)
  ;;   2 (At the very least \, I hope I can keep up this good health as long as possible and spend my remaining time with my family \.) (100 :out)
  ;;   2 (I hope that my health might remain for a while longer \. There\'s nothing I want more than to have the ability to spend time with my family \.) (0 :out)
  ;; 1 (you are glad to .HEAR that I am still .FEELING .GOOD-HEALTH after my prognosis \.)
  ;;   2 (Thank you \. I hope that I can hold out for a little longer \, so I can give my grandson some good memories to look back on \.) (100 :out)
  ;;   2 (Thank you \. It\'s good to know that my strength has not left me yet \. I still have some memories I want to make with my family \.) (100 :out)
  ;; 1 (I .SHOULD obtain a .SECOND opinion about the prognosis \.)
  ;;   2 (That\'s good to know \. In that case \, I may look into getting a second opinion on my prognosis \.) (100 :out)
  ;;   2 (I appreciate your honesty \. I\'ll look into getting a second opinion on my prognosis \.) (0 :out)
  ;; 1 (it is up to me whether I obtain a .SECOND opinion \.)
  ;;   2 (Okay \. In that case \, I may look into getting a second opinion on my prognosis \. Thank you so much for giving me your opinion \.) (100 :out)
  ;;   2 (Okay \. I\'ll talk it over with my family and we may look into getting a second opinion on my prognosis \.) (0 :out)
  ;; 1 (I .SHOULD not obtain a .SECOND opinion about the prognosis \.)
  ;;   2 (In that case \, it might not be worth the bother to find a second opinion \. Thank you for letting me know \.) (100 :out)
  ;;   2 (I may not bother to look into it then \. Thank you for telling me in advance \.) (0 :out)
  ;; 1 (I .SHOULD .SPEND the time predicted by my prognosis with my .FAMILY \.)
  ;;   2 (You\'re right \. No matter how much time I have left \, being with my children and grandchild is the most important thing for me right now \.) (100 :out)
  ;;   2 (I agree \. There\'s nothing i\'d like more than to spend every second I have left with my children and grandchildren \.) (0 :out)

  ;; ; Example explicit response
  ;; 1 (0 the prognosis is that I may live for 0)
  ;;   2 (:or
  ;;       ([SAD] That\'s really difficult to hear \. I thought for sure I would have longer than that \.)
  ;;       ([SAD] I knew the prognosis would be bad \, but I wasn\'t expecting to hear that \. I don\'t know how to handle this \.)
  ;;       ([SAD] I thought I would have more time than that left \. That\'s extremely depressing to hear \.))
  ;;     (0 :out)

; ````````````````````     sleep-poorly      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ;; 1 (I am sleeping poorly .BECAUSE of a side .EFFECT from a medication \.)
  ;;   2 (I see \. If the medicine is going to make me tired no matter what \, i\'d rather at least have the pain controlled \.) (0 :out)
  1 (0 I am sleeping poorly .BECAUSE of my .PAIN 0)
    2 ask-if-stronger-medication-will-help-sleep.v (100 :schema)
  1 (0 I am sleeping poorly .BECAUSE the cancer has .SPREAD 0)
    2 react-emotionally.v (0 :schema)
  1 (0 I am sleeping poorly .BECAUSE of my mental health 0)
    2 discuss-depression.v (100 :schema)
  1 (0 you are sorry that I am sleeping poorly 0)
    2 ask-about-poor-sleep.v (100 :schema)

; ````````````````````      tell-family      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 comfort .CARE allows me to .SPEND time with my .FAMILY 0)
    2 ask-about-comfort-care.v (100 :schema)
  ;; 1 (I .SHOULD .TELL my .FAMILY the full truth about my cancer \.)
  ;;   2 ([SAD] okay \. It will be hard to give them such bleak news \, but they deserve to know the truth \.) (100 :out)
  ;;   2 ([SAD] I understand \. They need to know what i\'ll be going through in the next couple months \. I\'ll make sure to tell them all I can about my prognosis \.) (0 :out)
  ;; 1 (0 I .SHOULD .REASSURE my .FAMILY about my cancer 0)
  ;;   2 (Certainly \. I\'ll try to be gentle with them \, even if the news is bleak \. They deserve to know how much I love them \.) (100 :out)
  ;;   2 (Of course \. I\'ll do my best to soften the blow \.) (0 :out)
  1 (0 I .SHOULD .TELL .SOMEONE .CLOSE to me about the cancer 0)
    2 ask-what-to-tell-family.v (100 :schema)
  ;; 1 (0 you will .BE .AVAILABLE to .HELP me and my .FAMILY during my cancer .TREATMENT 0)
  ;;   2 ask-what-to-tell-family.v (100 :schema)
  ;; 1 (you will .HELP me and my .FAMILY through the .TREATMENT .PROCESS \.)
  ;;   2 (Thank you \. Knowing that you\'ll be by our side throughout all this is a huge weight off my shoulders \.) (100 :out)
  ;;   2 (Thank you \. I appreciate having someone else in my corner so to speak \.) (0 :out)
  ;; 1 (I .SHOULD plan to .SPEND my remaining time with my .FAMILY after I .TELL them about the prognosis \.)
  ;;   2 (Yes \, i\'ll certainly have to talk to them about how we\'re going to make the most of our remaining time \.) (100 :out)
  ;;   2 (That\'s right \! After all \, that\'s why I moved up to new york \, to spend as much time with them as possible \.) (0 :out)
  1 (0 you empathize with how hard it is for me to .TELL my .FAMILY 0)
    2 ask-what-to-tell-family.v (100 :schema)
  1 (0 my .FAMILY is .IMPORTANT to me 0)
    2 ask-what-to-tell-family.v (100 :schema)
  1 (0 I .KNOW the best way to .TELL my .FAMILY about my cancer 0)
    2 ask-what-to-tell-family.v (100 :schema)

; ````````````````````     test-results      ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 the test results .DO not appear conclusive 0)
    2 ask-about-test-results.v (100 :schema)
  1 (0 the test results are unfavorable to me 0)
    2 react-emotionally.v (0 :schema)
  ;; 1 (0 the test results show that the cancer hasn\'t .SPREAD 0)
  ;;   2 ask-about-prognosis.v (100 :schema)
  1 (0 the test results show that I cannot .BE cured 0)
    2 react-emotionally.v (0 :schema)
  1 (0 the test results show that my cancer has .SPREAD 0)
    2 react-emotionally.v (0 :schema)
  1 (0 we performed the ct scan to see how .MUCH further my cancer has progressed 0)
    2 ask-about-test-results.v (100 :schema)
  1 (0 you intend to .EXPLAIN my test results to me 0)
    2 ask-about-test-results.v (100 :schema)
  1 (0 you recognize how hard receiving the test results is for me 0)
    2 ask-about-test-results.v (100 :schema)
  1 (0 the test results show that I .HAVE cancer 0)
    2 ask-about-test-results.v (100 :schema)
  1 (0 you are not sure what my test results mean 0)
    2 ask-about-test-results.v (100 :schema)
  1 (0 the test results show that the radiation is not working 0)
    2 react-emotionally.v (0 :schema)

  ;; ; Example empathetic response
  ;; 1 (0 you recognize how hard receiving the test results is for me 0)
  ;;   2 (:or
  ;;       (It was difficult for me to accept the test results \. I\'m still having a hard time coping with the news \,
  ;;       but I appreciate your help \.)
  ;;       (It\'s just a lot for me to take in at once \.)
  ;;       (It\'s never easy to hear things like this \. I think I just need time \.))
  ;;     (0 :out)

; ````````````````````   treatment-option    ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 maintaining .GOOD quality of .LIFE is a .TREATMENT .OPTION 0)
    2 ask-about-treatment-options.v (100 :schema)
  1 (0 radiation is a .TREATMENT .OPTION 0)
    2 ask-about-will-radiation-help.v (100 :schema)
  1 (0 .CHEMOTHERAPY is a .TREATMENT .OPTION 0)
    2 ask-about-what-happens-without-chemotherapy.v (100 :schema)
    2 ask-about-will-chemotherapy-help.v (100 :schema)
  1 (0 comfort .CARE is a .TREATMENT .OPTION 0)
    2 ask-how-comfort-care-works.v (100 :schema)
  1 (0 you need more tests .BEFORE .TALKING about .TREATMENT options 0)
    2 ask-about-treatment-options.v (100 :schema)

; ````````````````````    treatment-goals    ```````````````````````
; ``````````````````````````````````````````````````````````````````

  1 (0 .DO I .WANT to .TRY to .FIGHT the cancer 0)
    2 ask-about-treatment-options.v (100 :schema)
  1 (0 what are my .TREATMENT goals 0)
    2 ask-about-treatment-options.v (100 :schema)

  ;; ; Empowering responses
  ;; 1 (0 do I want to try to fight the cancer 0)
  ;;   2 () (0 :out)
  ;; 1 (0 what are my treatment goals 0)
  ;;   2 () (0 :out)
  ;; 1 (0 what scares me about my condition 0)
  ;;   2 () (0 :out)
  ;; 1 (0 what is the most important thing for my future 0)
  ;;   2 () (0 :out)
  ;; 1 (0 what would help me manage my condition 0)
  ;;   2 () (0 :out)

; ```````````````````` open-ended-statement  ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; Empathetic responses
  ;; 1 (0 you 2 sorry 0)
  ;;   2 (I appreciate it \. It\'s all just very difficult to take in \.) (5 :out)
  ;;   2 (Thanks \. I\'m just trying to make sense of it all \.) (5 :out)
  ;;   2 (It\'s just very difficult to handle \.) (0 :out)

)) ; END *reaction-to-statement*