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
;;	What changes might happen for you in the next few years ?
;;  What is the hardest part of growing older ?
;;  What is the best part of growing older ? 
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
'(
  ; household-chores
  1 (0 .HOUSEHOLD chore 4 today 0)
    2 *reaction-to-householdchores-today-input* (0 :subtree)
  1 (0 .HOUSEHOLD chore 4 .ENJOY 0)
    2 *reaction-to-householdchore-enjoy-input* (0 :subtree)
  1 (0 you helped someone with 0)
    2 *reaction-to-householdchore-help-others-input* (0 :subtree)
  1 (0 felt 2 you helped someone with .HOUSEHOLD chores 0)
    2 *reaction-to-householdchore-help-others-input* (0 :subtree)
  ; money
  1 (0 way 3 manage 1 .MONEY 0)
    2 *reaction-to-manage-money-ways-input* (0 :subtree)
  1 (0 managing .MONEY is not stressful 0)
    2 *reaction-to-manage-money-stressful-input* (0 :subtree)
  1 (0 managing .MONEY is stressful 0)
    2 *reaction-to-manage-money-stressful-input* (0 :subtree)
  1 (0 learned 2 managing .MONEY 0)
    2 *reaction-to-manage-money-learn-input* (0 :subtree)
  ; growing-older
  1 (0 change 2 happen 3 next few years 0)
    2 *reaction-to-life-changes-next-years-input* (0 :subtree)
  1 (0 hardest part 1 growing older 0)
    2 *reaction-to-growing-older-hardest-part-input* (0 :subtree)
  1 (0 best part 1 growing older 0)
    2 *reaction-to-growing-older-best-part-input* (0 :subtree)
))