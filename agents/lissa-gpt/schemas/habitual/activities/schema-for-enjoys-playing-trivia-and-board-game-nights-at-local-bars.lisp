(store-schema 'enjoys-playing-trivia-and-board-game-nights-at-local-bars.v

'(event-schema :header ((^me enjoys-playing-trivia-and-board-game-nights-at-local-bars.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (Trivia/ board game night is scheduled to happen at a local bar \.)
  ?pr2 (^me is available to attend the event \.)
)

:static-conds (
  ?s1 (^me is knowledgeable in trivia/ skilled in the board games \.)
  ?s2 (^me has the necessary materials to play the board games \.)
  ?s3 (^me has friends who are interested in attending the event \.)
)

:postconds (
  ?po1 (^me has enjoyed playing games with others \.)
  ?po2 (^me has spent quality time with friends \.)
)

:goals (
  ?g1 (^me \'s goal is to have fun playing trivia and board games with friends \.)
  ?g2 (^me \'s goal is to test her knowledge against others \.)
  ?g3 (^me \'s goal is to win rounds of games such as Scrabble \, Clue \, and Uno \.)
)

:episodes (
  ?e1 (^me becomes aware of trivia/ board game night happening at a nearby bar \.)
  ?e2 (^me contacts friends to see if they are interested in attending \.)
  ?e3 (^me and her friends arrive at the bar \.)
  ?e4 (^me and her friends are assigned a table or board to play their chosen game \.)
  ?e5 (^me and her friends order drinks and food \.)
  ?e6 (^me and her friends play trivia and board games for a few hours \.)
  ?e7 (^me answers questions related to trivia or wins rounds of board games such as Scrabble \, Clue \, and Uno \.)
  ?e8 (^me and her friends engage in friendly competition with other teams/players \.)
  ?e9 (^me and her friends socialize with other attendees and make new friends \.)
  ?e10 (^me and her friends settle the tab and say goodbye to the other attendees \.)
  ?e11 (^me and her friends depart from the bar \.)
)

)) ; END enjoys-playing-trivia-and-board-game-nights-at-local-bars.v