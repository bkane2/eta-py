;;  What is the best part of growing older? 
;;	gist: What is the best part of growing older ? 
;;	(0 best part 1 growing older 0)
;;	growing-older-best-part
;;	(2 What 2 best part 2 growing older 2)
;; MEETING WITH KIM NOTES (8/4/2017)
;; There isn't anything
;; Response: "Think about people/the most positive person you know. What would they say is the best part of growing older?"
;; Grandchildren
;; More time to do things they want to do
;; More time to travel
;; They care less about what others think / not caring what other people think / feeling more confident/stable
;; Their emotions are more stable
;; Perspective / wisdom
;; Not having to work as much
;; Feeling closer to family / more time for relationships
(MAPC 'ATTACHFEAT
'(
  (MATURE stable relationship relationships friendship friendships)
  (SENOIR discount minimum income social security medicare insurance)
  (CONFIDENT tolerate peaceful accomplishment wisdom sage experience wise)
  (EMOTION wellbeing regulation)
  (GRANDCHILDREN granddaughter grandson children CHILD DAUGHTER SON)
  (RETIRE time freetime)
))


(READRULES '*growing-older-best-part-input*
'(
  ; Questions
  1 (0 what 4 best part 0 ?)
    2 (What is the best part for growing older ?) (0 :gist)
  1 (0 .WH_ 2 best part 4 older 0 ?)
    2 (What is the best part for growing older ?) (0 :gist)
  ; Specific answers
  1 (0 .MATURE .MATURE 0)
    2 ((The best part of growing older is achieve 2 3 \.) (Growing-older-best-part)) (0 :gist)
  1 (0 senior senior 0)
    2 ((The best part of growing older is guaranteed 2 3 \.) (Growing-older-best-part)) (0 :gist)
  1 (0 .CONFIDENT 0)
    2 ((The best part of growing older is be 2 \.) (Growing-older-best-part)) (0 :gist)
  1 (0 .EMOTION .EMOTION 0)
    2 ((The best part of growing older is to obtain 2 3 \.) (Growing-older-best-part)) (0 :gist)
  1 (0 .GRANDCHILDREN 0)
    2 ((The best part of growing older is having 2 \.) (Growing-older-best-part)) (0 :gist)
  1 (0 .RETIRE 0)
    2 ((The best part of growing older is 2 \.) (Growing-older-best-part)) (0 :gist)
  1 (0 .NEG 1 think 0)
    2 ((You cannot think of a best part of growing older \.) (Growing-older-best-part)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what the best part of growing older \.) (Growing-older-best-part)) (0 :gist)
))


(READRULES '*reaction-to-growing-older-best-part-input*
'(
  1 (0 achieve .MATURE .MATURE 0)
    2 (Right \, getting older always means more 3 4 \.) (100 :out)
  1 (0 guaranteed senior senior 0)
    2 (Right \, you can obtain many benefits from society \.) (100 :out)
  1 (0 .CONFIDENT 0)
    2 (Growing older means you experienced a lot and knows a lot about life as time flies \.) (100 :out)
  1 (0 .EMOTION .EMOTION 0)
    2 (After go through lots of positive and negtive emotions \, you are good at emotion control \.) (100 :out)
  1 (0 .GRANDCHILDREN 0)
    2 (That is very sweet to enjoy the joy and happy times when sharing company with 2 \.) (100 :out)
  1 (0 .RETIRE 0)
    2 (Retiring is nice \. It gives us more time to expand our interests and achieve our dreams \.) (100 :out)
  1 (0 cannot think of 0)
    2 (I think growing older has a lot of positive aspects \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Personally \, I think the best part of becoming older is the experience that I gain \.) (100 :out)
))