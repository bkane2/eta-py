(store-schema 'enjoys-taking-improv-classes.v

'(event-schema :header ((^me enjoys-taking-improv-classes.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (Improv classes are being offered \.)
  ?pr2 (^me has the ability to enroll in improv classes \.)
)

:static-conds (
  ?s1 (^me has a fascination with improvisation \.)
  ?s2 (^me has the ability to think on her feet \.)
  ?s3 (^me is open to taking risks \.)
  ?s4 (^me has classmates who provide support \.)
  ?s5 (Improv classes can teach valuable life skills \.)
)

:postconds (
  ?po1 (^me \'s improv skills have improved \.)
  ?po2 (^me has learned valuable life skills \.)
  ?po3 (^me has a heightened sense of self-confidence \.)
)

:goals (
  ?g1 (^me \'s goal is to improve her improv skills \.)
  ?g2 (^me \'s goal is to gain valuable life skills from improv classes \.)
  ?g3 (^me \'s goal is to become more confident in her abilities \.)
)

:episodes (
  ?e1 (^me enrolls in an improv class \.)
  ?e2 (^me attends the class regularly \.)
  ?e3 (^me practices thinking on her feet and responding creatively \.)
  ?e4 (^me takes risks and explores new possibilities \.)
  ?e5 (^me develops stronger communication skills \.)
  ?e6 (^me becomes more confident in her abilities \.)
  ?e7 (^me learns to be adaptable to unexpected situations \.)
)

)) ; END enjoys-taking-improv-classes.v