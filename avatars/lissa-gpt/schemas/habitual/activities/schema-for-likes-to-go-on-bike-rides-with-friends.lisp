(store-schema 'likes-to-go-on-bike-rides-with-friends.v

'(event-schema :header ((^me likes-to-go-on-bike-rides-with-friends.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me has access to a bike \.)
  ?pr2 (^me \'s friends have access to bikes \.)
  ?pr3 (The weather is suitable for outdoor biking \.)
)

:static-conds (
  ?s1 (All bikes are in good condition \.)
  ?s2 (All riders know how to ride a bike \.)
  ?s3 (All riders are in good health and have the necessary physical ability to ride bikes \.)
)

:postconds (
  ?po1 (All riders have completed the bike ride \.)
  ?po2 (All riders have returned to the starting point of the ride \.)
)

:goals (
  ?g1 (^me \'s goal is to go on a bike ride with her friends \.)
  ?g2 (^me \'s friends\' goal is to have an enjoyable bike ride with ^me \.)
  ?g3 (All riders\' goals are to exercise and enjoy the outdoors \.)
)

:episodes (
  ?e1 (All riders meet at a predetermined location \.)
  ?e2 (All riders check that their bikes are functioning properly \.)
  ?e3 (All riders put on any necessary safety gear \, such as helmets \.)
  ?e4 (All riders agree on a route to take \.)
  ?e5 (All riders begin the bike ride \, sticking to the predetermined route \.)
  ?e6 (All riders ride at a pace that is comfortable for everyone in the group \.)
  ?e7 (All riders chat and laugh along the way \.)
  ?e8 (All riders stop for rest breaks \, and to take in the beauty of nature \.)
  ?e9 (All riders finish the bike ride \.)
  ?e10 (All riders return to the predetermined meeting location \.)
  ?e11 (All riders put away their bikes properly \.)
  ?e12 (All riders say goodbye to each other \.)
)

)) ; END likes-to-go-on-bike-rides-with-friends.v