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
;;   (Do you live by yourself or with others ?)
;;   (How long have you lived there ?)
;;   (Do you have children or grandchildren ?) 
;;   (Do you use facebook or skype ?)
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
; e.g., 
'(
  ; family
  1 (0 you .LIVE by yourself 0)
    2 *reaction-to-live-alone-input* (0 :subtree)
  1 (0 you .LIVE with 0)
    2 *reaction-to-live-alone-input* (0 :subtree)
  1 (0 you lived there for 0)
    2 *reaction-to-how-long-lived-there-input* (0 :subtree)
  1 (0 you .HAVE 2 .CHILD 0)
    2 *reaction-to-children-input* (0 :subtree)
  1 (0 you .HAVE 2 .GRANDCHILD 0)
    2 *reaction-to-children-input* (0 :subtree)
  1 (0 you .DO not .USE .SOCIAL-NETWORKS 0)
    2 *reaction-to-use-facebook-input* (0 :subtree)
  1 (0 you .USE .SOCIAL-NETWORKS 0)
    2 *reaction-to-use-facebook-input* (0 :subtree)
  ; gather-together
  1 (0 on holidays 0)
    2 *reaction-to-holidays-activities-input* (0 :subtree)
  1 (0 the holidays best part is 0)
    2 *reaction-to-holidays-best-part-input* (0 :subtree)
  1 (0 the holiday you prefer is 0)
    2 *reaction-to-holidays-you-prefer-input* (0 :subtree)
  1 (0 you .HAVE been to 1 .FAMILY gathering 0)
    2 *reaction-to-family-gathering-input* (0 :subtree)
  1 (0 you 3 to 2 wedding 0)
    2 *reaction-to-family-gathering-input* (0 :subtree)
  ; tell-me-about-you
  1 (0 your best quality is 0)
    2 *reaction-to-your-best-quality-input* (0 :subtree)
  1 (0 thing 3 change about yourself is 0)
    2 *reaction-to-want-change-about-you-input* (0 :subtree)
  1 (0 nothing 3 change about yourself 0)
    2 *reaction-to-want-change-about-you-input* (0 :subtree)
  1 (0 your wish is 0)
    2 *reaction-to-hopes-and-wishes-input* (0 :subtree)
))