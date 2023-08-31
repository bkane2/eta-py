(store-schema 'has-done-volunteer-work-for-environmental-organizations.v

'(event-schema :header ((^me has-done-volunteer-work-for-environmental-organizations.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (Environmental organizations are in need of volunteers \.)
  ?pr2 (^me has access to information on environmental organizations \.)
  ?pr3 (^me believes in preserving the world we live in \.)
)

:static-conds (
  ?s1 (Environmental organizations provide opportunities for volunteer work \.)
  ?s2 (^me has the necessary skills and knowledge to perform volunteer work \.)
  ?s3 (^me has access to resources needed to perform volunteer work \.)
)

:postconds (
  ?po1 (Environmental organizations have received volunteer work \.)
  ?po2 (^me has performed volunteer work \.)
)

:goals (
  ?g1 (^me \'s goal is to preserve the world we live in \.)
  ?g2 (Environmental organizations\' goal is to receive volunteer work \.)
)

:episodes (
  ?e1 (^me learns about environmental organizations in need of volunteers \.)
  ?e2 (^me decides which environmental organizations she wants to work with \.)
  ?e3 (^me contacts the environmental organizations to offer her help \.)
  ?e4 (^me attends training and orientation sessions for volunteer work \.)
  ?e5 (^me performs volunteer work according to the policies and guidelines of the environmental organizations \.)
  ?e6 (^me interacts and collaborates with other volunteers and staff of the environmental organizations \.)
  ?e7 (^me records and reports the work she has done for the environmental organizations \.)
  ?e8 (^me uses her experience and knowledge to expand public awareness and promote environmental protection \.)
)

)) ; END has-done-volunteer-work-for-environmental-organizations.v