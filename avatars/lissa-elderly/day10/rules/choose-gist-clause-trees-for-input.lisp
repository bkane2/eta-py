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
;;	Do you live in an apartment or a house ?
;;  What would you do to make you feel comfortable in your home ?
;;  What is a memory you have of one of your homes ?
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
  ; home
  1 (3 .DO you live 2 apartment 2 house 3)
    2 (*place-you-live-input*) (0 :subtrees)
  1 (3 what 2 you .DO 2 make you feel comfortable 2 home 3)
    2 (*things-comfortable-home-input*) (0 :subtrees)
  1 (3 what 2 memory 6 your homes 3)
    2 (*memory-from-home-input*) (0 :subtrees)
  ; staying-active
  1 (3 how 2 stay physically active 3)
    2 (*stay-physically-active-input*) (0 :subtrees)
  1 (3 how 2 keep your brain active 3)
    2 (*keep-brain-active-input*) (0 :subtrees)
  1 (3 how 2 cope with hearing 2 vision loss 3)
    2 (*hearing-vision-loss-cope-input*) (0 :subtrees)
  ; spirituality
  1 (3 .DO you 3 religious services 3)
    2 (*religious-services-input*) (0 :subtrees)
  1 (3 what ways 2 spirituality a part of your life 3)
    2 (*spirituality-part-of-life-input*) (0 :subtrees)
  1 (3 how does spirituality .HELP you 3)
    2 (*spirituality-helps-you-input*) (0 :subtrees)
))