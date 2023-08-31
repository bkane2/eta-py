;; *ETA-SCHEMA*: development version 6
;;
;; TODO
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'have-eta-dialog.v

'(dial-schema :header (((set-of ^me ^you) have-eta-dialog.v) ** ?e)
;`````````````````````````````````````````````````````````````````````
; An Eta dialogue focused around a patient-doctor interaction: after an introduction, the
; doctor may initiate conversation with a question. Otherwise, the patient has a list of
; questions on his agenda to ask the doctor (each one may spiral to various sub-dialogues
; before returning to the overall conversation track).
;
; 1. SOPHIE acted as a real cancer patient.
; 2. SOPHIE was able to show her concerns.
; 3. I did not understand what SOPHIE was saying about her prognosis.
; 4. I was given at one opportunity where SOPHIE needed a clarification.
; 5. I was able to discuss the treatment options with SOPHIE.
; 6. During the conversation I think there was chance of being empathetic.
; 7. I ended the conversation with a positive note without giving false hope.
; 8. I think SOPHIE understood her prognosis.
;
;
; palleative care
; doctor gives scan result, choice between chemotherapy A or chemotherapy B
; doesn't give choice of just focusing on comfort
; patients whose doctors offer comfort care as option more likely to take it
; should give the doctor an opportunity to present it as an option
; "what happens if I don't do chemotherapy?"
; "do you think chemotherapy's really going to help?"
; "do you think it's time for me to start thinking about comfort care?"
;
; prognosis:
; patient asks "what does this mean?"
; doctor says "let's try chemo" => doesn't even address question
; "how much of a difference do you think it'll make in terms of how long I live?"
; "how long do you think I have?"
;
;
; 4. What do test results show, how do I interpret them?
;
; 6. What kind of time do you think we're looking at?
;
; 9. Haven't told family everything yet. What should I say to them?
;
; 10. Follow up
;
;
;
; TODO: the steps in this schema are represented as ((set-of ^me ^you) ...), and likewise for the schemas for each
; subdialogue, but perhaps it would make sense for them to be (^me ... ^you) instead.
;

:episodes (

?e1 (^me say-to.v ^you '(Hi\, my name is Sophie\. In the last couple days \, I was given a CT scan to figure how far my cancer has progressed \. 
                        I\'m here today because I want to know what the results are and what they mean for my future \.))
;; TODO: maybe accomodate potential user reply here (with low certainty, so Eta doesn't wait too long for it)


;; 1. (test-results)
?e10 ((set-of ^me ^you) ask-about-test-results.v)


;; 2. (prognosis)
;; NOTE: may be obviated by previous replies.
?e20 ((set-of ^me ^you) ask-about-prognosis.v)

;; 3. (reason-for-cancer)
?e30 ((set-of ^me ^you) ask-why-have-cancer.v)

;; 4. (tell-family)
?e40 ((set-of ^me ^you) ask-what-to-tell-family.v)


?e300 (^me say-to.v ^you '(Thank you for taking the time to meet with me today\. It was difficult to talk about my future\, but comforting to
                          learn more about my options\. You\'ve given me a lot to think about and to discuss with my family\. Goodbye\.))

)

)) ; END have-eta-dialog.v


; TODO REFACTOR : store following topic keys:
;; (?e10 (test-results))
;; (?e20 (prognosis))
;; (?e30 (reason-for-cancer))
;; (?e40 (tell-family))