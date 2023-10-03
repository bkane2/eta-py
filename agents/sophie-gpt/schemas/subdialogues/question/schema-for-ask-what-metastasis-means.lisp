;; *ask-what-metastasis-means*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'ask-what-metastasis-means.v

'(dial-schema :header (((set-of ^me ^you) ask-what-metastasis-means.v) ** ?e)
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
  ; Sophie does not understand what metastasis means
  ?p1 (^me ((pres do.aux-s) not (know.v (ans-to
        (sub what.pq ((k metastasis.n) ((pres mean.v) *h)))))))
)

:goals (
  ; Sophie wants to know what metastasis means
  ?g1 (^me ((pres want.v) (to (know.v (ans-to
        (sub what.pq ((k metastasis.n) ((pres mean.v) *h))))))))
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(What does metastasis mean ?))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END ask-what-metastasis-means.v