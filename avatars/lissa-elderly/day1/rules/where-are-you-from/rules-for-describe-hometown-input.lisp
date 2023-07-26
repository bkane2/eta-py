;; (tell me more about your hometown ?)
;;	(describe-hometown)
;;		from-describe-hometown-input
;;			(0 where I grew up is 0)
;;			gist-question:(3 tell me more 4 hometown 0)
(MAPC 'ATTACHFEAT
'(
))


(READRULES '*describe-hometown-input*
'(
  ; It looks like there are no gist clause trees here, which might be appropriate because this question is so open-ended
  ; That said, it might be a good idea to get a sense of whether the user's hometown was a city, rural, suburban...
  1 (0)
    2 ((NIL Gist \: nothing found for how where you grew up is \.) (Describe-hometown)) (0 :gist)
))


(READRULES '*reaction-to-describe-hometown-input*
'(
  1 (0 NIL Gist 0)
    2 (Where you grew up is important in shaping who you are \.) (100 :out)
))