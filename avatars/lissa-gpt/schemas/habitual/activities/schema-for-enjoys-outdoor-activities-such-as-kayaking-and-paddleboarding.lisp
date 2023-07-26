(store-schema 'enjoys-outdoor-activities-such-as-kayaking-and-paddleboarding.v

'(event-schema :header ((^me enjoys-outdoor-activities-such-as-kayaking-and-paddleboarding.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me has free time \.)
  ?pr2 (Outdoor activity can take place \.)
  ?pr3 (^me has access to equipment for kayaking and paddleboarding \.)
)

:static-conds (
  ?s1 (^me is capable of participating in kayaking and paddleboarding \.)
  ?s2 (^me has the necessary skills for kayaking and paddleboarding \.)
)

:postconds (
  ?po1 (^me gains enjoyment from kayaking and paddleboarding \.)
  ?po2 (^me has spent her free time engaging in an outdoor activity \.)
  ?po3 (^me has increased her appreciation for nature \.)
  ?po4 (^me understands the importance of preserving the environment and embracing an active lifestyle \.)
)

:goals (
  ?g1 (^me \'s goal is to enjoy participating in outdoor activities \.)
  ?g2 (^me \'s goal is to gain a deeper appreciation for nature \.)
  ?g3 (^me \'s goal is to share the importance of preserving the environment and embracing an active lifestyle with others \.)
)

:episodes (
  ?e1 (^me obtains access to the required equipment \.)
  ?e2 (^me selects a location for kayaking and/or paddleboarding \.)
  ?e3 (^me prepares the equipment for the chosen activity \.)
  ?e4 (^me ventures out into the water \.)
  ?e5 (^me experiences the sensation of gliding through the water \.)
  ?e6 (^me takes in the natural beauty surrounding her \.)
  ?e7 (^me reflects on the importance of preserving the environment \.)
  ?e8 (^me completes the activity and returns the equipment \.)
)

)) ; END enjoys-outdoor-activities-such-as-kayaking-and-paddleboarding.v