(store-schema 'has-attended-wine-and-food-tastings-in-various-regions.v

'(event-schema :header ((^me has-attended-wine-and-food-tastings-in-various-regions.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (None)
)

:static-conds (
  ?s1 (^me is capable of attending tastings \.)
  ?s2 (^me has basic knowledge about wine and culinary arts \.)
)

:postconds (
  ?po1 (^me has gained knowledge about a new region\'s wine and food \.)
  ?po2 (^me has used her knowledge to appreciate food and wine even more \.)
)

:goals (
  ?g1 (^me \'s goal is to attend tastings \.)
  ?g2 (^me \'s goal is to discover new flavors \.)
  ?g3 (^me \'s goal is to increase her knowledge of wine and culinary arts \.)
)

:episodes (
  ?e1 (^me finds and chooses a tasting event to attend \.)
  ?e2 (^me travels to the region where the tasting is being held \.)
  ?e3 (^me participates in the tasting event \.)
  ?e4 (^me tries various food and wine samples at the event \.)
  ?e5 (^me hones her palate by tasting and identifying different flavors \.)
  ?e6 (^me learns about the various cuisines and wines from the different cultures \.)
  ?e7 (^me gains deeper knowledge about the intricacies of food and wine \.)
  ?e8 (^me returns home with new knowledge and appreciation for food and wine \.)
  ?e9 (^me plans to attend more tastings and discover new flavors in the future \.)
)

)) ; END has-attended-wine-and-food-tastings-in-various-regions.v