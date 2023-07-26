(store-schema 'enjoys-go-kart-racing-with-friends.v

'(event-schema :header ((^me enjoys-go-kart-racing-with-friends.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me and her friends have go-karts available to race \.)
  ?pr2 (There is an open go-kart track \.)
  ?pr3 (^me and her friends are free and available to go-kart race together \.)
)

:static-conds (
  ?s1 (^me knows how to drive a go-kart \.)
  ?s2 (^me \'s friends know how to drive go-karts \.)
)

:postconds (
  ?po1 (^me and her friends have finished the race \.)
  ?po2 (^me and her friends have had an enjoyable racing experience \.)
)

:goals (
  ?g1 (^me \'s goal is to have an enjoyable racing experience with her friends \.)
  ?g2 (^me \'s friends\' goal is to have an enjoyable racing experience with ^me \.)
)

:episodes (
  ?e1 (^me and her friends arrive at the go-kart track \.)
  ?e2 (^me and her friends sign up for a racing slot \.)
  ?e3 (^me and her friends wait for their turn to race \.)
  ?e4 (^me and her friends put on their helmets and enter their go-karts \.)
  ?e5 (^me and her friends start their engines and begin the race \.)
  ?e6 (^me and her friends navigate the track \, avoiding obstacles \, and drifting around corners \.)
  ?e7 (^me and her friends experience the adrenaline rush of go-kart racing \.)
  ?e8 (^me and her friends finish the race \, get out of their go-karts and remove their helmets \.)
  ?e9 (^me and her friends recount their experiences of the race and have fun together \.)
)

)) ; END enjoys-go-kart-racing-with-friends.v