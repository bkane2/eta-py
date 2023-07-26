(store-schema 'enjoys-playing-golf-and-miniature-golf.v

'(event-schema :header ((^me enjoys-playing-golf-and-miniature-golf.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me is able to physically play both golf and miniature golf \.)
)

:static-conds (
  ?s1 (^me is familiar with the rules of both games \.)
  ?s2 (Both golf and miniature golf courses are available to be played on \.)
  ?s3 (^me has access to appropriate equipment for both games \.)
)

:postconds (
  ?po1 (^me has played at least one round of golf or miniature golf \.)
)

:goals (
  ?g1 (^me \'s goal is to enjoy her time while playing golf or miniature golf \.)
  ?g2 (^me \'s goal is to hit good shots \.)
  ?g3 (^me \'s goal is to encourage others to try playing golf or miniature golf \.)
  ?g4 (Other players\' goal is to enjoy their time playing with ^me \.)
  ?g5 (Other players\' goal is to improve their skills \.)
)

:episodes (
  ?e1 (^me decides to play golf or miniature golf \.)
  ?e2 (^me deceides on which course to play on or which mini-golf location to go to \.)
  ?e3 (^me makes arrangements for playing such as booking a tee time or paying for admission \.)
  ?e4 (^me goes to the golf or miniature golf course \.)
  ?e5 (^me meets other players if any \.)
  ?e6 (^me or someone in the group gets equipment such as golf clubs or miniature golf putters and balls \.)
  ?e7 (The game begins and ^me takes turns hitting shots and moving the ball toward the hole \.)
  ?e8 (^me and the other players keep score of the game \.)
  ?e9 (^me continues playing until she completes the game \.)
  ?e10 (^me and the other players finish playing and return the equipment \.)
  ?e11 (^me talks to other players about their experience and encourages them to try playing again \.)
)

)) ; END enjoys-playing-golf-and-miniature-golf.v