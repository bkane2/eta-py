(store-schema 'enjoys-playing-board-games-with-friends-and-family.v

'(event-schema :header ((^me enjoys-playing-board-games-with-friends-and-family.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me has friends and family to play with \.)
  ?pr2 (^me has board games to play \.)
)

:static-conds (
  ?s1 (^me has knowledge of the rules of the board games she plays \.)
)

:postconds (
  ?po1 (The board games have been played \.)
  ?po2 (Memories have been made \.)
)

:goals (
  ?g1 (^me \'s goal is to play board games with her friends and family \.)
  ?g2 (The goal of ^me \'s friends and family is to enjoy playing board games with her \.)
)

:episodes (
  ?e1 (^me invites her friends and family over for a night of board games \.)
  ?e2 (^me sets up snacks and beverages for the group \.)
  ?e3 (^me chooses the board game to play \.)
  ?e4 (^me explains the rules of the board game to everyone \.)
  ?e5 (^me and her friends and family start playing the board game \.)
  ?e6 (^me encourages everyone to have fun and play their best \.)
  ?e7 (The group engages in friendly competition as the night goes on \.)
  ?e8 (^me \'s warm and inviting spirit keeps the atmosphere light and enjoyable \.)
  ?e9 (The game may get intense and tensions may run high \, but ^me keeps the environment friendly \.)
  ?e10 (Snacks and beverages continue to be enjoyed throughout the night \.)
  ?e11 (The board game is completed \.)
  ?e12 (Memories are made \, and everyone has a good time \.)
  ?e13 (Everyone looks forward to the next game night with ^me \.)
)

)) ; END enjoys-playing-board-games-with-friends-and-family.v