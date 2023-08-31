; List of factors and example ULFs:
; ```````````````````````````````````
; frame size (the size of the salient part of the scene)
;     (setq *input* '(((that ((the.d (frame.n size.n)) ((pres be.v) (= 1.5)))) certain-to-degree 1.0)))
; raw distance (distance between objects)
;     (setq *input* '(((that ((the.d (n+preds (raw.n distance.n) (of.p (set-of (the.d (|Twitter| block.n)) (the.d (|Texaco| block.n)))))) ((pres be.v) (= 1.5)))) certain-to-degree 1.0)))
; scaled raw distance (distance divided by the size of the objects)
;     (setq *input* '(((that ((the.d (n+preds (scaled.n raw.n distance.n) (of.p (set-of (the.d (|Twitter| block.n)) (the.d (|Texaco| block.n)))))) ((pres be.v) (= 1.5)))) certain-to-degree 1.0)))
; larger than
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) larger_than.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; taller than
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) taller_than.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; centroidwise higher than (relative elevation based on the centers' locations)
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) centroidwise_higher_than.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; basewise higher than (relative elevation based on the bottoms' locations)
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) basewise_higher_than.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; higher than
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) higher_than.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; at the same height
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) at_the_same_height.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; supported by
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) supported_by.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; indirectly supported by
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) indirectly_supported_by.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; horizontal deictic component (horizontal offset of two objects as it appears to the viewer)
;     (setq *input* '(((that ((the.d (n+pred (horizontal.a (deictic.a component.n)) (of.p (set-of ((the.d (|Twitter| block.n)) (the.d (|Texaco| block.n))))))) ((pres be.v) (= 1.5)))) certain-to-degree 1.0)))
; vertical deictic component (vertical offset of two objects as it appears to the viewer)
;     (setq *input* '(((that ((the.d (n+pred (vertical.a (deictic.a component.n)) (of.p (set-of ((the.d (|Twitter| block.n)) (the.d (|Texaco| block.n))))))) ((pres be.v) (= 1.5)))) certain-to-degree 1.0)))
; direction (checks whther an object is in a particular direction from a point)
;     TODO
; distance decay (1 if the objects coincide, then approaches 0 as objects are mved farther apart)
;     (setq *input* '(((that ((the.d (n+pred (distance.n decay.n) (of.p (set-of ((the.d (|Twitter| block.n)) (the.d (|Texaco| block.n))))))) ((pres be.v) (= 1.5)))) certain-to-degree 1.0)))
; argument size rescale (rescales the score for a relation based on the relative sizes of arguments)
;     (setq *input* '(((that ((the.d (n+preds ((argument.n size.n) rescale.n) (of.p (the.d (|Texaco| block.n)))) ((pres be.v) (= 1.5)))) certain-to-degree 1.0)))
; argument rank rescale (rescales the score for a relation based on the rank of the current argument object; lower the rank, lower the rescaled value)
;     (setq *input* '(((that ((the.d (n+preds ((argument.n rank.n) rescale.n) (of.p (the.d (|Texaco| block.n)))) ((pres be.v) (= 1.5)))) certain-to-degree 1.0)))
; deictic raw (right of deictic score before applying the argument rank rescale)
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) to_the_right_of_deictic_raw.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; deictic
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) to_the_right_of_deictic.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; extrinsic raw (same as with deictic)
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) to_the_right_of_extrinsic_raw.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; extrinsic
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) to_the_right_of_extrinsic.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; intrinsic raw (same as with deictic)
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) to_the_right_of_intrinsic_raw.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; intrinsic
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) to_the_right_of_intrinsic.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; near raw (nearness score before applying thte argument rank rescale and argument size rescale)
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) near_raw.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; near
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) near.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
; touching
;     (setq *input* '(((that ((the.d (|Twitter| block.n)) touching.p (the.d (|Texaco| block.n)))) certain-to-degree 1.0)))
(READRULES '*gist-clause-trees-for-response*
'(
  1 (0 \, because 0 \.)
    2 (*rephrase-conjunct-tree* (1 because 4 \.)) (0 :subtree+clause)
  ; By default, simply output the gist-clause
  1 (0)
    2 (1) (0 :out)
))


(READRULES '*rephrase-conjunct-tree*
; TODO: the approach I'm using here is not ideal (it requires the same patterns to be duplicated across two different
; trees; one for splitting off each '... also ...' conjunct, and one for finishing by splitting off the final clause).
; However, it's currently necessary as there's no recursive method for gist-clauses/text. This may be changed in the future.
'(
  1 (0 also 0)
    ; frame size (the size of the salient part of the scene)
    2 (todo)
      3 (*rephrase-conjunct-tree* (todo)) (0 :subtree+clause)
    ; raw distance
    2 (0 the raw distance of 4 and 4 is 2 also 0)
      3 (*rephrase-conjunct-tree* (1 the distance between 6 and 8 is 10 \, and 12)) (0 :subtree+clause)
    ; scaled raw distance
    2 (0 the scaled raw distance of 4 and 4 is 2 also 0)
      3 (*rephrase-conjunct-tree* (1 the distance between 7 and 9 divided by the size of the objects is 11 \, and 13)) (0 :subtree+clause)
    ;; ; larger/taller/higher than
    ;; 2 (0 noun-bw be compare-adj than 4 also 0)
    ;;   3 (*rephrase-conjunct-tree* (1 2 is 4 5 6 \, and 8)) (0 :subtree+clause)
    ; centroidwise higher than (relative elevation based on the centers' locations)
    2 (0 .NOUN-BW .BE centroidwise higher than 4 also 0)
      3 (*rephrase-conjunct-tree* (1 2 is 5 6 7 based on the height of their centers \, and 9)) (0 :subtree+clause)
    ; basewise higher than (relative elevation based on the centers' locations)
    2 (0 .NOUN-BW .BE basewise higher than 4 also 0)
      3 (*rephrase-conjunct-tree* (1 2 is 5 6 7 based on the height of their bottoms \, and 9)) (0 :subtree+clause)
    ; at the same height
    2 (0 .NOUN-BW .BE at the same height 4 also 0)
      3 (*rephrase-conjunct-tree* (1 2 is 4 5 6 7 as 8 \, and 10)) (0 :subtree+clause)
    ;; ; supported by
    ;; 2 (0 noun-bw be supported by 4 also 0)
    ;;   3 (*rephrase-conjunct-tree* (1 2 is 4 5 6 \, and 8)) (0 :subtree+clause)
    ;; ; indirectly supported by
    ;; 2 (0 noun-bw be indirectly supported by 4 also 0)
    ;;   3 (*rephrase-conjunct-tree* (1 2 is 4 5 6 7 \, and 9)) (0 :subtree+clause)
    ; horizontal deictic component (horizontal offset of two objects as it appears to the viewer)
    2 (todo)
      3 (*rephrase-conjunct-tree* (todo)) (0 :subtree+clause)
    ; vertical deictic component (vertical offset of two objects as it appears to the viewer)
    2 (todo)
      3 (*rephrase-conjunct-tree* (todo)) (0 :subtree+clause)
    ; direction (checks whether an object is in a particular direction from a point)
    2 (todo)
      3 (*rephrase-conjunct-tree* (todo)) (0 :subtree+clause)
    ; distance decay (1 if the objects coincide, then approaches 0 as objects are moved farther apart)
    2 (todo)
      3 (*rephrase-conjunct-tree* (todo)) (0 :subtree+clause)
    ; argument size rescale (rescales the score for a relation based on the relative sizes of arguments)
    2 (todo)
      3 (*rephrase-conjunct-tree* (todo)) (0 :subtree+clause)
    ; argument rank rescale (rescales the score for a relation based on the rank of the current argument object;  lower the rank, lower the rescaled value)
    2 (todo)
      3 (*rephrase-conjunct-tree* (todo)) (0 :subtree+clause)
    ; deictic raw
    2 (0 .NOUN-BW .BE 5 deictic raw 4 also 0)
      3 (*rephrase-conjunct-tree* (1 2 is 4 7 from the perspective of the viewer before scaling by object size \, and 9)) (0 :subtree+clause)
    ; deictic
    2 (0 .NOUN-BW .BE 5 deictic 4 also 0)
      3 (*rephrase-conjunct-tree* (1 2 is 4 6 from the perspective of the viewer \, and 8)) (0 :subtree+clause)
    ; extrinsic raw
    2 (0 .NOUN-BW .BE 5 extrinsic raw 4 also 0)
      3 (*rephrase-conjunct-tree* (1 2 is 4 7 based on its position on the table before scaling by object size \, and 9)) (0 :subtree+clause)
    ; extrinsic
    2 (0 .NOUN-BW .BE 5 extrinsic 4 also 0)
      3 (*rephrase-conjunct-tree* (1 2 is 4 6 based on its position on the table \, and 8)) (0 :subtree+clause)
    ; intrinsic raw
    2 (0 .NOUN-BW .BE 5 intrinsic raw 4 also 0)
      3 (*rephrase-conjunct-tree* (1 2 is 4 7 based on its orientation to 7 \, and 9)) (0 :subtree+clause)
    ; intrinsic
    2 (0 .NOUN-BW .BE 5 intrinsic 4 also 0)
      3 (*rephrase-conjunct-tree* (1 2 is 4 6 based on its orientation to 6 \, and 8)) (0 :subtree+clause)
    ; near raw (nearness score before applying thte argument rank rescale and argument size rescale)
    2 (0 .NOUN-BW .BE near raw 4 also 0)
      3 (*rephrase-conjunct-tree* (1 2 is 4 6 before scaling by object size \, and 8)) (0 :subtree+clause)
    ; other
    2 (*rephrase-conjunct-tree* (1 \, and 3)) (0 :subtree+clause)
  1 (0)
    2 *rephrase-final-tree* (0 :subtree)
))


(READRULES '*rephrase-final-tree*
'(
  1 (0 \.)
    ; frame size (the size of the salient part of the scene)
    2 (todo)
      3 (*fix-double-commas* (todo)) (0 :subtree+clause)
    ; raw distance
    2 (0 the raw distance of 4 and 4 is 2 \.)
      3 (*fix-double-commas* (1 the distance between 6 and 8 is 10 \.)) (0 :subtree+clause)
    ; scaled raw distance
    2 (0 the scaled raw distance of 4 and 4 is 2 \.)
      3 (*fix-double-commas* (1 the distance between 7 and 9 divided by the size of the objects is 11 \.)) (0 :subtree+clause)
    ;; ; larger/taller/higher than
    ;; 2 (0 noun-bw be compare-adj than 4 \.)
    ;;   3 (*fix-double-commas* (1 2 is 4 5 6 \.)) (0 :subtree+clause)
    ; centroidwise higher than (relative elevation based on the centers' locations)
    2 (0 .NOUN-BW .BE centroidwise higher than 4 \.)
      3 (*fix-double-commas* (1 2 is 5 6 7 based on the height of their centers \.)) (0 :subtree+clause)
    ; basewise higher than (relative elevation based on the centers' locations)
    2 (0 .NOUN-BW .BE basewise higher than 4 \.)
      3 (*fix-double-commas* (1 2 is 5 6 7 based on the height of their bottoms \.)) (0 :subtree+clause)
    ; at the same height
    2 (0 .NOUN-BW .BE at the same height 4 \.)
      3 (*fix-double-commas* (1 2 is 4 5 6 7 as 8 \.)) (0 :subtree+clause)
    ;; ; supported by
    ;; 2 (0 noun-bw be supported by 4 \.)
    ;;   3 (*fix-double-commas* (1 2 is 4 5 6 \.)) (0 :subtree+clause)
    ;; ; indirectly supported by
    ;; 2 (0 noun-bw be indirectly supported by 4 \.)
    ;;   3 (*fix-double-commas* (1 2 is 4 5 6 7 \.)) (0 :subtree+clause)
    ; horizontal deictic component (horizontal offset of two objects as it appears to the viewer)
    2 (todo)
      3 (*fix-double-commas* (todo)) (0 :subtree+clause)
    ; vertical deictic component (vertical offset of two objects as it appears to the viewer)
    2 (todo)
      3 (*fix-double-commas* (todo)) (0 :subtree+clause)
    ; direction (checks whether an object is in a particular direction from a point)
    2 (todo)
      3 (*fix-double-commas* (todo)) (0 :subtree+clause)
    ; distance decay (1 if the objects coincide, then approaches 0 as objects are moved farther apart)
    2 (todo)
      3 (*fix-double-commas* (todo)) (0 :subtree+clause)
    ; argument size rescale (rescales the score for a relation based on the relative sizes of arguments)
    2 (todo)
      3 (*fix-double-commas* (todo)) (0 :subtree+clause)
    ; argument rank rescale (rescales the score for a relation based on the rank of the current argument object;  lower the rank, lower the rescaled value)
    2 (todo)
      3 (*fix-double-commas* (todo)) (0 :subtree+clause)
    ; deictic raw
    2 (0 .NOUN-BW .BE 5 deictic raw 4 \.)
      3 (*fix-double-commas* (1 2 is 4 7 from the perspective of the viewer before scaling by object size \.)) (0 :subtree+clause)
    ; deictic
    2 (0 .NOUN-BW .BE 5 deictic 4 \.)
      3 (*fix-double-commas* (1 2 is 4 6 from the perspective of the viewer \.)) (0 :subtree+clause)
    ; extrinsic raw
    2 (0 .NOUN-BW .BE 5 extrinsic raw 4 \.)
      3 (*fix-double-commas* (1 2 is 4 7 based on its position on the table before scaling by object size \.)) (0 :subtree+clause)
    ; extrinsic
    2 (0 .NOUN-BW .BE 5 extrinsic 4 \.)
      3 (*fix-double-commas* (1 2 is 4 6 based on its position on the table \.)) (0 :subtree+clause)
    ; intrinsic raw
    2 (0 .NOUN-BW .BE 5 intrinsic raw 4 \.)
      3 (*fix-double-commas* (1 2 is 4 7 based on its orientation to 7 \.)) (0 :subtree+clause)
    ; intrinsic
    2 (0 .NOUN-BW .BE 5 intrinsic 4 \.)
      3 (*fix-double-commas* (1 2 is 4 6 based on its orientation to 6 \.)) (0 :subtree+clause)
    ; near raw (nearness score before applying thte argument rank rescale and argument size rescale)
    2 (0 .NOUN-BW .BE near raw 4 \.)
      3 (*fix-double-commas* (1 2 is 4 6 before scaling by object size \.)) (0 :subtree+clause)
    ;; ; raw distance
    ;; 2 (0 the raw distance of 4 and 4 is 2 \.)
    ;;   3 (*fix-double-commas* (1 the distance between 6 and 8 is 10 \.)) (0 :subtree+clause)
    ;; ; scaled raw distance
    ;; 2 (0 the scaled raw distance of 4 and 4 is 2 \.)
    ;;   3 (*fix-double-commas* (1 the distance between 7 and 9 divided by the size of the objects is 11 \.)) (0 :subtree+clause)
    ;; ; deictic raw
    ;; 2 (0 noun-bw 5 deictic raw 4 \.)
    ;;   3 (*fix-double-commas* (1 2 is 3 6 from the perspective of the viewer before scaling by object size \.)) (0 :subtree+clause)
    ; other
    2 *fix-double-commas* (0 :subtree)
))


(READRULES '*fix-double-commas*
'(
  1 (0 \, \, 0)
    2 (*fix-double-commas* (1 \, 4)) (0 :subtree+clause)
  1 (0)
    2 (1) (0 :out)
))