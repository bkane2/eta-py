;; *say-when-have-pain*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-when-have-pain.v

'(dial-schema :header (((set-of ^me ^you) say-when-have-pain.v) ** ?e)
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
  ; Sophie's pain has recently been getting worse
  ?p1 (((^me 's) pain.n) ((pres perf) recently.adv-e ((prog get.v) worse.a)))
  ;; Sophie has pain when she takes a deep breath.
  ?p2 (^me ((pres have.v) (k (n+preds pain.n (when.p (^me (pres breath.v)))))))
  ;; Sophie had pain when she swallowed throughout radiation.
  ?p3 (^me ((past have.v) (k (n+preds pain.n (when.p (^me (past swallow.v))))) (adv-e (during.p ((^me 's) (k (radiation.n treatment.n)))))))
)

:goals (
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I have pain when I take a deep breath \, and I used to have pain when I swallowed throughout my radiation treatment \.))
 
?e2 (^you reply-to.v ?e1)

)

:obligations (
  !o1 (?e1 obligates (^you be.v empathetic.a))
)

)) ; END say-when-have-pain.v