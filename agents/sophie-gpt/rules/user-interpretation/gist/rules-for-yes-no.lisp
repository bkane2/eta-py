; The rules in this file contain general rules for matching yes/no answers (as well as "not sure"). Since detection
; of these types of answers will generally be the same across various contexts, it's helpful to abstract them into
; single pattern trees.
;
; The :subtree keyword can be used in pattern rules to attempt to match the entire tree to a user input. E.g.,
;
; 1 (:subtree *match-affirm*)
;   2 ((My cancer has gotten worse \.) (Cancer-worse)) (0 :gist)
; 1 (:subtree *match-unsure*)
;   2 ((You are not sure whether my cancer has gotten worse \.) (Cancer-worse)) (0 :gist)
; 1 (:subtree *match-deny*)
;   2 ((My cancer has not gotten worse \.) (Cancer-worse)) (0 :gist)
;
; In this case, the matching process will return the empty sequence if a tree returns a result (the specific result
; of the subtree is not maintained, however), and nil otherwise.
;
; The following general word features are useful here:
;  (DENY no nah nope)
;  (UNTRUTH-ADV incorrect inaccurate untrue)
;  (DENY-ADV not never hardly little barely scarcely incorrect inaccurate untrue)
;  (DISAGREE disagreed)
;  (NEG DENY DENY-ADV DISAGREE doubt)
;  (NEG-MOD really quite very exactly entirely all completely)
;  (AFFIRM yes yeah yup indeed)
;  (CERTAINTY-ADV certainly certain sure)
;  (TRUTH-ADV correct accurate true)
;  (AFFIRM-ADV certainly certain absolutely sure definitely correct accurate true)
;  (AGREE agreed)
;  (POS AFFIRM AFFIRM-ADV AGREE)
;  (AFFIRM-BELIEF know think believe feel understand understanding belief beliefs thought feeling)
;

