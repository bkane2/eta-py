;; *say-appreciate-doctor-words*: development version 6
;;
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'say-appreciate-doctor-words.v

'(dial-schema :header (((set-of ^me ^you) say-appreciate-doctor-words.v) ** ?e)
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
)

:preconds (
  ; Sophie appreciates the doctor's admiration.
  ?p1 (^me (pres appreciate.v) ((^you 's) admiration.n))
  ; Sophie would prefer not having cancer to the doctor's admiration.
  ?p2 (^me (pres prefer.v) (to (not ((pres perf) cancer.n) ({over}.p-args ((^you 's) admiration.n) ))))
)

:goals (
 

)

:episodes (

?e1 (^me paraphrase-to.v ^you '(I am glad that you think I am handling my illness well\, but I would prefer not to have it at all \.))
 
?e2 (^you reply-to.v ?e1)

)

)) ; END say-appreciate-doctor-words.v