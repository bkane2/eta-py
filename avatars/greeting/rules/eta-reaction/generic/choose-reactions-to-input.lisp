;; "choose-reactions-to-input.lisp"  (note the plural!)
;; =======================================================
;; File for choosing a schema for a potentially compound reaction
;; to a feature-augmented gist "passage" -- multiple gist clauses
;; separated by stand-alone periods or question marks (& ending
;; in a period or question mark). (The packet for single clauses
;; is "choose-reaction-to-input.lisp" -- note the singular.) The
;; result returned is of form
;;    (<schema name> <list of selected gist clauses>),
;; where the selected gist clauses are intended as arguments of
;; the schema (exclusive of the event variable). Thus in further
;; elaboration of a schema, the implementation of individual
;; steps can be made dependent on the gist clause each step is
;; intended to react to.
;;
;; The idea is that any schema(s) we supply here will be elaborated
;; in the planning process so as to check at least any initial
;; non-question gist clauses for possible reactions, using 
;; '*reaction-to-input*' to pick specific choice trees and using
;; the latter to obtain a non-nil result if possible. For question
;; gist clauses at or near the end, the elaboration process will
;; use '*reaction-to-question*', which should lead to more specific
;; choice trees for answering (or deflecting) the question.
;;
;; **We might ultimately allow for more than one schema (plus
;; arguments) as the value reurned, so that Eta can exhibit some
;; variety in the way multiple-clause contributions by the user
;; are handled. We could either supply lists of schemas (with
;; args), leaving the choice to the planner, or begin with small,
;; high-level choice trees that choose among schemas for compound
;; reactions by Eta (allowing for latency to avoid repetitiveness).
(READRULES '*reactions-to-input*
; Unused in the GPT3-integrated system
'(
  1 (0)
    2 *reaction-to-input* (0 :subtree)
)) ; END *reactions-to-input*