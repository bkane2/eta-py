; On github at https://github.com/bkane2/eta-blocksworld 
; Select rules/spatial-question/rules-for-spatial-question-ulf.lisp
; ========================================================================
; "rules-for-spatial-questions.lisp"  -- currently under revision, June 21/19
; from previous version (v6). Add "between" rules. That's a bit tricky,
; because the complement of "between" either can be a plural ("between two
; red blocks") or a full NP conjunction ("between a red block and a blue
; block"), or a conjunction with ellipsis ("between a red and a blue
; block"; "between the Toyota and the SRI block"; "between the Toyota
; and SRI blocks").
;
; One issue is that to allow for names like "Burger King", we currently 
; need to preprocess to change this to "Burger_King". Would an alternative
; be to introduce features 'name-part1', 'name-part2, ..., which apply to
; parts of a multiword name, where single-word names have feature 'name',
; *as well as* feature 'name-part1'? Can we introduce a mini-grammar for
; names whose use is triggered by feature 'name-part1', and that allows
; a word with feature 'name' as a name, and allows appropriate sequences
; of words with features 'name-part1', 'name-part2, ... as names? But we
; can't do that via 'eval-lex-ulf', because this assumed we know for sure
; that the word(s) supplied can be of the specified category -- which we
; can't be sure of, just given features 'name-part1', 'name-part2, ... .
; So the grammar itself would need to check for particular word sequences,
; which would really be very inelegant, and infeasible for realistically
; large sets of names.
;
; Short of switching from single-word features (for pattern matching)
; to features assigned to word sequences (possible in TTT, I suppose),
; I think preprocessing is the best option. This might be done via the 
; gist clause mechanism, as part of "repairing" the user's word sequence
; as produced by the speech recognizer. Repairs are extremely context/
; domain-specific, but then that's also true for gist clause determination
; in general.
; 
;
; TODO: Some examples of references that might be more difficult to handle
; "The furthest one"
; "What about the McDonalds block"
; etc.
;
; "Does the SRI block have a block [on top of][above] it?"
; "Does there exist a block on the SRI block"
; "What is the color of the block ..."
; "Where is the block on the table that is near a blue block"
; "Is the SRI block above the McDonalds block and not the Texaco block?"
; "Is the SRI block above a red block or a blue block?"
;
; ====================================================================
;; Choice packets for ulf derivation from spatial questions by user.
;;
;; The initial set of features are intended to support analysis
;; of the user's spatial relation questions in the Blocks world
;; 
(MAPC 'ATTACHFEAT
'(
  ;; NOTE: As of 11/25/19, these features are now stored
  ;; in core/resources/blocksworld-word-data.lisp
))
;; NB: All questions are expected to have a separate question mark at the end;
;;     If necessary, prior input processing of the user input (as supplied -- 
;;     somewhat unreliably -- by the speech recognizer) should separate off
;;     or add a question mark, when the input seems to be in the form of 
;;     a question (typically starting with a be-word, a wh-word, or a prep-
;;     osition plus wh-word)
;;
;; NB: :ulf-recur rules specify 2 reassembly patterns -- one for the successive
;;     parts, and one for putting the ULFs for the parts together with the 
;;     correct bracketing; (:ulf rules specify just the ulf assembly patterns).
;;
;;     The first of these reassembly patterns needs to be a list of any of
;;     the following 3 sorts of components:
;;     - an atom, which will be used as-is in the second reassembly pattern;
;;     - a triple (lex-ulf@ <lex-cat> <part number>) which will (later) be
;;       evaluated into a lexical ULF atom or ULF expression;
;;     - a pattern of form (<name of a rule-tree> <itm1> <itm2> ...) where
;;       the <itmj> elements are typically integers indicating parts, but
;;       can also be arbitrary expressions, potentially containing integers
;;       indicating parts.
;;
;;     The second reassembly pattern just specifies how the "pieces" 
;;     (top-level components) in the first reassembly pattern should be 
;;     bracketed to yield the final ULF form (once the components of type
;;     (<name of a rule-tree> <itm1> <itm2> ...) have been recursively
;;     evaluated). It could also introduce additional ULF expressions,
;;     but for readability usually shouldn't, unless material needs to be
;;     added that doesn't fit with the syntactic constraints on types of
;;     components in the first reassembly pattern, as enumerated above.
;;     
;;     The expressions of form (lex-ulf@ <lex-cat> <part number>) in the
;;     resulting ULF are evaluated as a final step in the program 
;;     'choose-result-for1', which interprets the directives.
(READRULES '*spatial-question-ulf-tree*
; ```````````````````````````````````````
; Top level tree for spatial questions. Later we can use a more general tree,
; not restricted to the blocks world, and use occurrence of "block" or 
; "table" (& perhaps a spatial relation) to jump to this tree.
;
'(
  ; explanation questions
  1 (.ADV-EXPLAIN 0 between 0)
    2 (.ADV-EXPLAIN .BE 0 between 0)
      3 (((*yn-between-question-ulf-tree* 2 3 4 5)) ((sub why.adv-s (1 *h)) ?)) (0 :ulf-recur)
    2 (.ADV-EXPLAIN .DO 0 between 0)
      3 (((*do-question-ulf-tree* 2 3 4 5)) ((sub why.adv-s (1 *h)) ?)) (0 :ulf-recur)
  1 (.ADV-EXPLAIN 0)
    2 (.ADV-EXPLAIN .BE not .NP-OBJ 0)
      3 (((*yn-question-ulf-tree* 2 3 4 5)) ((sub why.adv-s (1 *h)) ?)) (0 :ulf-recur)
    2 (.ADV-EXPLAIN .BE not there 0)
      3 (((*exist-question-ulf-tree* 2 3 4 5)) ((sub why.adv-s (1 *h)) ?)) (0 :ulf-recur)
    2 (.ADV-EXPLAIN .BE .NP-OBJ 0)
      3 (((*yn-question-ulf-tree* 2 3 4)) ((sub why.adv-s (1 *h)) ?)) (0 :ulf-recur)
    2 (.ADV-EXPLAIN .BE there 0)
      3 (((*exist-question-ulf-tree* 2 3 4)) ((sub why.adv-s (1 *h)) ?)) (0 :ulf-recur)
    2 (.ADV-EXPLAIN .DO 0)
      3 (((*do-question-ulf-tree* 2 3)) ((sub why.adv-s (1 *h)) ?)) (0 :ulf-recur)
  1 (.ADV-EXPLAIN not .DET 2 .NOUN ?)
    2 (((*np-ulf-tree* 3 4 5)) ((sub why.adv-s ((not 1) *h)) ?)) (0 :ulf-recur)
  1 (.ADV-EXPLAIN .DET 2 .NOUN ?)
    2 (((*np-ulf-tree* 2 3 4)) ((sub why.adv-s (1 *h)) ?)) (0 :ulf-recur)
  ; "is/are"-questions
  1 (.BE 0 between 0) ; "between" causes issues with prep+NP patterns, so need specific rules
    2 (((*yn-between-question-ulf-tree* 1 2 3 4)) (1 ?)) (0 :ulf-recur)
  1 (.BE not .NP-OBJ 0)
    2 (((*yn-question-ulf-tree* 1 2 3 4)) (1 ?)) (0 :ulf-recur)
  1 (.BE .NP-OBJ 0)
    2 (((*yn-question-ulf-tree* 1 2 3)) (1 ?)) (0 :ulf-recur)
  ; existential there questions
  1 (.BE not there 0)
    2 (((*exist-question-ulf-tree* 1 2 3 4)) (1 ?)) (0 :ulf-recur)
  1 (.BE there 0)
    2 (((*exist-question-ulf-tree* 1 2 3)) (1 ?)) (0 :ulf-recur)
  ; have questions (usually indicates perfect aspect)
  1 (.HAVE 0)
    2 (((*has-question-ulf-tree* 1 2)) (1 ?)) (0 :ulf-recur)
  ; modal questions
  1 (.MODAL 0) ; e.g., can you see the NVidia block ?
    2 (((*modal-question-ulf-tree* 1 2)) (1 ?)) (0 :ulf-recur)
    2 (Sorry \, I am not handling modal questions yet \.) (0 :out)
  ; wh+do questions
  1 (.WH_ 0 .DO 0) ; e.g., what block did I just move ?
    2 (((*wh-do-question-ulf-tree* 1 2 3 4)) (1 ?)) (0 :ulf-recur)
  ; how_many questions
  1 (how_many 0 between 0)
    2 (((*wh-between-question-ulf-tree* 1 2 3 4)) (1 ?)) (0 :ulf-recur)
  ; The following has been incorporated into *wh-question-ulf-tree*
  ;;  1 (how_many 0)
  ;;  2 *how-many-question-ulf-tree* (0 :subtree)
  ; when questions
  1 (when 0)
    2 (((*when-question-ulf-tree* 1 2)) (1 ?)) (0 :ulf-recur)
  ; what color questions
  1 (.WH_ .COLOR 0)
    2 (((*color-question-ulf-tree* 1 2 3)) (1 ?)) (0 :ulf-recur)
  1 (.WH_ .BE .DET .COLOR 0)
    2 (((*color-question-ulf-tree* 1 2 3 4 5)) (1 ?)) (0 :ulf-recur)
  ; where questions
  1 (where 0)
    2 (((*where-question-ulf-tree* 1 2)) (1 ?)) (0 :ulf-recur)
  ; wh-questions
  1 (.WH_ 0 between 0)
    2 (((*wh-between-question-ulf-tree* 1 2 3 4)) (1 ?)) (0 :ulf-recur)
  1 (.WH_ 0)
    2 (((*wh-question-ulf-tree* 1 2)) (1 ?)) (0 :ulf-recur)
  ; PP[wh]-questions
  1 (between 2 .WH_ 0) ; e.g., Between which two blocks is the NVidia block ?
    2 (((*ppwh-between-question-ulf-tree* 1 2 3 4)) (1 ?)) (0 :ulf-recur)
  1 (.PREP 2 .WH_ 0) ; e.g., On top of which block is the NVidia block ?
    2 (((*ppwh-question-ulf-tree* 1 2 3 4)) (1 ?)) (0 :ulf-recur)
  ; "do"-questions
  1 (.DO 0)
    2 (((*do-question-ulf-tree* 1 2)) (1 ?)) (0 :ulf-recur)
  ; declarative questions
  1 (.NP-OBJ 3 .BE 0 ?) ; e.g. A red block is next to a blue block ?
    2 (((*spatial-sentence-ulf-tree* 1 2 3 4)) (1 ?)) (0 :ulf-recur)
  1 (.NP-OBJ 3 .VERB-REL 1 .NP-OBJ 0 ?) ; e.g. A red block adjoins a blue block ?
    2 (((*spatial-sentence-ulf-tree* 1 2 3 4 5)) (1 ?)) (0 :ulf-recur)
  1 (.NP-OBJ 3 .VERB-REL 1 .PREP 0 ?) ; e.g. A red block sits between two green blocks ?
    2 (((*spatial-sentence-ulf-tree* 1 2 3 4 5 6)) (1 ?)) (0 :ulf-recur)
  ; declarative 'modal' questions with ellipses, e.g., next to the Twitter block ?
  1 (1 .PREP 4 ?)
    2 (((*modal-question-ulf-tree* should it be 1 2 3 ?)) (1 ?)) (0 :ulf-recur)
  ; fallback rules
  1 (0 .NOUN-OBJ 0 between 0)
    2 *fallback-between-spatial-question-ulf-tree* (0 :subtree)
  1 (0 between 0 .NOUN-OBJ 0)
    2 *fallback-between-spatial-question-ulf-tree* (0 :subtree)
  1 (0 .NOUN-OBJ 0) ; last resort
    2 *fallback-spatial-question-ulf-tree* (0 :subtree)
  1 (0 .TABLE 0)
    2 *fallback-spatial-question-ulf-tree* (0 :subtree)
  1 (0 .PRON 0)
    2 *fallback-spatial-question-ulf-tree* (0 :subtree)
  1 (0 .CORP 0)
    2 *fallback-spatial-question-ulf-tree* (0 :subtree)
  ; in case no ULF is able to be extracted
  1 (0)
    2 (I didn\'t catch what you said \. Could you rephrase ?) (6 :out)
    2 (Sorry \, I didn\'t hear what you said \.) (6 :out)
    2 (I didn\'t quite understand \.) (0 :out)
)) ; END *spatial-question-ulf-tree*


(READRULES '*n1-ulf-tree*
; ````````````````````````````
; Parses premodified nouns
;
'(
  ; Historical nouns
  ; NOTE: there is a little disparity between how superlatives (e.g. "most recent turn")
  ; are handled here, in part to create consistency with adverbial handling (e.g. "most recently"),
  ; in which case "most" is a mod-a. I'm not sure what the best way to deal with this is.
  1 (most .ADJ-HISTORY 0)
    2 (((lex-ulf@ mod-a 1) (lex-ulf@ adj 2) (*n1-ulf-tree* 3)) ((1 2) 3)) (0 :ulf-recur)
  1 (.ADJ-HISTORY-MODIFIER .ADJ-HISTORY 0)
    2 (((lex-ulf@ mod-a 1) (lex-ulf@ adj 2) (*n1-ulf-tree* 3)) ((1 2) 3)) (0 :ulf-recur)
  1 (.ADJ-HISTORY .ADJ-HISTORY 0)
    2 (((lex-ulf@ adj 1) (lex-ulf@ mod-a 2) (*n1-ulf-tree* 3)) ((2 1) 3)) (0 :ulf-recur)
  ; Straightforward noun, possibly with a corporation and maybe a premodifying adj 
  1 (.NOUN)
    2 (lex-ulf@ noun 1) (0 :ulf)
  1 (.NOUN .NOUN)
    2 ((lex-ulf@ noun 1) (lex-ulf@ noun 2)) (0 :ulf)
  1 (.CORP .NOUN) ; e.g., NVidia block
    2 ((lex-ulf@ name 1) (lex-ulf@ noun 2)) (0 :ulf)
  1 (.ADJ .CORP .NOUN) ; e.g., red NVidia block
    2 ((lex-ulf@ adj 1) ((lex-ulf@ name 2) (lex-ulf@ noun 3))) (0 :ulf)
  1 (.CORP) ; e.g., [the] Starbucks
    2 (((lex-ulf@ name 1)) (1 block.n)) (0 :ulf-recur)
  ; Postmodifiers (allow two, i.e., 2 PPs or a PP and a relative clause (either order) 
  1 (2 .NOUN 1 .PREP .DET 1 .NOUN 1 .PREP 2 .NP-OBJ 3) ; e.g., blocks near each other on the table
    2 (((*n1-ulf-tree* 1 2) (*pp-ulf-tree* 3 4 5 6 7) (*pp-ulf-tree* 8 9 10 11 12)) (n+preds 1 2 3)) (0 :ulf-recur)
  1 (2 .NOUN 1 .PREP .NP-OBJ 2 that .BE 1 .PREP 2 .NP-OBJ 3) ; e.g., block on the table that is near a red block
    2 (((*n1-ulf-tree* 1 2) (*pp-ulf-tree* 3 4 5 6) that.rel (lex-ulf@ v 8) (*pp-ulf-tree* 9 10 11 12 13)) (n+preds 1 2 (3 (4 5)))) (0 :ulf-recur)
  1 (2 .NOUN 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3) ; e.g., red block above the SRI block and the NVidia block
    2 (((*n1-ulf-tree* 1 2) (*pp-ulf-tree* 3 4 5 6 7 8 9)) (n+preds 1 2)) (0 :ulf-recur)
  1 (2 .NOUN 1 between 0 .NOUN-OBJ) ; e.g., block between a blue and a green block
    2 (((*n1-ulf-tree* 1 2) (*pp-between-ulf-tree* 3 4 5 6)) (n+preds 1 2)) (0 :ulf-recur)
  1 (2 .NOUN 1 .PREP 2 .NP-OBJ 3) ; e.g., block next_to the farthest blue block
    2 (((*n1-ulf-tree* 1 2) (*pp-ulf-tree* 3 4 5 6 7)) (n+preds 1 2)) (0 :ulf-recur)
  1 (2 .NOUN that .BE 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3) ; e.g., block that is above the SRI block and the NVidia block
    2 (((*n1-ulf-tree* 1 2) that.rel (lex-ulf@ v 4) (*pp-ulf-tree* 5 6 7 8 9 10 11)) (n+preds 1 (2 (3 4)))) (0 :ulf-recur)
  1 (2 .NOUN that .BE 1 between 0 .NOUN-OBJ) ; e.g., block that is between the NVidia block and SRI block
    2 (((*n1-ulf-tree* 1 2) that.rel (lex-ulf@ v 4) (*pp-ulf-tree* 5 6 7 8)) (n+preds 1 (2 (3 4)))) (0 :ulf-recur)
  1 (2 .NOUN that .BE 1 .PREP 2 .NP-OBJ 3) ; e.g., block that is on the table
    2 (((*n1-ulf-tree* 1 2) that.rel (lex-ulf@ v 4) (*pp-ulf-tree* 5 6 7 8 9)) (n+preds 1 (2 (3 4)))) (0 :ulf-recur)
  ; Historical postmodifier
  ; TODO: a relative clause can have adverbs, such as in "what is the first block that I just recently moved?"
  1 (2 .NOUN 1 .PRON .VERB-REL .PREP 2 .NP-OBJ 3) ; e.g, first block that I put on the Twitter block
    2 (((*n1-ulf-tree* 1 2) that.rel (*np-ulf-tree* 4) (lex-ulf@ v 5) (*pp-ulf-tree* 6 7 8 9)) (n+preds 1 (sub 2 (3 (4 *h 5))))) (0 :ulf-recur)
  1 (2 .NOUN 1 .PRON .VERB-REL) ; e.g., second block that I moved
    2 (((*n1-ulf-tree* 1 2) that.rel (*np-ulf-tree* 4) (lex-ulf@ v 5)) (n+preds 1 (sub 2 (3 (4 *h))))) (0 :ulf-recur)
  1 (2 .NOUN 1 .VERB-REL .PREP 2 .NP-OBJ 3) ; e.g., blocks that were put on the Twitter block
    2 (((*n1-ulf-tree* 1 2) that.rel (lex-ulf@ v-pasv 4) (*pp-ulf-tree* 5 6 7 8)) (n+preds 1 (2 (3 4)))) (0 :ulf-recur)
  1 (2 .NOUN 1 .VERB-REL) ; e.g., blocks that were moved
    2 (((*n1-ulf-tree* 1 2) that.rel (lex-ulf@ v-pasv 4)) (n+preds 1 (2 3))) (0 :ulf-recur)
  ; PP after rel-clause might be a pred complement to "be", so we try this last 
  1 (2 .NOUN that .BE 1 .PREP .DET 1 .NOUN 1 .PREP 2 .NP-OBJ 3) ; e.g., block that is on the table near the red block
    2 (((*n1-ulf-tree* 1 2) that.rel (lex-ulf@ v 4) (*pp-ulf-tree* 5 6 7 8 9 10) (*pp-ulf-tree* 10 11 12 13)) (n+preds 1 (2 (3 4)) 5)) (0 :ulf-recur)
  ; Superlative adj's, possibly followed by more adjectives and then any postmodifiers 
  1 (.SUP-ADJ .NOUN 0) ; e.g., highest block on the stack
    2 (((lex-ulf@ sup-adj 1) (*n1-ulf-tree* 2 3)) (most-n 1 2)) (0 :ulf-recur)
  1 (.SUP-ADJ .ADJ .NOUN 0) ; e.g., highest red block on the table
    2 (((lex-ulf@ sup-adj 1) (*n1-ulf-tree* 2 3 4)) (most-n 1 2)) (0 :ulf-recur)
  1 (most .SUP-ADJ-BASE .NOUN 0) ; e.g., highest block on the stack
    2 (((lex-ulf@ adj 2) (*n1-ulf-tree* 3 4)) (most-n 1 2)) (0 :ulf-recur)
  1 (most .SUP-ADJ-BASE .ADJ .NOUN 0) ; e.g., highest red block on the table
    2 (((lex-ulf@ adj 2) (*n1-ulf-tree* 3 4 5)) (most-n 1 2)) (0 :ulf-recur)
  ; Ordinary premodifying adj's 
  1 (.ADJ .NOUN 0) ; e.g., red block that is to_the_left_of a blue block
    2 (((lex-ulf@ adj 1) (*n1-ulf-tree* 2 3)) (1 2)) (0 :ulf-recur)
  1 (.ADJ .ADJ .NOUN 0) ; e.g., second red block
    2 (((lex-ulf@ adj 1) (lex-ulf@ adj 2) (*n1-ulf-tree* 3 4)) (1 2 3)) (0 :ulf-recur)
; 2 rel-clauses unlikely, so hold off for now 
)) ; END *n1-ulf-tree*


(READRULES '*np-ulf-tree*
; ``````````````````````````````
; Parses noun phrase.
;
'(
  ; How_many
  1 (how_many 2 .NOUN 0) ; e.g., how_many red blocks
    2 (((*n1-ulf-tree* 2 3 4)) ((nquan (how.mod-a many.a)) 1)) (0 :ulf-recur)
  ; Cases with a determiner 
  1 (.DET 2 .NOUN 0) ; e.g., the nearest block to_the_left_of a red block
    2 (((lex-ulf@ det 1) (*n1-ulf-tree* 2 3 4)) (1 2)) (0 :ulf-recur)
  ; Pronoun 
  1 (me)
    2 me.pro (0 :ulf)
  1 (I)
    2 i.pro (0 :ulf)
    2 (you)
    2 you.pro (0 :ulf)
  1 (.PRON)
    2 (lex-ulf@ pro 1) (0 :ulf)
  ; Numerical 
  1 (.DEG-ADV .NUM-ADJ 1 .NOUN 5) ; e.g., exactly two red blocks in a stack
    2 (((lex-ulf@ adv-a 1) (lex-ulf@ adj 2) (*n1-ulf-tree* 3 4 5)) ((nquan (1 2)) 3)) (0 :ulf-recur)
  ; Reification 
  1 (.NOUN 0) ; e.g., blocks on the table
    2 (((*n1-ulf-tree* 1 2)) (k 1)) (0 :ulf-recur)
  1 (.NOUN .NOUN 0) ; e.g., coffee table
    2 (((*n1-ulf-tree* 1 2 3)) (k 1)) (0 :ulf-recur)
  1 (.ADJ .NOUN 0) ; e.g., red blocks in_front_of you
    2 (((*n1-ulf-tree* 1 2 3)) (k 1)) (0 :ulf-recur)
  1 (.ADJ .ADJ .NOUN 0) ; e.g., leftmost red blocks on the table
    2 (((*n1-ulf-tree* 1 2 3 4)) (k 1)) (0 :ulf-recur)
  ; Ellipsis ("the turn before this")
  ; NOTE: we currently assume the user meant "turn" here... this probably isn't true in general
  1 (this)
    2 (((lex-ulf@ det 1)) (1 turn.n)) (0 :ulf-recur)
  1 (that)
    2 (((lex-ulf@ det 1)) (1 turn.n)) (0 :ulf-recur)
  ; Proper name
  ; NOTE: for now this is transformed into (the.d (|Name| block.n)), but should the parser be able
  ; to support straightforward proper names to refer to the blocks?
  1 (.CORP)
    2 (((lex-ulf@ name 1)) (the.d (1 block.n))) (0 :ulf-recur)
  ; Ungrammatical fallback rules
  1 (.CORP .NOUN) ; e.g., [touching] Starbucks block
    2 (((*n1-ulf-tree* 1 2)) (the.d 1)) (0 :ulf-recur)
  1 (the .CORP) ; e.g., the Starbucks
    2 (((lex-ulf@ det 1) (*n1-ulf-tree* 2)) (1 2)) (0 :ulf-recur)
; Still need "There are...", "There is ..." sentence forms.
)) ; END *np-ulf-tree*


(READRULES '*pp-ulf-tree*
; ``````````````````````````````
; Parses prepositional phrase
;
'(
  ; Conjunction of two noun phrases 
  1 (.PREP .DET 2 .NOUN .CONJ .DET 2 .NOUN) ; e.g., above the SRI block and the Nvidia block
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2 3 4) (*np-ulf-tree* 6 7 8)) (1 (set-of 2 3))) (0 :ulf-recur)
  1 (.PREP .DET 2 .NOUN .CONJ 1 .CORP .NOUN) ; e.g., above the SRI block and Nvidia block
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2 3 4) (*np-ulf-tree* 2 6 7 8)) (1 (set-of 2 3))) (0 :ulf-recur)
  ; Preposition with a postmodified noun 
  1 (.PREP .DET 2 .NOUN that 0) ; e.g., on the red block that is on the SRI block
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2 3 4 5 6)) (1 2)) (0 :ulf-recur)
  1 (.PREP .DET 2 .NOUN .PREP 0) ; e.g., on the red block above the SRI block
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2 3 4 5 6)) (1 2)) (0 :ulf-recur)
  ; Simple prepositions 
  1 (.PREP .DET 2 .NOUN) ; e.g., on a red block
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2 3 4)) (1 2)) (0 :ulf-recur)
  1 (.PREP 2 .NOUN) ; e.g., on red blocks
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2 3)) (1 2)) (0 :ulf-recur)
  1 (.PREP .PRON) ; e.g., on it
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2)) (1 2)) (0 :ulf-recur)
  1 (.PREP .CORP) ; e.g., on Starbucks
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2)) (1 2)) (0 :ulf-recur)
  1 (.PREP .DET .CORP) ; e.g., on the Starbucks
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2 3)) (1 2)) (0 :ulf-recur)
  1 (.PREP this) ; e.g., before this
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2)) (1 2)) (0 :ulf-recur)
  1 (.PREP that) ; e.g., before that
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2)) (1 2)) (0 :ulf-recur)
  1 (in .NOUN-TOTAL) ; e.g., in total
    2 (((lex-ulf@ prep 1) (*np-ulf-tree* 2)) (1 2)) (0 :ulf-recur)
  ; Recurse if there's a premodifying adverb-rel 
  1 (not .PREP .DET 3 .NOUN) ; e.g., not on a red block
    2 (((*pp-ulf-tree* 2 3 4 5)) (not 1)) (0 :ulf-recur)
  1 (not .PREP .ADJ 1 .NOUN) ; e.g., not on red blocks
    2 (((*pp-ulf-tree* 2 3 4 5)) (not 1)) (0 :ulf-recur)
  1 (not .PREP .PRON) ; e.g., not on it
    2 (((*pp-ulf-tree* 2 3)) (not 1)) (0 :ulf-recur)
  1 (.DEG-ADV .PREP .DET 3 .NOUN) ; e.g., directly on a red block
    2 (((lex-ulf@ adv-a 1) (*pp-ulf-tree* 2 3 4 5)) (1 2)) (0 :ulf-recur)
  1 (.DEG-ADV .PREP .ADJ 1 .NOUN) ; e.g., directly on red blocks
    2 (((lex-ulf@ adv-a 1) (*pp-ulf-tree* 2 3 4 5)) (1 2)) (0 :ulf-recur)
  1 (.DEG-ADV .PREP .PRON) ; e.g., directly on it
    2 (((lex-ulf@ adv-a 1) (*pp-ulf-tree* 2 3)) (1 2)) (0 :ulf-recur)
  1 (.DEG-ADV .ADV-HISTORY .PREP 0) ; e.g., most recently on a red block
    2 (((lex-ulf@ mod-a 1) (*pp-ulf-tree* 2 3 4)) (1 2)) (0 :ulf-recur)
  1 (.ADV-HISTORY .PREP .DET 3 .NOUN) ; e.g., recently on a red block
    2 (((*adv-ulf-tree* 1) (*pp-ulf-tree* 2 3 4 5)) (1 2)) (0 :ulf-recur)
  1 (.ADV-HISTORY .PREP .ADJ 1 .NOUN) ; e.g., previously on red blocks
    2 (((*adv-ulf-tree* 1) (*pp-ulf-tree* 2 3 4 5)) (1 2)) (0 :ulf-recur)
  1 (.ADV-HISTORY .PREP .PRON) ; e.g., initially on it
    2 (((*adv-ulf-tree* 1) (*pp-ulf-tree* 2 3)) (1 2)) (0 :ulf-recur)
)) ; END *pp-ulf-tree*


(READRULES '*psp-ulf-tree*
; ``````````````````````````````
; Parses sentencial prepositional phrase
;
'(
  1 (.PREP .NP-OBJ 3 .BE .VERB .PREP .NP-OBJ 3) ; e.g., before the NVidia block was put on the SRI block
    2 (((lex-ulf@ ps 1) (*np-ulf-tree* 2 3) (lex-ulf@ v-pasv 5) (*pp-ulf-tree* 6 7 8)) (1 (2 (3 4)))) (0 :ulf-recur)
  1 (.PREP .NP-OBJ 3 .BE .VERB) ; e.g., before the NVidia block was moved
    2 (((lex-ulf@ ps 1) (*np-ulf-tree* 2 3) (lex-ulf@ v-pasv 5)) (1 (2 3))) (0 :ulf-recur)
  1 (.PREP .NP-OBJ 2 .VERB .NP-OBJ 3 .PREP .NP-OBJ 3) ; e.g., before I put the NVidia block on the SRI block
    2 (((lex-ulf@ ps 1) (*np-ulf-tree* 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5 6) (*pp-ulf-tree* 7 8 9)) (1 (2 (3 4 5)))) (0 :ulf-recur)
  1 (.PREP .NP-OBJ 2 .VERB .NP-OBJ 3) ; e.g., before I moved it
    2 (((lex-ulf@ ps 1) (*np-ulf-tree* 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5 6)) (1 (2 (3 4)))) (0 :ulf-recur)
  1 (.PREP .NP-OBJ 3 .BE .PREP .NP-OBJ 3) ; e.g., before it was on the Twitter block
    2 (((lex-ulf@ ps 1) (*np-ulf-tree* 2 3) (lex-ulf@ v 4) (*pp-ulf-tree* 5 6 7)) (1 (2 (3 4)))) (0 :ulf-recur)
)) ; END *psp-ulf-tree*


(READRULES '*adv-ulf-tree*
; `````````````````````````````
; Parses adverbial phrase
;
'(
  ; Basic/single-word adverbials
  1 (just) ; just is an adv-e in the context of historical questions
    2 (((lex-ulf@ adv-adj 1)) (adv-e 1)) (0 :ulf-recur) ; NOTE: might need changing in future
  1 (not) ; e.g., not
    2 not (0 :ulf)
  1 (most .ADV-E) ; e.g., most recently
    2 (((lex-ulf@ mod-a 1) (*adv-ulf-tree* 2)) (adv-e (1 2))) (0 :ulf-recur)
  1 (.DEG-ADV) ; e.g., directly
    2 (lex-ulf@ adv-a 1) (0 :ulf)
  1 (.ADV-F) ; e.g., once
    2 (((lex-ulf@ adv-adj 1)) (adv-f 1)) (0 :ulf-recur)
  1 (.ADV-E) ; e.g., previously
    2 (((lex-ulf@ adv-adj 1)) (adv-e 1)) (0 :ulf-recur)
  1 (.ADV-E .ADV-F) ; e.g., recently always
    2 (((lex-ulf@ mod-a 1) (lex-ulf@ adv-adj 2)) (adv-f (1 2))) (0 :ulf-recur)
  1 (.DEG-ADV .ADV-E) ; e.g., right now
    2 (((lex-ulf@ mod-a 1) (lex-ulf@ adv-adj 2)) (adv-e (1 2))) (0 :ulf-recur)
  ; Simple prepositional adverbials
  1 (.PREP 3 .VERY 3 .NOUN-HISTORY) ; e.g., on the very first turn
    2 (((*pp-ulf-tree* 1 2 4 5)) (adv-e 1)) (0 :ulf-recur)
  1 (.PREP-HISTORY 3 .NOUN-HISTORY .CONJ .PREP-HISTORY 3 .NOUN-HISTORY) ; e.g., before the fifth turn and after the second turn
    2 (((*pp-ulf-tree* 1 2 3) (lex-ulf@ cc 4) (*pp-ulf-tree* 5 6 7)) (adv-e (1 2 3))) (0 :ulf-recur)
  1 (recently .PREP 3 .NOUN-HISTORY) ; e.g., recently before the last turn
    2 (((lex-ulf@ mod-a 1) (*pp-ulf-tree* 2 3 4)) (adv-e (1 2))) (0 :ulf-recur)
  1 (.DEG-ADV .PREP 3 .NOUN-HISTORY) ; e.g., right before the last turn
    2 (((lex-ulf@ mod-a 1) (*pp-ulf-tree* 2 3 4)) (adv-e (1 2))) (0 :ulf-recur)
  1 (.DET .NOUN-HISTORY .PREP 0 .NOUN-HISTORY) ; e.g., two minutes before the last turn
    2 (((*np-ulf-tree* 1 2) (*pp-ulf-tree* 3 4 5)) (adv-e ((mod-a ({by}.p 1)) 2))) (0 :ulf-recur)
  1 (.PREP 3 .NOUN-HISTORY) ; e.g., during the first turn
    2 (((*pp-ulf-tree* 1 2 3)) (adv-e 1)) (0 :ulf-recur)
  1 (.DET .NOUN-HISTORY .PREP-HISTORY-ADJ) ; e.g., two turns ago
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ adj 3)) (adv-e ((mod-a ({by}.p 1)) 2))) (0 :ulf-recur)
  ; Sentential prepositional adverbials
  1 (.PREP-HISTORY-SIMPLE 0 .VERB 0) ; e.g., before I moved it
    2 (*psp-ulf-tree* (1 2 3 4)) (0 :subtree+clause)
  1 (recently .PREP-HISTORY-SIMPLE 0 .VERB 0) ; e.g., recently before I moved it
    2 (((lex-ulf@ mod-a 1) (*psp-ulf-tree* 2 3 4 5)) (1 2)) (0 :ulf-recur)
  1 (.DEG-ADV .PREP-HISTORY-SIMPLE 0 .VERB 0) ; e.g., right before I moved it
    2 (((lex-ulf@ mod-a 1) (*psp-ulf-tree* 2 3 4 5)) (1 2)) (0 :ulf-recur)
  1 (.DET .NOUN-HISTORY .PREP-HISTORY-SIMPLE 0 .VERB 0) ; e.g., two minutes before I moved it
    2 (((*np-ulf-tree* 1 2) (*psp-ulf-tree* 3 4 5 6)) ((mod-a ({by}.p 1)) 2)) (0 :ulf-recur)
  ; Ellipsis (sentential preposition)
  1 (.PREP-HISTORY-SIMPLE the 1 .NOUN-OBJ) ; e.g., before the Twitter block ("did I move the Target block before the Twitter block?")
    2 (*psp-ulf-tree* (1 I moved 2 3 4)) (0 :subtree+clause)
  1 (recently .PREP-HISTORY-SIMPLE the 1 .NOUN-OBJ) ; e.g., recently before the Twitter block
    2 (((lex-ulf@ mod-a 1) (*psp-ulf-tree* 2 I moved 3 4 5)) (1 2)) (0 :ulf-recur)
  1 (.DEG-ADV .PREP-HISTORY-SIMPLE the 1 .NOUN-OBJ) ; e.g., right before the Twitter block
    2 (((lex-ulf@ mod-a 1) (*psp-ulf-tree* 2 I moved 3 4 5)) (1 2)) (0 :ulf-recur)
  1 (.DET .NOUN-HISTORY .PREP-HISTORY-SIMPLE the 1 .NOUN-OBJ) ; e.g., two minutes before the Twitter block
    2 (((*np-ulf-tree* 1 2) (*psp-ulf-tree* 3 I moved 4 5 6)) ((mod-a ({by}.p 1)) 2)) (0 :ulf-recur)
  1 (.PREP-HISTORY-SIMPLE .CORP) ; e.g., before Twitter
    2 (*psp-ulf-tree* (1 I moved 2)) (0 :subtree+clause)
  1 (.DEG-ADV .PREP-HISTORY-SIMPLE .CORP) ; e.g., right before Twitter
    2 (((lex-ulf@ mod-a 1) (*psp-ulf-tree* 2 I moved 3)) (1 2)) (0 :ulf-recur)
  1 (.DET .NOUN-HISTORY .PREP-HISTORY-SIMPLE .CORP) ; e.g., two minutes before Twitter
    2 (((*np-ulf-tree* 1 2) (*psp-ulf-tree* 3 I moved 4)) ((mod-a ({by}.p 1)) 2)) (0 :ulf-recur)
  ; Ellipsis (other)
  1 (.DET .TIME) ; e.g., three times
    2 (((*np-ulf-tree* 1 2)) (adv-f ({at}.p 1))) (0 :ulf-recur)
  1 (.ADJ-HISTORY .NOUN-HISTORY) ; e.g., last turn
    2 (((*n1-ulf-tree* 1 2)) (adv-e (during.p (the.d 1)))) (0 :ulf-recur)
)) ; END *adv-ulf-tree*


