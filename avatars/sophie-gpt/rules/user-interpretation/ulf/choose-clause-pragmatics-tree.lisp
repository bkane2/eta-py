(READRULES '*clause-pragmatics-tree*
;``````````````````````````````````````````````````
; Transduction tree for inferring additional facts from the
; gist-clause interpretations of user input.
;
; TODO: make gist clause patterns more general so that
; language model generated gist clauses can be matched.
;
'(
  ; Empathetic
  1 (:or
    (0 You 2 sorry 0)
    ;;; Reason for cancer
    ;; (0 You 1 wish 1 I 1 .NEG have cancer 0) ; You wish that I didn't have cancer
    (0 You wish that I do not have cancer 0)
    (0 You are sorry that I have cancer 0)
    (0 Cancer is a bad illness 0)
    (0 Cancer can affect anyone 0)
    (0 There is nothing you could have done to change your cancer diagnosis 0)
    (0 There\'s nothing you could have done to change your cancer diagnosis 0)
    (0 Cancer can affect the human body suddenly 0)
    (0 It is expected to feel badly after learning your cancer is terminal 0)
    (0 You empathize with how hard it is to learn my cancer is terminal 0)
    (0 How have I been feeling since the cancer metastasized 0)
    (0 You are going to help me cope with learning my cancer is terminal 0)
    ;;; Test results
    (0 You recognize how hard receiving the test results is for me 0)
    (0 How do I feel about my test results 0)
    ;;; Tell family
    (0 My family is important to me 0)
    (0 You empathize with how hard it is for me to tell my family 0)
    (0 You empathize with how difficult my condition is for my family 0)
    (0 You will be available to help me and my family during cancer treatment 0)
    ;;; Prognosis bargaining (current health)
    (0 You are glad to hear that I am still feeling healthy after my prognosis 0)
    ;;; Prognosis
    (0 You are sorry to inform me of a poor prognosis 0)
    (0 My family is important to understanding what I want to do with my prognosis 0)
    (0 What scares me about my prognosis 0)
    (0 What do I feel about my prognosis 0)
    ;;; Pain
    (0 You are sorry that I am in pain 0)
    ;;; Energy
    (0 You are sorry that I have been feeling down recently 0)
    (0 What parts of my future feel out of my control 0)
    (0 How is my mental health 0)
    ;;; Appointment
    (0 You are sorry that my daughter could not come today 0)
    (0 How am I doing today 0)
    ;;; Open-ended
    (0 How am I feeling about my condition 0)
    (0 How have I been feeling 0)
    (0 You are glad to hear that I am feeling well 0)
    (0 Was I nervous for this appointment 0)
    (0 You will be available to help me 0)
    (0 You empathize with 0)
  )
    2 (^you be.v empathetic.a) (0 :ulf)



  ; Explicit
  ; NOTE: for explicit module, we need to have the following (note that each "level"
  ; entails all the previous levels):
  ; 1. (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n)))
  ; 2. (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))
  ; 3. (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))
  ; 4. (^you tell.v ^me (a.d (specific.a (prognosis.n timeframe.n))))

  ;;; Cancer worse
  1 (:or
    (0 The test results show that I cannot be cured 0)
    (0 My cancer is terminal 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) condition.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))) (0 :ulf)
  1 (:or
    (0 The test results show that my cancer has spread 0)
    (0 My cancer has gotten worse 0)
    (0 radiation is not working 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) condition.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v worse.a)))) (0 :ulf)
  1 (:or
    (0 My cancer has not gotten worse 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) condition.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v (not worse.a))))) (0 :ulf)

  ;;; Prognosis (level 1)
  1 (:or
    ;;; Prognosis bargaining (current health)
    (0 My health right now may improve my prognosis 0)
    (0 My health right now does not change my prognosis 0)
    (0 My health right now improves my prognosis 0)
    ;;; Prognosis bargaining (quitting smoking)
    (0 Quitting smoking will not make my prognosis better 0)
    (0 Quitting smoking might make my prognosis better 0)
    (0 Quitting smooking will make my prognosis better 0)
    ;;; Prognosis bargaining (habits)
    (0 Healthy habits will not help me outlive my prognosis 0)
    (0 Healthy habits will help me outlive my prognosis 0)
    (0 Healthy habits may help me outlive my prognosis 0)
    ;;; Prognosis denial
    (0 My understanding of my prognosis is correct 0)
    (0 My understanding of my prognosis may be correct 0)
    (0 My understanding of my prognosis is incorrect 0)
    (0 The majority of people have an accurate prognosis 0)
    (0 The majority of people do not have an accurate prognosis 0)
    (0 Many people do not have an accurate prognosis 0)
    (0 It is unlikely that I outlive my prognosis 0)
    (0 There is some chance I could outlive my prognosis 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n)))) (0 :ulf)

  ;;; Prognosis (level 2)
  1 (:or
    (0 prognosis is that I cannot be cured 0)
    (0 prognosis .BE 3 terminal 0)
    (0 prognosis .BE 3 .DIE 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))) (0 :ulf)

  ;;; Prognosis (level 3)
  1 (:or
    ;;; Prognosis bargaining (graduation)
    (0 My prognosis is that I will not live to attend the graduation of my grandson 0)
    (0 My prognosis is that I might live to attend the graduation of my grandson 0)
    (0 My prognosis is that I will live to attend the graduation of my grandson 0)
    (0 My prognosis might allow me to attend the graduation of my grandson 0)
    (0 My prognosis will not allow me to attend the graduation of my grandson 0)
    (0 My prognosis is that I likely won\'t live to see my grandson\'s graduation 0)
    ;;; Prognosis
    (0 The prognosis is that I do not have long left to live 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))
       (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))) (0 :ulf)

  ;;; Prognosis (level 4)
  1 (:or
    (0 The prognosis is that I may live for .NUMBER-TOTAL .ELAPSED-TIME 0)
    (0 The prognosis is that I may live for several .ELAPSED-TIME 0)
    (0 The prognosis is that I may live for a .ELAPSED-TIME 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))
       (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))
       (^you tell.v ^me (a.d (specific.a (prognosis.n timeframe.n))))) (0 :ulf)

  1 (:or
    ;;; Treatment options
    (0 Comfort Care is a treatment option 0)
    ;;; Comfort care
    (0 You do not think I need comfort care 0)
    (0 You think I need comfort care 0)
    (0 Receiving comfort care from a nurse is an option 0)
    (0 Receiving comfort care in my own home is an option 0)
    (0 Receiving comfort care from a specialized service is an option 0)
    (0 Receiving comfort care in a dedicated facility is an option 0)
    (0 Comfort care allows me to spend time with my family 0)
    (0 Comfort care should alleviate my pain 0)
  )
    2 ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) (plur option.n)))) and
       (^you tell.v ^me (about.p-arg (k (comfort.n care.n))))) (0 :ulf)

  1 (:or
    ;;; Treatment options
    (0 Chemotherapy is a treatment option 0)
    ;;; Chemotherapy
    (0 You do not think I need chemotherapy 0)
    (0 You think I need chemotherapy 0)
    (0 You think we should talk to my oncologist about chemotherapy 0)
    (0 You do not think I need chemotherapy because I should get comfort care instead 0)
    (0 A side effect of chemotherapy is 0)
    (0 One way to get chemotherapy is 0)
  )
    2 ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) (plur option.n)))) and
       (^you tell.v ^me (about.p-arg (k chemotherapy.n)))) (0 :ulf)
  
  1 (:or
    ;;; Treatment options
    (0 Radiation is a treatment option 0)
    ;;; Experimental therapy
    (0 Experimental treatments might make my prognosis better 0)
    (0 Experimental treatments will make my prognosis better 0)
    (0 Experimental treatments will not make my prognosis better 0)
  )
    2 ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) (plur option.n))))) (0 :ulf)

  1 (:or
    ;;; Tell family
    (0 I should reassure my family about the cancer 0)
    (0 I should tell my family the full truth about my cancer 0)
    ;;; Radiation
    (0 You think I need radiation 0)
    (0 You do not think I need radiation 0)
    ;;; Energy
    (0 I should take an antidepressant 0)
    (0 I should see a therapist 0)
  )
    2 (^you be.v explicit.a) (0 :ulf)



  ; Empowering
  1 (:or
    ;;; Treatment options
    (0 What are my treatment goals 0)
    (0 What are my priorities 0)
    (0 Do I have 1 .QUESTION about my treatment options 0)
    (0 What do I understand about my treatment options 0)
    ;;; Treatment goals
    (0 Do I want to try 1 fight the cancer 0)
    ;;; Test results
    (0 Do I want my family to be .AVAILABLE when you tell me about the test results 0)
    (0 Do I want anyone to be .AVAILABLE when you tell me about the test results 0)
    (0 Do I know what the tests say 0)
    (0 Do I have 1 .QUESTION about my test results 0)
    (0 How much information do I want about my test results 0)
    ;;; Tell family
    (0 Do I want you to contact a family member now 0)
    (0 What can you do to help me break the news to my family 0)
    (0 Do I want you to be .AVAILABLE when I tell my family about the prognosis 0)
    (0 How much do I want my family to know about the prognosis 0)
    (0 Who in my family do I want to tell about the prognosis 0)
    ;;; Prognosis
    (0 Do I want anyone to be .AVAILABLE when you tell me about the prognosis 0)
    (0 Do I want my family to be .AVAILABLE when you tell me about the prognosis 0)
    (0 How specific do I want you to be about my prognosis 0)
    (0 How much information do I want about my prognosis 0)
    (0 Do I understand my prognosis 0)
    ;;; Question about prognosis
    (0 Am I ready to discuss my treatment goals 0)
    (0 Am I ready to start discussing my treatment options 0)
    (0 Do I have 1 .QUESTION about my prognosis 0)
    ;;; Treatment goals (comfort care)
    (0 What do I think about comfort care 0)
    (0 Have I considered comfort care 0)
    (0 Do I understand how comfort care works 0)
    (0 Do I have 1 .QUESTION about comfort care 0)
    ;;; Chemotherapy
    (0 Do I have 1 .QUESTION about chemotherapy 0)
    (0 What are my feelings about chemotherapy 0)
    (0 Do I understand how chemotherapy works 0)
    ;;; Energy
    (0 How is my energy 0)
    (0 Is something harming my mental health 0)
    (0 What scares me about my condition 0)
    ;;; Open-ended
    (0 Do I have 1 .QUESTION 0)
    (0 How do I think this conversation is going 0) 
    (0 How does that sound 0)
    (0 What do I understand 0)
    (0 How much information do I want 0)
    (0 What is the most important thing for my future 0)
    (0 What would help me manage my condition 0)
  )
    2 (^you be.v empowering.a) (0 :ulf)



  ; Goodbye responses
  1 (0 goodbye 0)
    2 ((the.d conversation.n) be.v over.a) (0 :ulf)
))