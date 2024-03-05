(READRULES '*pragmatic*
;``````````````````````````````````````````````````
; Transduction tree for inferring additional facts from the
; gist-clause interpretations of user input.
;
'(
  ; Empathetic
  1 (:or
    (0 you 2 sorry 0)
    ;;; Cancer
    (0 you 1 wish 1 .SELF 1 .NEG have 2 .CANCER-ILLNESS 0)
    (0 you 1 wish 2 things 2 .BE 2 different 0)
    (0 you 2 .BE 3 sorry 1 .SELF have 2 .CANCER-ILLNESS 0)
    (0 cancer .BE 2 .BAD 1 .CANCER-ILLNESS 0)
    (0 .CANCER-ILLNESS can affect .ANYONE 0)
    (0 nothing 2 could have done 3 .CHANGE 2 .CANCER-ILLNESS 0)
    (0 nothing 2 could have done 3 .CHANGE 2 diagnosis 0)
    (0 .CANCER-ILLNESS can affect 3 body suddenly 0)
    (0 .NORMAL to 3 after .LEARN-GEN 1 .CANCER-ILLNESS 1 terminal 0)
    (0 .NORMAL to 3 after .LEARN-GEN 1 .NEG 1 .OUTLIVE 0)
    (0 you .EMPATHIZE 2 .DIFFICULT 3 .LEARN-GEN 0)
    (0 how 1 .SELF 1 .FEELING since 1 .CANCER-ILLNESS 0)
    (0 how 3 .FEELING 1 about 3 .CANCER_ILLNESS 0)
    (0 you 3 help 1 .COPE 1 .LEARN-GEN 0)
    ;;; Test results
    (0 you 1 .UNDERSTAND-GEN 3 how .DIFFICULT 0)
    (0 you 1 .UNDERSTAND-GEN 4 .DIFFICULT to 0)
    (0 you 1 .UNDERSTAND-GEN 8 .BE .DIFFICULT 0)
    (0 .WH_ 3 .FEELING 1 about 3 .DIAGNOSIS-TESTS 0)
    ;;; Treatment Options
    (0 empathize 2 how overwhelming .LEARN-GEN 3 .TREATMENT-OPTION .BE 0)
    ;;; Tell family
    (3 my .FAMILY 1 .BE 1 .IMPORTANT 0)
    (0 you .EMPATHIZE 2 .DIFFICULT 8 .TELL 1 .FAMILY 0)
    (0 you .EMPATHIZE 2 .DIFFICULT 5 for 1 .FAMILY 0)
    (0 you 2 .BE .AVAILABLE 5 .FAMILY 0)
    ;;; Prognosis bargaining (current health)
    (0 you 2 .HAPPY-WORDS 5 .SELF 4 .GOOD-HEALTH 0)
    (0 you 2 .HAPPY-WORDS 5 .SELF 4 .FEELING 1 .OKAY 0)
    ;;; Prognosis
    (0 you 2 .BE 3 sorry 8 .PROGNOSIS-WORD 0)
    (0 my .FAMILY 1 .BE 1 .IMPORTANT 2 .UNDERSTAND-GEN 8 .PROGNOSIS-WORD 0)
    (0 .WH_ 5 .ANXIETY-WORD 5 .PROGNOSIS-WORD 0)
    (0 .WH_ 3 .FEELING 1 about 3 .PROGNOSIS-WORD 0)
    (0 .AUX 2 .WANT-GEN .DOCTOR-PRON 1 .CONCENTRATE 2 .PROGNOSIS-WORD 2 or 2 .EMOTION ?)
    ;;; Pain
    (0 you 2 .BE 3 sorry 8 .PAIN 0)
    (0 you 2 .UNDERSTAND-GEN 8 .PAIN 0)
    (0 you 2 imagine 8 .PAIN 0)
    ;;; Energy
    (0 you 2 .BE 3 sorry 8 .MENT-HEALTH 0)
    (0 .WH_ 5 .PROGNOSIS-WORD 4 out of 1 control 0)
    (0 how .BE 4 .MENT-HEALTH 0)
    ;;; Appointment
    (0 you 2 .BE 3 sorry 5 .FAMILY 2 .NEG 0)
    (0 how .BE 2 .FEELING 2 .NOW 0)
    (0 we 3 .RELATIONSHIP-DEVELOP 5 .RELATIONSHIP 0)
    ;;; Open-ended
    (0 how .HAVE 2 been .FEELING 5)
    (0 .BE 2 .FRIGHTENED 5 .APPOINTMENT 0)
    (0 you 2 .BE 3 .AVAILABLE 3 .HELP 0)
    (0 you .EMPATHIZE 1 with 0)
    (0 .DOCTOR-PRON 1 .ADMIRE 2 .HAVE 1 .PROGNOSIS-DEALING with 1 .CANCER-ILLNESS 0)
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
    (0 .CANCER-ILLNESS 3 .BE .NEG 1 .CANCER-WORSE 0)
    (0 .CANCER-ILLNESS 3 .HAVE .NEG 1 .CANCER-WORSE 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) condition.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v (not worse.a))))) (0 :ulf)
  1 (:or
    (0 .CANCER-ILLNESS 0 .NEG 1 .BE .CURE 0)
    (0 .CANCER-ILLNESS 0 .NEG 1 .CURE 0)
    (0 .CANCER-ILLNESS 3 never 1 .CURE 0)
    (0 .CANCER-ILLNESS 0 .BE 2 .NEG 1 .CURE 0)
    (0 .CANCER-ILLNESS 0 .NEG 2 make it 0)
    (0 .CANCER-ILLNESS 3 .BE 2 terminal 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) condition.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))) (0 :ulf)
  1 (:or
    (0 .CANCER-ILLNESS 3 .BE 2 .CANCER-INCREASE 0)
    (0 .CANCER-ILLNESS 3 .HAVE 2 .CANCER-INCREASE 0)
    (0 .CANCER-ILLNESS 3 .BE 2 .CANCER-WORSE 0)
    (0 .CANCER-ILLNESS 3 .HAVE 2 .CANCER-WORSE 0)
    (0 .RADIATION-TREATMENT 3 .NEG 1 .WORK 0)
    (0 .CANCER-INCREASE 3 .SELF 2 .CANCER-ILLNESS 0)
    (0 .SELF 2 .CANCER-ILLNESS 2 .CANCER-INCREASE 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) condition.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v worse.a)))) (0 :ulf)

  ;;; Prognosis (level 1)
  1 (:or
    ;;; Prognosis bargaining (current health)
    (0 .HEALTHY 2 .NOW 3 .CHANGE-IMPROVE 2 .PROGNOSIS-WORD 0)
    (0 .HEALTHY 2 .NOW 3 make 2 .PROGNOSIS-WORD better 0)
    (0 .HEALTHY 2 .NOW 3 make 2 .PROGNOSIS-WORD better 0)
    (0 .HEALTHY 2 .NOW 3 .MAKE-BETTER 2 .PROGNOSIS-WORD 0)
    (0 .HEALTHY 2 .NOW 4 .OUTLIVE 2 .PROGNOSIS-WORD 0)
    ;;; Prognosis bargaining (quitting smoking)
    (0 .QUIT 1 .SMOKE 3 .CHANGE-IMPROVE 2 .PROGNOSIS-WORD 0)
    (0 .QUIT 1 .SMOKE 3 make 2 .PROGNOSIS-WORD better 0)
    (0 .QUIT 1 .SMOKE 3 make 2 .PROGNOSIS-WORD better 0)
    (0 .QUIT 1 .SMOKE 3 .MAKE-BETTER 2 .PROGNOSIS-WORD 0)
    (0 .QUIT 1 .SMOKE 4 .OUTLIVE 2 .PROGNOSIS-WORD 0)
    ;;; Prognosis bargaining (habits)
    (0 .HEALTHY 2 .HABIT 3 .CHANGE-IMPROVE 2 .PROGNOSIS-WORD 0)
    (0 .HEALTHY 2 .HABIT 3 make 2 .PROGNOSIS-WORD better 0)
    (0 .HEALTHY 2 .HABIT 3 make 2 .PROGNOSIS-WORD better 0)
    (0 .HEALTHY 2 .HABIT 3 .MAKE-BETTER 2 .PROGNOSIS-WORD 0)
    (0 .HEALTHY 2 .HABIT 4 .OUTLIVE 2 .PROGNOSIS-WORD 0)
    ;;; Prognosis denial
    (0 my 1 understanding 3 .PROGNOSIS-WORD 2 .BE 1 .TRUTH-WORD 0)
    (0 .SELF 1 .BE 2 .TRUTH-WORD 3 about 2 .PROGNOSIS-WORD 0)
    (0 .MOST 1 .PERSON-PL 4 .TRUTH-WORD 2 .PROGNOSIS-WORD 0)
    (0 .MUCH 1 .PERSON-PL 4 .TRUTH-WORD 2 .PROGNOSIS-WORD 0)
    (0 .FEW 1 .PERSON-PL 4 .TRUTH-WORD 2 .PROGNOSIS-WORD 0)
    (0 .MOST 1 .PERSON-PL 4 .OUTLIVE 4 .PROGNOSIS-WORD 0)
    (0 .MUCH 1 .PERSON-PL 4 .OUTLIVE 4 .PROGNOSIS-WORD 0)
    (0 .FEW 1 .PERSON-PL 4 .OUTLIVE 4 .PROGNOSIS-WORD 0)
    (0 .FREQ-WORD 3 .OUTLIVE 4 .PROGNOSIS-WORD 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n)))) (0 :ulf)

  ;;; Prognosis (level 2)
  1 (:or
    (0 .NEG 1 .BE .CURE 0)
    (0 .NEG 1 .CURE 0)
    (0 never 1 .CURE 0)
    (0 .BE 2 .NEG 1 .CURE 0)
    (0 .NEG 2 make it 0)
    (0 .PROGNOSIS-WORD 3 .BE 3 .NEG)
    (0 .PROGNOSIS-WORD 3 .BE 2 terminal 0)
    (0 .PROGNOSIS-WORD 3 .BE 3 .DIE 0)
    (0 .PROGNOSIS-WORD 3 .BE 3 unfavorable 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))) (0 :ulf)

  ;;; Prognosis (level 3)
  1 (:or
    ;;; Prognosis bargaining (graduation)
    (0 .CANCER-LIVE 3 .ATTEND 4 .GRAD-WORDS 0)
    (0 .PROGNOSIS-WORD 6 .ATTEND 4 .GRAD-WORDS 0)
    ;;; Prognosis
    (0 .NEG 3 .PROGNOSIS-MORE 3 .CANCER-LIVE 0)
    (0 .NEG 3 .CANCER-LIVE 3 .PROGNOSIS-MORE 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))
       (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))) (0 :ulf)

  ;;; Prognosis (level 4)
  1 (:or
    (0 .PROGNOSIS-LIVE 2 .NUMBER-TOTAL 3 .ELAPSED-TIME 0)
    (0 .PROGNOSIS-LIVE 2 several 1 .ELAPSED-TIME 0)
    (0 .PROGNOSIS-LIVE 2 a 1 .ELAPSED-TIME 0)
    (0 .PROGNOSIS-LIVE 2 some 1 .ELAPSED-TIME 0)
  )
    2 ((^you be.v explicit.a) and
       (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n))) and
       (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))
       (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))
       (^you tell.v ^me (a.d (specific.a (prognosis.n timeframe.n))))) (0 :ulf)

  1 (:or
    ;;; Treatment options
    (0 .COMFORT-CARE-WORD 5 .BE 3 .TREATMENT-OPTION 0)
    (0 .TREATMENT-OPTION 2 .BE 3 .COMFORT-CARE-WORD 0)
    (0 .MODAL 2 .TRY 5 .COMFORT-CARE-WORD 0)
    (0 .WANT-GEN 2 .PROVIDE 2 advice 3 .TREATMENT-OPTION 0)
    ;;; Comfort care
    (0 need 2 .COMFORT-CARE-WORD 0)
    (0 .COMFORT-CARE-WORD 5 .TIME-WORDS with 2 .FAMILY 0)
    (0 .COMFORT-CARE-WORD 5 .BE with 2 .FAMILY 0)
    (0 .COMFORT-CARE-WORD 5 .PAIN-ALLEVIATE 2 .PAIN 0)
  )
    2 ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) (plur option.n)))) and
       (^you tell.v ^me (about.p-arg (k (comfort.n care.n))))) (0 :ulf)

  1 (:or
    ;;; Treatment options
    (0 .CHEMOTHERAPY 5 .BE 3 .TREATMENT-OPTION 0)
    (0 .TREATMENT-OPTION 2 .BE 3 .CHEMOTHERAPY 0)
    (0 .MODAL 2 .TRY 5 .CHEMOTHERAPY 0)
    ;;; Chemotherapy
    (0 need 2 .CHEMOTHERAPY 0)
    (0 .DISCUSS 3 oncologist 3 .CHEMOTHERAPY 0)
    (0 .DISCUSS 3 .CHEMOTHERAPY 3 oncologist 0)
    (0 side effect 2 .CHEMOTHERAPY 2 .BE 0)
    (0 .FUTURE-POSS 2 accept 2 .PAINFUL 2 .CHEMOTHERAPY 1 live longer 0)
    (0 .BE 3 side effect 2 .CHEMOTHERAPY 0)
    (0 One way to get chemotherapy is 0)
    (0 way 3 .MED-TAKE 2 .CHEMOTHERAPY 2 .BE 0)
  )
    2 ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) (plur option.n)))) and
       (^you tell.v ^me (about.p-arg (k chemotherapy.n)))) (0 :ulf)
  
  1 (:or
    ;;; Treatment options
    (0 radiation 5 .BE 3 .TREATMENT-OPTION 0)
    (0 .TREATMENT-OPTION 2 .BE 3 radiation 0)
    (0 .MODAL 2 .TRY 5 radiation 0)
    (0 need 2 radiation 0)
    (0 .WANT-GEN 2 .BE .RESUSCITATE 0)
    ;;; Experimental therapy
    (0 .EXPERIMENTAL .TREATMENT 5 .BE 3 .TREATMENT-OPTION 0)
    (0 .TREATMENT-OPTION 2 .BE 3 .EXPERIMENTAL .TREATMENT 0)
    (0 .MODAL 2 .TRY 5 .EXPERIMENTAL .TREATMENT 0)
    (0 .EXPERIMENTAL .TREATMENT 4 .PROGNOSIS-WORD 2 .CHANGE-IMPROVE 0)
    (0 .EXPERIMENTAL .TREATMENT 4 .CHANGE-IMPROVE 2 .PROGNOSIS-WORD 0)
    (0 .FUTURE-POSS 2 you .WANT-GEN 2 review 2 condition 0)
  )
    2 ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) (plur option.n))))) (0 :ulf)

  1 (:or
    ;;; Tell family
    (0 .MODAL 2 .REASSURE 2 .FAMILY 0)
    (0 .MODAL 2 .TELL 2 .FAMILY 3 .HONESTY-WORD 0)
    (0 .MODAL 2 .BE 3 .HONESTY-WORD 5 .FAMILY 0)
    ;; Open-ended
    (0 .THINK-GEN 2 .MODAL .REVISIT 2 conversation 1 .LATER-TIME 0)
    (0 may .DOCTOR-PRON .SHARE .WH_ .DOCTOR-PRON .THINK-GEN 0)
    ;;; Energy
    (0 .MODAL 3 .MENT-TREATMENT 0)
  )
    2 (^you be.v explicit.a) (0 :ulf)



  ; Empowering
  1 (:or
    ;;; Treatment goals
    (0 .WH_ 1 .BE 4 .CANCER-GOALS 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .WANT-GEN 4 .CANCER-FIGHT 0 ?)
    (0 .WH_ 1 .BE 2 most 1 .IMPORTANT 0 ?)
    (0 who 1 .BE .YOUR-REF 2 .SUPPORT 0 ?)
    (0 .WH_ feelings .AUX you .HAVE about .DEATH 0 ?)
    (0 .WH_ .BE 1 feelings 1 about .RELIGION 0 ?)
    (0 .WH_ .AUX 1 .WANT-GEN 1 .AVOID 3 .TREATMENT-OPTION 0 ?)
    (0 .DOCTOR-PRON .WANT-GEN 1 give 1 .RECOMMENDATION 2 .YOUR-REF .TREATMENT-OPTION 0)
    (0 .AUX-BASE 2 .SELF 3 .MORE-INFO 6 .CANCER-GOALS 0 ?)
    ;;; Open-ended
    (0 .WH_ 2 .BE 5 .IMPORTANT 5 future 0 ?)
    (0 .WH_ 8 .BE 5 .IMPORTANT 2 .MY-REF 0 ?)
    (0 .WH_ 8 .BE 5 .MEANS 1 most 2 .MY-REF 0 ?)
    (0 .WH_ 3 .HELP .SELF 8 ?)
  )
    2 ((^you be.v empowering.a) and (^you ask.v ^me (about.p-arg ((^me 's) (plur value.n))))) (0 :ulf)

  1 (:or
    ;;; Treatment options
    (0 .AUX-BASE 2 .SELF 3 .QUESTION 5 .TREATMENT-OPTION 0 ?)
    (0 .WH_ 1 .SELF 1 .KNOW 5 .TREATMENT-OPTION 0 ?)
    ;;; Test results
    (0 .AUX-BASE 2 .SELF 3 .WANT-GEN 3 .FAMILY 3 .AVAILABLE 8 .DIAGNOSIS-TESTS 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .WANT-GEN 3 .SOMEONE 3 .AVAILABLE 8 .DIAGNOSIS-TESTS 0 ?)
    (0 .AUX-BASE 2 .SELF 1 .KNOW 3 .DIAGNOSIS-TESTS 2 .DIAGNOSIS-INDICATE 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .KNOW-GEN 4 .DIAGNOSIS-TESTS 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .QUESTION 5 .DIAGNOSIS-TESTS 0 ?)
    (0 .WH_ 2 .INFORMATION-GEN 3 .WANT-GEN 6 .DIAGNOSIS-TESTS 0 ?)
    ;;; Tell family
    (0 .AUX-BASE 2 .SELF 3 .WANT-GEN 5 .CONTACT 3 .FAMILY 0 ?)
    (0 .WH_ 3 you do 5 .HELP 6 .FAMILY 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .WANT-GEN 3 you 3 .AVAILABLE 8 .TELL 3 .FAMILY 0 ?)
    (0 .WH_ 3 .SELF 3 .WANT-GEN 3 .FAMILY 5 .KNOW-GEN 0 ?)
    (0 .FAMILY-WHO 3 .FAMILY 2 .SELF 3 .WANT-GEN 3 .TELL 0 ?)
    ;;; Prognosis
    (0 .AUX-BASE 2 .SELF 3 .WANT-GEN 3 .FAMILY 3 .AVAILABLE 8 .PROGNOSIS-WORD 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .WANT-GEN 3 .SOMEONE 3 .AVAILABLE 8 .PROGNOSIS-WORD 0 ?)
    (0 how .SPECIFIC 3 .WANT-GEN 6 .PROGNOSIS-WORD 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .KNOW-GEN 4 .PROGNOSIS-WORD 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .QUESTION 5 .PROGNOSIS-WORD 0 ?)
    (0 .WH_ 2 .INFORMATION-GEN 3 .WANT-GEN 6 .PROGNOSIS-WORD 0 ?)
    ;;; Question about prognosis
    (0 .BE .SELF 2 .READY 3 .DISCUSS 5 .TREATMENT-OPTION 0 ?)
    (0 .BE .SELF 2 .READY 3 .DISCUSS 5 .CANCER-GOALS 0 ?)
    ;;; Treatment goals (comfort care)
    (0 .WH_ 3 .SELF 3 .THINK-GEN 4 .COMFORT-CARE-WORD 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .THOUGHT 3 .COMFORT-CARE-WORD 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .KNOW-GEN 4 .COMFORT-CARE-WORD 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .QUESTION 5 .COMFORT-CARE-WORD 0 ?)
    ;;; Chemotherapy
    (0 .WH_ 3 .SELF 3 .THINK-GEN 4 .CHEMOTHERAPY 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .THOUGHT 3 .CHEMOTHERAPY 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .KNOW-GEN 4 .CHEMOTHERAPY 0 ?)
    (0 .AUX-BASE 2 .SELF 3 .QUESTION 5 .CHEMOTHERAPY 0 ?)
    ;;; Energy
    (0 how 2 .BE 3 .SELF 2 .ENERGY 0 ?)
    (0 .BE 3 .ANYTHING 3 .MAKE-WORSE 3 .MENT-HEALTH 0 ?)
    (0 .WH_ 3 .ANXIETY-WORD 3 .SELF 0 ?)
    ;;; Open-ended
    (0 .AUX-BASE 2 .SELF 3 .QUESTION 0 ?)
    (0 .WH_ 3 .SELF 2 .THINK-GEN 3 .CONVERSATION 0 ?)
    (0 how .DO 3 .SOUND 4 ?)
    (0 .WH_ 1 .AUX-BASE 2 .SELF 3 .KNOW-GEN 0 ?)
    (0 .WH_ 2 .INFORMATION-GEN 3 .WANT-GEN 0 ?)
    (0 .BE 2 following 1 WH_ .DOCTOR-PRON say 0 ?)
    (0 .SELF 2 .TELL 3 .MORE-INFO 0 ?)
  )
    2 (^you be.v empowering.a) (0 :ulf)



  ; Goodbye responses
  1 (0 goodbye 0)
    2 ((the.d conversation.n) be.v over.a) (0 :ulf)
))