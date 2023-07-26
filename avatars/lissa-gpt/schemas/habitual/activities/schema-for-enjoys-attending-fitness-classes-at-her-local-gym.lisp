(store-schema 'enjoys-attending-fitness-classes-at-her-local-gym.v

'(event-schema :header ((^me enjoys-attending-fitness-classes-at-her-local-gym.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me must be able to attend the class \.)
  ?pr2 (The gym must offer fitness classes \.)
)

:static-conds (
  ?s1 (^me is a fitness enthusiast and enjoys taking fitness classes \.)
  ?s2 (^me is physically able to participate in the fitness classes \.)
  ?s3 (The gym offers classes for different fitness levels and interests \.)
)

:postconds (
  ?po1 (^me attends the fitness class \.)
  ?po2 (^me \'s physical fitness improves \.)
  ?po3 (^me makes new friends who have similar interests \.)
)

:goals (
  ?g1 (^me \'s goal is to attend and participate in fitness classes regularly \.)
  ?g2 (^me \'s goal is to maintain a healthy lifestyle \.)
  ?g3 (^me \'s goal is to make new friends who have similar interests \.)
)

:episodes (
  ?e1 (^me schedules a fitness class \.)
  ?e2 (^me arrives at the gym on time for the class \.)
  ?e3 (^me checks into the class and gets prepared \.)
  ?e4 (^me participates in the class and follows the instructor\'s lead \.)
  ?e5 (^me engages in physical activity and exercises during the class \.)
  ?e6 (^me feels challenged \, invigorated \, and energized after the class \.)
  ?e7 (^me interacts with other class participants and makes new friends \.)
  ?e8 (^me continues going to the classes regularly to maintain her healthy lifestyle \.)
)

)) ; END enjoys-attending-fitness-classes-at-her-local-gym.v