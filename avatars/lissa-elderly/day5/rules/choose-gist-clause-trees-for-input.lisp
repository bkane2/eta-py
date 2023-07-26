;; File for setting up the choice tree *gist-clause-trees*,
;; which selects among specific gist-clause extraction trees
;; for processing a user input, based on a feature-augmented 
;; initial gist clause for Lissa's output (usually a question
;; to the user that prompted the input).
;;
;; The following Lissa gist clauses are from "lissa5-schema.lisp",
;; where 'store-output-gist-clauses' is used to store output
;; gist clauses in a hash table indexed by action proposition
;; variables, and the hash table itself is accessed as property
;; 'gist-clauses' of *lissa-schema*:
;;
;;	What is a recent outdoor activity you have done?
;;  What is your favorite season to be outdoors?
;;  What do you enjoy doing when the weather keeps you indoors? 
;;
;;   While these are hand-supplied, the idea is that ultimately
;;   they would be set up automatically via NLP. For example,
;;   "Did you find it hard?" might readily lead to gist clause
;;   "Did you find your favorite class hard?" if we can successfully
;;   resolve the anaphor. More subtly, a trailing question "What
;;   about you?" often seems interpretable as a kind of analogical
;;   variant of the speaker's preceding assertion, just changing
;;   a nominal (etc.) phrase -- e.g., "I'm a comp sci major"  --> 
;;   "I'm a ... major"; "My favorite movie is Bladerunner"  --> 
;;   "My favorite movie is ...", etc.
;;
;;   This is why we don't simply use a verbatim match to Lissa's
;;   output.
(READRULES '*gist-clause-trees-for-input*
'(
  ; outdoors
  1 (2 what 2 recent outdoor activity 4)
    2 (*recent-outdoor-activity-input*) (0 :subtrees)
  1 (2 what 2 favorite season 2 outdoors 2)
    2 (*favorite-season-outdoors-input*) (0 :subtrees)
  1 (2 what 2 .ENJOY 3 weather keeps you indoors 2)
    2 (*things-enjoy-doing-indoors-input*) (0 :subtrees)
  ; travel
  1 (2 what types of travel 2 .ENJOY 2)
    2 (*travel-enjoy-input*) (0 :subtrees)
  1 (2 what 2 favorite .VACATION 4)
    2 (*favorite-vacation-input*) (0 :subtrees)
  1 (3 if you won 1 free trip 1 where 2 you go 3)
    2 (*free-trip-input*) (0 :subtrees)
  ; plan-for-today
  1 (2 what 2 .PLAN after this session 2)
    2 (*plan-after-this-session-input*) (0 :subtrees)
  1 (2 what 2 you .HAVE 2 .DINNER tonight 2)
    2 (*dinner-tonight-input*) (0 :subtrees)
  1 (2 what 2 .DO 3 .WIND down before bed 2)
    2 (*wind-down-before-bed-input*) (0 :subtrees)
))