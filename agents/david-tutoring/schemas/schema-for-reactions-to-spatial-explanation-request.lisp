
;; Oct, 18/19: define the schema *reactions-to-spatial-explanation-request*
;; ================================================================
;; 
;; 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(store-schema 'react-to-spatial-explanation-request.v

  '(dial-schema :header ((^me react-to-spatial-explanation-request.v) ** ?e)
  ;`````````````````````````````````````````````````````````````````````````````````````````````
    :episodes (
              ?e1 (^you articulate2-to.v ^me ?ulf)
              ?e2 (^me seek-answer-from.v |Spatial-Reasoning-System| ?ulf)
               ; this would send the ulf (obtained from the properties
               ; of the actual name replacing ?var) to an appropriate
               ; file, monitored by the Spatial-QA-Server; the server
               ; would empty the file after reading it;
               ; Currently variable given should be '?ans+alternates if expect
               ; to recieve list of answer and then alternates, or should be given
               ; as '?ans if expect to recieve only answer.
              ?e3 (^me receive-answer-from.v |Spatial-Reasoning-System| ?ans+alternates)
               ; the value of ?ans+alternates would be read off from a file
               ; to which Spatial-QA-Server sends the answer (with weighted
               ; alternates); once ; the answer is read off, the file would
               ; be emptied.
              ?e4 (^me conditionally-paraphrase-to.v ^you (main-answer.f ?ans+alternates))
               ; here ?ans is split off from ?ans+alternates;
               ; "conditionally say to you" would normally expand
               ; into just (^me say-to.v you '?ans); but I'm thinking
               ; of keeping the door open to something more complex,
               ; in cases where Georgiy's system provides multiple,
               ; weighted possibilities, in which case one might
               ; instantiate a subplan for generating a main answer
               ; but also mention alternates (attached as property
               ; to ?e3, I suppose).
    )

)) ; END react-to-spatial-explanation-request.v