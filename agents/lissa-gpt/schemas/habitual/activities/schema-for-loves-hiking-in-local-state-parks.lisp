(store-schema 'loves-hiking-in-local-state-parks.v

'(event-schema :header ((^me loves-hiking-in-local-state-parks.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me is physically capable of hiking \.)
  ?pr2 (Local state parks are open to the public \.)
)

:static-conds (
  ?s1 (State parks have properly maintained hiking trails \.)
)

:postconds (
  ?po1 (^me has hiked the trail \.)
)

:goals (
  ?g1 (^me \'s goal is to go hiking in state parks \.)
  ?g2 (^me \'s goal is to escape the hustle and bustle of the city \.)
  ?g3 (^me \'s goal is to meander down a peaceful nature trail \.)
  ?g4 (^me \'s goal is to discover new pathways and hidden natural wonders \.)
)

:episodes (
  ?e1 (^me goes to a local state park \.)
  ?e2 (^me selects a hiking trail \.)
  ?e3 (^me spends time walking along the peaceful \, calming trail \.)
  ?e4 (^me discovers new pathways and hidden natural wonders \.)
  ?e5 (^me \'s worries fade away as she focuses on hiking \.)
  ?e6 (^me takes in her surroundings and experiences a sense of joy and wonderment \.)
  ?e7 (^me completes the hike and returns home \.)
)

)) ; END loves-hiking-in-local-state-parks.v