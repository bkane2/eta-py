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
;;	How far did you go in school ?
;;  What part of your education has been most meaningful to you ?
;;  What do you think about lifelong learning ?
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
  ; education
  1 (0 you went to school 0)
    2 *reaction-to-education-how-far-input* (0 :subtree)
  1 (0 the most meaningful part 3 education 0)
    2 *reaction-to-education-most-meaningful-input* (0 :subtree)
  1 (0 you think life long learning 0)
    2 *reaction-to-thoughts-about-lifelong-learning-input* (0 :subtree)
  ; employment
  1 (0 .WORK benefited you 0)
    2 *reaction-to-work-benefit-input* (0 :subtree)
  1 (0 best part 2 retirement 0)
    2 *reaction-to-retirement-best-part-input* (0 :subtree)
  1 (0 way to give back to your community 0)
    2 *reaction-to-give-back-to-community-input* (0 :subtree)
  ; life-goal
  1 (0 personal goal you are working on to stay healthy 0)
    2 *reaction-to-goal-stay-healthy-input* (0 :subtree)
  1 (0 being healthier improves your life quality 0)
    2 *reaction-to-being-healthier-life-quality-input* (0 :subtree)
  1 (0 step that you .HAVE taken to achieve your goal 0)
    2 *reaction-to-steps-achieve-goal-input* (0 :subtree)
))