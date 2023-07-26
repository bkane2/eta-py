;; *acknowledge-empathy*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'acknowledge-empathy.v

'(dial-schema :header (((set-of ^me ^you) acknowledge-empathy.v) ** ?e)
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
  ; Sophie's cancer has spread
  ?s2 (((^me 's) cancer.n) ((pres perf) spread.v))
  ; Sophie finds it difficult and emotional to hear that her cancer has spread
  ?s3 (^me ((pres find.v) it.pro (difficult.a and.cc emotional.a) (to (hear.v (that (((^me 's) cancer.n) ((pres perf) spread.v)))))))
)

:preconds (
  ; Sophie's pain has become worse recently
  ?p1 (((^me 's) pain.n) ((pres perf) got.v worse.a recently.adv-e))
  ; The user was empathetic towards Sophie
  ?p2 (^you ((past be.v) empathetic.a (adv-a (towards.p ^me))))
  ; Sophie is glad that the user is there to answer her questions
  ?p3 (^me ((pres be.v) glad.a (that (^you ((pres be.v) there.pro (to (answer.v ((^me 's) (plur question.n)))))))))
)

:goals (
  ; Sophie wants to acknowledge the doctor's help with a short statement
  ?g1 (^me ((pres want.v) (to (acknowledge.v ((^you 's) help.n) (with.p-arg (a.d (short.a statement.n)))))))
)

:episodes (

?e1 (:try-in-sequence

  (:if (^you tell.v ^me (that (((^me 's) cancer.n) be.v terminal.a)))

    ?e2 (^me paraphrase-to.v ^you '([SAD] It\'s really difficult to hear that my cancer is likely terminal \.
                                    But your help means a lot to me \.))
    ?e3 (^you reply-to.v ?e2))

  (:if (^you tell.v ^me (that (((^me 's) cancer.n) be.v worse.a)))

    ?e2 (^me paraphrase-to.v ^you '([SAD] It\'s really difficult to hear that my cancer is worse \. But thank
                                    you for being so honest and supportive \.))
    ?e3 (^you reply-to.v ?e2))

  (:else
  
    ?e2 (^me say-to.v ^you ?words)
    ?e3 (^you reply-to.v ?e1)))

)

)) ; END acknowledge-empathy.v