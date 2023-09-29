;; *say-pain-rating*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-pain-rating.v

'(dial-schema :header (((set-of ^me ^you) say-pain-rating.v) ** ?e)
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
)

:preconds (
  ;; Sophie rates her pain as a seven out of ten.
  ? p1 (^me ((pres rate.v) pain.n (as.p (seven.a out-of.p ten.n))))
)

:goals (
  
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I rate my pain as a seven out of ten \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-pain-rating.v