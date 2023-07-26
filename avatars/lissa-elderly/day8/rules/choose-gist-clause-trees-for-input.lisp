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
;;	What types of art do you enjoy ?
;;  Have you ever taken lessons in a kind of art ?
;;  How does art help you cope with negative emotions ?
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
  ; technology
  1 (3 what 2 use your smartphone 6)
    2 (*smartphone-use-input*) (0 :subtrees)
  1 (3 what 3 best part of advances in technology 3)
    2 (*technology-best-part-input*) (0 :subtrees)
  1 (3 what 3 hardest part of advances in technology 3)
    2 (*technology-hardest-part-input*) (0 :subtrees)
  ; books-and-newspaper
  1 (3 what kinds of books 2 .LIKE to read 3)
    2 (*books-like-to-read-input*) (0 :subtrees)
  1 (3 how often 2 read 2 newspaper 3)
    2 (*newspaper-how-often-input*) (0 :subtrees)
  1 (3 .DO you .LIKE 2 discuss politics 5)
    2 (*like-politics-input*) (0 :subtrees)
  ; arts
  1 (3 what types of art 2 you .ENJOY 3)
    2 (*art-type-you-enjoy-input*) (0 :subtrees)
  1 (3 .HAVE you ever taken lessons 5 art 3)
    2 (*art-lessons-input*) (0 :subtrees)
  1 (3 how 2 art .HELP 2 cope 2 negative emotions 3)
    2 (*ways-art-helps-input*) (0 :subtrees)
))