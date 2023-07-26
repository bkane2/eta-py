;; (What is the best part ?)
;;	(holidays-best-part)
;;		from-holidays-best-part-input
;;			(0 The holidays best part is 0)
;;			gist-question:(3 what 2 best part 0)
(MAPC 'ATTACHFEAT
'(
  (BE being)
  (TALK talking conversation)
  (SEE seeing)
  (OTHERS FAMILY friends people everybody)
  (EATING eat food delicious tasty yummy)
))


(READRULES '*holidays-best-part-input*
'(
  ; Specific answer
  1 (0 .BE 3 .OTHERS 0)
    2 ((The holidays best part is being with 4 \.) (Holidays-best-part)) (0 :gist)
  1 (0 .HAVE 3 .FUN 0)
    2 ((The holidays best part is having fun \.) (Holidays-best-part)) (0 :gist)
  1 (0 .TALK 0)
    2 ((The holidays best part is talking with people \.) (Holidays-best-part)) (0 :gist)
  1 (0 .SEE 3 .OTHERS 0)
    2 ((The holidays best part is seeing 4 \.) (Holidays-best-part)) (0 :gist)
  1 (0 .EATING 0)
    2 ((The holidays best part is eating \.) (Holidays-best-part)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for the holidays best part is \.) (Holidays-best-part)) (0 :gist)
))


(READRULES '*reaction-to-holidays-best-part-input*
'(
  1 (0 being with .OTHERS 0)
    2 (0 .FAMILY 0)
      3 (It must be great to be with family \.) (100 :out)
    2 (0 friends 0)
      3 (It must be great to be with friends \.) (100 :out)
    2 (0)
      3 (It must be great to be with others \.) (100 :out)
  1 (0 seeing .OTHERS 0)
    2 (0 .FAMILY 0)
      3 (It must be great to see family \.) (100 :out)
    2 (0 friends 0)
      3 (It must be great to see friends \.) (100 :out)
    2 (0)
      3 (It must be great to see others \.) (100 :out)
  1 (0 having .FUN 0)
    2 (It\'s always good to have fun \. Staying positive helps \.) (100 :out)
  1 (0 talking 0)
    2 (Talking with people during the holidays is a great way to lift your spirits \.) (100 :out)
  1 (0 .EATING 0)
    2 (That\'s right \. Thanksgiving parties are when I always get to eat a lot of delicious foods and desserts \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Holidays are always a happy time \, in my opinion \.) (100 :out)
))