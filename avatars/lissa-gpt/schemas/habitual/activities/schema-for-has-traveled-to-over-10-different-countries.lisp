(store-schema 'has-traveled-to-over-10-different-countries.v

'(event-schema :header ((^me has-traveled-to-over-10-different-countries.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me has enough financial resources to travel \.)
  ?pr2 (^me has a valid passport \.)
)

:static-conds (
  ?s1 (^me is interested in traveling \.)
  ?s2 (^me has knowledge of different countries and cultures \.)
  ?s3 (^me has access to information and resources about traveling \.)
)

:postconds (
  ?po1 (^me has traveled to over different countries \.)
  ?po2 (^me has gained knowledge about different cultures and history \.)
  ?po3 (^me has sampled different cuisines \.)
)

:goals (
  ?g1 (^me \'s goal is to travel to different countries and immerse herself in new cultures \.)
  ?g2 (^me \'s goal is to broaden her knowledge and experiences \.)
)

:episodes (
  ?e1 (^me researches destinations and travel requirements \.)
  ?e2 (^me plans for transportation \, accommodation \, and activities \.)
  ?e3 (^me packs her bags with necessary items for the trip \.)
  ?e4 (^me goes to the airport or other transportation terminals \.)
  ?e5 (^me travels to the destination country \.)
  ?e6 (^me checks into the accommodation \.)
  ?e7 (^me explores the country\'s landmarks and attractions \.)
  ?e8 (^me interacts with locals and learns about their culture and way of life \.)
  ?e9 (^me tries the local cuisine \.)
  ?e10 (^me engages in different activities \, such as hiking or water sports \.)
  ?e11 (^me takes photos to capture memories \.)
  ?e12 (^me makes transportation arrangements for departure \.)
  ?e13 (^me returns home with knowledge \, experiences \, and memories \.)
)

)) ; END has-traveled-to-over-10-different-countries.v