(READRULES '*yn-question-ulf-tree*
; `````````````````````````````````````
; Parses yes-no questions.
;
'(
  ; Questions beginning with 'is not' (mostly relevant for explanation questions,
  ; e.g., "why isn't the Twitter block on the Texaco block?")
  1 (.BE not 0)
    2 (((*yn-question-ulf-tree* 1 3)) (not 1)) (0 :ulf-recur)
  ; Asking about conjunction of blocks
  1 (.BE .NP-OBJ 3 and .NP-OBJ 2 .NOUN 0)
    ; Historical
    2 (.BE .NP-OBJ 3 and .NP-OBJ 2 .NOUN .REL-ADJ .ADV-HIST-WORD 0 ?) ; e.g., were the NVidia block and the SRI block touching on the first turn ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*np-ulf-tree* 5 6 7) (lex-ulf@ adj 8) (*adv-ulf-tree* 9 10) ?) ((set-of 2 3) (1 4 5))) (0 :ulf-recur)
    2 (.BE .NP-OBJ 3 and .NP-OBJ 2 .NOUN 1 .REL-ADJ .ADV-HIST-WORD 0 ?) ; e.g., were the NVidia block and the SRI block directly touching previously ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*np-ulf-tree* 5 6 7) (lex-ulf@ adv-a 8) (lex-ulf@ adj 9) (*adv-ulf-tree* 10 11) ?) ((set-of 2 3) (1 4 5 6))) (0 :ulf-recur)
    2 (.BE .NP-OBJ 3 and .NP-OBJ 2 .NOUN 1 .PREP each .OTHER .ADV-HIST-WORD 0 ?) ; e.g., were the NVidia block and the SRI block (directly) touching each other ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*np-ulf-tree* 5 6 7) (*pp-ulf-tree* 8 9 10 11) (*adv-ulf-tree* 12 13) ?) ((set-of 2 3) (1 4 5))) (0 :ulf-recur)
    ; Standard
    2 (.BE .NP-OBJ 3 and .NP-OBJ 2 .NOUN .REL-ADJ ?) ; e.g., are the NVidia block and the SRI block touching ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*np-ulf-tree* 5 6 7) (lex-ulf@ adj 8) ?) ((set-of 2 3) (1 4))) (0 :ulf-recur)
    2 (.BE .NP-OBJ 3 and .NP-OBJ 2 .NOUN 1 .REL-ADJ ?) ; e.g., are the NVidia block and the SRI block directly touching ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*np-ulf-tree* 5 6 7) (lex-ulf@ adv-a 8) (lex-ulf@ adj 9) ?) ((set-of 2 3) (1 4 5))) (0 :ulf-recur)
    2 (.BE .NP-OBJ 3 and .NP-OBJ 2 .NOUN 1 .PREP each .OTHER ?) ; e.g., are the NVidia block and the SRI block (directly) touching each other ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*np-ulf-tree* 5 6 7) (*pp-ulf-tree* 8 9 10 11) ?) ((set-of 2 3) (1 4))) (0 :ulf-recur)
  ; Asking about a single block
  1 (.BE .DET 2 .NOUN-OBJ 0)
    ; Historical
    2 (.BE .DET 2 .NOUN-OBJ 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., was the NVidia block above the SRI block and the Texaco block previously ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4) (*pp-ulf-tree* 5 6 7 8 9 10 11) (*adv-ulf-tree* 12 13) ?) (2 (1 3 4))) (0 :ulf-recur)
    2 (.BE .DET 2 .NOUN-OBJ 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., was the NVidia block on [a red block]/[it]/[red blocks] on the first turn ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4) (*pp-ulf-tree* 5 6 7 8 9) (*adv-ulf-tree* 10 11) ?) (2 (1 3 4))) (0 :ulf-recur)
    2 (.BE .DET 2 .NOUN-OBJ .ADJ .ADV-HIST-WORD 0 ?) ; e.g., was the NVidia block clear/red/visible before I moved it ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4) (lex-ulf@ adj 5) (*adv-ulf-tree* 6 7) ?) (2 (1 3 4))) (0 :ulf-recur)
    2 (.BE .DET 2 .NOUN-OBJ 4 .DET 2 .NOUN 4 .ADV-HIST-WORD 0 ?) ; e.g., was the Twitter block the leftmost block before I moved it ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4 5) (*np-ulf-tree* 6 7 8 9) (*adv-ulf-tree* 10 11) ?) (2 (1 (= 3) 4))) (0 :ulf-recur)
    2 (.BE .DET 2 .NOUN-OBJ 4 .ADV-HISTORY 1 .DET 2 .NOUN 4 ?) ; e.g., was the Twitter block recently the leftmost block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4 5) (*adv-ulf-tree* 6 7) (*np-ulf-tree* 8 9 10 11) ?) (2 (1 3 (= 4)))) (0 :ulf-recur)
    ; Standard
    2 (.BE .DET 2 .NOUN-OBJ 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3 ?) ; e.g., is the NVidia block above the SRI block and the Texaco block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4) (*pp-ulf-tree* 5 6 7 8 9 10 11) ?) (2 (1 3))) (0 :ulf-recur)
    2 (.BE .DET 2 .NOUN-OBJ 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., is the NVidia block on [a red block]/[it]/[red blocks] ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4) (*pp-ulf-tree* 5 6 7 8 9) ?) (2 (1 3))) (0 :ulf-recur)
    2 (.BE .DET 2 .NOUN-OBJ .ADJ ?) ; e.g., is the NVidia block clear/red/visible ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4) (lex-ulf@ adj 5) ?) (2 (1 3))) (0 :ulf-recur)
    2 (.BE .DET 2 .NOUN-OBJ 4 .DET 2 .NOUN 4 ?) ; e.g., is the Twitter block the leftmost block?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4 5) (*np-ulf-tree* 6 7 8 9) ?) (2 (1 (= 3)))) (0 :ulf-recur)
  ; Asking about a single block (by proper name)
  1 (.BE .CORP 0)
    ; Historical
    2 (.BE .CORP 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., was NVidia above the SRI block and the Texaco block previously ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*pp-ulf-tree* 3 4 5 6 7 8 9) (*adv-ulf-tree* 10 11) ?) (2 (1 3 4))) (0 :ulf-recur)
    2 (.BE .CORP 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., was NVidia on [a red block]/[it]/[red blocks] on the first turn ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*pp-ulf-tree* 3 4 5 6 7) (*adv-ulf-tree* 8 9) ?) (2 (1 3 4))) (0 :ulf-recur)
    2 (.BE .CORP .ADJ .ADV-HIST-WORD 0 ?) ; e.g., was NVidia clear/red/visible before I moved it ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ adj 3) (*adv-ulf-tree* 4 5) ?) (2 (1 3 4))) (0 :ulf-recur)
    2 (.BE .CORP .DET 2 .NOUN 4 .ADV-HIST-WORD 0 ?) ; e.g., was Twitter the leftmost block before I moved it ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*np-ulf-tree* 3 4 5 6) (*adv-ulf-tree* 7 8) ?) (2 (1 (= 3) 4))) (0 :ulf-recur)
    2 (.BE .CORP .ADV-HISTORY 1 .DET 2 .NOUN 4 ?) ; e.g., was Twitter recently the leftmost block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*adv-ulf-tree* 3 4) (*np-ulf-tree* 5 6 7 8) ?) (2 (1 3 (= 4)))) (0 :ulf-recur)
    ; Standard
    2 (.BE .CORP 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3 ?) ; e.g., is NVidia above the SRI block and the Texaco block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*pp-ulf-tree* 3 4 5 6 7 8 9) ?) (2 (1 3))) (0 :ulf-recur)
    2 (.BE .CORP 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., is NVidia on [a red block]/[it]/[red blocks] ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*pp-ulf-tree* 3 4 5 6 7) ?) (2 (1 3))) (0 :ulf-recur)
    2 (.BE .CORP .ADJ ?) ; e.g., is NVidia clear/red/visible ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ adj 3) ?) (2 (1 3))) (0 :ulf-recur)
    2 (.BE .CORP .DET 2 .NOUN 4 ?) ; e.g., is Twitter the leftmost block?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*np-ulf-tree* 3 4 5 6) ?) (2 (1 (= 3)))) (0 :ulf-recur)
  ; Asking about a pronoun
  1 (.BE .PRON 0)
    ; Historical
    2 (.BE .PRON 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., was it on top of [a red block]/[them]/[red blocks] previously ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*pp-ulf-tree* 3 4 5 6 7) (*adv-ulf-tree* 8 9) ?) (2 (1 3 4))) (0 :ulf-recur)
    2 (.BE .PRON .ADJ .ADV-HIST-WORD 0 ?) ; e.g., was it clear/red/visible previously ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ adj 3) (*adv-ulf-tree* 4 5) ?) (2 (1 3 4))) (0 :ulf-recur)
    ; Standard
    2 (.BE .PRON 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., is it on top of [a red block]/[them]/[red blocks] ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*pp-ulf-tree* 3 4 5 6 7) ?) (2 (1 3))) (0 :ulf-recur)
    2 (.BE .PRON .ADJ ?) ; e.g., is it clear/red/visible ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ adj 3) ?) (2 (1 3))) (0 :ulf-recur)
)) ; END *yn-question-ulf-tree*


(READRULES '*exist-question-ulf-tree*
; ````````````````````````````````````````
; Parses existential there questions.
;
'(
  ; Historical
  1 (.BE there 3 .NOUN 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., was there a red block above the SRI block and the NVidia block last turn ?
    2 (((lex-ulf@ v 1) there.pro (*np-ulf-tree* 3 4 5 6 7 8 9 10 11) (*adv-ulf-tree* 12 13) ?) (2 (1 3 4))) (0 :ulf-recur)
  1 (.BE there 1 .ADV-HISTORY 3 .NOUN 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., was there ever a red block on the NVidia block ?
    2 (((lex-ulf@ v 1) there.pro (*adv-ulf-tree* 3 4) (*np-ulf-tree* 5 6 7 8 9 10 11)) (2 (1 3 4))) (0 :ulf-recur)
  1 (.BE there 3 .NOUN 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., was there a red block on a red block previously ?
    2 (((lex-ulf@ v 1) there.pro (*np-ulf-tree* 3 4 5 6 7 8 9) (*adv-ulf-tree* 10 11) ?) (2 (1 3 4))) (0 :ulf-recur)
  ; Standard
  1 (.BE there 3 .NOUN 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3 ?) ; e.g., is there a red block above the SRI block and the NVidia block ?
    2 (((lex-ulf@ v 1) there.pro (*np-ulf-tree* 3 4 5 6 7 8 9 10 11) ?) (2 (1 3))) (0 :ulf-recur)
  1 (.BE there 3 .NOUN 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., is there a red block on [a blue block]/[it]
    2 (((lex-ulf@ v 1) there.pro (*np-ulf-tree* 3 4 5 6 7 8 9) ?) (2 (1 3))) (0 :ulf-recur)
)) ; END *exist-question-ulf-tree*


(READRULES '*has-question-ulf-tree*
; `````````````````````````````````````
; Parses has questions (typically indicates perfect aspect, i.e. "has been")
;
'(
  1 (.HAVE 2 .NP-OBJ 3 .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., has the SRI block ever touched the NVidia block ?
    2 (((*np-ulf-tree* 2 3 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) (*np-ulf-tree* 8 9 10) ?) (1 (2 ((past perf) (3 4))))) (0 :ulf-recur)
  1 (.HAVE 2 .NP-OBJ 3 .ADV_ 1 been 1 .ADJ ?) ; e.g., has the SRI block ever been (totally) clear ?
    2 (((*np-ulf-tree* 2 3 4) (*adv-ulf-tree* 5 6) (lex-ulf@ adj 9) ?) (1 (2 ((past perf) (be.v 3))))) (0 :ulf-recur)
  1 (.HAVE 2 .NP-OBJ 3 .ADV_ 1 been between 0 ?) ; e.g., has the SRI block ever been between the NVidia block and Twitter block ?
    2 (((*np-ulf-tree* 2 3 4) (*adv-ulf-tree* 5 6) (*pp-between-ulf-tree* 8 9) ?) (1 (2 ((past perf) (be.v 3))))) (0 :ulf-recur)
  1 (.HAVE 2 .NP-OBJ 3 .ADV_ 1 been 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., has the SRI block ever been on the NVidia block ?
    2 (((*np-ulf-tree* 2 3 4) (*adv-ulf-tree* 5 6) (*pp-ulf-tree* 8 9 10 11 12) ?) (1 (2 ((past perf) (be.v 3))))) (0 :ulf-recur)
  1 (.HAVE there .ADV_ 1 been 2 .NP-OBJ 3 between 0 ?) ; e.g., has there ever been a block between the NVidia block and Twitter block ?
    2 ((there.pro (*adv-ulf-tree* 3 4) (*np-ulf-tree* 6 7 8 9 10) ?) (2 ((past perf) (be.v 1 3)))) (0 :ulf-recur)
  1 (.HAVE there .ADV_ 1 been 2 .NP-OBJ 3 .PREP 2 .NP-OBJ 3 ?) ; e.g., has there ever been a block on the SRI block ?
    2 ((there.pro (*adv-ulf-tree* 3 4) (*np-ulf-tree* 6 7 8 9 10 11 12) ?) (2 ((past perf) (be.v 1 3)))) (0 :ulf-recur)
  1 (.HAVE .PRON .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., have I ever moved the Target block ?
    2 (((*np-ulf-tree* 2) (*adv-ulf-tree* 3 4) (lex-ulf@ v- 5) (*np-ulf-tree* 6 7 8) ?) (1 (2 ((past perf) (3 4))))) (0 :ulf-recur)
  1 (.HAVE .PRON .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., have I moved the Target block ?
    2 (((*np-ulf-tree* 2) (lex-ulf@ v- 3) (*np-ulf-tree* 4 5 6) ?) (1 ((past perf) (2 3)))) (0 :ulf-recur)
)) ; END *has-question-ulf-tree*


(READRULES '*modal-question-ulf-tree*
; `````````````````````````````````````````
; Parses modal questions (e.g. can you see the NVidia block ?).
; 'should' questions added for purposes of concept tutoring (7/9/2020) -B.K.
;
'(
  ; Asking about conjunction of blocks
  1 (.MODAL .NP-OBJ 3 and .NP-OBJ 2 .NOUN 0)
    ; Standard
    2 (.MODAL .NP-OBJ 3 and .NP-OBJ 2 .NOUN .BE .REL-ADJ ?) ; e.g., should the NVidia block and the SRI block be touching ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*np-ulf-tree* 5 6 7) (lex-ulf@ v- 8) (lex-ulf@ adj 9) ?) (1 (set-of 2 3) (4 5))) (0 :ulf-recur)
    2 (.MODAL .NP-OBJ 3 and .NP-OBJ 2 .NOUN .BE 1 .REL-ADJ ?) ; e.g., should the NVidia block and the SRI block be directly touching ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*np-ulf-tree* 5 6 7) (lex-ulf@ v- 8) (lex-ulf@ adv-a 9) (lex-ulf@ adj 10) ?) (1 (set-of 2 3) (4 5 6))) (0 :ulf-recur)
    2 (.MODAL .NP-OBJ 3 and .NP-OBJ 2 .NOUN .BE 1 .PREP each .OTHER ?) ; e.g., should the NVidia block and the SRI block be touching each other ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*np-ulf-tree* 5 6 7) (lex-ulf@ v- 8) (*pp-ulf-tree* 9 10 11 12) ?) (1 (set-of 2 3) (4 5))) (0 :ulf-recur)
  ; Asking about a single block
  1 (.MODAL 1 .DET 2 .NOUN-OBJ 0)
    ; Negation
    2 (.MODAL not .DET 2 .NOUN-OBJ .BE 1 between .NP-OBJ 3 .CONJ .NP-OBJ 3 ?) ; e.g., should not the NVidia block be between the SRI block and the Texaco block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 3 4 5) (lex-ulf@ v- 6) (*pp-between-ulf-tree* 7 8 9 10 11 12 13) ?) (1 not 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL not .DET 2 .NOUN-OBJ .BE 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3 ?) ; e.g., should not the NVidia block be above the SRI block and the Texaco block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 3 4 5) (lex-ulf@ v- 6) (*pp-ulf-tree* 7 8 9 10 11 12 13) ?) (1 not 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL not .DET 2 .NOUN-OBJ .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., should not the NVidia block be on [a red block]/[it]/[red blocks] ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 3 4 5) (lex-ulf@ v- 6) (*pp-ulf-tree* 7 8 9 10 11) ?) (1 not 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL not .DET 2 .NOUN-OBJ .BE .ADJ ?) ; e.g., should not the NVidia block be clear/red/visible ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 3 4 5) (lex-ulf@ v- 6) (lex-ulf@ adj 7) ?) (1 not 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL not .DET 2 .NOUN-OBJ 4 .BE .DET 2 .NOUN 4 ?) ; e.g., should not the Twitter block be the leftmost block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 3 4 5 6) (lex-ulf@ v- 7) (*np-ulf-tree* 8 9 10 11) ?) (1 not 2 (3 (= 4)))) (0 :ulf-recur)
    ; Standard
    2 (.MODAL .DET 2 .NOUN-OBJ .BE 1 between .NP-OBJ 3 .CONJ .NP-OBJ 3 ?) ; e.g., should the NVidia block be between the SRI block and the Texaco block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4) (lex-ulf@ v- 5) (*pp-between-ulf-tree* 6 7 8 9 10 11 12) ?) (1 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL .DET 2 .NOUN-OBJ .BE 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3 ?) ; e.g., should the NVidia block be above the SRI block and the Texaco block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9 10 11 12) ?) (1 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL .DET 2 .NOUN-OBJ .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., should the NVidia block be on [a red block]/[it]/[red blocks] ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9 10) ?) (1 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL .DET 2 .NOUN-OBJ .BE .ADJ ?) ; e.g., should the NVidia block be clear/red/visible ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4) (lex-ulf@ v- 5) (lex-ulf@ adj 6) ?) (1 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL .DET 2 .NOUN-OBJ 4 .BE .DET 2 .NOUN 4 ?) ; e.g., should the Twitter block be the leftmost block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3 4 5) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9 10) ?) (1 2 (3 (= 4)))) (0 :ulf-recur)
  ; Asking about a single block (by proper name)
  1 (.MODAL .CORP 0)
    ; Standard
    2 (.MODAL .CORP .BE 1 between .NP-OBJ 3 .CONJ .NP-OBJ 3 ?) ; e.g., should NVidia be between the SRI block and the Texaco block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*pp-between-ulf-tree* 4 5 6 7 8 9 10) ?) (1 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL .CORP .BE 1 .PREP .NP-OBJ 3 .CONJ .NP-OBJ 3 ?) ; e.g., should NVidia be above the SRI block and the Texaco block ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*pp-ulf-tree* 4 5 6 7 8 9 10) ?) (1 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL .CORP .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., should NVidia be on [a red block]/[it]/[red blocks] ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*pp-ulf-tree* 4 5 6 7 8) ?) (1 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL .CORP .BE .ADJ ?) ; e.g., should NVidia be clear/red/visible ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (lex-ulf@ adj 4) ?) (1 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL .CORP .BE .DET 2 .NOUN 4 ?) ; e.g., should Twitter be the leftmost block?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*np-ulf-tree* 4 5 6 7) ?) (1 2 (3 (= 4)))) (0 :ulf-recur)
  ; Asking about a pronoun
  1 (.MODAL 1 .PRON 0)
    ; Negation
    2 (.MODAL not .PRON .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., should not it be on top of [a red block]/[them]/[red blocks] ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 3) (lex-ulf@ v- 4) (*pp-ulf-tree* 5 6 7 8 9) ?) (1 not 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL not .PRON .BE .ADJ ?) ; e.g., should not it be clear/red/visible ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 3) (lex-ulf@ v- 4) (lex-ulf@ adj 5) ?) (1 not 2 (3 4))) (0 :ulf-recur)
    ; Standard
    2 (.MODAL .PRON .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., should it be on top of [a red block]/[them]/[red blocks] ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*pp-ulf-tree* 4 5 6 7 8) ?) (1 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL .PRON .BE .ADJ ?) ; e.g., should it be clear/red/visible ?
      3 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (lex-ulf@ adj 4) ?) (1 2 (3 4))) (0 :ulf-recur)
  ; Spatial verb
  1 (.MODAL .NP-OBJ 2 not .VERB-REL 1 between 0 ?) ; e.g., should anything not sit between the two red blocks ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 5) (*pp-between-ulf-tree* 7 8)
 ?) (1 2 (not (3 (adv-a 4)))))
  1 (.MODAL .NP-OBJ 2 not .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., should any block not touch the NVidia block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 5) (*np-ulf-tree* 6 7 8) ?) (1 2 (not (3 4)))) (0 :ulf-recur)
  1 (.MODAL .NP-OBJ 2 not .VERB-REL .PREP 2 .NP-OBJ 3 ?) ; e.g., should any block not sit on the red NVidia block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9) ?) (1 2 (not (3 (adv-a 4))))) (0 :ulf-recur)
  1 (.MODAL .NP-OBJ 2 .VERB-REL 1 between 0 ?) ; e.g., should anything sit between the two red blocks ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 4) (*pp-between-ulf-tree* 6 7) ?) (1 2 (3 (adv-a 4)))) (0 :ulf-recur)
  1 (.MODAL .NP-OBJ 2 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., should any block support the NVidia block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7) ?) (1 2 (3 4))) (0 :ulf-recur)
  1 (.MODAL .NP-OBJ 2 .VERB-REL .PREP 2 .NP-OBJ 3 ?) ; e.g., should any block sit on the red NVidia block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 4) (*pp-ulf-tree* 5 6 7 8) ?) (1 2 (3 (adv-a 4)))) (0 :ulf-recur)
  1 (.MODAL .PRON .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., should I move the Twitter block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*np-ulf-tree* 4 5 6) ?) (1 2 (3 4))) (0 :ulf-recur)
  1 (.MODAL .PRON .VERB-REL .DET 2 .NOUN 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., should I put the Twitter block (directly) on the Texaco block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*np-ulf-tree* 4 5 6) (*pp-ulf-tree* 7 8 9 10 11) ?) (1 2 (3 4 5))) (0 :ulf-recur)
  1 (.MODAL .PRON .VERB-REL .PRON 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., should I put it (directly) on the Twitter block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*np-ulf-tree* 4) (*pp-ulf-tree* 5 6 7 8 9) ?) (1 2 (3 4 5))) (0 :ulf-recur)
  ; Asking about an existential proposition
  1 (.MODAL there 0)
    ; Negation
    2 (.MODAL not there .BE .DET 2 .NOUN 1 between 0 ?) ; e.g., should not there be a red block between the Twitter block and the Texaco block ?
      3 (((lex-ulf@ v 1) there.pro (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7 8 9 10) ?) (1 not 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL not there .BE .DET 2 .NOUN 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., should not there be a red block on the Twitter block ?
      3 (((lex-ulf@ v 1) there.pro (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7 8 9 10 11 12) ?) (1 not 2 (3 4))) (0 :ulf-recur)
    ; Standard
    2 (.MODAL there .BE .DET 2 .NOUN 1 between 0 ?) ; e.g., should there be a red block between the Twitter block and the Texaco block ?
      3 (((lex-ulf@ v 1) there.pro (lex-ulf@ v- 3) (*np-ulf-tree* 4 5 6 7 8 9) ?) (1 2 (3 4))) (0 :ulf-recur)
    2 (.MODAL there .BE .DET 2 .NOUN 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., should there be a red block on the Twitter block ?
      3 (((lex-ulf@ v 1) there.pro (lex-ulf@ v- 3) (*np-ulf-tree* 4 5 6 7 8 9 10 11) ?) (1 2 (3 4))) (0 :ulf-recur)
; Should the Twitter block not be on ... ?
; Should I have moved the ... ?
; Should I have put the ... on ... ?
; Should I not have moved the ... ?
; Should not I have moved the ... ?
)) ; END *modal-question-ulf-tree*


(READRULES '*where-question-ulf-tree*
; `````````````````````````````````````````
; Parses where questions.
;
'(
  ; Historical
  1 (where .BE .DET 2 .NOUN .ADV-HIST-WORD 0 ?) ; e.g., where was the NVidia block previously ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5) (*adv-ulf-tree* 6 7) ?) (sub 1 (3 (2 *h 4)))) (0 :ulf-recur)
  1 (where .BE .PRON .ADV-HIST-WORD 0 ?) ; e.g., where was it before I moved it ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (*adv-ulf-tree* 4 5) ?) (sub 1 (3 (2 *h 4)))) (0 :ulf-recur)
  ; Standard
  1 (where .BE .DET 2 .NOUN .PREP-WHERE-ADV 2 .NP-OBJ 3 ?) ; e.g., where is the Twitter block with respect to the Texaco block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5) (*pp-ulf-tree* 6 7 8 9) ?) (sub 1 (3 (2 *h (adv-a 4))))) (0 :ulf-recur)
  1 (where .BE .PRON .PREP-WHERE-ADV 2 .NP-OBJ 3 ?) ; e.g., where is it with respect to the Texaco block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (*pp-ulf-tree* 4 5 6 7) ?) (sub 1 (3 (2 *h (adv-a 4))))) (0 :ulf-recur)
  1 (where .BE .DET 2 .NOUN ?) ; e.g., where is the NVidia block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5) ?) (sub 1 (3 (2 *h)))) (0 :ulf-recur)
  1 (where .BE .PRON ?) ; e.g., where is it ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) ?) (sub 1 (3 (2 *h)))) (0 :ulf-recur)
  ; NOTE: does this make sense?
  1 (where .BE there 0) ; interpret like a y/n-question, i.e., drop the "where"
    2 (((*yn-question-ulf-tree* 2 3 4)) 1) (0 :ulf-recur)
  ; Modal where-questions
  1 (where should 2 .NP-OBJ 3 .BE .PREP-WHERE-ADV 2 .NP-OBJ 3 ?) ; e.g., where should the Twitter block be relative to the Texaco block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5) (lex-ulf@ v- 6) (*pp-ulf-tree* 7 8 9 10) ?) (sub 1 (2 3 (4 *h (adv-a 5))))) (0 :ulf-recur)
  1 (where should 2 .NP-OBJ 3 .BE ?) ; e.g., where should the Twitter block be ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5) (lex-ulf@ v- 6) ?) (sub 1 (2 3 (4 *h)))) (0 :ulf-recur)
  1 (where should .PRON .VERB-REL 2 .NP-OBJ 3 .PREP-WHERE-ADV 2 .NP-OBJ 3 ?) ; e.g., where should I move the Twitter block relative to the Texaco block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7) (*pp-ulf-tree* 8 9 10 11) ?) (sub 1 (2 3 (4 5 *h (adv-a 6))))) (0 :ulf-recur)
  1 (where should .PRON .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., where should I move the Twitter block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7) ?) (sub 1 (2 3 (4 5 *h)))) (0 :ulf-recur)
  1 (where .DO 2 .NP-OBJ 3 .NECESSITY to .BE ?) ; e.g., where does the Twitter block need to be ?
    2 (((lex-ulf@ wh-pred 1) (*np-ulf-tree* 3 4 5) (lex-ulf@ v- 8) ?) (sub 1 ((pres need.aux-v) 2 (3 *h)))) (0 :ulf-recur)
  1 (where .DO .PRON .NECESSITY to .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., where do I need to move the Twitter block ?
    2 (((lex-ulf@ wh-pred 1) (*np-ulf-tree* 3) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9) ?) (sub 1 ((pres need.aux-v) 2 (3 4 *h)))) (0 :ulf-recur)
