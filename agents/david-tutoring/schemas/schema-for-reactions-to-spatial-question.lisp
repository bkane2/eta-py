
;; July, 11/19: define the schema *reactions-to-spatial-question*
;; ================================================================
;; 
;; This is intended to "work" for one or more non-question gist 
;; clauses followed by a final gist-clause question.
;;
;; The idea is to react to the question first, followed by "so" 
;; (as a new-topic-initiation signal), followed by a reaction to
;; the initial gist clause. (So this schema ignores any intermediate
;; clauses.) 
;;
;; An alternative would be to react to the initial gist clause
;; first, followed by "As for your question," or something similar;
;; in general, it seems to require stronger discourse signals to
;; get back to an unanswered question than to get back to another
;; component of the user's input. Also, this would work well for 
;; question-deflection responses by Eta like "Let's keep the 
;; focus on you". Anyway, in future, we might provide multiple
;; applicable schemas in "choose-reactions-to-input.lisp", and
;; choose from these (via a small choice tree, even if only to
;; vary response styles by using non-zero latency?)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(store-schema 'react-to-spatial-question.v

  '(dial-schema :header ((^me react-to-spatial-question.v) ** ?e)
  ;````````````````````````````````````````````````````````````````````````````````````
    :episodes (
              ;; ?e1 (^me perceive-world.v |Blocks-World-System| ?ulf ?perceptions)
              ;; ?e2 (:store-in-context (get-actions.f ?perceptions))
               ; this is where Eta "sees" the blocks world, specifically block movements.
               ; ?perceptions is given as a list of propositions reflecting Eta's perceptions
               ; e.g. locations of blocks (at-loc.p), things that have moved (move.v), etc.
              ?e1 (^you articulate2-to.v ^me ?ulf)
              ?e3 (^me seek-answer-from.v |Spatial-Reasoning-System| ?ulf)
               ; this would send the ulf (obtained from the properties
               ; of the actual name replacing ?var) to an appropriate
               ; file, monitored by the Spatial-QA-Server; the server
               ; would empty the file after reading it;
               ; Currently variable given should be '?ans+alternates if expect
               ; to recieve list of answer and then alternates, or should be given
               ; as '?ans if expect to recieve only answer.
              ?e4 (^me receive-answer-from.v |Spatial-Reasoning-System| ?ans-relations)
              ;; ?e4 (^me receive-answer-from.v |Spatial-Reasoning-System| ?ans+alternates)
               ; the value of ?ans+alternates would be read off from a file
               ; to which Spatial-QA-Server sends the answer (with weighted
               ; alternates); once ; the answer is read off, the file would
               ; be emptied.
              ?e5 (^me conditionally-paraphrase-to.v ^you ?ulf ?ans-relations)
              ;; ?e5 (^me conditionally-paraphrase-to.v you (main-answer.f ?ans+alternates))
               ; here ?ans is split off from ?ans+alternates;
               ; "conditionally say to you" would normally expand
               ; into just (^me say-to.v you '?ans); but I'm thinking
               ; of keeping the door open to something more complex,
               ; in cases where Georgiy's system provides multiple,
               ; weighted possibilities, in which case one might
               ; instantiate a subplan for generating a main answer
               ; but also mention alternates (attached as property
               ; to ?e4, I suppose).
    )

)) ; END react-to-spatial-question.v