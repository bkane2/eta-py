(store-schema 'likes-to-attend-theater-productions-and-musicals.v

'(event-schema :header ((^me likes-to-attend-theater-productions-and-musicals.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (A theater production or musical is happening in town \.)
)

:static-conds (
  ?s1 (^me is capable of attending theater productions and musicals \.)
  ?s2 (There are available seats for ^me to take \.)
)

:postconds (
  ?po1 (^me has attended the theater production or musical \.)
)

:goals (
  ?g1 (^me \'s goal is to attend the theater production or musical \.)
)

:episodes (
  ?e1 (^me finds out that a theater production or musical is happening in town \.)
  ?e2 (^me plans to attend the theater production or musical \.)
  ?e3 (^me looks up ticket availability and prices \.)
  ?e4 (^me purchases a ticket for herself \.)
  ?e5 (^me arrives at the theater to watch the production/musical \.)
  ?e6 (^me takes her seat in the theater \.)
  ?e7 (^me watches the performance \.)
  ?e8 (^me savors every moment of the performance and is transported to a different world \.)
  ?e9 (^me enjoys the talented actors and singers who bring the stories to life \.)
  ?e10 (The production/musical ends \.)
  ?e11 (^me leaves the theater \.)
)

)) ; END likes-to-attend-theater-productions-and-musicals.v