(store-schema 'enjoys-attending-comedy-shows-and-improv-performances.v

'(event-schema :header ((^me enjoys-attending-comedy-shows-and-improv-performances.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (There exist comedy shows or improv performances for ^me to attend \.)
)

:static-conds (
  ?s1 (Comedy shows and improv performances involve humor \.)
  ?s2 (Comedy shows and improv performances are events open to the public \.)
)

:postconds (
  ?po1 (^me has attended a comedy show or improv performance \.)
)

:goals (
  ?g1 (^me \'s goal is to be entertained and have a good laugh \.)
)

:episodes (
  ?e1 (^me searches for upcoming comedy shows and improv performances \.)
  ?e2 (^me chooses a comedy show or improv performance to attend \.)
  ?e3 (^me purchases a ticket for the show or performance selected \.)
  ?e4 (^me becomes present at the comedy show or improv performance \.)
  ?e5 (^me experiences the humor provided by the event \.)
  ?e6 (^me leaves the event \.)
)

)) ; END enjoys-attending-comedy-shows-and-improv-performances.v