; Where do you want me to put the Twitter block ?
)) ; END *where-question-ulf-tree*


(READRULES '*when-question-ulf-tree*
; ````````````````````````````````````
; Parses when questions.
;
'(
  1 (when .DO .PRON not .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., when did I not move the Twitter block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (lex-ulf@ v- 5) (*np-ulf-tree* 6 7 8) ?) (sub 1 (2 3 (not (4 5 (adv-e *h)))))) (0 :ulf-recur)
  1 (when .DO .PRON .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., when did I recently move the Twitter block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (*adv-ulf-tree* 4 5) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9) ?) (sub 1 (2 3 (4 (5 6 (adv-e *h)))))) (0 :ulf-recur)
  1 (when .DO .PRON .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., when did I move the Twitter block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7) ?) (sub 1 (2 3 (4 5 (adv-e *h))))) (0 :ulf-recur)
  1 (when .DO 2 .NP-OBJ 3 not .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., when did the Twitter block not touch the Texaco block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5) (lex-ulf@ v- 7) (*np-ulf-tree* 8 9 10) ?) (sub 1 (2 3 (not (4 5 (adv-e *h)))))) (0 :ulf-recur)
  1 (when .DO 2 .NP-OBJ 3 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., when did the Twitter block touch the Texaco block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9) ?) (sub 1 (2 3 (not (4 5 (adv-e *h)))))) (0 :ulf-recur)
  1 (when .BE 2 .NP-OBJ 3 .VERB-REL ?) ; e.g., when was the Twitter block moved ?
    2 (((lex-ulf@ wh-pred 1) (*np-ulf-tree* 3 4 5) (lex-ulf@ v-pasv 6) ?) (sub 1 (2 (3 (adv-e *h))))) (0 :ulf-recur)
  1 (when .BE 2 .NP-OBJ 3 not .PREP 2 .NP-OBJ 3 ?) ; e.g., when was the SRI block not on_top_of the Twitter block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5) (*pp-ulf-tree* 7 8 9 10) ?) (sub 1 (3 (2 not 4 (adv-e *h))))) (0 :ulf-recur)
  1 (when .BE 2 .NP-OBJ 3 .PREP 2 .NP-OBJ 3 ?) ; e.g., when was the SRI block on_top_of the Twitter block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5) (*pp-ulf-tree* 6 7 8 9) ?) (sub 1 (3 (2 4 (adv-e *h))))) (0 :ulf-recur)
  1 (when .BE 2 .NP-OBJ 3 .ADJ ?) ; e.g., when was the SRI block clear ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5) (lex-ulf@ adj 6) ?) (sub 1 (3 (2 4 (adv-e *h))))) (0 :ulf-recur)
)) ; END *when-question-ulf-tree*


