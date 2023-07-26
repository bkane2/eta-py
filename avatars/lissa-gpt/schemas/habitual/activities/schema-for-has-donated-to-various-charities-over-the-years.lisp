(store-schema 'has-donated-to-various-charities-over-the-years.v

'(event-schema :header ((^me has-donated-to-various-charities-over-the-years.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me has the financial ability to donate to charities \.)
)

:static-conds (
  ?s1 (There are existing charities that ^me can donate to \.)
)

:postconds (
  ?po1 (^me has made a donation to a charity \.)
)

:goals (
  ?g1 (^me \'s goal is to make a positive impact on the world \.)
  ?g2 (Charities\' goal is to receive donations to support their cause \.)
)

:episodes (
  ?e1 (^me finds a charity that resonates with her beliefs \.)
  ?e2 (^me decides how much she wants to donate \.)
  ?e3 (^me makes a payment to the charity \.)
  ?e4 (The charity receives ^me \'s payment \.)
  ?e5 (The charity uses ^me \'s donation to support their cause \.)
  ?e6 (Countless people benefit from the charity\'s efforts \.)
  ?e7 (^me feels happy and fulfilled \.)
  ?e8 (^me encourages others to donate to charities too \.)
)

)) ; END has-donated-to-various-charities-over-the-years.v