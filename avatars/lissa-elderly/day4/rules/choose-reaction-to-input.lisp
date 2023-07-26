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
;; the inputs responding to the questions (as gist clauses)
;;
;;	What kinds of dishes do you like to cook ?
;;	How did you learn to cook ?
;;	How have you shared cooking with people in your life ? 
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
  ; weather
  1 (0 the weather outside is 0)
    2 *reaction-to-how-is-weather-input* (0 :subtree)
  1 (0 the weather forecast for this evening is 0)
    2 *reaction-to-weather-forecast-input* (0 :subtree)
  1 (0 your favorite weather is 0)
    2 *reaction-to-favorite-weather-input* (0 :subtree)
  1 (0 the weather you .DO not .LIKE is 0)
    2 *reaction-to-favorite-weather-input* (0 :subtree)
  ; driving
  1 (0 your first car 0)
    2 *reaction-to-first-car-input* (0 :subtree)
  1 (0 you 1 never taken 2 road trip 0)
    2 *reaction-to-road-trips-input* (0 :subtree)
  1 (0 you took 2 road trip 0)
    2 *reaction-to-road-trips-input* (0 :subtree)
  1 (0 .WAY 1 cope with giving up driving 0)
    2 *reaction-to-giving-up-driving-input* (0 :subtree)
  1 (0 .DO not know 2 deal with giving up driving 0)
    2 *reaction-to-giving-up-driving-input* (0 :subtree)
  ; cooking
  1 (0 you 2 .LIKE to .COOK 0)
    2 *reaction-to-dishes-like-to-cook-input* (0 :subtree)
  1 (0 you 2 .LIKE to .BAKE 0)
    2 *reaction-to-dishes-like-to-cook-input* (0 :subtree)
  1 (0 you 1 .DO not 1 know how to .COOK 0)
    2 *reaction-to-dishes-like-to-cook-input* (0 :subtree)
  1 (0 you learned cooking 0)
    2 *reaction-to-learn-to-cook-input* (0 :subtree)
  1 (0 you .HAVE shared cooking with 0)
    2 *reaction-to-share-cooking-with-others-input* (0 :subtree)
))