(READRULES '*color-question-ulf-tree*
; `````````````````````````````````````````
; Parses what color questions.
;
'(
  ; Historical
  1 (what .COLOR .NOUN .BE 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what color block was to_the_left_of the SRI block previously ?
    2 (((lex-ulf@ det 1) (lex-ulf@ adj 2) (lex-ulf@ noun 3) (lex-ulf@ v 4) (*pp-ulf-tree* 5 6 7 8 9) (*adv-ulf-tree* 10 11) ?) ((1 (2 3)) (4 5 6))) (0 :ulf-recur)
  1 (what .COLOR .BE .NP-OBJ 2 .CONJ .NP-OBJ 2 .ADV-HIST-WORD 0 ?) ; e.g., what color were the Target block and the Starbucks block initially ?
    2 (((lex-ulf@ det 1) (lex-ulf@ noun 2) (lex-ulf@ v 3) (*np-ulf-tree* 4 5) (*np-ulf-tree* 7 8) (*adv-ulf-tree* 9 10) ?) (sub ({of}.p (1 2)) ((set-of 4 5) (3 *h 6)))) (0 :ulf-recur)
  1 (what .COLOR .BE .NP-OBJ 0 .ADV-HIST-WORD 0 ?) ; e.g., what color was the Nvidia block initially ?
    2 (((lex-ulf@ det 1) (lex-ulf@ noun 2) (lex-ulf@ v 3) (*np-ulf-tree* 4 5) (*adv-ulf-tree* 6 7) ?) (sub ({of}.p (1 2)) (4 (3 *h 5)))) (0 :ulf-recur)
  1 (what .BE .DET .COLOR of .NP-OBJ 0 .ADV-HIST-WORD 0 ?) ; e.g., what was the color of the NVidia block initially ?
    2 (((lex-ulf@ det 1) (lex-ulf@ noun 4) (lex-ulf@ v 2) (lex-ulf@ prep 5) (*np-ulf-tree* 6 7) (*adv-ulf-tree* 8 9) ?) (sub (4 (1 2)) (3 (5 *h 6)))) (0 :ulf-recur)
  ; Standard
  1 (what .COLOR .NOUN .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what color block is to_the_left_of the SRI block ?
    2 (((lex-ulf@ det 1) (lex-ulf@ adj 2) (lex-ulf@ noun 3) (lex-ulf@ v 4) (*pp-ulf-tree* 5 6 7 8 9) ?) ((1 (2 3)) (4 5))) (0 :ulf-recur)
  1 (what .COLOR .BE .NP-OBJ 2 .CONJ .NP-OBJ 2 ?) ; e.g., what color are the Target block and the Starbucks block ?
    2 (((lex-ulf@ det 1) (lex-ulf@ noun 2) (lex-ulf@ v 3) (*np-ulf-tree* 4 5) (*np-ulf-tree* 7 8) ?) (sub ({of}.p (1 2)) ((set-of 4 5) (3 *h)))) (0 :ulf-recur)
  1 (what .COLOR .BE .NP-OBJ 0 ?) ; e.g., what color is the Nvidia block ?
    2 (((lex-ulf@ det 1) (lex-ulf@ noun 2) (lex-ulf@ v 3) (*np-ulf-tree* 4 5)) (sub ({of}.p (1 2)) (4 (3 *h)))) (0 :ulf-recur)
  1 (what .BE .DET .COLOR of .NP-OBJ 0 ?) ; e.g., what is the color of the NVidia block ?
    2 (((lex-ulf@ det 1) (lex-ulf@ noun 4) (lex-ulf@ v 2) (lex-ulf@ prep 5) (*np-ulf-tree* 6 7) ?) (sub (4 (1 2)) (3 (5 *h)))) (0 :ulf-recur)
  1 (what .COLOR .NOUN .BE there .PREP 2 .NP-OBJ 3 ?) ; e.g., what color blocks are there on the table ?
    2 (((lex-ulf@ det 1) (lex-ulf@ adj 2) (lex-ulf@ noun 3) (lex-ulf@ v 4) there.pro (*pp-ulf-tree* 6 7 8 9) ?) (5 (4 (1 (2 3)) 6))) (0 :ulf-recur)
  1 (what .COLOR .NOUN .BE there ?) ; e.g., what color blocks are there ?
    2 (((lex-ulf@ det 1) (lex-ulf@ adj 2) (lex-ulf@ noun 3) (lex-ulf@ v 4) there.pro ?) (5 (4 (1 (2 3))))) (0 :ulf-recur)
  1 (what .COLOR .BE there ?) ; e.g., what colors are there ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) there.pro ?) (3 (2 1))) (0 :ulf-recur)
)) ; END *color-question-ulf-tree*


(READRULES '*wh-question-ulf-tree*
; ``````````````````````````````````````
; Parses wh- questions.
; NOTE: 'where' and 'what color' questions are parsed separately for organizational reasons.
;
'(
  ; Passive historical
  1 (.WH_ 2 .BE .ADV_ 1 .VERB-REL between 0 ?) ; e.g., what (block) was just placed between the SRI and NVidia blocks ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 4 5) (lex-ulf@ v-pasv 6) (*pp-between-ulf-tree* 7 8) ?) (1 (2 (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 .BE .ADV_ 1 .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what (block) was just placed on the SRI block ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 4 5) (lex-ulf@ v-pasv 6) (*pp-ulf-tree* 7 8 9 10 11) ?) (1 (2 (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 .BE .ADV_ 1 .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what (block) was only moved once ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 4 5) (lex-ulf@ v-pasv 6) (*adv-ulf-tree* 7 8) ?) (1 (2 (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 .BE .ADV_ 1 .VERB-REL ?) ; e.g., what (block) was just moved ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 4 5) (lex-ulf@ v-pasv 6) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .BE .VERB-REL between 0 .ADV-HIST-WORD 0 ?) ; e.g., what (block) was placed between the SRI and NVidia blocks two turns ago ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v-pasv 4) (*pp-between-ulf-tree* 5 6) (*adv-ulf-tree* 7 8) ?) (1 (2 3 4))) (0 :ulf-recur)
  1 (.WH_ 2 .BE .VERB-REL 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what (block) was placed on the SRI block two turns ago ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v-pasv 4) (*pp-ulf-tree* 5 6 7 8 9) (*adv-ulf-tree* 10 11) ?) (1 (2 3 4))) (0 :ulf-recur)
  1 (.WH_ 2 .BE .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what (block) was moved two turns ago ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v-pasv 4) (*adv-ulf-tree* 5 6) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .BE .VERB-REL between 0 ?) ; e.g., what (block) was placed between the SRI and NVidia blocks ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v-pasv 4) (*pp-between-ulf-tree* 5 6) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .BE .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what (block) was placed on the SRI block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v-pasv 4) (*pp-ulf-tree* 5 6 7 8 9) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .BE .VERB-REL ?) ; e.g., what (block) was moved ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v-pasv 4) ?) (1 2)) (0 :ulf-recur)
  ; Past perf pasv (historical)
  1 (.WH_ 2 .HAVE .ADV_ 1 been .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what (block) has just been placed on the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 4 5) (lex-ulf@ v-pasv- 7) (*pp-ulf-tree* 8 9 10 11 12) ?) (1 (2 (((past perf) 3) 4)))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE been .ADV_ 1 .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what (block) has been recently placed on the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 5 6) (lex-ulf@ v-pasv- 7) (*pp-ulf-tree* 8 9 10 11 12) ?) (1 (2 (((past perf) 3) 4)))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE been .VERB-REL 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what (block) has been placed on the Twitter block two turns ago ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v-pasv- 5) (*pp-ulf-tree* 6 7 8 9 10) (*adv-ulf-tree* 11 12) ?) (1 (((past perf) 2) 3 4))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE been .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what (block) has been placed on the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v-pasv- 5) (*pp-ulf-tree* 6 7 8 9 10) ?) (1 (((past perf) 2) 3))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .ADV_ 1 been .VERB-REL ?) ; e.g., what (block) has just been moved ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 4 5) (lex-ulf@ v-pasv- 7) ?) (1 (2 ((past perf) 3)))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE been .ADV_ 1 .VERB-REL ?) ; e.g., what (block) has been recently moved ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 5 6) (lex-ulf@ v-pasv- 7) ?) (1 (2 ((past perf) 3)))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE been .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what (block) has been moved two turns ago ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v-pasv- 5) (*adv-ulf-tree* 6 7) ?) (1 (((past perf) 2) 3))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE been .VERB-REL ?) ; e.g., what (block) has been moved ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v-pasv- 5) ?) (1 ((past perf) 2))) (0 :ulf-recur)
  ; + Not (historical)
  1 (.WH-DET 1 .NOUN .BE not 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what red blocks were not on_top_of the NVidia block initially ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*pp-ulf-tree* 6 7 8 9 10) (*adv-ulf-tree* 11 12) ?) (1 (2 not 3 4))) (0 :ulf-recur)
  1 (.WH-DET 1 .NOUN .BE not 1 .ADJ .ADV-HIST-WORD 0 ?) ; e.g., what blocks were not (totally) clear during the previous turn ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) (lex-ulf@ adj 7) (*adv-ulf-tree* 8 9) ?) (1 (2 not 3 4))) (0 :ulf-recur)
  ; + There (historical)
  1 (.WH-DET 1 .NOUN .BE there 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what red blocks were there on blue blocks at the start ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*pp-ulf-tree* 6 7 8 9 10) (*adv-ulf-tree* 11 12) ?) (1 (2 3 4))) (0 :ulf-recur)
  ; Pronoun (historical)
  1 (.WH-PRON .BE 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what was next to the Texaco block previously ?
    2 ((what.pro (lex-ulf@ v 2) (*pp-ulf-tree* 3 4 5 6 7) (*adv-ulf-tree* 8 9) ?) (1 (2 3 4))) (0 :ulf-recur)
  1 (.WH-PRON .BE the .SUP-ADJ 2 .ADV-HIST-WORD 0 ?) ; e.g., what was the highest red block before I moved the SRI block ?
    2 (((lex-ulf@ pro 1) (lex-ulf@ v 2) the.d (*n1-ulf-tree* 4 5) (*adv-ulf-tree* 6 7) ?) (1 (2 (= (the.d 4)) 5))) (0 :ulf-recur)
  1 (.WH-PRON .BE the most .SUP-ADJ-BASE 2 .ADV-HIST-WORD 0 ?) ; e.g., what was the most high red block before I moved the SRI block ?
    2 (((lex-ulf@ pro 1) (lex-ulf@ v 2) the.d (*n1-ulf-tree* 4 5 6) (*adv-ulf-tree* 7 8) ?) (1 (2 (= (the.d 4)) 5))) (0 :ulf-recur)
  1 (.WH-PRON .BE the 2 .NOUN .PREP .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what was the block next_to the farthest blue block initially ?
    2 (((lex-ulf@ pro 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5 6 7 8) (*adv-ulf-tree* 9 10) ?) (1 (2 (= 3) 4))) (0 :ulf-recur)
  1 (.WH-PRON .BE the 2 .NOUN 8 .ADV-HIST-WORD 0 ?) ; e.g., what was the first block that I put on the Twitter block previously ?
    2 (((lex-ulf@ pro 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5 6) (*adv-ulf-tree* 7 8) ?) (1 (2 (= 3) 4))) (0 :ulf-recur)
  ; Past perf (historical)
  1 (.WH_ 2 .HAVE .PRON .ADV_ 1 .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what blocks have I just moved before I moved the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (*np-ulf-tree* 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) (*adv-ulf-tree* 8 9) ?) (sub 1 (2 (3 ((past perf) (4 *h 5)))))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .PRON .ADV_ 1 .VERB-REL ?) ; e.g., what blocks have I just moved ?
    2 (((*np-ulf-tree* 1 2) (*np-ulf-tree* 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) ?) (sub 1 (2 (3 ((past perf) (4 *h)))))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .PRON .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what blocks have I moved since the beginning ?
    2 (((*np-ulf-tree* 1 2) (*np-ulf-tree* 4) (lex-ulf@ v- 5) (*adv-ulf-tree* 6 7) ?) (sub 1 (2 ((past perf) (3 *h 4))))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .PRON .VERB-REL ?) ; e.g., what blocks have I moved ?
    2 (((*np-ulf-tree* 1 2) (*np-ulf-tree* 4) (lex-ulf@ v- 5) ?) (sub 1 (2 ((past perf) (3 *h))))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .PRON .ADV_ 1 .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what blocks have I recently put on the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (*np-ulf-tree* 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) (*pp-ulf-tree* 8 9 10 11 12) ?) (sub 1 (2 (3 ((past perf) (4 *h 5)))))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .PRON .VERB-REL 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what blocks have I put on the Twitter block since the beginning ?
    2 (((*np-ulf-tree* 1 2) (*np-ulf-tree* 4) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9 10) (*adv-ulf-tree* 11 12) ?) (sub 1 (2 ((past perf) (3 *h 4 5))))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .PRON .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what blocks have I put on the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (*np-ulf-tree* 4) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9 10) ?) (sub 1 (2 ((past perf) (3 *h 4))))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., what blocks have recently touched the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 4 5) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9) ?) (1 (2 ((past perf) (3 4))))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .VERB-REL 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what blocks have touched the Twitter block since the beginning ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7) (*adv-ulf-tree* 8 9) ?) (1 ((past perf) (2 3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., what blocks have touched the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7) ?) (1 ((past perf) (2 3)))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .ADV_ 1 .VERB-REL ?) ; e.g., what blocks have recently moved ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 4 5) (lex-ulf@ v- 6) ?) (1 ((past perf) 2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what blocks have moved since the beginning ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v- 4) (*adv-ulf-tree* 5 6) ?) (1 ((past perf) 2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .HAVE .VERB-REL ?) ; e.g., what blocks have moved ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v- 4) ?) (1 ((past perf) 2))) (0 :ulf-recur)
  ; Non-be verb (historical)
  1 (.WH_ 2 .VERB-REL 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what block sat on the SRI block previously ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-ulf-tree* 4 5 6 7 8) (*adv-ulf-tree* 9 10)) (1 (2 3 4))) (0 :ulf-recur)
  1 (.WH_ 2 .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., what block initially faced the SRI block ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 3 4) (lex-ulf@ v 5) (*np-ulf-tree* 6 7 8)) (1 (2 (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 .VERB-REL 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what block faced the SRI block initially ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4 5 6) (*adv-ulf-tree* 7 8)) (1 (2 3 4))) (0 :ulf-recur)
  1 (.WH_ 2 .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what changed since last turn ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*adv-ulf-tree* 4 5)) (1 (2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .ADV_ 1 .VERB-REL ?) ; e.g., what recently changed ?
    2 (((*np-ulf-tree* 1 2) (*adv-ulf-tree* 3 4) (lex-ulf@ v 5)) (1 (2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .DO not .VERB-REL ?) ; e.g., what blocks did not move ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) not (lex-ulf@ v- 5)) (1 (2 3 4))) (0 :ulf-recur)
  1 (.WH_ 2 .VERB-REL ?) ; e.g., what blocks moved ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3)) (1 2)) (0 :ulf-recur)
  ; Standard (historical premodifier)
  1 (.WH_ 2 .BE .ADV_ 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what red blocks were (most) recently above it ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*adv-ulf-tree* 4 5) (*pp-ulf-tree* 6 7 8 9) ?) (1 (2 3 4))) (0 :ulf-recur)
  1 (.WH_ 2 .BE .ADV_ 1 .ADJ ?) ; e.g., which blocks were initially clear ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*adv-ulf-tree* 4 5) (lex-ulf@ adj 6) ?) (1 (2 3 4))) (0 :ulf-recur)
  ; Standard (historical)
  1 (.WH_ 2 .BE 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what red blocks were above it initially ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-ulf-tree* 4 5 6 7 8) (*adv-ulf-tree* 9 10) ?) (1 (2 3 4))) (0 :ulf-recur)
  1 (.WH_ 2 .BE 1 .ADJ .ADV-HIST-WORD 0 ?) ; e.g., which blocks were (totally) clear initially ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (lex-ulf@ adj 5) (*adv-ulf-tree* 6 7) ?) (1 (2 3 4))) (0 :ulf-recur)
  1 (.WH_ 2 .BE 2 .NP-OBJ 3 .ADV_ 1 .PREP ?) ; e.g., what/which block was the NVidia block previously on_top_of ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4 5 6) (*adv-ulf-tree* 7 8) (lex-ulf@ prep 9) ?) (sub 1 (3 (2 4 (5 *h))))) (0 :ulf-recur)
  1 (.WH_ 2 .BE 2 .NP-OBJ 3 .PREP .ADV-HIST-WORD 0 ?) ; e.g., what/which block was the NVidia block on_top_of before I moved it ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4 5 6) (lex-ulf@ prep 7) (*adv-ulf-tree* 8 9) ?) (sub 1 (3 (2 (4 *h) 5)))) (0 :ulf-recur)
  ; + Not
  1 (.WH-DET 1 .NOUN .BE not 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what red blocks are not directly on_top_of the NVidia block ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*pp-ulf-tree* 6 7 8 9 10) ?) (1 (2 not 3))) (0 :ulf-recur)
  1 (.WH-DET 1 .NOUN .BE not 1 .ADJ ?) ; e.g., what blocks are not (totally) clear ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) (lex-ulf@ adj 7) ?) (1 (2 not 3))) (0 :ulf-recur)
  ; + There
  1 (.WH-DET 1 .NOUN .BE there 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what red blocks are there on blue blocks ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*pp-ulf-tree* 6 7 8 9 10) ?) (1 (2 3))) (0 :ulf-recur)
  ; Pronoun
  1 (.WH-PRON .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what is next to the Texaco block ?
    2 ((what.pro (lex-ulf@ v 2) (*pp-ulf-tree* 3 4 5 6 7) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH-PRON .BE the .SUP-ADJ 2 ?) ; e.g., what is the highest red block ?
    2 (((lex-ulf@ pro 1) (lex-ulf@ v 2) the.d (*n1-ulf-tree* 4 5) ?) (1 (2 (= (the.d 4))))) (0 :ulf-recur)
  1 (.WH-PRON .BE the most .SUP-ADJ-BASE 2 ?) ; e.g., what is the highest red block ?
    2 (((lex-ulf@ pro 1) (lex-ulf@ v 2) the.d (*n1-ulf-tree* 4 5 6) ?) (1 (2 (= (the.d 4))))) (0 :ulf-recur)
  1 (.WH-PRON .BE the 2 .NOUN .PREP .NP-OBJ 3 ?) ; e.g., what is the block next_to the farthest blue block ?
    2 (((lex-ulf@ pro 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5 6 7 8) ?) (1 (2 (= 3)))) (0 :ulf-recur)
  1 (.WH-PRON .BE the 2 .NOUN 8 ?) ; e.g., what is the third block to the left of the Twitter block ?
    2 (((lex-ulf@ pro 1) (lex-ulf@ v 2) (*np-ulf-tree* 3 4 5 6) ?) (1 (2 (= 3)))) (0 :ulf-recur)
  ; Non-be verb
  1 (.WH_ 2 .DO not .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what block doesn't sit on the table ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9 10)) (1 (2 not (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 .DO not .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., what blocks don't touch the SRI block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (lex-ulf@ v- 5) (*np-ulf-tree* 6 7 8)) (1 (2 not (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what block sits on the SRI block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-ulf-tree* 4 5 6 7 8)) (1 (2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., what block faces the SRI block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4 5 6)) (1 (2 3))) (0 :ulf-recur)
  ; Standard
  1 (.WH_ 2 .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what red blocks are above it ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-ulf-tree* 4 5 6 7 8) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .BE 1 .ADJ ?) ; e.g., which blocks are (totally) clear ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (lex-ulf@ adj 5) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH_ 2 .BE 2 .NP-OBJ 3 .PREP ?) ; e.g., what/which block is the NVidia block on_top_of ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4 5 6) (lex-ulf@ prep 7) ?) (sub 1 (3 (2 (4 *h))))) (0 :ulf-recur)
  ; The following rules were repurposed from the "how many" question tree,
  ; and need to be re-integrated into the above at some point.
  ; ````````````````````````````````````````````````````````````````
  ; Counting blocks satisfying some property (historical)
  1 (.WH-DET 1 .NOUN .BE there .ADV-HIST-WORD 0 ?) ; e.g., how many red blocks were there initially ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) there.pro (*adv-ulf-tree* 6 7) ?) (1 (2 there.pro 4))) (0 :ulf-recur)
  1 (.WH-DET 1 .NOUN 3 .BE not .ADJ .ADV-HIST-WORD 0 ?) ; e.g., how many blocks (on the table) were not red before this turn ?
    2 (((*np-ulf-tree* 1 2 3 4) (lex-ulf@ v 5) (lex-ulf@ adj 7) (*adv-ulf-tree* 8 9) ?) (1 (2 not 3 4))) (0 :ulf-recur)
  1 (.WH-DET 1 .NOUN 3 .BE .ADJ .ADV-HIST-WORD 0 ?) ; e.g., how many blocks (on the table) were red previously ?
    2 (((*np-ulf-tree* 1 2 3 4) (lex-ulf@ v 5) (lex-ulf@ adj 6) (*adv-ulf-tree* 7 8) ?) (1 (2 3 4))) (0 :ulf-recur)
  1 (.WH-DET .BE not .ADJ .ADV-HIST-WORD 0 ?) ; e.g., how many were not red initially ?
    2 (((*np-ulf-tree* 1 blocks) (lex-ulf@ v 2) (lex-ulf@ adj 4) (*adv-ulf-tree* 5 6) ?) (1 (2 not 3 4))) (0 :ulf-recur)
  1 (.WH-DET .BE .ADJ .ADV-HIST-WORD 0 ?) ; e.g., how many were red initially ?
    2 (((*np-ulf-tree* 1 blocks) (lex-ulf@ v 2) (lex-ulf@ adj 3) (*adv-ulf-tree* 4 5) ?) (1 (2 3 4))) (0 :ulf-recur)
  ; Counting blocks satisfying some preposition
  1 (.WH-DET 1 .NOUN .BE not .PREP 2 .NP-OBJ 3 .CONJ 2 .NP-OBJ 3 ?) ; e.g., how many blocks are not on red blocks or blue blocks ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*pp-ulf-tree* 6 7 8 9 10 11 12 13) ?) (1 (2 not 3))) (0 :ulf-recur)
  1 (.WH-DET 1 .NOUN .BE 1 .PREP 2 .NP-OBJ 3 .CONJ 2 .NP-OBJ 3 ?) ; e.g., how many blocks are above the SRI block and NVidia block ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*pp-ulf-tree* 6 7 8 9 10 11 12 13) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH-DET 1 .NOUN .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., how many blocks are there on some red block ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*pp-ulf-tree* 6 7 8 9) ?) (1 (2 3))) (0 :ulf-recur)
  ; Counting blocks satisfying some property
  1 (.WH-DET 1 .NOUN .BE there in .NOUN-TOTAL ?) ; e.g., how many red blocks are there in total ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) there.pro (*pp-ulf-tree* 6 7) ?) (1 (2 there.pro (adv-a 4)))) (0 :ulf-recur)
  1 (.WH-DET 1 .NOUN .BE there ?) ; e.g., how many red blocks are there ?
    2 (((*np-ulf-tree* 1 2 3) (lex-ulf@ v 4) there.pro ?) (1 (2 there.pro))) (0 :ulf-recur)
  1 (.WH-DET 1 .NOUN 3 .BE not .ADJ ?) ; e.g., how many blocks on the table are not red ?
    2 (((*np-ulf-tree* 1 2 3 4) (lex-ulf@ v 5) (lex-ulf@ adj 7) ?) (1 (2 not 3))) (0 :ulf-recur)
  1 (.WH-DET 1 .NOUN 3 .BE .ADJ ?) ; e.g., how many blocks are red ?
    2 (((*np-ulf-tree* 1 2 3 4) (lex-ulf@ v 5) (lex-ulf@ adj 6) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH-DET .BE not .ADJ ?) ; e.g., how many are not red ?
    2 (((*np-ulf-tree* 1 blocks) (lex-ulf@ v 2) (lex-ulf@ adj 4) ?) (1 (2 not 3))) (0 :ulf-recur)
  1 (.WH-DET .BE .ADJ ?) ; e.g., how many are red ?
    2 (((*np-ulf-tree* 1 blocks) (lex-ulf@ v 2) (lex-ulf@ adj 3) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH-DET of .DET 1 .NOUN .BE .PREP 2 .NP-OBJ 3 ?) ; e.g., how many of the blocks are on some blue block ?
    2 (((*np-ulf-tree* 1 4 5) (lex-ulf@ v 6) (*pp-ulf-tree* 7 8 9 10) ?) (1 (2 3))) (0 :ulf-recur)
  1 (.WH-DET of .DET 1 .NOUN .BE .ADJ ?) ; e.g., how many of the blocks are red ?
    2 (((*np-ulf-tree* 1 4 5) (lex-ulf@ v 6) (lex-ulf@ adj 7) ?) (1 (2 3))) (0 :ulf-recur)
  ; Modal wh-question
  1 (.WH_ 2 should not .BE between 0 ?) ; e.g., what block should not be between the Twitter block and the Texaco block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (lex-ulf@ v- 5) (*pp-between-ulf-tree* 6 7) ?) (1 (2 not (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 should .BE between 0 ?) ; e.g., what block should be between the Twitter block and the Texaco block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (lex-ulf@ v- 4) (*pp-between-ulf-tree* 5 6) ?) (1 (2 (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 should not .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what block should not be on the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9 10) ?) (1 (2 not (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 should .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what block should be on the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (lex-ulf@ v- 4) (*pp-ulf-tree* 5 6 7 8 9) ?) (1 (2 (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 should not .BE .ADJ ?) ; e.g., what block should not be clear ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (lex-ulf@ v- 5) (lex-ulf@ adj 6) ?) (1 (2 not (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 should .BE .ADJ ?) ; e.g., what block should be clear ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (lex-ulf@ v- 4) (lex-ulf@ adj 5) ?) (1 (2 (3 4)))) (0 :ulf-recur)
  1 (.WH_ 2 should .PRON .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what block should I put on the Twitter block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9 10) ?) (sub 1 (2 3 (4 *h 5)))) (0 :ulf-recur)
  1 (.WH_ 2 should .PRON .VERB-REL ?) ; e.g., what block should I move ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (lex-ulf@ v- 5) ?) (sub 1 (2 3 (4 *h)))) (0 :ulf-recur)
)) ; END *wh-question-ulf-tree*


(READRULES '*ppwh-question-ulf-tree*
; ````````````````````````````````````````
; Parses PP[wh] questions.
;
'(
  ; Historical
  1 (.PREP-HISTORY .WH-DET 2 .BE .NP-OBJ 3 between 0 ?) ; e.g., during what turn was the NVidia block between a red block and a blue block ?
    2 (((*pp-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5 6) (*pp-between-ulf-tree* 7 8) ?) (sub 1 (3 (2 4 (adv-e *h))))) (0 :ulf-recur)
  1 (.PREP-HISTORY .WH-DET 2 .BE .NP-OBJ 3 .PREP .NP-OBJ 3 ?) ; e.g., during what turn was the NVidia block on the SRI block ?
    2 (((*pp-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5 6) (*pp-ulf-tree* 7 8 9) ?) (sub 1 (3 (2 4 (adv-e *h))))) (0 :ulf-recur)
  1 (.PREP .WH-DET 2 .BE .NP-OBJ 4 .ADV-HIST-WORD 0 ?) ; e.g., on what object was the NVidia block previously ?
    2 (((*pp-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5 6) (*adv-ulf-tree* 7 8) ?) (sub 1 (3 (2 *h 4)))) (0 :ulf-recur)
  ; Historical + do
  1 (.PREP-HISTORY .WH-DET 2 .DO .PRON .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., during what turn did I move the SRI block ?
    2 (((*pp-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9) ?) (sub 1 (2 3 (4 5 (adv-e *h))))) (0 :ulf-recur)
  1 (.PREP .WH-DET 2 .DO .PRON .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., between which blocks did I just move the SRI block ?
    2 (((*pp-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5) (*adv-ulf-tree* 6 7) (lex-ulf@ v- 8) (*np-ulf-tree* 9 10 11) ?) (sub 1 (2 3 (4 (5 6 *h))))) (0 :ulf-recur)
  1 (.PREP .WH-DET 2 .DO .PRON .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., between which blocks did I move the SRI block ?
    2 (((*pp-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9) ?) (sub 1 (2 3 (4 5 *h)))) (0 :ulf-recur)
  1 (.PREP .WH-DET 2 .DO .PRON .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., on_to what block did I just move the SRI block ?
    2 (((*pp-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5) (*adv-ulf-tree* 6 7) (lex-ulf@ v- 8) (*np-ulf-tree* 9 10 11) ?) (sub 1 (2 3 (4 (5 6 *h))))) (0 :ulf-recur)
  1 (.PREP .WH-DET 2 .DO .PRON .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., on_to what block did I move the SRI block ?
    2 (((*pp-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9) ?) (sub 1 (2 3 (4 5 *h)))) (0 :ulf-recur)
  ; Standard
  1 (.PREP .WH-DET 2 .BE .NP-OBJ 4 ?) ; e.g., on what object is the NVidia block ?
    2 (((*pp-ulf-tree* 1 2 3) (lex-ulf@ v 4) (*np-ulf-tree* 5 6) ?) (sub 1 (3 (2 *h)))) (0 :ulf-recur)
; TODO: add further rules, e.g., for "On what blocks are there other blocks ?", or
; "On how many blocks is the Target block resting/placed/supported/positioned ?"
)) ; END *ppwh-question-ulf-tree*


(READRULES '*wh-do-question-ulf-tree*
; ````````````````````````````````````````
; Parses wh + do questions.
;
'(
  ; Premodifying+postmodifying adv-e
  1 (where .DO .PRON .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., where did I ever move the NVidia block since the beginning ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (*adv-ulf-tree* 4 5) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9) (*adv-ulf-tree* 10 11) ?) (sub 1 (2 3 (4 (5 6 (adv-a *h) 7))))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .ADV_ 1 .VERB-REL between 0 .ADV-HIST-WORD 0 ?) ; e.g., what blocks did I ever put between the SRI block and NVidia block since the beginning ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) (*pp-between-ulf-tree* 8 9) (*adv-ulf-tree* 10 11) ?) (sub 1 (2 3 (4 (5 *h 6 7))))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .ADV_ 1 .VERB-REL 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what blocks did I ever put on the SRI block since the beginning ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) (*pp-ulf-tree* 8 9 10 11 12) (*adv-ulf-tree* 13 14) ?) (sub 1 (2 3 (4 (5 *h 6 7))))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .ADV_ 1 .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what blocks did I ever move since the beginning ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) (*adv-ulf-tree* 8 9) ?) (sub 1 (2 3 (4 (5 *h 6))))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON not .ADV_ 1 .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what blocks did I not ever move since the beginning ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (*adv-ulf-tree* 6 7) (lex-ulf@ v- 8) (*adv-ulf-tree* 9 10) ?) (sub 1 (2 3 (not (4 (5 *h 6)))))) (0 :ulf-recur)
  ; Premodifying adverb
  1 (where .DO .PRON .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., where did I just move the NVidia block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (*adv-ulf-tree* 4 5) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9) ?) (sub 1 (2 3 (4 (5 6 (adv-a *h)))))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .ADV_ 1 .VERB-REL between 0 ?) ; e.g., what (block) did I just put between the SRI block and NVidia block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) (*pp-between-ulf-tree* 8 9) ?) (sub 1 (2 3 (4 (5 *h 6))))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .ADV_ 1 .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what (block) did I just put on the SRI block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) (*pp-ulf-tree* 8 9 10 11 12) ?) (sub 1 (2 3 (4 (5 *h 6))))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .ADV_ 1 .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what (block) did I only move once?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) (*adv-ulf-tree* 8 9) ?) (sub 1 (2 3 (4 (5 *h 6))))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON not .ADV_ 1 .VERB-REL ?) ; e.g., what (block) did I not just move ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (*adv-ulf-tree* 6 7) (lex-ulf@ v- 8) ?) (sub 1 (2 3 (not (4 (5 *h)))))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .ADV_ 1 .VERB-REL ?) ; e.g., what (block) did I just move ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (*adv-ulf-tree* 5 6) (lex-ulf@ v- 7) ?) (sub 1 (2 3 (4 (5 *h))))) (0 :ulf-recur)
  ; Postmodifying adv-e
  1 (where .DO .PRON .VERB-REL 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., where did I move the NVidia block two turns ago ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7) (*adv-ulf-tree* 8 9) ?) (sub 1 (2 3 (4 5 (adv-a *h) 6)))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .VERB-REL between 0 .ADV-HIST-WORD 0 ?) ; e.g., what (block) did I put between the SRI block and NVidia block two turns ago ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (lex-ulf@ v- 5) (*pp-between-ulf-tree* 6 7) (*adv-ulf-tree* 8 9) ?) (sub 1 (2 3 (4 *h 5 6)))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .VERB-REL 1 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., what (block) did I put on the SRI block two turns ago ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9 10) (*adv-ulf-tree* 11 12) ?) (sub 1 (2 3 (4 *h 5 6)))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what (block) did I move two turns ago ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (lex-ulf@ v- 5) (*adv-ulf-tree* 6 7) ?) (sub 1 (2 3 (4 *h 5)))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON not .VERB-REL .ADV-HIST-WORD 0 ?) ; e.g., what (blocks) did I not move two turns ago ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (lex-ulf@ v- 6) (*adv-ulf-tree* 7 8) ?) (sub 1 (2 3 (not (4 *h 5))))) (0 :ulf-recur)
  ; Standard
  1 (where .DO .PRON .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., where did I move the NVidia block ?
    2 (((lex-ulf@ wh-pred 1) (lex-ulf@ v 2) (*np-ulf-tree* 3) (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7) ?) (sub 1 (2 3 (4 5 (adv-a *h))))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .VERB-REL between 0 ?) ; e.g., what (block) did I put between the SRI block and NVidia block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (lex-ulf@ v- 5) (*pp-between-ulf-tree* 6 7) ?) (sub 1 (2 3 (4 *h 5)))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .VERB-REL 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., what (block) did I put on the SRI block ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9 10) ?) (sub 1 (2 3 (4 *h 5)))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON .VERB-REL ?) ; e.g., what (block) did I move ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (lex-ulf@ v- 5) ?) (sub 1 (2 3 (4 *h)))) (0 :ulf-recur)
  1 (.WH_ 2 .DO .PRON not .VERB-REL ?) ; e.g., what (block) did I not move ?
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 4) (lex-ulf@ v- 6) ?) (sub 1 (2 3 (not (4 *h))))) (0 :ulf-recur)
)) ; END *wh-do-question-ulf-tree*


(READRULES '*do-question-ulf-tree*
; ```````````````````````````````````````
; Parses do questions.
;
'(
  ; Questions beginning with 'is not' (mostly relevant for explanation questions,
  ; e.g., "why don't the Twitter block and Texaco block touch?")
  1 (.DO not 0)
    2 (((*do-question-ulf-tree* 1 3)) (not 1)) (0 :ulf-recur)
  ; Action verbs (historical)
  1 (.DO .PRON .VERB-REL 2 .NP-OBJ 3 between 0 ?) ; e.g., did I put anything between the two red blocks ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*np-ulf-tree* 4 5 6) (*pp-between-ulf-tree* 7 8) ?) (1 2 (3 4 5))) (0 :ulf-recur)
  1 (.DO .PRON .VERB-REL 2 .NP-OBJ 3 .PREP 2 .NP-OBJ 3 ?) ; e.g., did I put anything on the Twitter block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*np-ulf-tree* 4 5 6) (*pp-ulf-tree* 7 8 9 10) ?) (1 2 (3 4 5))) (0 :ulf-recur)
  1 (.DO .PRON .VERB-REL 2 .NP-OBJ 3 between 0 .ADV-HIST-WORD 0 ?) ; e.g., did I put anything between the two red blocks initially ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*np-ulf-tree* 4 5 6) (*pp-between-ulf-tree* 7 8) (*adv-ulf-tree* 9 10) ?) (1 2 (3 4 5 6))) (0 :ulf-recur)
  1 (.DO .PRON .VERB-REL 2 .NP-OBJ 3 .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., did I put anything on the Twitter block initially ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (lex-ulf@ v- 3) (*np-ulf-tree* 4 5 6) (*pp-ulf-tree* 7 8 9 10) (*adv-ulf-tree* 11 12) ?) (1 2 (3 4 5 6))) (0 :ulf-recur)
  1 (.DO .PRON .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 between 0 ?) ; e.g., did I recently put anything between the two red blocks ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*adv-ulf-tree* 3 4) (lex-ulf@ v- 5) (*np-ulf-tree* 6 7 8) (*pp-between-ulf-tree* 9 10) ?) (1 2 (3 (4 5 6)))) (0 :ulf-recur)
  1 (.DO .PRON .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 .PREP 2 .NP-OBJ 3 ?) ; e.g., did I recently put anything on the Twitter block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2) (*adv-ulf-tree* 3 4) (lex-ulf@ v- 5) (*np-ulf-tree* 6 7 8) (*pp-ulf-tree* 9 10 11 12) ?) (1 2 (3 (4 5 6)))) (0 :ulf-recur)
  ; Negation (historical)
  1 (.DO .NP-OBJ 2 not .VERB-REL 1 between 0 .ADV-HIST-WORD 0 ?) ; e.g., did anything not sit between the two red blocks initially ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 5) (*pp-between-ulf-tree* 7 8) (*adv-ulf-tree* 9 10) ?) (1 2 (not (3 (adv-a 4) 5)))) (0 :ulf-recur)
  1 (.DO .NP-OBJ 2 not .VERB-REL 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., did any block not support the NVidia block at the first turn ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 5) (*np-ulf-tree* 6 7 8) (*adv-ulf-tree* 9 10) ?) (1 2 (not (3 4 5)))) (0 :ulf-recur)
  1 (.DO .NP-OBJ 2 not .VERB-REL .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., did any block not sit on the red NVidia block on the turn before this ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9) (*adv-ulf-tree* 10 11) ?) (1 2 (not (3 (adv-a 4) 5)))) (0 :ulf-recur)
  ; Standard (historical)
  1 (.DO .NP-OBJ 2 .VERB-REL 1 between 0 .ADV-HIST-WORD 0 ?) ; e.g., did anything sit between the two red blocks initially ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 4) (*pp-between-ulf-tree* 6 7) (*adv-ulf-tree* 8 9) ?) (1 2 (3 (adv-a 4) 5))) (0 :ulf-recur)
  1 (.DO .NP-OBJ 2 .VERB-REL 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., did any block support the NVidia block at the first turn ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7) (*adv-ulf-tree* 8 9) ?) (1 2 (3 4 5))) (0 :ulf-recur)
  1 (.DO .NP-OBJ 2 .VERB-REL .PREP 2 .NP-OBJ 3 .ADV-HIST-WORD 0 ?) ; e.g., did any block sit on the red NVidia block on the turn before this ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 4) (*pp-ulf-tree* 5 6 7 8) (*adv-ulf-tree* 9 10) ?) (1 2 (3 (adv-a 4) 5))) (0 :ulf-recur)
  ; Negated
  1 (.DO .NP-OBJ 2 not .VERB-REL 1 between 0 ?) ; e.g., does anything not sit between the two red blocks ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 5) (*pp-between-ulf-tree* 7 8)
 ?) (1 2 (not (3 (adv-a 4)))))
  1 (.DO .NP-OBJ 2 not .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., does any block not touch the NVidia block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 5) (*np-ulf-tree* 6 7 8) ?) (1 2 (not (3 4)))) (0 :ulf-recur)
  1 (.DO .NP-OBJ 2 not .VERB-REL .PREP 2 .NP-OBJ 3 ?) ; e.g., does any block not sit on the red NVidia block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 5) (*pp-ulf-tree* 6 7 8 9) ?) (1 2 (not (3 (adv-a 4))))) (0 :ulf-recur)
  ; Historical premodifier
  1 (.DO .NP-OBJ 2 .ADV_ 1 .VERB-REL 1 between 0 ?) ; e.g., did anything recently sit between the two red blocks ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*adv-ulf-tree* 4 5) (lex-ulf@ v- 6)
 (*pp-between-ulf-tree* 8 9) ?) (1 2 (3 (4 (adv-a 5)))))
  1 (.DO .NP-OBJ 2 .ADV_ 1 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., did any block initially touch the NVidia block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*adv-ulf-tree* 4 5) (lex-ulf@ v- 6) (*np-ulf-tree* 7 8 9) ?) (1 2 (3 (4 5)))) (0 :ulf-recur)
  1 (.DO .NP-OBJ 2 .ADV_ 1 .VERB-REL .PREP 2 .NP-OBJ 3 ?) ; e.g., did any block previously sit on the red NVidia block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (*adv-ulf-tree* 4 5) (lex-ulf@ v- 6) (*pp-ulf-tree* 7 8 9 10) ?) (1 2 (3 (4 (adv-a 5))))) (0 :ulf-recur)
  ; Standard
  1 (.DO .NP-OBJ 2 .VERB-REL 1 between 0 ?) ; e.g., does anything sit between the two red blocks ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 4) (*pp-between-ulf-tree* 6 7) ?) (1 2 (3 (adv-a 4)))) (0 :ulf-recur)
  1 (.DO .NP-OBJ 2 .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., does any block support the NVidia block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 4) (*np-ulf-tree* 5 6 7) ?) (1 2 (3 4))) (0 :ulf-recur)
  1 (.DO .NP-OBJ 2 .VERB-REL .PREP 2 .NP-OBJ 3 ?) ; e.g., does any block sit on the red NVidia block ?
    2 (((lex-ulf@ v 1) (*np-ulf-tree* 2 3) (lex-ulf@ v- 4) (*pp-ulf-tree* 5 6 7 8) ?) (1 2 (3 (adv-a 4)))) (0 :ulf-recur)
  ; Modal 'do'
  1 (.DO 2 .NP-OBJ 3 .NECESSITY to .BE 1 between 0 ?) ; e.g., does the Twitter block need to be between the Texaco block and the Mercedes block ?
    2 (((*np-ulf-tree* 2 3 4) (lex-ulf@ v- 7) (*pp-between-ulf-tree* 8 9 10) ?) (((pres need.aux-v) 1 (2 3)) ?)) (0 :ulf-recur)
  1 (.DO 2 .NP-OBJ 3 .NECESSITY to .BE 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., does the Twitter block need to be (directly) on the Texaco block ?
    2 (((*np-ulf-tree* 2 3 4) (lex-ulf@ v- 7) (*pp-ulf-tree* 8 9 10 11 12) ?) (((pres need.aux-v) 1 (2 3)) ?)) (0 :ulf-recur)
  1 (.DO 2 .NP-OBJ 3 .NECESSITY to .BE .ADJ ?) ; e.g., does the Twitter block need to be clear ?
    2 (((*np-ulf-tree* 2 3 4) (lex-ulf@ v- 7) (lex-ulf@ adj 8) ?) (((pres need.aux-v) 1 (2 3)) ?)) (0 :ulf-recur)
  1 (.DO .PRON .NECESSITY to .VERB-REL 2 .NP-OBJ 3 ?) ; e.g., do I need to move the Twitter block ?
    2 (((*np-ulf-tree* 2) (lex-ulf@ v- 5) (*np-ulf-tree* 6 7 8) ?) (((pres need.aux-v) 1 (2 3)) ?)) (0 :ulf-recur)
  1 (.DO .PRON .NECESSITY to .VERB-REL .DET 2 .NOUN 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., do I need to put the Twitter block (directly) on the Target block ?
    2 (((*np-ulf-tree* 2) (lex-ulf@ v- 5) (*np-ulf-tree* 6 7 8) (*pp-ulf-tree* 9 10 11 12 13) ?) (((pres need.aux-v) 1 (2 3 4)) ?)) (0 :ulf-recur)
  1 (.DO .PRON .NECESSITY to .VERB-REL .PRON 1 .PREP 2 .NP-OBJ 3 ?) ; e.g., do I need to put it (directly) on the Target block ?
    2 (((*np-ulf-tree* 2) (lex-ulf@ v- 5) (*np-ulf-tree* 6) (*pp-ulf-tree* 7 8 9 10 11) ?) (((pres need.aux-v) 1 (2 3 4)) ?)) (0 :ulf-recur)
; Does not the Twitter block need to be on ...?
; Do you want me to ... ?
)) ; END *do-question-ulf-tree*


