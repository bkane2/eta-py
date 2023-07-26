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
;;   ((what did you have for breakfast ?))
;;   ((what is your favorite flavor of ice cream ?))
;;   ((what is your favorite food ?))
;;   ((How did you get here today ?))
(MAPC 'ATTACHFEAT ; needed for detecting alternatives in the
; watching-or-reading question
'(
  (SPARE-TIME-ACTIVITY sports read reading watch watching play playing hike hiking explore exploring walk walking walks hobby hobbies painting) ; others? "make", "build" seem too general
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
  ; rochester1
  1 (0 you 0 been in rochester 0)
    2 *reaction-to-how-long-in-rochester-input* (0 :subtree)
  1 (0 you .DO not .LIKE 6 rochester 0)
    2 *reaction-to-not-like-about-rochester-input* (0 :subtree)
  1 (0 you .LIKE 6 rochester 0)
    2 *reaction-to-like-about-rochester-input* (0 :subtree)
  1 (0 you would change 0 rochester 0)
    2 *reaction-to-changing-rochester-input* (0 :subtree)
  ; rochester2
  1 (0 you would take me 0)
    2 *reaction-to-tour-of-rochester-input* (0 :subtree)
  1 (0 your favorite place to eat 0)
    2 *reaction-to-favorite-eatery-input* (0 :subtree)
  1 (0 .GARBAGE plate 0)
    2 *reaction-to-garbage-plate-input* (0 :subtree)
  1 (0 you .HAVE 2 to 2 dinosaur .BARBECUE 0)
    2 *reaction-to-dinosaur-bbq-input* (0 :subtree)
  ; pets
  1 (0 you .DO not .HAVE a pet 0)
    2 *reaction-to-have-a-pet-input* (0 :subtree)
  1 (0 your pet is 0)
    2 *reaction-to-have-a-pet-input* (0 :subtree)
  1 (0 your .FAMILY member has 0)
    2 *reaction-to-family-neighbor-pet-input* (0 :subtree)
  1 (0 your neighbor has 0)
    2 *reaction-to-family-neighbor-pet-input* (0 :subtree)
  1 (0 you .BELIEVE pets .HELP their owners 0)
    2 *reaction-to-pets-help-owners-input* (0 :subtree)
))