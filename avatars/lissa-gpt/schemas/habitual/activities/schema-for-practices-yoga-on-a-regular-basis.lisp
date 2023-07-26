(store-schema 'practices-yoga-on-a-regular-basis.v

'(event-schema :header ((^me practices-yoga-on-a-regular-basis.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me has the ability to practice yoga \.)
  ?pr2 (^me has the equipment and space to practice yoga \.)
  ?pr3 (^me has knowledge of yoga practices \.)
)

:static-conds (
  ?s1 (Equipment \, such as a yoga mat \, is available and functional \.)
  ?s2 (^me has an available space to practice yoga \.)
)

:postconds (
  ?po1 (^me has completed yoga practice \.)
  ?po2 (^me has improved physical and mental wellbeing \.)
  ?po3 (^me feels improved energy \, focus \, and attitude towards life \.)
)

:goals (
  ?g1 (^me \'s goal is to practice yoga to maintain physical and mental wellbeing and to improve energy \, focus \, and attitude towards life \.)
)

:episodes (
  ?e1 (^me sets aside a dedicated time and space for practicing yoga \.)
  ?e2 (^me prepares her equipment and space for yoga practice \.)
  ?e3 (^me stretches her muscles and joints \.)
  ?e4 (^me practices various yoga postures (asanas) to build strength \, flexibility \, and balance in her body \.)
  ?e5 (^me practices meditation and deep breathing exercises to ease stress and anxiety in her mind \.)
  ?e6 (^me takes breaks as needed throughout her practice \.)
  ?e7 (^me completes her yoga practice \.)
)

)) ; END practices-yoga-on-a-regular-basis.v