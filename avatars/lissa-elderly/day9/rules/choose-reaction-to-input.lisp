;; "choose-reaction-to-input.lisp" (for single gist clause inputs)
;; ===============================================================
;; File for choosing a reaction to a feature-augmented gist
;; clause extracted from a user's answer to a question. In
;; general, the gist clause is expected to provide sufficient
;; information to allow choice of a comment (if warranted) from
;; Lissa, based on choice trees for specific answers, thematic
;; answers, and potentially a final question in the gist
;; clause list.
;;
;; This packet is for single clauses -- see 
;;     "choose-reactions-to-input.lisp"
;; (note the plural) for a packet that makes a choice of a schema
;; depending on multiple gist clauses extracted from the user 
;; input -- but realizing the steps of the schema again depend
;; on the choice packet in this file, and the choice trees 
;; referenced here.
;; 
;; The gist clause input is expected to be of the (at least
;; approximate) form currently constructed by the choice trees
;; for extracting gist clauses from user input, specifically
;; the inputs responsing to the questions (as gist clauses)
;;
;;	What kinds of exercise do you do these days?
;;  Do you like to exercise on your own or with other people?
;;  Do you like to exercise outdoors or in a gym? 
(MAPC 'ATTACHFEAT ; needed for detecting alternatives in the
; watching-or-reading question
'(
))


(READRULES '*reaction-to-input*
; Choose between reaction to a question and an assertion
; Only one gist clause is expected here
'(
  1 (0 .WH_ 3 .SELF 0)
    2 *reaction-to-question* (0 :subtree)
  1 (0 .AUX .SELF 0)
    2 *reaction-to-question* (0 :subtree)
  1 (0 right-really 4 ?)
    2 *reaction-to-question* (0 :subtree)
  1 (0) ; by default, it's an assertion
    2 *reaction-to-assertion* (0 :subtree)
))


(READRULES '*reaction-to-assertion*
; Very rough initial attempt.
; Actually, it seems we could readily provide reactions
; directly here, instead of delegating to specialized
; choice trees. However, it seems we have better oversight
; by using separate choice trees, specified in a file that
; also contains the specialized features for the topic at
; issue.
;
'(
  ; sleep
  1 (0 you .DO not sleep well at night 0)
    2 *reaction-to-sleep-quality-input* (0 :subtree)
  1 (0 you sleep well at night 0)
    2 *reaction-to-sleep-quality-input* (0 :subtree)
  1 (0 your sleep quality has gotten 3 as you .HAVE gotten older 0)
    2 *reaction-to-sleep-quality-input* (0 :subtree)
  1 (0 you think that naps 0)
    2 *reaction-to-opinion-about-nap-input* (0 :subtree)
  1 (0 you improve your sleep 0)
    2 *reaction-to-improve-sleep-input* (0 :subtree)
  ; health
  1 (0 you .DO not think your doctor takes your concerns seriously 0)
    2 *reaction-to-doctor-attitude-concerns-input* (0 :subtree)
  1 (0 you think your doctor takes your concerns seriously 0)
    2 *reaction-to-doctor-attitude-concerns-input* (0 :subtree)
  1 (0 a good doctor 0)
    2 *reaction-to-good-doctor-qualities-input* (0 :subtree)
  1 (0 you manage your health concerns 0)
    2 *reaction-to-managing-health-concerns-input* (0 :subtree)
  ; exercise
  1 (0 you .DO not .DO any exercise 0)
    2 *reaction-to-exercises-you-do-input* (0 :subtree)
  1 (0 as exercise you 0)
    2 *reaction-to-exercises-you-do-input* (0 :subtree)
  1 (0 you .LIKE to exercise alone 0)
    2 *reaction-to-exercise-alone-vs-withothers-input* (0 :subtree)
  1 (0 you .LIKE to exercise with other people 0)
    2 *reaction-to-exercise-alone-vs-withothers-input* (0 :subtree)
  1 (0 you .LIKE to exercise outdoors 0)
    2 *reaction-to-exercise-outdoors-vs-gym-input* (0 :subtree)
  1 (0 you .LIKE to exercise in gym 0)
    2 *reaction-to-exercise-outdoors-vs-gym-input* (0 :subtree)
))