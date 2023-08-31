;; *react-mildly-to-non-empathy*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'react-mildly-to-non-empathy.v

'(dial-schema :header (((set-of ^me ^you) react-mildly-to-non-empathy.v) ** ?e)
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
)

:preconds (
  ; Sophie's pain has become worse recently
  ?p1 (((^me 's) pain.n) ((pres perf) got.v worse.a recently.adv-e))
  ; Sophie doesn't fully understand her condition
  ?p2 (^me ((pres do.aux-s) not (fully.adv-a understand.v ((^me 's) condition.n))))
  ; The user is not empathetic
  ?p3 (^you ((pres be.v) not empathetic.a))
  ; Sophie is mildly upset
  ?p4 (^me ((pres be.v) (mildly.mod-a upset.a)))
)

:goals (
  ; Sophie wants to know more about her condition
  ?g1 (^me ((pres want.v) (to (know.v (more.d (n+preds {information}.n
        (about.p ((^me 's) condition.n))))))))
  ; Sophie wants stronger pain medication
  ?g2 (^me ((pres want.v) (k (stronger.a (pain.n medication.n)))))
)

:episodes (

  ?e1 (:try-in-sequence

    (:if (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))

      ?e2 (^me paraphrase-to.v ^you '(What do you mean ? I feel fine other than the pain \.))
      ?e3 (^you reply-to.v ?e2))

    (:if (^you tell.v ^me (that (((^me 's) cancer.n) be.v worse.a)))

      ?e2 (^me paraphrase-to.v ^you '(What do you mean my cancer is worse ? I feel fine other than the pain \.))
      ?e3 (^you reply-to.v ?e2))

    (:if (^you tell.v ^me (that (((^me 's) cancer.n) be.v (not worse.a))))

      ?e2 (^me paraphrase-to.v ^you '(Are you sure the cancer isn\'t worse ? The pain has been keeping me up at night \.))
      ?e3 (^you reply-to.v ?e2))

    (:else
    
      ?e2 (^me paraphrase-to.v ^you '(What is going on ? I feel fine other than the pain \.))
      ?e3 (^you reply-to.v ?e2)))

)

:obligations (
  !o1 (?e2 obligates (^you be.v empathetic.a))
)

)) ; END react-mildly-to-non-empathy.v