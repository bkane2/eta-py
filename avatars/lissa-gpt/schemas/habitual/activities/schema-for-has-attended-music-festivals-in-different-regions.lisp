(store-schema 'has-attended-music-festivals-in-different-regions.v

'(event-schema :header ((^me has-attended-music-festivals-in-different-regions.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me loves music \.)
  ?pr2 (^me has knowledge of music festivals \.)
  ?pr3 (Music festivals are happening \.)
)

:static-conds (
  ?s1 (Festivals have diverse genres of music \.)
  ?s2 (Festivals provide their own unique atmosphere \.)
  ?s3 (Festivals provide different sights and sounds \.)
)

:postconds (
  ?po1 (^me attends the music festival \.)
)

:goals (
  ?g1 (^me \'s goal is to attend the music festival in various regions \.)
)

:episodes (
  ?e1 (^me discovers the music festival \.)
  ?e2 (^me researches the music festival \.)
  ?e3 (^me plans her travel and accommodation arrangements \.)
  ?e4 (^me attends the music festival \.)
  ?e5 (^me enjoys the diverse genres of music available at the festival \.)
  ?e6 (^me explores the unique atmosphere and sights of the festival \.)
)

)) ; END has-attended-music-festivals-in-different-regions.v