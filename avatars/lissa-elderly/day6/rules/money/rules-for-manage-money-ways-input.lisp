;;  What are some ways you manage your money? For example, tell me about 
;;	some of your strategies to pay bills on time or strategies for saving money.
;;	gist: What are some ways you manage your money ?
;;	(0 way 3 manage 1 money 0)
;;	manage-money-ways
;;	(2 What 2 ways 1 manage 1 money 2)
(MAPC 'ATTACHFEAT
'(
  (BUDGET plan planning)
  (ADVISOR advisors consultant consultants)
  (CREDIT card report)
  (SOFTWARE app apps)
  (FAMILY GRANDCHILDREN grandchild children CHILD DAUGHTER daughters SON sons SPOUSE wife husband siblings brother brothers sister sisters parents MOTHER FATHER grandparents GRANDMOTHER GRANDFATHER cousin cousins uncle aunt)
))


(READRULES '*manage-money-ways-input*
'(
  ; Questions
  1 (0 how 1 you 1 make .MONEY ?)
    2 (How can I make money ?) (0 :gist)
  1 (0 how 2 you 1 manage 1 .MONEY 0 ?)
    2 (What are some ways I manage my money ?) (0 :gist)
  1 (0 what 2 you 1 manage 1 .MONEY 0 ?)
    2 (What are some ways I manage my money ?) (0 :gist)
  1 (0 .WH_ 2 you 1 manage 1 .MONEY 0 ?)
    2 (What are some ways I manage my money ?) (0 :gist)
  ; Specific answers
  1 (0 .BUDGET 0)
    2 ((The way you manage your money is having plan \.) (Manage-money-ways)) (0 :gist)
  1 (0 .ADVISOR 0)
    2 ((The way you manage your money is getting help from 2 \.) (Manage-money-ways)) (0 :gist)
  1 (0 .CREDIT .CREDIT 0)
    2 ((The way you manage your money is checking 2 3 on time \.) (Manage-money-ways)) (0 :gist)
  1 (0 .SOFTWARE 0)
    2 ((The way you manage your money is getting help from 2 \.) (Manage-money-ways)) (0 :gist)
  1 (0 .FAMILY 0)
    2 ((The way you manage your money is getting help from 2 \.) (Manage-money-ways)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for a way to manage your money \.) (Manage-money-ways)) (0 :gist)
))


(READRULES '*reaction-to-manage-money-ways-input*
'(
  1 (0 .BUDGET 0)
    2 (It is brilliant to have a plan to manage your money \. It can help you to save money \.) (100 :out)
  1 (0 .ADVISOR 0)
    2 (You can get many professional suggestion from 2 \.) (100 :out)
  1 (0 .CREDIT .CREDIT 0)
    2 (Check 2 3 is a good habbit to manage your money \.) (100 :out)
  1 (0 .SOFTWARE 0)
    2 (Sounds cool that you can use modern technology to manage your money \.) (100 :out)
  1 (0 .FAMILY 0)
    2 (You manage your money with the help with 2 \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (That is a good way to manage your money \.) (100 :out)
))