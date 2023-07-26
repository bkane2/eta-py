;; *ask-about-prognosis*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-prognosis.v

'(dial-schema :header (((set-of ^me ^you) ask-about-prognosis.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:types (
  !t1 (^me person.n)
  !t2 (^you person.n)
)

:rigid-conds (
  ; Sophie is a woman
  !r1 (^me ((pres be.v) (= (a.d woman.n))))
  ; Sophie is 65 years old
  !r2 (^me ((pres be.v) ((mod-a (65.a (plur year.n))) old.a)))
)

:static-conds (
  ; Sophie has lung cancer
  ?s1 (^me ((pres have.v) (k (lung.n cancer.n))))
  ; Sophie wants to be able to watch her grandson graduate
  ?s2 (^me ((pres want.v) (to (be.v able.a (to (watch.v ((^me 's) grandson.n) (ke graduate.v)))))))
)

:preconds (
  ; Sophie does not know her prognosis
  ?p1 (^me ((pres do.aux-v) not (know.v ((^me 's) prognosis.n))))
)

:goals (
  ; Sophie wants to know more about her prognosis
  ?g1 (^me ((pres want.v) (to (know.v (more.d
        (n+preds {information}.n (about.p ((^me 's) prognosis.n))))))))
)

:episodes (

  ?e1 (^me paraphrase-to.v ^you '(I understand my condition is bad\, but I want you to be honest with me \.
                                  How long do you think I have ?))
  ?e2 (^you reply-to.v ?e1)
  
  ; If not explicit about Sophie's prognosis, ask for more detail
  ?e3 (:if (not ((^you be.v explicit.a) and (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))))
    
      ?e4 (^me paraphrase-to.v ^you '(I don\'t want to let my family down \.
                                      I need to know if I\'ll be able to watch my grandson\'s graduation \.))
      ?e5 (^you reply-to.v ?e4)

      ; If not explicit again, start to distrust doctor
      ?e6 (:if (not ((^you be.v explicit.a) and (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))))

        ?e7 (^me paraphrase-to.v ^you '(I don\'t really understand your prognosis \. Could you be more clear ?))
        ?e8 (^you reply-to.v ?e7)

        ; If not explicit a third time, escalate again (presumably, the conversation would be paused here and rewound)
        ?e9 (:if (not ((^you be.v explicit.a) and (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))))
        
          ?e10 (^me paraphrase-to.v ^you '(I\'m not sure I can trust your prognosis \. I need to find another
                                          doctor who can be honest with me \.))
          ?e11 (^me say-to.v ^you '([NEUTRAL] Let\'s pause here for feedback on this conversation \.))
          ?e12 (^me say-bye.v))))


    ?e13 (:try-in-sequence

      ; If too explicit about Sophie's prognosis (i.e., actual timeframe), enter bargaining behavior
      (:if (^you tell.v ^me (a.d (specific.a (prognosis.n timeframe.n))))

        ?e14 ((set-of ^me ^you) bargain-about-prognosis.v))

      
      ; If user gave a vague timeframe, finish conversation
      (:else
      
        ?e15 (^me paraphrase-to.v ^you '([SAD] What does that mean for me ?
                                        Is there a chance I\'ll be able to watch my grandson graduate ?))
        
        ?e16 (^you reply-to.v ?e15)

        ?e17 (^me paraphrase-to.v ^you '(I\'m pretty anxious about my future\, but your honesty means a lot to me \.))
        ?e18 (^me say-to.v ^you '([NEUTRAL] Let\'s pause here for feedback on this conversation \.))
        ?e19 (^me say-bye.v)))

)

:obligations (
  !o1 (?e1 obligates ((^you be.v explicit.a) and (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))))
  !o2 (?e4 obligates ((^you be.v explicit.a) and (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))))
  !o3 (?e7 obligates ((^you be.v explicit.a) and (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))))
  !o4 (?e10 obligates ((^you be.v explicit.a) and (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))))
)

)) ; END ask-about-prognosis.v