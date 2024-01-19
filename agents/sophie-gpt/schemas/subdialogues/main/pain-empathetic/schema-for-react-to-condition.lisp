;; *react-to-condition*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'react-to-condition.v

'(dial-schema :header (((set-of ^me ^you) react-to-condition.v) ** ?e)
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
)

:preconds (
  ; The doctor just told Sophie the news about her cancer
  ?p2 (^you (just.adv-e ((past tell.v) ^me (n+preds news.n (about.p ((^me 's) cancer.n))))))
  ; Sophie is distraught
  ?p3 (^me ((pres be.v) distraught.a))
)

:goals (
)

:episodes (

  ?e1 (:try-in-sequence

    (:if (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))

      ?e2 (^me paraphrase-to.v ^you '(No\, no\, no \. That can\'t be true \.))
      ?e3 (^you reply-to.v ?e2))

    (:if (^you tell.v ^me (that (((^me 's) cancer.n) be.v worse.a)))

      ?e2 (^me paraphrase-to.v ^you '(Oh no \. This can\'t be happening \.))
      ?e3 (^you reply-to.v ?e2))

    (:if (^you tell.v ^me (that (((^me 's) cancer.n) be.v (not worse.a))))

      ?e2 (^me paraphrase-to.v ^you '(How can you be sure ?))
      ?e3 (^you reply-to.v ?e2))

    (:if (^you tell.v ^me (about.p-arg ((^me 's) condition.n)))
    
      ?e2 (^me paraphrase-to.v ^you '(Oh no \. This can\'t be happening \.))
      ?e3 (^you reply-to.v ?e2))

    (:else
    
      ?e2 (^me paraphrase-to.v ^you '(This is too much for me to handle \.))
      ?e3 (^you reply-to.v ?e2)))

)

:obligations (
  !o1 (?e2 obligates (^you be.v empathetic.a))
)

)) ; END react-to-condition.v