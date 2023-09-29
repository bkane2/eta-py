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

  ; If not empathetic, express fear about condition
  ?e3 (:if (not (^you be.v empathetic.a))
  
    ?e4 ((set-of ^me ^you) react-mildly-to-non-empathy.v)

    ; If not empathetic again, escalate emotions
    ?e6 (:if (not (^you be.v empathetic.a))
    
      ?e7 ((set-of ^me ^you) react-moderately-to-non-empathy.v)))


  ; Proceed with Sophie's main question
  ?e13 (:if (not (^you tell.v ^me (about.p-arg ((^me 's) condition.n))))
  
    ?e14 (^me paraphrase-to.v ^you '(I think I\'m ready to hear about my condition now \.))
    ?e15 (^you reply-to.v ?e14)
    
    ?e16 (:if (not (^you tell.v ^me (about.p-arg ((^me 's) condition.n))))
  
      ?e17 (^me paraphrase-to.v ^you '(What do you know about my condition ?))
      ?e18 (^you reply-to.v ?e17)))

)

:obligations (
  !o1 (?e1 obligates (^you be.v empathetic.a))
  !o2 (?e14 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) condition.n)))))
  !o3 (?e17 obligates ((^you be.v explicit.a) and (^you tell.v ^me (about.p-arg ((^me 's) condition.n)))))
)

)) ; END ask-about-pain.v