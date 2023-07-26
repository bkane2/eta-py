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
;;	What kinds of exercise do you do these days?
;;  Do you like to exercise on your own or with other people?
;;  Do you like to exercise outdoors or in a gym? 
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
  ; sleep
  1 (3 how 2 sleep 2 night 3)
    2 (*sleep-quality-input*) (0 :subtrees)
  1 (3 .DO you think 2 naps 5 .HELPFUL 3)
    2 (*opinion-about-nap-input*) (0 :subtrees)
  1 (3 what 4 improve your sleep 3)
    2 (*improve-sleep-input*) (0 :subtrees)
  ; health
  1 (3 .DO you think 2 doctor takes 3 concerns seriously 3)
    2 (*doctor-attitude-concerns-input*) (0 :subtrees)
  1 (3 what 2 qualities of a good doctor 3)
    2 (*good-doctor-qualities-input*) (0 :subtrees)
  1 (3 how 2 you managing 2 health concerns 3)
    2 (*managing-health-concerns-input*) (0 :subtrees)
  ; exercise
  1 (3 what 2 exercise 2 you .DO 3)
    2 (*exercises-you-do-input*) (0 :subtrees)
  1 (3 .DO you .LIKE 2 exercise alone or with other people 3)
    2 (*exercise-alone-vs-withothers-input*) (0 :subtrees)
  1 (3 .DO you 2 exercise outdoors or 2 gym 3)
    2 (*exercise-outdoors-vs-gym-input*) (0 :subtrees)
))