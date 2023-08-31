(store-schema 'enjoys-attending-concerts-and-live-music-events.v

'(event-schema :header ((^me enjoys-attending-concerts-and-live-music-events.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (There is a concert or live music event happening \.)
  ?pr2 (^me is aware of the happening of such an event \.)
  ?pr3 (^me is physically able to attend \.)
)

:static-conds (
  ?s1 (^me is interested in music \.)
  ?s2 (^me has money to buy tickets \.)
  ?s3 (^me has free time to attend \.)
)

:postconds (
  ?po1 (^me has attended a concert or live music event \.)
  ?po2 (^me has experienced a transformative experience \.)
)

:goals (
  ?g1 (^me \'s goal is to attend a concert or live music event \.)
  ?g2 (^me \'s goal is to enjoy and immerse herself in the moment \.)
)

:episodes (
  ?e1 (^me hears about a concert or live music event \.)
  ?e2 (^me checks to see if she is interested in the performers \.)
  ?e3 (^me checks the date and time of the event \.)
  ?e4 (If she is interested \, ^me buys tickets to the event \.)
  ?e5 (On the day of the event \, ^me arrives at the venue \.)
  ?e6 (^me waits in line to enter \.)
  ?e7 (^me finds her seat or position in the crowd \.)
  ?e8 (The concert or live music event begins \.)
  ?e9 (^me immerses herself in the experience \.)
  ?e10 (^me sways to the beat and sings along with the crowd \.)
  ?e11 (Over the course of the event \, ^me experiences a transformative experience \.)
  ?e12 (When the concert or live music event ends \, ^me leaves the venue \.)
)

)) ; END enjoys-attending-concerts-and-live-music-events.v