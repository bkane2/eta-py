; NOTE: these rules were copied from the original SOPHIE system; they may need to be adjusted for the new modules.
;
; This is the top-level gist-clause interpretation rule tree, used to select an appropriate choice packet using
; the context of SOPHIE's previous question or statement. If a match fails here, the system falls back to a
; general subtree intended to match generic questions from the user.
;
(READRULES '*gist-clause-trees-for-input*
'(

  ; It's assumed that Sophie only answers these questions in the very beginning,
  ; so they should redirect back to the topic of the first schema in the dialogue.
  1 (:or
    (3 .NICE to .MEET you 3 \.)
    (you .CAN .CALL me sophie \.)
    (I .CAN .HEAR you \.))
    2 (*pain-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.BE 1 .REASON 3 .PAIN 3 .MAKE-WORSE 1 ?)
    (why 3 .PAIN 2 .MAKE-WORSE 1 ?)
    (what 2 .CAUSE 2 .PAIN 2 .MAKE-WORSE 1 ?)
    (why has my .PAIN been getting worse .RECENTLY ?)
    (my .PAIN has .RECENTLY been getting worse \.)
    (I .BELIEVE my cancer has gotten worse .BECAUSE my .PAIN has also gotten worse \.))
    2 (*pain-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (what 2 the prognosis 3 ?)
    (what 2 my prognosis ?)
    (what 3 mean for 1 future ?)
    (I .KNOW that my cancer has gotten worse \, but i\'m not sure how .BAD it is \.)
    (I .WANT to .TALK about my prognosis today \.)
    (0 How long do you think I have ? 0)
    (0 I need to know about my future 0)
    (0 What does my cancer mean for my future ? 0)
    (0 How bad does my future look ? 0)
    (0 I 1 .NEG 2 understand your prognosis 0))
    2 (*prognosis-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (what 2 my options for .TREATMENT ?)
    (what are my .TREATMENT options if I .DO not .DO .CHEMOTHERAPY ?)
    (0 I\'m finding it stressful to decide which treatment option to take 0)
    (0 I really need to know how these treatments help with my own goals 0)
    (0 You\'re giving me too much information at once and not listening to my goals 0)
    (0 Given the goals that we discussed \, what option do you think is the best ? 0))
    2 (*treatment-option-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (why 1 I not 1 sleeping well ?)
    (I .HAVE not been sleeping well \.))
    2 (*sleep-poorly-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (how will I .KNOW if my .PAIN medication is working ?)
    (why isn\'t the .PAIN medication working anymore ?))
    2 (*medicine-working-input*
        *general-input*) (0 :subtrees)

  1 (:or
    (.CAN I .HAVE a stronger .PAIN medication ?))
    2 (*medicine-stronger-request-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (what .DO my test results mean ?)
    (1 really scared about my worsening condition \.)
    (I don\'t think you understand how hard this is for me !)
    (I don\'t think I can handle this right now \. I need a break \.)
    (I appreciate your empathy \, but can you tell me about my condition ?)
    (0 can you tell me about my condition ?))
    2 (*test-results-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (why .DO I .HAVE cancer ?))
    2 (*reason-for-cancer-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (what .SHOULD I .TELL my .FAMILY ?))
    2 (*tell-family-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.DO I need .CHEMOTHERAPY ?))
    2 (*chemotherapy-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.DO you think .CHEMOTHERAPY will .HELP ?)
    (Do you think I need chemotherapy ?))
    2 (*chemotherapy-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (how does comfort .CARE .WORK ?)
    (.SHOULD I get comfort .CARE ?)
    (Do you think I need comfort care ?)
    (I\'ve heard about something called comfort care \. Do you think that\'s an option ?))
    2 (*comfort-care-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (are you sure that I .DO not need comfort .CARE ?))
    2 (*comfort-care-verification-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (I am here .ALONE \.))
    2 (*appointment-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (I got my diagnosis after visiting a .LUNG doctor \.)
    (I .HAVE lost 1 weight \.))
    2 (*diagnosis-details-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (I had radiation .TREATMENT for .FIVE weeks \.)
    (I was .FEELING a little better after radiation \.))
    2 (*radiation-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.DO you think radiation will .HELP ?))
    2 (*radiation-verification-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (what are the side effects of .CHEMOTHERAPY ?)
    (how does .CHEMOTHERAPY .WORK ?))
    2 (*chemotherapy-details-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.DO you think .EXPERIMENTAL therapies will .HELP ?))
    2 (*experimental-therapy-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (I .HAVE been fatigued \.)
    (I .HAVE had .TROUBLE concentrating \.)
    (I feel mildly depressed \.)
    (I feel anxious about my future \.)
    (will an .ANTIDEPRESSANT .HELP me with my .PAIN ?)
    (.SHOULD I .TRY medication .BEFORE I .TRY .THERAPY ?)
    (my future feels out of my control .BECAUSE I .DO not .KNOW how .MUCH time I .HAVE to live \.))
    2 (*energy-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (I don\'t .HAVE allergies to any .MEDICINE \.)
    (I am only taking lortab to treat my .PAIN \.)
    (I am taking cozar to .HELP with blood pressure \.)
    (taking the lortab more .FREQUENTLY helps \.)
    (I am taking lortab every .THREE hours \.)
    (I .DO not .HAVE a .HISTORY of narcotic abuse \.))
    2 (*medicine-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (what are the side effects of stronger .PAIN medication ?))
    2 (*medicine-side-effects-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.CAN I get addicted to narcotics ?))
    2 (*medicine-side-effects-addiction-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (I .HAVE a .HISTORY of alcohol abuse but .DO not .DRINK .NOW \.)
    (I .HAVE a .HISTORY of alcohol abuse \.)
    (I .DO not .DRINK often .NOW \.)
    (I .HAVE a .HISTORY of smoking but .QUIT .SIX months ago \.)
    (I .HAVE a .HISTORY of smoking \.)
    (I .QUIT smoking .SIX months ago \.)
    (nobody .IN my .FAMILY has a .HISTORY of mental illness \.)
    (my .FAMILY does not .HAVE a .HISTORY of mental illness \.)
    (my .MOTHER died of complications from her diabetes \.)
    (my .FATHER died of prostate cancer \.))
    2 (*medical-history-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (I would .LIKE a refill of .MEDICINE \.))
    2 (*medicine-refill-request-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (has the cancer gotten worse ?))
    2 (*cancer-worse-input*
       *general-input*) (0 :subtrees)
  
  1 (:or
    (are you sure the cancer has not gotten worse ?))
    2 (*cancer-worse-verification-input*
       *general-input*) (0 :subtrees)
  
  1 (:or
    (will stronger .PAIN medication .HELP me .SLEEP ?))
    2 (*stronger-medicine-help-sleep-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.SHOULD I get a .SECOND opinion about my prognosis ?))
    2 (*prognosis-second-opinion-input*
       *prognosis-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.CAN I trust your prognosis ?)
    (I\'m not sure I can trust your prognosis 0)
    (0 There\'s no way your prognosis is true 0)
    (0 I don\'t believe your prognosis 0)
    (0 That\'s ridiculous \. I know I have more time than that 0))
    2 (*prognosis-trust-input*
       *prognosis-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.CAN I outlive your prognosis like my uncle Fred did ?)
    (0 I had an uncle Fred who outlived his prognosis 0))
    2 (*prognosis-bargaining-uncle-input*
       *prognosis-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.CAN I outlive your prognosis if I .HAVE .GOOD-HEALTH habits ?))
    2 (*prognosis-bargaining-habits-input*
       *prognosis-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.CAN I outlive your prognosis if I .QUIT smoking ?))
    2 (*prognosis-bargaining-quit-smoke-input*
       *prognosis-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.CAN I outlive your prognosis if I am .GOOD-HEALTH .NOW ?))
    2 (*prognosis-bargaining-now-input*
       *prognosis-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.CAN I outlive your prognosis until the graduation of my grandson ?)
    (my goal is to survive .LONG enough to .BE there for my .FAMILY \.)
    (0 I need to know if I\'ll be able to watch my grandson\'s graduation 0)
    (0 Is there a chance I\'ll be able to watch my grandson graduate ? 0)
    (0 I just want to make sure I'm there for my grandson 0))
    ; (.BE 1 .ANYTHING 5 .IMPROVE 1 prognosis 8 .GRAD-WORDS 1 ?)
    2 (*prognosis-bargaining-graduation-input*
       *prognosis-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.CAN I outlive your prognosis 0)
    (0 I don\'t see how you could possibly know that prediction for sure 0))
    2 (*prognosis-bargaining-input*
       *prognosis-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (.CAN you rephrase your .QUESTION ?)
    (what are your questions ?))
    2 (*ask-for-questions-input*
       *general-input*) (0 :subtrees)

  1 (:or
    (Goodbye \.))
    2 (*say-bye-input*
       *general-input*) (0 :subtrees)

  1 (0)
    2 (*general-input*) (0 :subtrees)
))