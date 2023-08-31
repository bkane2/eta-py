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
;;           (where are you from ?)
;;           (tell me more about your hometown ?)
;;           (how did you like the weather in your hometown ?)
;;           (How did you end up in Rochester ?)
(MAPC 'ATTACHFEAT ; needed for detecting alternatives in the
; watching-or-reading question
'(
  (SPARE-TIME-ACTIVITY sports READ reading watch watching play playing hike hiking explore exploring WALK walking walks HOBBY hobbies painting) ; others? "make", "build" seem too general
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
'(
  ; getting-to-know
  1 (0 your name is 0)
    2 *reaction-to-name-input* (0 :subtree)
  1 (0 you had 4 for breakfast 0)
    2 *reaction-to-breakfast-today-input* (0 :subtree)
  1 (0 ice cream flavor you .LIKE 0)
    2 *reaction-to-favorite-icecream-input* (0 :subtree)
  1 (0 you .DO not 3 favorite ice cream flavor 0)
    2 *reaction-to-favorite-icecream-input* (0 :subtree)
  1 (0 food you .LIKE 0)
    2 *reaction-to-favorite-food-input* (0 :subtree)
  1 (0 .DO not .HAVE a favorite food 0)
    2 *reaction-to-favorite-food-input* (0 :subtree)
  1 (0 to get here 0)
    2 *reaction-to-how-you-got-here-input* (0 :subtree)
  ; where-are-you-from
  1 (0 you are from 0)
    2 *reaction-to-hometown-input* (0 :subtree)
  1 (0 the weather in your hometown 0)
    2 *reaction-to-hometown-weather-input* (0 :subtree)
  1 (0 you .DO not .LIKE the weather 0)
    2 *reaction-to-hometown-weather-input* (0 :subtree)
  1 (0 you .LIKE the weather 0)
    2 *reaction-to-hometown-weather-input* (0 :subtree)
  1 (0 where you grew up is 0)
    2 *reaction-to-describe-hometown-input* (0 :subtree)
  1 (0 you ended up in rochester 0)
    2 *reaction-to-endup-in-rochester-input* (0 :subtree)
  ; activities
  1 (0 your .HOBBY is 0)
    2 *reaction-to-hobbies-input* (0 :subtree)
  1 (0 .DO not .LIKE 2 .HOBBY 0)
    2 *reaction-to-hobbies-input* (0 :subtree)
  1 (0 you .DO not .LIKE reading 0)
    2 *reaction-to-like-to-read-input* (0 :subtree)
  1 (0 you .LIKE reading 0)
    2 *reaction-to-like-to-read-input* (0 :subtree)
  1 (0 you .LIKE to .READ 0)
    2 *reaction-to-things-like-to-read-input* (0 :subtree)
  1 (0 you spend your days 0)
    2 *reaction-to-spend-your-days-input* (0 :subtree)
  1 (0 you .LIKE to 5 in neighborhood 0)
    2 *reaction-to-things-in-neighborhood-input* (0 :subtree)
  1 (0 you .DO not .LIKE to 5 in neighborhood 0)
    2 *reaction-to-things-in-neighborhood-input* (0 :subtree)
))