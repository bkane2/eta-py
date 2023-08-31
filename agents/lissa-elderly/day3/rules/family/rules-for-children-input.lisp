;; (Do you have children or grandchildren ?)
;;	(children)
;;		from-children-input
;;			(0 I have 2 child 0) (I have 2 grandchild  0)
;;			gist-question:(3 do you have children 0)
(MAPC 'ATTACHFEAT
'(
  (FIRST-PER-PRON I we)
  (CHILD children SON DAUGHTER sons daughters)
  (GRANDCHILD grandchildren grandkid grandkids grandson granddaughter grandsons granddaughters)
  (FEW a ONE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN ELEVEN)
  (BOY boys)
  (GIRL girls)
))


(READRULES '*children-input*
'(
  ; Reciprocal questions
  1 (0 what 2 you 0 ?)
    2 (Do I have any children or grandchildren ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (Do I have any children or grandchildren ?) (0 :gist)
  1 (0 .DO you 4 children 0 ?)
    2 (Do I have any children or grandchildren ?) (0 :gist)
  ; Specific answers
  1 (no .FIRST-PER-PRON 2 .NEG 0)
    2 ((You have no children \.) (Children)) (0 :gist)
  1 (0 no .CHILD 0)
    2 ((You have no 3 \.) (Children)) (0 :gist)
  1 (0 no .GRANDCHILD 0)
    2 ((You have no 3 \.) (Children)) (0 :gist)
  1 (0 .NEG 1 any .CHILD 0)
    2 ((You have no 5 \.) (Children)) (0 :gist)
  1 (0 .NEG 1 any 3 .GRANDCHILD 0)
    2 ((You have no 6 \.) (Children)) (0 :gist)
  ;; this one makes "i have a son". from where? I dont know?
  1 (0 .FIRST-PER-PRON .HAVE 1 .FEW 3 .CHILD 0)
    2 ((You have 5 7 \.) (Children)) (0 :gist)
  1 (0 .FIRST-PER-PRON .HAVE 1 .FEW 3 .GRANDCHILD 0)
    2 ((You have 5 7 \.) (Children)) (0 :gist)
  1 (0 .FIRST-PER-PRON .HAVE no .CHILD 0)
    2 ((You have no 5 \.) (Children)) (0 :gist)
  1 (0 .FIRST-PER-PRON .DO not .HAVE 1 .CHILD 0)
    2 ((You have no 7 \.) (Children)) (0 :gist)
  1 (0 .FIRST-PER-PRON .HAVE no .GRANDCHILD 0)
    2 ((You have no 5 \.) (Children)) (0 :gist)
  1 (0 .FIRST-PER-PRON .DO not .HAVE 1 .GRANDCHILD 0)
    2 ((You have no 7 \.) (Children)) (0 :gist)
  1 (1 .YES 0)
    2 ((You have children \.) (Children)) (0 :gist)
  1 (1 .FIRST-PER-PRON .DO 0)
    2 ((You have children \.) (Children)) (0 :gist)
  1 (0 my 1 .CHILD 0)
    2 ((You have at least a 4 \.) (Children)) (0 :gist)
  1 (0 my 1 .GRANDCHILD 0)
    2 ((You have at least a 4 \.) (Children)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for if you have any children or grandchildren \.) (Children)) (0 :gist)
))


(READRULES '*thematic-children-input*
'(
  1 (0 .FIRST-PER-PRON .HAVE 2 children 4 .FEW .BOY 0)
    2 ((You have 7 sons \.) (Children)) (0 :gist)
  1 (0 .FIRST-PER-PRON .HAVE 2 children 4 .FEW .GIRL 0)
    2 ((You have 7 daughters \.) (Children)) (0 :gist)
  1 (0 .FIRST-PER-PRON .HAVE 2 grandchildren 4 .FEW boys 0)
    2 ((You have 7 grandsons \.) (Children)) (0 :gist)
  1 (0 .FIRST-PER-PRON .HAVE 2 grandchildren 4 .FEW .GIRL 0)
    2 ((You have 7 granddaughters \.) (Children)) (0 :gist)
))


(READRULES '*reaction-to-children-input*
'(
  1 (0 no 0)
    2 (Oh \, okay \! I do have two girls but no grandchildren \.) (100 :out)
  1 (0 .CHILD 0)
    2 (It must\'ve been nice raising children \.) (100 :out)
  1 (0 .GRANDCHILD 0)
    2 (It must be wonderful having grandchildren \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Oh \, okay \! I do have two girls but no grandchildren \.) (100 :out)
))