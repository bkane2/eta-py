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
;;	What is a recent outdoor activity you have done?
;;  What is your favorite season to be outdoors?
;;  What do you enjoy doing when the weather keeps you indoors? 
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
  ; outdoors
  1 (0 recent outdoor activity 0)
    2 *reaction-to-recent-outdoor-activity-input* (0 :subtree)
  1 (0 favorite season 2 outdoors is 0)
    2 *reaction-to-favorite-season-outdoors-input* (0 :subtree)
  1 (0 .ENJOY 3 you .HAVE to stay indoors 0)
    2 *reaction-to-things-enjoy-doing-indoors-input* (0 :subtree)
  ; travel
  1 (0 .ENJOY 2 travel 0)
    2 *reaction-to-travel-enjoy-input* (0 :subtree)
  1 (0 favorite .VACATION 0)
    2 *reaction-to-favorite-vacation-input* (0 :subtree)
  1 (0 if you win 1 free trip 0)
    2 *reaction-to-free-trip-input* (0 :subtree)
  1 (0 you .DO not .WANT 3 free trip 0)
    2 *reaction-to-free-trip-input* (0 :subtree)
  ; plan-for-today
  1 (0 your .PLAN after this session 0)
    2 *reaction-to-plan-after-this-session-input* (0 :subtree)
  1 (0 you will .HAVE 3 for .DINNER tonight 0)
    2 *reaction-to-dinner-tonight-input* (0 :subtree)
  1 (0 you 4 to .WIND down before bed 0)
    2 *reaction-to-wind-down-before-bed-input* (0 :subtree)
))