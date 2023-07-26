(store-schema 'frequently-attends-concerts-by-her-favorite-artists.v

'(event-schema :header ((^me frequently-attends-concerts-by-her-favorite-artists.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (The concert of the specified artist is taking place \.)
)

:static-conds (
  ?s1 (^me has the financial resources to purchase tickets \.)
  ?s2 (The concert has available tickets \.)
  ?s3 (^me has transportation to the concert venue \.)
  ?s4 (^me knows the schedule of the concert \.)
)

:postconds (
  ?po1 (^me has attended the concert of the specified artist \.)
)

:goals (
  ?g1 (^me \'s goal is to attend the concert of her favorite artist \.)
  ?g2 (The artist\'s goal is to perform their music for the audience \.)
)

:episodes (
  ?e1 (^me purchases the tickets for the concert \.)
  ?e2 (^me plans for transportation to the concert venue \.)
  ?e3 (^me arrives at the concert venue on time \.)
  ?e4 (^me finds her way to her seat or to the general front and center of the stage area \.)
  ?e5 (^me immerses herself in the music and atmosphere \.)
  ?e6 (^me sings along with the lyrics of the artist\'s songs \.)
  ?e7 (^me loses herself in the rhythm of the music \.)
  ?e8 (The artist lights up the stage and performs their music \.)
  ?e9 (The audience cheers and sings along with the artist \.)
  ?e10 (^me exits the concert venue after it has ended \.)
)

)) ; END frequently-attends-concerts-by-her-favorite-artists.v