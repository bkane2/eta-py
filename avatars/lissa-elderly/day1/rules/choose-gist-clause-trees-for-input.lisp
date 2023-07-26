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
;;   (what are your hobbies ?)
;;   (do you like to read ?)
;;   (what kind of things you like to read ?)
;;   (how do you spend your days ?)
;;   (what kind of things do you like in your neighborhood ?)
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
  ; getting-to-know
  1 (2 what 1 your name 1)
    2 (*name-input*) (0 :subtrees)
  1 (2 what 1 you .HAVE 2 breakfast 1)
    2 (*breakfast-today-input*) (0 :subtrees)
  1 (1 what 2 favorite 2 ice cream 1)
    2 (*favorite-icecream-input*) (0 :subtrees)
  1 (1 what 2 favorite 2 food 1)
    2 (*favorite-food-input*) (0 :subtrees)
  1 (1 how 2 get here 1)
    2 (*how-you-got-here-input*) (0 :subtrees)
  ; where-are-you-from
  1 (3 where are you from 0)
    2 (*hometown-input*) (0 :subtrees)
  1 (3 tell me more 4 hometown 0)
    2 (*describe-hometown-input*) (0 :subtrees)
  1 (3 how 2 .LIKE the weather 2 hometown 0)
    2 (*hometown-weather-input*) (0 :subtrees)
  1 (3 how 2 end up in rochester 0)
    2 (*endup-in-rochester-input*) (0 :subtrees)
  ; activities
  1 (3 what are 1 hobbies 0)
    2 (*hobbies-input*) (0 :subtrees)
  1 (3 .DO 1 .LIKE to .READ 0)
    2 (*like-to-read-input*) (0 :subtrees)
  1 (3 what 2 things you .LIKE to .READ 0)
    2 (*things-like-to-read-input*) (0 :subtrees)
  1 (3 how 2 you spend 1 days 0)
    2 (*spend-your-days-input*) (0 :subtrees)
  1 (3 what 4 you .LIKE 4 neighborhood 0)
    2 (*things-in-neighborhood-input*) (0 :subtrees)
))