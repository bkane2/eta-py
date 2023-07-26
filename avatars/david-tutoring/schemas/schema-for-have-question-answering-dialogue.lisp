;; *have-question-answering-dialogue*: development version 6
;;
;; Dialogue for blocks world question-answering dialogue
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'have-question-answering-dialogue.v

'(dial-schema :header (((set-of ^me ^you) have-question-answering-dialogue.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````
; Blocks world conversation. An expected blocks world dialogue consists
; of the agent repeatedly asking the user if they have a spatial question
; to ask, followed by a question from the user, followed by an appropriate
; response by the agent. This repeats until the user says something interpreted
; as a goodbye, and is possibly preempted by some "smalltalk" questions
; (currently disabled).
;

:types (
  !t1 (^you person.n)
  !t2 (^me robot.n)
  !t3 ((the.d table.n) table.n)
  ; Eventually this should be changed to just ?bb (plur block1.n)
  !t4  ((the.d (|Target| block.n)) block.n)
  !t5  ((the.d (|Starbucks| block.n)) block.n)
  !t6  ((the.d (|Twitter| block.n)) block.n)
  !t7  ((the.d (|Texaco| block.n)) block.n)
  !t8  ((the.d (|McDonald's| block.n)) block.n)
  !t9  ((the.d (|Mercedes| block.n)) block.n)
  !t10 ((the.d (|Toyota| block.n)) block.n)
  !t11 ((the.d (|Burger King| block.n)) block.n)
)


:rigid-conds (
  !r1 ((the.d (|Target| block.n)) blue.a)
  !r2 ((the.d (|Starbucks| block.n)) green.a)
  !r3 ((the.d (|Twitter| block.n)) red.a)
  !r4 ((the.d (|Texaco| block.n)) blue.a)
  !r5 ((the.d (|McDonald's| block.n)) green.a)
  !r6 ((the.d (|Mercedes| block.n)) red.a)
  !r7 ((the.d (|Toyota| block.n)) blue.a)
  !r8 ((the.d (|Burger King| block.n)) green.a)
)


:episodes (

  ; David introduces himself.
  ?e1 (^me say-to.v ^you 
        '(Hi\, my name is David\. I\'m ready to answer your spatial questions\.))

  ; Repeat prompting the user for a spatial question until finished.
  ?e2 (:repeat-until (?e2 finished2.a)

    ; Prompt the user for a spatial question.
    ?e3 (^me paraphrase-to.v ^you
          '(Do you have a spatial question for me ?))

    ; User replies with either spatial question, special request, or smalltalk.
    ?e4 (^you reply-to.v ?e3)

    ; If user makes an unknown request, inform them of lack of understanding.
    ; Note that spatial questions and requests are otherwise handled as reactions.
    ?e5 (:if ((^you (make.v (a.d (unknown.a request.n)))) ** ?e4)
        ?e6 (^me say-to.v ^you '(I apologize \, I could not understand what you said \.))))
)

)) ; END have-question-answering-dialogue.v