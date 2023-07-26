; This is the top-level gist-clause interpretation rule tree, used to select an appropriate choice packet using
; the context of LISSA's previous question or statement. If a match fails here, the system falls back to a
; general subtree intended to match generic questions from the user.
;
(READRULES '*gist-clause-trees-for-input*
'(
  ;; 1 (:or
  ;;   (.BE 1 .REASON 3 .PAIN 3 .MAKE-WORSE 1 ?)
  ;;   (why 3 .PAIN 2 .MAKE-WORSE 1 ?)
  ;;   (what 2 .CAUSE 2 .PAIN 2 .MAKE-WORSE 1 ?)
  ;;   (why has my .PAIN been getting worse .RECENTLY ?)
  ;;   (my .PAIN has .RECENTLY been getting worse \.)
  ;;   (I .BELIEVE my cancer has gotten worse .BECAUSE my .PAIN has also gotten worse \.))
  ;;   2 (*pain-input*
  ;;      *general-input*) (0 :subtrees)

  1 (:or
    (Goodbye \.))
    2 (*say-bye-input*
       *general-input*) (0 :subtrees)

  1 (0)
    2 (*general-input*) (0 :subtrees)
))