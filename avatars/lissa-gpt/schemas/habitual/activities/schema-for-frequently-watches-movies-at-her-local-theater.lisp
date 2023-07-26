(store-schema 'frequently-watches-movies-at-her-local-theater.v

'(event-schema :header ((^me frequently-watches-movies-at-her-local-theater.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (The theater is open \.)
  ?pr2 (^me has free time \.)
)

:static-conds (
  ?s1 (The theater has movie screenings \.)
  ?s2 (^me is financially able to purchase a ticket \.)
)

:postconds (
  ?po1 (^me has watched a movie \.)
  ?po2 (^me has enjoyed her movie experience \.)
)

:goals (
  ?g1 (^me \'s goal is to watch a movie \.)
  ?g2 (^me \'s goal is to enjoy her movie experience \.)
)

:episodes (
  ?e1 (^me checks the theater\'s schedule for movie screenings \.)
  ?e2 (^me finds a movie she wants to watch \.)
  ?e3 (^me purchases a ticket for the movie \.)
  ?e4 (^me enters the theater \.)
  ?e5 (^me buys a bucket of popcorn and a soft drink \.)
  ?e6 (^me finds a seat in the theater \.)
  ?e7 (^me watches the movie \.)
  ?e8 (^me immerses herself in the movie experience \.)
  ?e9 (The movie ends \.)
  ?e10 (^me leaves the theater \.)
)

)) ; END frequently-watches-movies-at-her-local-theater.v