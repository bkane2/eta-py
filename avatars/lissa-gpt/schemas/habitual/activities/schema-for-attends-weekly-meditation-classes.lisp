(store-schema 'attends-weekly-meditation-classes.v

'(event-schema :header ((^me attends-weekly-meditation-classes.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (The meditation class is scheduled to take place \.)
  ?pr2 (^me has the ability to attend the meditation class \.)
  ?pr3 (^me is interested in attending \.)
)

:static-conds (
  ?s1 (There is a class instructor \.)
  ?s2 (The class location has a peaceful atmosphere \.)
  ?s3 (The lights are dimmed \.)
  ?s4 (The class location has comfortable cushions \.)
)

:postconds (
  ?po1 (^me has attended the meditation class \.)
  ?po2 (^me has experienced inner peace and calmness \.)
  ?po3 (^me feels energized and rejuvenated after the class \.)
)

:goals (
  ?g1 (^me \'s goal is to attend the meditation class \.)
  ?g2 (^me \'s goal is to achieve inner peace and calmness \.)
  ?g3 (^me \'s goal is to feel rejuvenated and energized after the class \.)
)

:episodes (
  ?e1 (^me goes to the location of the meditation class \.)
  ?e2 (^me enters the class and takes her seat \.)
  ?e3 (The instructor guides the meditation \.)
  ?e4 (The instructor dims the lights \.)
  ?e5 (^me focuses on her breathing \.)
  ?e6 (^me allows her mind to quiet \.)
  ?e7 (^me achieves inner peace and calmness \.)
  ?e8 (The class ends \.)
  ?e9 (^me exits the class location \.)
)

)) ; END attends-weekly-meditation-classes.v