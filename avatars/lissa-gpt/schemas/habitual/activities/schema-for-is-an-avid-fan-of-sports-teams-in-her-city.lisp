(store-schema 'is-an-avid-fan-of-sports-teams-in-her-city.v

'(event-schema :header ((^me is-an-avid-fan-of-sports-teams-in-her-city.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (Sports teams exist in ^me \'s city \.)
)

:static-conds (
  ?s1 (^me has knowledge about the sports teams in her city \.)
  ?s2 (^me has access to media covering the sports teams in her city \.)
  ?s3 (The sports teams in ^me \'s city have games to play \.)
)

:postconds (
  ?po1 (^me has cheered for the sports teams in her city \.)
  ?po2 (^me has increased her knowledge of the latest news and stats about the sports teams \.)
)

:goals (
  ?g1 (^me \'s goal is to cheer on her local sports teams \.)
  ?g2 (The goal of the sports teams is to win games \.)
)

:episodes (
  ?e1 (^me hears that a game is scheduled \.)
  ?e2 (^me gets dressed in her team\'s gear \.)
  ?e3 (^me arrives at the stadium or turns on the TV to watch the game \.)
  ?e4 (^me cheers and roots for her team during the game \.)
  ?e5 (^me discusses the game and her favorite players with friends and family during and/or after the game \.)
  ?e6 (^me reads or watches post-game coverage about the game \.)
)

)) ; END is-an-avid-fan-of-sports-teams-in-her-city.v