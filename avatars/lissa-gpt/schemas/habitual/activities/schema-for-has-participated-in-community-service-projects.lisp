(store-schema 'has-participated-in-community-service-projects.v

'(event-schema :header ((^me has-participated-in-community-service-projects.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me is physically able to participate in community service projects \.)
  ?pr2 (The opportunity to participate in a community service project exists \.)
)

:static-conds (
  ?s1 (^me is willing to participate in community service projects \.)
  ?s2 (^me is passionate about giving back to the community \.)
)

:postconds (
  ?po1 (Community service has been provided \.)
  ?po2 (^me has gained experience in community service \.)
)

:goals (
  ?g1 (^me \'s goal is to provide community service \.)
  ?g2 (The community\'s goal is to receive ^me \'s community service \.)
)

:episodes (
  ?e1 (A community service opportunity arises \.)
  ?e2 (^me learns about the community service opportunity \.)
  ?e3 (^me decides to participate in the community service project \.)
  ?e4 (^me prepares for the community service project (e \.g \. research \, getting supplies together) \.)
  ?e5 (^me participates in the community service project \.)
  ?e6 (The community service project is completed \.)
  ?e7 (^me reflects on her experience and what she gained from the project \.)
)

)) ; END has-participated-in-community-service-projects.v