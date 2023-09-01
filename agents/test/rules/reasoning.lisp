(READRULES '*reason-top-down*
'(
  1 ((^you reply-to.v !expr) 0 (^you say-to.v ^me !expr) 0)
    2 (^you reply-to.v 1.3) (0 :ulf)
  ;; 1 ((^you reply-to.v !expr) 0)
  ;;   2 (*reason-top-down1* (prefix-each! 1.3 (2))) (0 :subtree-permute)
))

(READRULES '*reason-bottom-up*
'(
  1 (0)
    2 ((*reasoning-split* *reasoning-thematic*) (1)) (0 :subtrees)
))

(READRULES '*reasoning-split*
'(
  1 (0)
    2 ((*choose-subtrees-split* (1)) (split-sentences! (1))) (0 :subtrees-permute)
))

(READRULES '*reasoning-thematic*
'(
  1 (0)
    2 ((*reasoning-sub5* *reasoning-sub6*) (1)) (0 :subtrees)
))

(READRULES '*choose-subtrees-split*
'(
  1 (0 cat 0)
    2 (*reasoning-sub3* *reasoning-sub4*) (0 :raw)
  1 (0)
    2 (*reasoning-sub1* *reasoning-sub2*) (0 :raw)
))

(READRULES '*reasoning-sub1*
'(
  1 (0 is 1 snowing 0)
    2 (:and
        (there.pro ((pres be.v) (k snow.n) (on.p (the.d ground.n))))
        (^me ((pres can.aux-s) ski.v))
      ) (0 :ulf)
  1 (0 i 2 mortal 0)
    2 (i am capable of dying \.) (0 :nl)
))

(READRULES '*reasoning-sub2*
'(
  1 (0 is 1 snowing 0)
    2 (i can play in the snow \.) (0 :nl)
))

(READRULES '*reasoning-sub3*
'(
  1 (0 i own 0 cat 0)
    2 (i have a pet \.) (0 :nl)
  1 (0 my cat 2 nice 0)
    2 (i like my cat \.) (0 :nl)
))

(READRULES '*reasoning-sub4*
'(
  1 (0 i own 0 cat 0)
    2 (i like cats \.) (0 :nl)
))

(READRULES '*reasoning-sub5*
'(
  1 (0 mortal 0 skiis 0)
    2 (:and
      (^me ((pres can.aux-s) ski.v))
      (^me ((pres can.aux-s) die.v (adv-e (while.p (ka ski.v)))))
    ) (0 :ulf)
))

(READRULES '*reasoning-sub6*
'(
  1 (0 cat 0)
    2 (^me ((pres feed.v) (my.d cat.n))) (0 :ulf)
))