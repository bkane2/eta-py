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
  1 (0 ?) ; anything ending with ?
    2 *reaction-to-question* (0 :subtree)
  1 (.WH_ 0) ; wh or how question
    2 *reaction-to-question* (0 :subtree)
  1 (.AUX .NP_ 0) ; modal question
    2 *reaction-to-question* (0 :subtree)
  1 (0 .AUX .NP_ 1) ; tag question
    2 *reaction-to-question* (0 :subtree)
  1 (0) ; by default, it's a statement
    2 *reaction-to-statement* (0 :subtree)
))