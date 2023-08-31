(MAPC 'ATTACHFEAT
'(
))


(READRULES '*reaction-to-input*
; Currently we only branch to a question in the case
; of a question related to the getting-to-know you
; question(s). We want to be very cautious here since
; queries can take the form of questions. We do, however,
; need to expand this with various possible non-query
; questions, such as "can you answer wh-questions?".
'(
  1 (0 .WH_ 1 .SELF name 0)
    2 *reaction-to-question* (0 :subtree)
  1 (0 .AUX .SELF 1 .ANSWER 1 .QUESTION 0)
    2 *reaction-to-question* (0 :subtree)
  1 (0 .WH_ 1 questions 1 .AUX .SELF 1 .ANSWER 0)
    2 *reaction-to-question* (0 :subtree)
  1 (0 .AUX .SELF 0)
    2 *reaction-to-question* (0 :subtree)
  1 (0) ; by default, it's an assertion
    2 *reaction-to-assertion* (0 :subtree)
))


(READRULES '*reaction-to-assertion*
'(
  1 (your name is 0)
    2 *reaction-to-name-input* (0 :subtree)
  1 (Eta 2 not .UNDERSTAND 2 your name 0)
    2 *reaction-to-name-input* (0 :subtree)
  1 (spatial-question 0)
    2 *reaction-to-spatial-question-input* (0 :subtree)
  1 (goodbye 0)
    2 exchange-goodbyes.v (0 :schema)
  1 (pause 0)
    2 pause-conversation.v (0 :schema)
))


(READRULES '*reaction-to-unexpected*
'(
))