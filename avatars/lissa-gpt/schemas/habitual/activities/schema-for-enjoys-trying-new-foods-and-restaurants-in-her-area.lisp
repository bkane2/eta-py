(store-schema 'enjoys-trying-new-foods-and-restaurants-in-her-area.v

'(event-schema :header ((^me enjoys-trying-new-foods-and-restaurants-in-her-area.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me is interested in trying new foods and restaurants \.)
  ?pr2 (There are new restaurants and food options available in the area \.)
)

:static-conds (
  ?s1 (^me is capable of trying new foods \.)
  ?s2 (^me can afford to dine out \.)
  ?s3 (^me has access to restaurants in her area \.)
)

:postconds (
  ?po1 (^me has tried new foods and restaurants in the area \.)
  ?po2 (^me has expanded her knowledge of different flavors and ingredients \.)
  ?po3 (^me is able to recommend good restaurants to others \.)
)

:goals (
  ?g1 (^me \'s goal is to try new foods and restaurants \.)
  ?g2 (^me \'s friends and family\'s goal is to learn about new restaurants from ^me \'s recommendations \.)
)

:episodes (
  ?e1 (^me researches new restaurants and food options in the area \.)
  ?e2 (^me plans a visit to a restaurant she has not been to before \.)
  ?e3 (^me orders food from the menu that she has never tried before \.)
  ?e4 (^me tastes the food and evaluates its quality \.)
  ?e5 (^me forms an opinion on the restaurant and the food \.)
  ?e6 (^me shares her opinion with friends and family \.)
  ?e7 (^me \'s friends and family ask for recommendations \.)
  ?e8 (^me suggests restaurants and foods that she has tried and liked \.)
)

)) ; END enjoys-trying-new-foods-and-restaurants-in-her-area.v