;;	What is the hardest part of growing older?
;;	gist: What is the hardest part of growing older ?
;;	(0 hardest part 1 growing older 0)
;;	growing-older-hardest-part
;;	(2 What 2 hardest part 2 growing older 2)
;; MEETING WITH KIM NOTES (8/4/2017)
;; Losing independence
;; Relying on my kids
;; "Burden"
;; Giving up driving
;; Vision loss / hearing loss / not being able to see as well / not being able to hear as well
;; Give up things they used to be able to do
;; Give up taking walks
;; Pain
;; Arthritis
;; Memory / forgetfulness
;; Death / loss / losing my husband / losing my wife
;; Being a caregiver
;; Stopping work
;; Living on a fixed income / money
;; Having to move out of house / give up home / move to another home
(MAPC 'ATTACHFEAT
'(
  (ILLNESS health ill medication medicine pills)
  (LONELY alone loneliness)
  (DEPEND CARE)
  (DISABLE deaf blind)
  (VISION listening hearing watch LISTEN)
  (WORSE bad)
))


(READRULES '*growing-older-hardest-part-input*
'(
  ; Questions
  1 (0 what 4 you 0 ?)
    2 (What is the hardest part when I grow older ?) (0 :gist)
  1 (0 .WH_ 4 chore 1 .ENJOY 0 ?)
    2 (What is the hardest part when I grow older ?) (0 :gist)
  ; Specific answers
  1 (0 .NEG 2 .WORSE 0)
    2 ((Do not have hardest part for growing older \.) (Growing-older-hardest-part)) (0 :gist)
  1 (0 .NEG 1 .VISION 0)
    2 ((The hardest part of growing older is bad 4 \.) (Growing-older-hardest-part)) (0 :gist)
  1 (0 .VISION 1 .WORSE 0)
    2 ((The hardest part of growing older is bad 2 \.) (Growing-older-hardest-part)) (0 :gist)
  1 (0 .ILLNESS 0)
    2 ((The hardest part of growing older is 2 \.) (Growing-older-hardest-part)) (0 :gist)
  1 (0 .LONELY 0)
    2 ((The hardest part of growing older is loneliness \.) (Growing-older-hardest-part)) (0 :gist)
  1 (0 .DEPEND 0)
    2 ((The hardest part of growing older is needing care \.) (Growing-older-hardest-part)) (0 :gist)
  1 (0 .DISABLE 0)
    2 ((The hardest part of growing older is getting disable \.) (Growing-older-hardest-part)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what the hardest part of growing older is \.) (Growing-older-hardest-part)) (0 :gist)
))


(READRULES '*reaction-to-growing-older-hardest-part-input*
'(
  ; NOTE: These reactions are a bit too specific, some need to be rephrased in case
  ; LISSA doesn't judge user input correctly.
  1 (0 not .HAVE hardest part 0)
    2 (I am happy to hear that you are happy with your life \.) (100 :out)
  1 (0 bad .VISION 0)
    2 (I am sorry to hear that you have problem with 3 \. Hopefully a doctor might be able to help you with that \.) (100 :out)
  1 (0 .ILLNESS 0)
    2 (Hopefully exercise helps keep you healthy \, and medicine if you need it !) (100 :out)
  1 (0 .LONELY 0)
    2 (Make sure to keep contact with your friends and family if you can \.) (100 :out)
  1 (0 .DEPEND 0)
    2 (Being dependent on others sounds a little bit upset \. But I think every one will go through this period \. Just treat it as a process of nature \.) (100 :out)
  1 (0 .DISABLE 0)
    2 (You should explore other interests of our life and do not just focus on the frustrated part \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I really hope you can get through that part \.) (100 :out)
))