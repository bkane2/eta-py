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
;;	What kinds of dishes do you like to cook ?
;;	How did you learn to cook ?
;;	How have you shared cooking with people in your life ? 
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
  ; weather
  1 (2 how 2 weather 3)
    2 (*how-is-weather-input*) (0 :subtrees)
  1 (1 how 3 weather forecast 4)
    2 (*weather-forecast-input*) (0 :subtrees)
  1 (1 what 2 favorite weather 3)
    2 (*favorite-weather-input*) (0 :subtrees)
  ; driving
  1 (2 what 1 you .REMEMBER 2 first car 3)
    2 (*first-car-input*) (0 :subtrees)
  1 (1 .HAVE you 4 road trip 4)
    2 (*road-trips-input*) (0 :subtrees)
  1 (1 how 2 cope 1 giving up driving 3)
    2 (*giving-up-driving-input*) (0 :subtrees)
  ; cooking
  1 (2 what 2 dishes 2 .LIKE to .COOK 3)
    2 (*dishes-like-to-cook-input*) (0 :subtrees)
  1 (1 how 2 learn to .COOK 4)
    2 (*learn-to-cook-input*) (0 :subtrees)
  1 (1 how 2 shared cooking 1 people 4)
    2 (*share-cooking-with-others-input*) (0 :subtrees)
))