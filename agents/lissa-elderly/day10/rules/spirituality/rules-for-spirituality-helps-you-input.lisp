;;	How does spirituality help you when life gets hard? 
;;	(0 spirituality helps me 0)
;;	spirituality-helps-you
;;	(How does spirituality help you ?)
;;	(3 How does spirituality help you 3 )
;; MEETING WITH KIM NOTES (8/8/2017)
;; Own death
;; Someone’s loss
;; Grief
;; Comfort
;; Other people’s support
;; Things happen for reason
;; Not alone
;; Feeling connected with nature
(MAPC 'ATTACHFEAT
'(
  (ALT-COPE cope coping deal dealing accept accepting)
  (ALT-PEOPLE people people\'s person FRIEND friends someone ALT-FAMILY)
  (ALT-FAMILY FAMILY children grandchildren CHILD grandchild SON DAUGHTER grandson granddaughter niece nephew)
  (ALT-COMFORT comfort comfortable consolation solace happy happiness happier joy content contentment contented)
))


(READRULES '*spirituality-helps-you-input*
'(
  ; Questions
  1 (0 what religion 2 you 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 are 2 you 2 religious 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 .DO 2 you 2 follow 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 are 2 you 2 spiritual 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 what 2 you 0 ?)
    2 (How does spirituality help me ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (How does spirituality help me ?) (0 :gist)
  ; Specific answers
  1 (0 .ALT-COPE 3 own death 0)
    2 ((Spirituality helps you cope with your own death \.) (Spirituality-helps-you)) (0 :gist)
  1 (0 come 1 terms 3 own death 0)
    2 ((Spirituality helps you cope with your own death \.) (Spirituality-helps-you)) (0 :gist)
  1 (0 loss of 2 .ALT-PEOPLE 0)
    2 ((Spirituality helps you cope with the loss of someone \.) (Spirituality-helps-you)) (0 :gist)
  1 (0 death of 2 .ALT-PEOPLE 0)
    2 ((Spirituality helps you cope with the loss of someone \.) (Spirituality-helps-you)) (0 :gist)
  1 (0 grief 0)
    2 ((Spirituality helps you deal with grief \.) (Spirituality-helps-you)) (0 :gist)
  1 (0 .ALT-COMFORT 0)
    2 ((Spirituality helps you feel more comfortable \.) (Spirituality-helps-you)) (0 :gist)
  1 (0 other 1 .ALT-PEOPLE 1 .SUPPORT 0)
    2 ((Spirituality helps you through the support of other people \.) (Spirituality-helps-you)) (0 :gist)
  1 (0 things happen 3 reason 0)
    2 ((Spirituality helps you realize things happen for a reason \.) (Spirituality-helps-you)) (0 :gist)
  1 (0 .NEG 1 alone 0)
    2 ((Spirituality helps you realize you are not alone \.) (Spirituality-helps-you)) (0 :gist)
  1 (0 connected 2 nature 0)
    2 ((Spirituality helps you be connected with nature \.) (Spirituality-helps-you)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how spirituality helps you \.) (Spirituality-helps-you)) (0 :gist)
))


(READRULES '*reaction-to-spirituality-helps-you-input*
'(
  1 (0 spirituality helps you cope with your own death 0)
    2 (I can see how spirituality would help you cope with death \. For example \, knowing that even though your body may die \, your essence lives on \.) (100 :out)
  1 (0 spirituality helps you cope with the loss of someone 0)
    2 (It makes sense that spirituality would help you cope with the loss of someone close \. It helps you know they\'re in a better place \.) (100 :out)
  1 (0 spirituality helps you deal with grief 0)
    2 (Sometimes when you are grieving \, spirituality is one place you can turn to in order to feel better \.) (100 :out)
  1 (0 spirituality helps you feel more comfortable 0)
    2 (Spirituality can definitely help you feel more comfortable with your purpose in life \.) (100 :out)
  1 (0 spirituality helps you through the .SUPPORT of other people 0)
    2 (It\'s very nice how religion or spirituality help connect you to other supportive people \.) (100 :out)
  1 (0 spirituality helps you realize things happen for a reason 0)
    2 (I think it\'s important to understand how everything in life is connected \.) (100 :out)
  1 (0 spirituality helps you realize you are not alone 0)
    2 (It\'s good to realize that whenever you are in a bad place \, there are people out there who care about you \.) (100 :out)
  1 (0 spirituality helps you .BE connected with nature 0)
    2 (I think it\'s important to realize the importance of living with nature \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Personally \, spirituality helps me feel like I have some sense of purpose in the world \.) (100 :out)
))