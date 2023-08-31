;; *discuss-activities*: development version 5 (UNDER CONSTRUCTION)
;;
;; After defining *discuss-activities*, we create a hash table 
;;       *output-semantics* 
;; containing interpretations of Lissa outputs, under hash keys 
;; like (*discuss-activities* ?e1). The main goal is to be able later
;; to match certain user inputs to question interpretations, to
;; see if the inputs already answer the questions, making them
;; redundant.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(store-schema 'discuss-activities.v

'(dial-schema :header (((set-of ^me ^you) discuss-activities.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````
; LISSA introduces herself, sets the scene, asks about the user's 
; major, responds to the user's reply, and starts the "Rochester"
; part of the dialog.

:types (
      !t1 (^me person.n)
      !t2 (^you person.n)
)

:rigid-conds (
      ; Lissa is a woman
      !r1 (^me ((pres be.v) (= (a.d woman.n))))
      ; Lissa is 25 years old
      !r2 (^me ((pres be.v) ((mod-a (25.a (plur year.n))) old.a)))
)

:static-conds (
)

:preconds (
      ; Lissa doesn't know the user's hobbies
      ?p1 (Lissa doesn\'t know the other person\'s hobbies \.)
)

:goals (
      ; Lissa wants to have a casual conversation
      ?g2 (^me ((pres want.v) (to (have.v (a.d (casual.a conversation.n))))))
      ; Lissa wants to know about the user's hobbies
      ?g1 (Lissa wants to know about the other person\'s hobbies \.)
)

:episodes (

?e1 (^me paraphrase-to.v ^you '(Do you have any hobbies or anything in particular you like to do for fun ?))
 
?e2 (^you reply-to.v ?e1)

?e4 (^me paraphrase-to.v ^you '(I love to read \. Do you like to read ?))

?e5 (^you reply-to.v ?e4)

?e8 (^me paraphrase-to.v ^you '(How do you spend your days ?))

?e9 (^you reply-to.v ?e8)

?e10 (^me paraphrase-to.v ^you '(What kind of things do you like to do in your neighborhood ?))

?e11 (^you reply-to.v ?e10)

)

)) ; END discuss-activities.v