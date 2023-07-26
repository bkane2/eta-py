(store-schema 'likes-to-paint-and-draw-in-her-spare-time.v

'(event-schema :header ((^me likes-to-paint-and-draw-in-her-spare-time.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me has spare time \.)
  ?pr2 (^me has access to her art supplies \.)
  ?pr3 (^me is in a peaceful and comfortable environment \.)
)

:static-conds (
  ?s1 (^me has the skills to paint and draw \.)
  ?s2 (^me has materials to create art \.)
)

:postconds (
  ?po1 (New art has been created \.)
  ?po2 (^me has expressed herself through her art \.)
)

:goals (
  ?g1 (^me \'s goal is to create art \.)
  ?g2 (^me \'s goal is to express herself through art \.)
)

:episodes (
  ?e1 (^me gathers her art supplies \.)
  ?e2 (^me chooses the medium she wants to work with \.)
  ?e3 (^me sets up her workspace \.)
  ?e4 (^me starts the creative process \, either by sketching or painting \.)
  ?e5 (^me loses herself in the creative flow \.)
  ?e6 (^me experiments with new techniques and mediums \.)
  ?e7 (^me takes breaks when necessary and steps back to observe her art \.)
  ?e8 (^me adds detail and finishing touches to her work \.)
  ?e9 (^me feels a sense of fulfillment and accomplishment from the art she has created \.)
)

)) ; END likes-to-paint-and-draw-in-her-spare-time.v