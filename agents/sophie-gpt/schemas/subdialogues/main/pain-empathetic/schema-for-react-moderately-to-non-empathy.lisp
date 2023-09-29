;; *react-moderately-to-non-empathy*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'react-moderately-to-non-empathy.v

'(dial-schema :header (((set-of ^me ^you) react-moderately-to-non-empathy.v) ** ?e)
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
  ; Sophie is moderately upset
  ?p4 (^me ((pres be.v) (moderately.mod-a upset.a)))
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

      ?e2 (^me paraphrase-to.v ^you '([ANGRY] There\'s no way my condition is terminal ! That\'s ridiculous \.))
      ?e3 (^you reply-to.v ?e2))

    (:if (^you tell.v ^me (that (((^me 's) cancer.n) be.v worse.a)))

      ?e2 (^me paraphrase-to.v ^you '(I don\'t see how you could know that for sure \. There\'s no way that\'s true \.))
      ?e3 (^you reply-to.v ?e2))

    (:if (^you tell.v ^me (that (((^me 's) cancer.n) be.v (not worse.a))))

      ?e2 (^me paraphrase-to.v ^you '(I don\'t see how you could know that for sure \. There\'s no way that\'s true \.))
      ?e3 (^you reply-to.v ?e2))

    (:else
    
      ?e2 (^me paraphrase-to.v ^you '(I don\'t think you understand how hard this is for me !))
      ?e3 (^you reply-to.v ?e2)))

)

:obligations (
  !o1 (?e2 obligates (^you be.v empathetic.a))
)

)) ; END react-moderately-to-non-empathy.v