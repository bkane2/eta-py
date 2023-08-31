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
;;	What types of art do you enjoy ?
;;  Have you ever taken lessons in a kind of art ?
;;  How does art help you cope with negative emotions ?
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
  ; technology
  1 (0 you .DO not .HAVE a smartphone 0)
    2 *reaction-to-smartphone-use-input* (0 :subtree)
  1 (0 you .HAVE a smartphone 0)
    2 *reaction-to-smartphone-use-input* (0 :subtree)
  1 (0 you use your smartphone for 0)
    2 *reaction-to-smartphone-use-input* (0 :subtree)
  1 (0 the best part of advances in technology is 0)
    2 *reaction-to-technology-best-part-input* (0 :subtree)
  1 (0 no good in advances in technology 0)
    2 *reaction-to-technology-best-part-input* (0 :subtree)
  1 (0 the hardest part of advances in technology is 0)
    2 *reaction-to-technology-hardest-part-input* (0 :subtree)
  ; books-and-newspaper
  1 (0 you .DO not .LIKE to read books 0)
    2 *reaction-to-books-like-to-read-input* (0 :subtree)
  1 (0 you .LIKE 3 books 0)
    2 *reaction-to-books-like-to-read-input* (0 :subtree)
  1 (0 you .DO not read newspaper 0)
    2 *reaction-to-newspaper-how-often-input* (0 :subtree)
  1 (0 you read newspaper 0)
    2 *reaction-to-newspaper-how-often-input* (0 :subtree)
  1 (0 you .DO not .LIKE to discuss politics 0)
    2 *reaction-to-like-politics-input* (0 :subtree)
  1 (0 you .LIKE to discuss politics 0)
    2 *reaction-to-like-politics-input* (0 :subtree)
  ; arts
  1 (0 the type of art you .ENJOY 0)
    2 *reaction-to-art-type-you-enjoy-input* (0 :subtree)
  1 (0 .DO not .ENJOY any 2 art 0)
    2 *reaction-to-art-type-you-enjoy-input* (0 :subtree)
  1 (0 you .HAVE not taken lessons in any kind of art 0)
    2 *reaction-to-art-lessons-input* (0 :subtree)
  1 (0 you .HAVE taken lessons in 0)
    2 *reaction-to-art-lessons-input* (0 :subtree)
  1 (0 art helps .ONE cope with stress 0)
    2 *reaction-to-ways-art-helps-input* (0 :subtree)
))