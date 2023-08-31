;; *teach-BW-concept-to*: development version 7
;;
;; Dialogue for blocks world concept tutoring 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(store-schema 'teach-BW-concept-to.v

'(dial-schema :header ((^me teach-BW-concept-to.v ^you) ** ?e)
;``````````````````````````````````````````````````````````````````
; Blocks world concept tutoring session; such a session is expected to consist
; of the agent selecting a concept for which it has a concept schema, guiding 
; the user in the construction of instances of this concept, providing corrective
; feedback, and terminating when the user appears to understand the concept
; (or chooses to end the interaction). Some "small talk" may occur (currently
; disabled).

:types (
  !t1 (^you person.n)
  !t2 (^me robot.n)  
  !t3 (?cc (plur BW-concept-structure.n)); concepts that ^me knows (as obj-schema)
  !t4 (|Table| table.n)
  !t5  ((the.d (|Target| block.n)) block.n)
  !t6  ((the.d (|Starbucks| block.n)) block.n)
  !t7  ((the.d (|Twitter| block.n)) block.n)
  !t8  ((the.d (|Texaco| block.n)) block.n)
  !t9  ((the.d (|McDonald's| block.n)) block.n)
  !t10 ((the.d (|Mercedes| block.n)) block.n)
  !t11 ((the.d (|Toyota| block.n)) block.n)
  !t12 ((the.d (|Burger King| block.n)) block.n)
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

:static-conds (
  ; Currently not handled by Eta
  ?s1 (^me understand.v ?cc); assume that understanding a set of things
                            ; entails understanding each of them
  ?s2 (^you at-loc.p |Table|)
  ?s3 (^me at-loc.p |Table|)
)

:preconds (
  ; Currently not handled by Eta
  ?p1 (some ?c ((?c member-of.p ?cc) and (not (^you understand.v ?c))))
)

:goals (
  ; TODO: now that this is (somewhat) supported, should the schema be modified to
  ; use goal-driven replanning?
  ;; ?g1 (^me want1.v (that (^you understand1.v ?c)))
  ;; ?g2 (^you want1.v (that ((^me teach-BW-concept-to.v ^you) @ ^now)))
)


:episodes (

  ; David introduces himself.
  ?e1 (^me say-to.v ^you 
        '(Hi\, my name is David\. I\'m ready to teach you some spatial concept \.))

  ; David randomly selects one of the BW concepts he knows (assumed to be
  ; of comparable complexity).
  ; TODO: it might make more sense for this action to be
  ; "(^me try.v (to (choose.v ...)))", since something may go wrong - for instance,
  ; you might already understand all the concepts that Eta has available.
  ?e2 (^me choose.v (a.d ?c (random.a
        (:l (?x) (and (?x member-of.p ?cc) (not (^you understand.v ?x)))))))

  ; David announces the name of the chosen concept to the user.
  ?e3 (^me say-to.v ^you '(I would like to teach you the concept of
                            (concept-noun-phrase.f ?c) \.))

  ; David forms (through querying the BW system) the goal representation for the
  ; simplest possible example of the concept.
  ; TODO: likewise - Eta might not have any visual/BW concepts,
  ; the concepts may be ill-formed, etc.
  ?e4 (^me form-spatial-representation.v (a.d ?goal-rep ((most.mod-a simple.a)
        (:l (?x) (and (?x goal-schema1.n) (?x instance-of.p ?c))))))

  ; Eta guides the user through construction of the simple example.
  ?e5 (^me guide-BW-construction.v ^you ?goal-rep)

  ; Eta says that the simple example has been built, and asks the user if
  ; they now understand the concept.
  ?e6 (^me say-to.v ^you '(Excellent\. You have now built the simplest possible
                            (concept-noun.f ?c) \.))
  ; TODO: add rule paraphrasing naturally to (Do you think you understand the concept ?)
  ?e7 (^me paraphrase-to.v ^you '(Do you understand the concept ?))

  ; Two generalizations need to be made in the following dialogue:
  ; First, the system shouldn't assume that building one 'additional' extension
  ; is sufficient for the user understanding the concept. The user might need to
  ; go through multiple cycles of building extensions (e.g., first building a
  ; taller one, then building a wider one, etc.) before understanding it.
  ; Second, the BW system currently only supports the extensions "bigger" and
  ; "smaller", which are tried as alternatives. Ultimately, a number of types of
  ; extensions should be supported (like "taller", "longer", "wider", "diagonal", etc.),
  ; and they should be parsed directly from user input (or from David's selection) and
  ; used in the form-spatial-representation.v episode.
  ; ````````````````````````````````````````````````````````````````````````````````````
  ?e8 (^you reply-to.v ?e7)

  ; Either (9a) user says that they understand the concept, (9b) the user asks to
  ; make a bigger example, (9c) the user asks to make a smaller example, or (9d)
  ; the user says something else.
  ?e9 (:try-in-sequence
  
    ; (9a) If the user says that they understand the concept...
    (:if ((^you say-yes.v) * ?e8)
    
      ; Take the user at their word and exit the dialogue.
      ; But should David have the user make an extension anyways?
      ?e10 (^me say-to.v ^you '(Great\. Thanks for playing pupil!))
      ?e11 (^me commit-to-STM.v (that (^you understand.v ?c)))
      ?e12 (^me say-to.v ^you '(Goodbye for now!))
      ?e13 (^me say-bye.v))

    ; (9b)
    ; TODO: what if there aren't enough blocks to make a bigger one? Currently,
    ; David will notice this and quit once it tries to find a plan to build the
    ; goal structure, but he shouldn't ask the user to try to build a bigger
    ; structure in the first place, in that case. He'll also still assume that
    ; the user understands the concept even if the attempt to build the extension
    ; fails, which is wrong. But how can Eta determine whether a goal representation
    ; can be built or not before the planner actually trying to find a step? Should
    ; such a failure condition be built into the act of forming a spatial representation
    ; of the goal structure?
    (:if ((^you ask-to-make-structure-bigger.v) * ?e8)
    
      ; David acknowledges user's request, prompts the user to try.
      ?e15 (^me say-to.v ^you '(We certainly can make a bigger one\. Why don\'t you try it?))
      ?e16 (^you reply-to.v ?e15)
      ; David finds a bigger goal structure as an extension.
      ; TODO: bigger.a to be replaced once comparatives figured out.
      ?e17 (^me form-spatial-representation.v (a.d ?goal-rep1 (bigger.a
        (:l (?x) (and (?x goal-schema1.n) (?x instance-of.p ?c)))))))

    ; (9c)
    ; TODO: Same as the comment above on (^you ask-to-make-structure-bigger.v). This
    ; will fail if the structure can't be made with fewer blocks (which will almost
    ; certainly be the case if "most simple" corresponds to "smallest"), but David
    ; will still ask the user to build the structure first, and will assume the user
    ; understands the concept even in the case of such a failure.
    (:if ((^you ask-to-make-structure-smaller.v) * ?e8)
    
      ; David acknowledges user's request, prompts the user to try.
      ?e20 (^me say-to.v ^you '(We certainly can make a smaller one\. Why don\'t you try it?))
      ?e21 (^you reply-to.v ?e20)
      ; David finds a bigger goal structure as an extension.
      ; TODO: smaller.a to be replaced once comparatives figured out.
      ?e22 (^me form-spatial-representation.v (a.d ?goal-rep1 (smaller.a
        (:l (?x) (and (?x goal-schema1.n) (?x instance-of.p ?c)))))))

    ; (9d)
    (:else
    
      ; David asks if user wants to make a bigger example.
      ; TODO: add rule paraphrasing naturally to (Do you want to try to make a bigger one?)
      ?e25 (^me paraphrase-to.v ^you '(Do you want to make a bigger example of the concept ?))

      ; The user responds to the request (possibly just silent acknowledgement).
      ?e26 (^you reply-to.v ?e25)

      ; If the user replies 'no'...
      ?e27 (:if ((^you say-no.v) * ?e26)

        ; For now, if the user is refusing, David should just exit the conversation.
        ?e28 (^me say-to.v ^you '(Oh\, ok\. I must assume that you understand
                                  the concept then\. Goodbye for now!))
        ?e29 (^me commit-to-STM.v (that (^you understand.v ?c)))
        ?e30 (^me say-bye.v))
      
      ; TODO: User might also try to clarify the meaning of "bigger" here,
      ; which David should be able to answer.

      ; David finds a bigger goal structure as an extension.
      ; TODO: bigger.a to be replaced once comparatives figured out.
      ?e31 (^me form-spatial-representation.v (a.d ?goal-rep1 (bigger.a
        (:l (?x) (and (?x goal-schema1.n) (?x instance-of.p ?c))))))))

  ; David supervises the user in building ?goal-rep1.
  ?e40 (^me supervise-BW-construction.v ^you ?goal-rep1)

  ; David tells the user that they understand the concept upon completion.
  ?e50 (^me say-to.v ^you '(Great! I think you\'ve got the idea of
                            (concept-noun-phrase.f ?c) \. You\'ve caught on fast\.))

  ; User acknowledges David (possibly just silence).
  ; TODO: what if user replies that they still don't understand the concept?
  ; Would require "looping" as the user builds more extensions of the concept,
  ; but I'm currently avoiding this now for the purposes of the demo.
  ?e51 (^you reply-to.v ?e50)

  ; David commits to memory that the user understands the concept.
  ; TODO: this needs to be stored in persistent long-term memory eventually,
  ; not just short-term context.
  ?e52 (^me commit-to-STM.v (that (^you understand.v ?c)))

  ; David says goodbye after conversation is over.
  ?e100 (^me say-to.v ^you '(Thanks for playing pupil! Goodbye for now!))

)


:episode-relations (
  ; Not included yet
)


:necessities (
  ; Not included yet
)


:certainties (
  !c1 (!e16 0.3)
  !c2 (!e21 0.3)
  !c3 (!e51 0.3)
  !c4 (!e8 0.4)
  !c5 (!e26 0.4)
)


)) ; END teach-BW-concept-to.v