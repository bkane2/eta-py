(READRULES '*reasoning-split*
'(
  1 (0 is 1 snowing 0)
    2 (:and
        (there.pro ((pres be.v) (k snow.n) (on.p (the.d ground.n))))
        (^me ((pres can.aux-s) ski.v))
      ) (0 :ulf)
  1 (0 i 2 mortal 0)
    2 (i am capable of dying \.) (0 :nl)
))

(READRULES '*reasoning*
'(
  1 (0 mortal 0 skiis 0)
    2 (:and
      (^me ((pres can.aux-s) ski.v))
      (^me ((pres can.aux-s) die.v (adv-e (while.p (ka ski.v)))))
    ) (0 :ulf)
))