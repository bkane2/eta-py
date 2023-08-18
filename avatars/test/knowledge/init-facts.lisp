;; Initial facts to add to the avatar's knowledge base
;;
;; TODO: currently disused, since the knowledge previously here
;; was added as rigid-conds and static-conds to dialogue schemas.

(defparameter *init-knowledge* '(
  (^me ((pres want.v) (to (test.v (the.d system.n)))))
  (^me say-to.v ^you '(this is an initial test string \.))
))