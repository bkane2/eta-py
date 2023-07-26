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
;;   (Do you live by yourself or with others ?)
;;   (How long have you lived there ?)
;;   (Do you have children or grandchildren ?) 
;;   (Do you use facebook or skype ?)
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
  ; family
  1 (3 .DO you .LIVE 2 yourself 0)
    2 (*live-alone-input*) (0 :subtrees)
  1 (3 how long 1 you lived 0)
    2 (*how-long-lived-there-input*) (0 :subtrees)
  1 (3 .DO you .HAVE .CHILD 0)
    2 (*children-input* *thematic-children-input*) (0 :subtrees)
  1 (3 .DO you 1 facebook 0)
    2 (*use-facebook-input*) (0 :subtrees)
  ; gather-together
  1 (3 what 2 you 3 holidays 0)
    2 (*holidays-activities-input*) (0 :subtrees)
  1 (3 what 2 best part 0)
    2 (*holidays-best-part-input*) (0 :subtrees)
  1 (3 what 2 holidays you 1 prefer 0)
    2 (*holidays-you-prefer-input*) (0 :subtrees)
  1 (3 .HAVE you 3 .FAMILY gathering 1 recently 0)
    2 (*family-gathering-input*) (0 :subtrees)
  ; tell-me-about-you
  1 (2 what 1 your best qualities 1)
    2 (*your-best-quality-input*) (0 :subtrees)
  1 (1 what 2 things 3 change about yourself 1)
    2 (*want-change-about-you-input*) (0 :subtrees)
  1 (1 what 2 hopes and wishes 1)
    2 (*hopes-and-wishes-input*) (0 :subtrees)
))