(READRULES '*spatial-sentence-ulf-tree*
; ```````````````````````````````````````````
; Parses declarative questions.
;
'(
  ; Historical
  1 (.NP-OBJ 3 .BE 1 between 0 .ADV-HIST-WORD 0) ; a red block was between the NVidia and Mercedes blocks previously
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-between-ulf-tree* 5 6) (*adv-ulf-tree* 7 8)) (1 (2 3 4))) (0 :ulf-recur)
  1 (.NP-OBJ 3 .BE 1 .PREP 0 .ADV-HIST-WORD 0) ; a red block was on the NVidia block before I moved it
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-ulf-tree* 5 6) (*adv-ulf-tree* 7 8)) (1 (2 3 4))) (0 :ulf-recur)
  1 (.NP-OBJ 3 .VERB-REL 1 .NP-OBJ 0 .ADV-HIST-WORD 0) ; a red block supported the NVidia block before
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 5 6) (*adv-ulf-tree* 7 8)) (1 (2 3 4))) (0 :ulf-recur)
  1 (.NP-OBJ 3 .VERB-REL 1 between 0 .ADV-HIST-WORD 0) ; a red block sat between the NVidia and Mercedes blocks initially
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-between-ulf-tree* 5 6) (*adv-ulf-tree* 7 8)) (1 (2 3 4))) (0 :ulf-recur)
  1 (.NP-OBJ 3 .VERB-REL 1 .PREP 0 .ADV-HIST-WORD 0) ; a red block sat on the NVidia block previously
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-ulf-tree* 5 6) (*adv-ulf-tree* 7 8)) (1 (2 3 4))) (0 :ulf-recur)
  ; Standard
  1 (.NP-OBJ 3 .BE 1 between 0) ; a red block is between the NVidia and Mercedes blocks
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-between-ulf-tree* 5 6)) (1 (2 3))) (0 :ulf-recur)
  1 (.NP-OBJ 3 .BE 1 .PREP 0) ; a red block is on the NVidia block
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-ulf-tree* 5 6)) (1 (2 3))) (0 :ulf-recur)
  1 (.NP-OBJ 3 .VERB-REL 1 .NP-OBJ 0) ; a red block supports the NVidia block
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*np-ulf-tree* 5 6)) (1 (2 3))) (0 :ulf-recur)
  1 (.NP-OBJ 3 .VERB-REL 1 between 0) ; a red block sits between the NVidia and Mercedes blocks
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-between-ulf-tree* 5 6)) (1 (2 3))) (0 :ulf-recur)
  1 (.NP-OBJ 3 .VERB-REL 1 .PREP 0) ; a red block sits on the NVidia block
    2 (((*np-ulf-tree* 1 2) (lex-ulf@ v 3) (*pp-ulf-tree* 5 6)) (1 (2 3))) (0 :ulf-recur)
)) ; END *spatial-sentence-ulf-tree*
; TO BE CHECKED FOR APPROPRIATENESS/ACCURACY/COMPLETENESS
(READRULES '*fallback-spatial-question-ulf-tree*
; ````````````````````````````````````````````````````
; These rules should be accessed as last resort by *spatial-question-ulf-tree*
; For the most part, these rules just allow for ignoring some words here and
; there, but there are also some reformulations (e,g., "support" relations)
; NOTE: These don't check for potential historical questions currently
;
'(
  1 (4 where 2 .DET 2 .NOUN-OBJ 2)
    2 (((*wh-question-ulf-tree* where is 4 5 6 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 where 2 .PRON 2)
    2 (((*wh-question-ulf-tree* where is 4 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 where .BE there 0)
    2 (((*fallback-spatial-question-ulf-tree* 3 4 5)) 1) (0 :ulf-recur)
  1 (4 .WH-DET 2 .NOUN .BE 2 .PREP 2 .NOUN 2 ?) ;
    2 (((*wh-question-ulf-tree* 2 3 4 5 7 8 9 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 .WH-DET 1 .COLOR .BE .DET 1 .NOUN-OBJ 2)
    2 (((*wh-question-ulf-tree* 2 4 5 6 7 8 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 .WH-DET 1 .COLOR 1 .NOUN-OBJ .BE 1 .PREP 3 .NOUN 2)
    2 (((*wh-question-ulf-tree* what color 6 is 8 9 10 11 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 .WH-PRON .BE 2 .SUP-ADJ 2 .NOUN 2)
    2 (((*wh-question-ulf-tree* 2 3 the 5 6 7 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 .WH-PRON .BE 2 most .SUP-ADJ-BASE 2 .NOUN 2)
    2 (((*wh-question-ulf-tree* 2 3 the 5 6 7 8 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 .WH-DET 2 .NOUN .BE the .SUP-ADJ 2) ; e.g., which red block is the highest up ?
    2 (((*wh-question-ulf-tree* which is the 7 3 4 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 .WH-DET 2 .NOUN .BE the most .SUP-ADJ-BASE 2) ; e.g., which red block is the highest up ?
    2 (((*wh-question-ulf-tree* which is the 7 8 3 4 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (8 .SUP-ADJ 2 .NOUN 5) ; desperation rule for a superlative
    2 (((*wh-question-ulf-tree* which is the 2 3 4 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (8 most .SUP-ADJ-BASE 2 .NOUN 5) ; desperation rule for a superlative
    2 (((*wh-question-ulf-tree* which is the 2 3 4 5 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 .WH-PRON .BE the 2 .NOUN 1 .BE 1 .PREP 3 .DET 2 .NOUN 5)
    2 (((*wh-question-ulf-tree* what is 4 5 6 that is 9 10 11 12 13 14 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 .WH-DET 2 .NOUN .BE 1 .PREP 3 .DET 2 .NOUN 5)
    2 (((*wh-question-ulf-tree* which 3 4 is 6 7 8 9 10 11 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 .WH-DET 2 .NOUN .BE supporting .DET 2 .NOUN 2) ; transform to on-relation
    2 (((*wh-question-ulf-tree* on 2 3 4 is 7 8 9 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (4 .WH-DET 2 .NOUN .BE 1 supported by .DET 2 .NOUN 2) ; transform to on-relation
    2 (((*wh-question-ulf-tree* 2 3 4 5 on 9 10 11 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (2 .BE 1 .DET 2 .NOUN 2 .PREP 3 .DET 3 .NOUN 2)
    2 (((*yn-question-ulf-tree* 2 4 5 6 8 9 10 11 12 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (2 .BE .PRON 2 .PREP 3 .DET 3 .NOUN 2)
    2 (((*yn-question-ulf-tree* 2 3 5 6 7 8 9 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (2 .BE 1 .DET 2 .NOUN 2 .PREP 3 .PRON 2)
    2 (((*yn-question-ulf-tree* 2 4 5 6 8 9 10 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (2 .BE .DET 2 .NOUN 1 .ADJ 2)
    2 (((*yn-question-ulf-tree* 2 3 4 5 7 ?)) (poss-ques 1)) (0 :ulf-recur)
  1 (0 .DET 2 .NOUN-OBJ and 2 .NOUN-OBJ 0) ; e.g., are the SRI block and NVidia block touching ?
    2 (((*yn-question-ulf-tree* 1 2 3 4 5 2 6 7 8)) (poss-ques 1)) (0 :ulf-recur)
  ; More can/should be added
  1 (0 .DET 2 .NOUN-OBJ 0)
    2 (You are asking about some 3 4 \, but I didn\'t catch what it was \.) (6 :out)
    2 (I heard you mention some 3 4 \, but didn\'t hear the rest \.) (6 :out)
    2 (I couldn\'t hear what you said apart from mentioning some 3 4 \.) (0 :out)
  1 (0 .DET .TABLE 0)
    2 (You referred to the table \, but I didn\'t catch what you said \.) (0 :out)
  1 (0 .INDEX-DET .NOUN-OBJ 0)
    2 (I\'m not sure what object you\'re referring to \.) (0 :out)
  1 (0 .PRON 0)
    2 (I\'m not sure what your question is referring to \.) (4 :out)
    2 (I didn\'t catch what you are referring to \.) (0 :out)
  1 (0 .CORP 0)
    2 (I heard you mention the 2 block \, but I didn\'t catch the rest \.) (0 :out)
; variants of begging-off responses should be added, with non-zero latency,
; so that the user will see a variety of such responses
))
;  ; borrowed stuff, for reference:
;   2 *yn-question-ulf-tree* (0 :subtree)
;  1 (modal 0)      ; e.g., "Can you see the NVidia block ?
;   2 *modal-question-ulf-tree* (0 :subtree)
;  1 (wh_ 0)
;   2 *wh-question-ulf-tree* (0 :subtree)
;  1 (prep 2 wh_ 0) ; e.g., "On top of which block is the NVidia block ?"
;   2 *ppwh-question-ulf-tree* (0 :subtree)