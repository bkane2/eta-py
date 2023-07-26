;;	How did you learn about managing money?
;;	gist: How did you learn about managing money ?
;;	(0 learned 2 managing money 0)
;;	manage-money-learn
;;	(2 How 2 learn 2 managing 2 money 2) (2 how 2 you make money 2)
(MAPC 'ATTACHFEAT
'(
  (FAMILY GRANDCHILDREN grandchild children CHILD DAUGHTER daughters SON sons SPOUSE wife husband siblings brother brothers sister sisters parents MOTHER FATHER grandparents GRANDMOTHER GRANDFATHER cousin cousins uncle aunt)
  (FRIEND friends)
  (UNIVERSITY course courses school ADVISOR advisors consultant consultants accountant)
  (VIDEO tv shows show radio web online)
  (LIFE experience)
  (READ reading book books magazine article articles paper newspapers)
))


(READRULES '*manage-money-learn-input*
'(
  ; Questions
  1 (0 how 1 you 1 make .MONEY ?)
    2 (How can I make money ?) (0 :gist)
  1 (0 how 2 you 1 managing .MONEY ?)
    2 (How did I learn about making money ?) (0 :gist)
  1 (0 what 2 travel 2 you 1 .ENJOY 0 ?)
    2 (How did I learn about making money ?) (0 :gist)
  1 (0 .WH_ 2 travel 2 you 1 .ENJOY 0 ?)
    2 (How did I learn about making money ?) (0 :gist)
  ; Specific answers
  1 (0 .FAMILY 0)
    2 ((You learned managing money from 2 \.) (Manage-money-learn)) (0 :gist)
  1 (0 .FRIEND 0)
    2 ((You learned managing money from 2 \.) (Manage-money-learn)) (0 :gist)
  1 (0 .UNIVERSITY 0)
    2 ((You learned managing money from 2 \.) (Manage-money-learn)) (0 :gist)
  1 (0 .READ 0)
    2 ((You learned managing money from 2 \.) (Manage-money-learn)) (0 :gist)
  1 (0 .VIDEO 0)
    2 ((You learned managing money from 2 \.) (Manage-money-learn)) (0 :gist)
  1 (0 .LIFE 0)
    2 ((You learned managing money from experience \.) (Manage-money-learn)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how you learned about managing money \.) (Manage-money-learn)) (0 :gist)
))


(READRULES '*reaction-to-manage-money-learn-input*
'(
  1 (0 .FAMILY 0)
    2 (Right \, most people learned how to manage their money from family \. It is reasonable that you learned it from 2 \.) (100 :out)
  1 (0 .FRIEND 0)
    2 (Right \, friends affect us in many ways \. When my friend told me the way he deals with his money \, I decided to try it too \.) (100 :out)
  1 (0 .UNIVERSITY 0)
    2 (Learning from 2 is convincing \. I think it is a credible way to get information \.) (100 :out)
  1 (0 .VIDEO 0)
    2 (Learning from 2 is convenient \. But you should distinguish whether it is credible \.) (100 :out)
  1 (0 .READ 0)
    2 (Learning from 2 is convenient \. But you should distinguish whether it is credible \.) (100 :out)
  1 (0 .LIFE 0)
    2 (Right \, actually \, most people learn to manage their money from their daily life \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Okay \. Sounds like a good way to learn managing money \.) (100 :out)
))