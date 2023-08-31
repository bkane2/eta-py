(store-schema 'loves-to-travel-and-explore-new-cities-and-cultures.v

'(event-schema :header ((^me loves-to-travel-and-explore-new-cities-and-cultures.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me has the desire to travel \.)
  ?pr2 (^me has the resources to travel \.)
)

:static-conds (
  ?s1 (The destinations ^me wants to travel to are accessible \.)
  ?s2 (The modes of transportation to travel to the destinations ^me wants to go to exists \.)
)

:postconds (
  ?po1 (^me gains new cultural knowledge and experiences \.)
  ?po2 (^me has a fun time while traveling \.)
)

:goals (
  ?g1 (^me \'s goal is to travel to new destinations \.)
  ?g2 (^me \'s goal is to learn about and experience new cultures \.)
)

:episodes (
  ?e1 (^me finds a destination that she wants to travel to \.)
  ?e2 (^me researches the destination to determine what it offers \.)
  ?e3 (^me saves money for the trip \.)
  ?e4 (^me buys necessary travel tickets \.)
  ?e5 (^me plans an itinerary for her trip \.)
  ?e6 (^me packs her bags \.)
  ?e7 (^me travels to the destination \.)
  ?e8 (^me experiences local foods and customs \.)
  ?e9 (^me visits tourist destinations \.)
  ?e10 (^me interacts with locals \.)
  ?e11 (^me learns new information \.)
  ?e12 (^me returns home from the trip \.)
)

)) ; END loves-to-travel-and-explore-new-cities-and-cultures.v