; To handle affirmations that change meaning when prefixed with a negative
; modifier, we define a custom predicate.
(defpred !non-neg x (not (isa x 'neg)))
; We also need the following predicate to be able to exclude things like
; "I'm not really sure".
(defpred !non-neg-mod x (and (not (isa x 'neg)) (not (isa x 'neg-mod))))
; The following predicates help make things a bit more concise.
(defpred !affirm-adv x (isa x 'affirm-adv))
(defpred !modal x (isa x 'modal))


(READRULES '*match-affirm*
; Generic "yes" answers.
'(
  ; {yes, yeah, yup, indeed, certainly, certain, absolutely, sure, definitely, correct, true, agree, agreed}
  ; followed directly by the end of a clause. *non-neg and *non-neg-mod ensure that this does not occur within
  ; a negative polarity, e.g., "I'm not really sure."
  1 (*non-neg *non-neg-mod .POS .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
  ; Of course.
  1 (0 of course *non-neg .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
  ; I (certainly) agree that ...
  1 (0 I ?affirm-adv .AGREE 0)
    2 ((Yes \.)) (0 :gist)
  ; It's (certainly) {correct, accurate, true} that ...
  1 (0 .CLEFT-PRON is ?affirm-adv .TRUTH-ADV 0)
    2 ((Yes \.)) (0 :gist)
  1 (0 .CLEFT ?affirm-adv .TRUTH-ADV 0)
    2 ((Yes \.)) (0 :gist)
  ; There's a chance that ...
  1 (0 .CLEFT-PRON is ?non-neg ?non-neg .ODDS 0)
    2 ((Yes \.)) (0 :gist)
  1 (0 .CLEFT ?non-neg ?non-neg .ODDS 0)
    2 ((Yes \.)) (0 :gist)
  ; I (certainly) {think, know, believe} so.
  1 (0 I ?affirm-adv .AFFIRM-BELIEF so .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
  ; That is (certainly) my {understanding, belief}.
  1 (0 .CLEFT-PRON ?affirm-adv is ?affirm-adv my .AFFIRM-BELIEF .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
  1 (0 .CLEFT ?affirm-adv my .AFFIRM-BELIEF .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
  ; As far as {I know, I understand, I believe} (for sure).
  1 (*non-neg far as I .AFFIRM-BELIEF .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
  1 (*non-neg far as I .AFFIRM-BELIEF for .AFFIRM-ADV .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
  ; As far as I'm aware.
  1 (*non-neg far as I am aware .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
  1 (*non-neg far as I\'m aware .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
  ; I'd (certainly) recommend {it, that}.
  1 (0 I ?modal ?affirm-adv .RECOMMEND .CLEFT-PRON .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
  1 (0 I\'d ?affirm-adv .RECOMMEND .CLEFT-PRON .CLAUSE-PUNC 0)
    2 ((Yes \.)) (0 :gist)
)) ; END *match-affirm*


(READRULES '*match-unsure*
; Generic "unsure" answers.
'(
  ; {perhaps, maybe, possibly} (that ...)
  1 (0 .PERHAPS .CLAUSE-PUNC 0)
    2 ((Maybe \.)) (0 :gist)
  1 (0 .PERHAPS that 0)
    2 ((Maybe \.)) (0 :gist)
  ; {unsure, uncertain, etc.} ({that, whether, if} ...)
  1 (0 .UNCERTAINTY-ADV .CLAUSE-PUNC 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .UNCERTAINTY-ADV .INTEROG 0)
    2 ((Not sure \.)) (0 :gist)
  ; Not (quite) sure ({that, whether, if} ...)
  1 (0 .NEG ?affirm-adv .CERTAINTY-ADV .CLAUSE-PUNC 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .NEG ?affirm-adv .CERTAINTY-ADV .INTEROG 0)
    2 ((Not sure \.)) (0 :gist)
  ; Don't know ({that, whether, if} ...)
  1 (0 .NEG ?affirm-adv know .CLAUSE-PUNC 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .NEG ?affirm-adv know .INTEROG 0)
    2 ((Not sure \.)) (0 :gist)
  ; No clue ({that, whether, if} ...)
  1 (0 .NEG clue .CLAUSE-PUNC 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .NEG clue .INTEROG 0)
    2 ((Not sure \.)) (0 :gist)
  ; {couldn't, can't} (quite) {say, tell} (you) ({for sure, with (any) certainty}) ({that, whether, if} ...)
  1 (0 .CAN .NEG ?affirm-adv .COMMUNICATIVE 1 .CLAUSE-PUNC 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .CAN .NEG ?affirm-adv .COMMUNICATIVE 1 .INTEROG 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .CAN\'T ?affirm-adv .COMMUNICATIVE 1 .CLAUSE-PUNC 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .CAN\'T ?affirm-adv .COMMUNICATIVE 1 .INTEROG 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .CAN .NEG ?affirm-adv .COMMUNICATIVE 1 .GENERAL-PREP 1 .CERTAINTY-ADV .CLAUSE-PUNC 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .CAN .NEG ?affirm-adv .COMMUNICATIVE 1 .GENERAL-PREP 1 .CERTAINTY-ADV .INTEROG 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .CAN\'T ?affirm-adv .COMMUNICATIVE 1 .GENERAL-PREP 1 .CERTAINTY-ADV .CLAUSE-PUNC 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .CAN\'T ?affirm-adv .COMMUNICATIVE 1 .GENERAL-PREP 1 .CERTAINTY-ADV .INTEROG 0)
    2 ((Not sure \.)) (0 :gist)
  ; Difficult (for me) to {say, tell} (you) ({for sure, with (any) certainty}) ({that, whether, if} ...)
  1 (0 .DIFFICULT 2 to .COMMUNICATIVE 1 .CLAUSE-PUNC 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .DIFFICULT 2 to .COMMUNICATIVE 1 .INTEROG 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .DIFFICULT 2 to .COMMUNICATIVE 1 .GENERAL-PREP 1 .CERTAINTY-ADV .CLAUSE-PUNC 0)
    2 ((Not sure \.)) (0 :gist)
  1 (0 .DIFFICULT 2 to .COMMUNICATIVE 1 .GENERAL-PREP 1 .CERTAINTY-ADV .INTEROG 0)
    2 ((Not sure \.)) (0 :gist)
)) ; END *match-unsure*


(READRULES '*match-deny*
; Generic "no" answers.
'(
  ; {no, nah, hope, not, never, hardly, little, barely, scarcely, incorrect, inaccurate, untrue, disagree, disagreed, doubt}
  ; followed directly by the end of a clause. *non-neg and *non-neg-mod ensure that this does not occur within
  ; a negative polarity, e.g., "I don't doubt it."
  1 (*non-neg *non-neg-mod .NEG .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  ; Of course not
  1 (0 of course .NEG .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  ; Absolutely not
  1 (0 .AFFIRM-ADV .NEG .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  ; I (certainly) {disagree, don't agree} (that ...)
  1 (0 I ?affirm-adv .NEG .AGREE .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  1 (0 I ?affirm-adv .NEG .AGREE that 0)
    2 ((No \.)) (0 :gist)
  1 (0 I ?affirm-adv .DISAGREE that 0)
    2 ((No \.)) (0 :gist)
  ; It's (certainly) {untrue, incorrect, not (quite) true, not (quite) correct} that ...
  1 (0 .CLEFT-PRON is ?affirm-adv .NEG ?affirm-adv .TRUTH-ADV 0)
    2 ((No \.)) (0 :gist)
  1 (0 .CLEFT ?affirm-adv .NEG ?affirm-adv .TRUTH-ADV 0)
    2 ((No \.)) (0 :gist)
  1 (0 .CLEFT ?affirm-adv .UNTRUTH-ADV 0)
    2 ((No \.)) (0 :gist)
  ; There's {no chance, barely any chance} (that ...)
  1 (0 .CLEFT-PRON is .NEG 1 .ODDS 0)
    2 ((No \.)) (0 :gist)
  1 (0 .CLEFT .NEG 1 .ODDS 0)
    2 ((No \.)) (0 :gist)
  ; I (certainly) don't {think, know, believe} so.
  1 (0 I ?affirm-adv .NEG .AFFIRM-BELIEF so .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  ; I (very much) doubt {it, that ...}
  1 (0 I .NEG-MOD 1 doubt .CLEFT-PRON .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  1 (0 I .NEG-MOD 1 doubt .INTEROG 0)
    2 ((No \.)) (0 :gist)
  1 (0 I doubt .CLEFT-PRON .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  1 (0 I doubt .INTEROG 0)
    2 ((No \.)) (0 :gist)
  ; Not as far as {I know, I understand, I believe}.
  1 (.NEG 1 far as I .AFFIRM-BELIEF .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  ; Not as far as I'm aware.
  1 (.NEG 1 far as I am aware .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  1 (.NEG 1 far as I\'m aware .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  ; I (certainly) would (certainly) not recommend {it, that}.
  1 (0 I ?affirm-adv ?modal ?affirm-adv .NEG .RECOMMEND .CLEFT-PRON .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
  1 (0 I\'d ?affirm-adv .NEG .RECOMMEND .CLEFT-PRON .CLAUSE-PUNC 0)
    2 ((No \.)) (0 :gist)
)) ; END *match-deny*