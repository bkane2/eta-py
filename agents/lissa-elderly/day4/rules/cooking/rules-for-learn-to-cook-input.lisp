;;	How did you learn to cook?
;;	(0 I learned cooking 0)  (0 I do not know 2 cook 0) 
;;	learn-to-cook
;;		gist-question:(1 how 2 learn to cook 4) 
(MAPC 'ATTACHFEAT
'(
  (SCHOOL university college course courses class classes)
  (PARENTS FATHER MOTHER)
  (FAMILY-MEMBER grandparents GRANDMOTHER GRANDFATHER PARENTS FATHER MOTHER uncle aunt siblings brother brothers sister sisters)
  (BOOK books recipes recipe)
  (MYSELF internet)
  (LEARN-TO-COOK-TWO LEARN-TO-COOK-TWO-SCHOOL LEARN-TO-COOK-TWO-BOOK)
  (LEARN-TO-COOK-TWO-SCHOOL middle high SCHOOL cooking class classes course courses college university dorm)
  (LEARN-TO-COOK-TWO-BOOK cooking BOOK books)
  ;(learn-to-cook-two-self self learning)
))


(READRULES '*learn-to-cook-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (How do I learn to cook ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (How do I learn to cook ?) (0 :gist)
  ; Specific answers
  1 (1 .NEG 2 know 2 .COOK 0)
    2 ((You do not know how to cook \.) (Learn-to-cook)) (0 :gist)
  1 (0 .LEARN-TO-COOK-TWO .LEARN-TO-COOK-TWO 0)
    2 ((You learned cooking from your 2 3 \.) (Learn-to-cook)) (0 :gist)
  1 (0 .SCHOOL 0)
    2 ((You learned cooking from your 2 \.) (Learn-to-cook)) (0 :gist)
  1 (0 .FAMILY-MEMBER 0)
    2 ((You learned cooking from your 2 \.) (Learn-to-cook)) (0 :gist)
  1 (0 .BOOK 0)
    2 ((You learned cooking from your 2 \.) (Learn-to-cook)) (0 :gist)
  1 (0 .MYSELF 0)
    2 ((You learned cooking by 2 \.) (Learn-to-cook)) (0 :gist)
  1 (0 roommate 0)
    2 ((You learned cooking from your roommate \.) (Learn-to-cook)) (0 :gist)
  1 (0 .FRIEND 0)
    2 ((You learned cooking from your friend \.) (Learn-to-cook)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for whom you learned cooking \.) (Learn-to-cook)) (0 :gist)
))


(READRULES '*reaction-to-learn-to-cook-input*
'(
  1 (1 .NEG 0)
    2 (Okay \. I don\'t know cooking either \.) (100 :out)
  1 (0 .LEARN-TO-COOK-TWO .LEARN-TO-COOK-TWO 0)
    2 (0 .LEARN-TO-COOK-TWO-SCHOOL .LEARN-TO-COOK-TWO-SCHOOL 0)
      3 (I learned making some mexican food from my roommate while in college \. It was so much fun \.) (100 :out)
    2 (0 .LEARN-TO-COOK-TWO-BOOK .LEARN-TO-COOK-TWO-BOOK 0)
      3 (I like cooking based on recipes from books because they are easy to follow \.) (100 :out)
  1 (0 .SCHOOL 0)
    2 (I learned making some mexican food from my roommate while in college \. It was so much fun \.) (100 :out)
  1 (0 .FAMILY-MEMBER 0)
    2 (Many people that I know learned cooking from their 2 \.) (100 :out)
  1 (0 .BOOK 0)
    2 (I like cooking based on recipes from books because they are easy to follow \.) (100 :out)
  1 (0 yourself 0)
    2 (You seem like a very independent person \.) (100 :out)
  1 (0 roommate 0)
    2 (I learned making some mexican food from my roommate while in college \. It was so much fun \.) (100 :out)
  1 (0 .FRIEND 0)
    2 (I learned making some mexican food from a mexican neighbor who used to live in neighborhood when I was young \. It was so much fun \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I think the internet is very helpful for finding good recipes \.) (100 :out)
))