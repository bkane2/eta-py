;; *mention-sadness-about-prognosis*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'mention-sadness-about-prognosis.v

'(dial-schema :header (((set-of ^me ^you) mention-sadness-about-prognosis.v) ** ?e)
;`````````````````````````````````````````````````````````````````````````````````````

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
  ; Sophie feels sad about her prognosis
  ?p1 (^me ((pres feel.v) sad.a (adv-a (about.p ((^me 's) prognosis.n)))))
  ; Sophie is extremely upset and emotional
  ?p2 (^me ((pres be.v) ((extremely.mod-a upset.a) and.cc emotional.a)))
)

:goals (
  ?g1 (^me ((pres want.v) (to (let.v ^you (ka (know.v ((^me 's) (plur feeling.n))))))))
)

:episodes (

?e1 (^me say-to.v ^you ?words)
 
?e2 (^you reply-to.v ?e1)

)

)) ; END mention-sadness-about-prognosis.v