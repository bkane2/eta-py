;; *ask-about-pain*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-about-pain.v

'(dial-schema :header (((set-of ^me ^you) ask-about-pain.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````

:types (
  !t1 (^me person.n)
  !t2 (^you person.n)
)

:rigid-conds (
  ; Sophie's name is Sophie
  !r0 (((^me 's) name.n) ((pres be.v) (= |Sophie|)))
  ; Sophie is a woman
  !r1 (^me ((pres be.v) (= (a.d woman.n))))
  ; Sophie is 65 years old
  !r2 (^me ((pres be.v) ((mod-a (65.a (plur year.n))) old.a)))
)

:static-conds (
  ; Sophie has lung cancer
  ?s1 (^me ((pres have.v) (k (lung.n cancer.n))))
  ; Sophie has pain in her chest
  ?s2 (^me ((pres have.v) (k (n+preds pain.n (in.p ((^me 's) chest.n))))))
  ; Sophie is taking Lortab for her pain
  ?s3 (^me ((pres take.v) (k |Lortab|.n) (adv-a (for.p ((^me 's) pain.n)))))
  ; Sophie is not ready to talk about treatment options yet
  ?s4 (^me ((pres be.v) not ready.a (to (talk.v (about.p-arg (k (plur (treatment.n option.n)))) yet.adv-e))))
)

:preconds (
  ; Sophie's pain has become worse recently
  ?p1 (((^me 's) pain.n) ((pres perf) got.v worse.a recently.adv-e))
  ; Sophie doesn't fully understand her condition
  ?p2 (^me ((pres do.aux-s) not (fully.adv-a understand.v ((^me 's) condition.n))))
)

:goals (
  ; Sophie wants to know more about her condition
  ?g1 (^me ((pres want.v) (to (know.v (more.d (n+preds {information}.n
        (about.p ((^me 's) condition.n))))))))
  ; Sophie wants stronger pain medication
  ?g2 (^me ((pres want.v) (k (stronger.a (pain.n medication.n)))))
)

:episodes (

  ?e1 (^me paraphrase-to.v ^you '(Why has my pain been getting worse recently ?))
  ?e2 (^you reply-to.v ?e1)


  ; Make sure that the user has actually answered Sophie's question
  ?e3 (:if (not (^you tell.v ^me (about.p-arg ((^me 's) condition.n))))
  
    ?e4 (^me paraphrase-to.v ^you '(Could you tell me what this means for my condition ?))
    ?e5 (^you reply-to.v ?e4)
    
    ?e6 (:if (not (^you tell.v ^me (about.p-arg ((^me 's) condition.n))))
  
      ?e7 (^me paraphrase-to.v ^you '(Please be honest with me\, what do you know about my condition ?))
      ?e8 (^you reply-to.v ?e7)

      ?e9 (:if (not (^you tell.v ^me (about.p-arg ((^me 's) condition.n))))

        ?e10 (^me paraphrase-to.v ^you '(I am really worried about my test results \. Can you tell me what they mean ?))
        ?e11 (^you reply-to.v ?e10))))

  
  ; "Forget" previous empathy from the user upon hearing bad news for the first time
  ; TODO: I'm not sure about this approach in general; requires further thought.
  ?e12 (^me forget-from-stm.v (that (^you be.v empathetic.a)))

  
  ; React negatively to news about condition
  ?e13 ((set-of ^me ^you) react-to-condition.v)


  ; If not empathetic, express fear about condition
  ?e14 (:if (not (^you be.v empathetic.a))
  
    ?e15 ((set-of ^me ^you) react-mildly-to-non-empathy.v)

    ; If not empathetic again, escalate emotions
    ?e16 (:if (not (^you be.v empathetic.a))
    
      ?e17 ((set-of ^me ^you) react-moderately-to-non-empathy.v)

      ; If not empathetic a third time, escalate emotions further
      ; (presumably, the conversation would be paused here and rewound)
      ?e18 (:if (not (^you be.v empathetic.a))
      
        ?e19 (^me paraphrase-to.v ^you '(I don\'t think I can handle this right now \. I need a break \.))
        ?e20 (^me say-to.v ^you '([NEUTRAL] Let\'s pause here for feedback on this conversation \.))
        ?e21 (^me say-bye-to.v ^you))))


  ; If the user was empathetic, acknowledge their empathy and close the conversation
  ?e22 ((set-of ^me ^you) acknowledge-empathy.v)

  ?e23 (^me say-to.v ^you '([NEUTRAL] Let\'s pause here for feedback on this conversation \.))

)

:obligations (
  !o1 (?e1 obligates (^you be.v empathetic.a))
  ;; !o2 (?e14 obligates (^you be.v empathetic.a))
  ;; !o3 (?e16 obligates (^you be.v empathetic.a))
  !o4 (?e19 obligates (^you be.v empathetic.a))
)

)) ; END ask-about-pain.v