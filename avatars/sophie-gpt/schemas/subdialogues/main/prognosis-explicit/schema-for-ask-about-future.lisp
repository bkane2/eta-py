;; *ask-about-future*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-future.v

'(dial-schema :header (((set-of ^me ^you) ask-about-future.v) ** ?e)
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

  ?e1 (^me paraphrase-to.v ^you '(What does my cancer mean for my future ?))
  ?e2 (^you reply-to.v ?e1)

  ; Question: should the user be expected to give a "warning shot" here before delivering the
  ; bad news, such that SOPHIE escalates emotions if the user neglects this step?
  
  ; If not explicit about Sophie's future, ask for more detail
  ?e3 (:if (not ((^you be.v explicit.a) and (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))))
    
      ?e4 (^me paraphrase-to.v ^you '(I want you to be honest with me \. How bad does my future look ?))
      ?e5 (^you reply-to.v ?e4)

      ; If not explicit again, start to distrust doctor
      ?e6 (:if (not ((^you be.v explicit.a) and (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))))

        ?e7 (^me paraphrase-to.v ^you '(I don\'t really understand your prognosis \. Could you be more clear ?))
        ?e8 (^you reply-to.v ?e7)

        ; If not explicit a third time, escalate again (presumably, the conversation would be paused here and rewound)
        ?e9 (:if (not ((^you be.v explicit.a) and (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))))
        
          ?e10 (^me paraphrase-to.v ^you '(I\'m not sure I can trust your prognosis \. I need to find another
                                          doctor who can be honest with me \.))
          ?e11 (^me say-to.v ^you '([NEUTRAL] Let\'s pause here for feedback on this conversation \.))
          ?e12 (^me say-bye.v))))


  ?e13 (:try-in-sequence

    ; If user is too explicit, enter denial behavior
    (:if (^you tell.v ^me (a.d (vague.a (prognosis.n timeframe.n))))

      ?e14 ((set-of ^me ^you) deny-prognosis.v))


    ; If user mentioned cancer terminal without timeframe, proceed with prognosis question
    (:else
    
      ?e15 ((set-of ^me ^you) ask-about-prognosis.v)))

)

:obligations (
  !o1 (?e1 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n)))))
  !o2 (?e4 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n)))))
  !o3 (?e7 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n)))))
  !o4 (?e10 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) prognosis.n)))))
)

)) ; END ask-about-future.v