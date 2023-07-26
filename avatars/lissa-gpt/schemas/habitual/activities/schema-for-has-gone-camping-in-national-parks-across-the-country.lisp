(store-schema 'has-gone-camping-in-national-parks-across-the-country.v

'(event-schema :header ((^me has-gone-camping-in-national-parks-across-the-country.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me is in a location near a national park)
  ?pr2 (There are camping facilities available in the national park)
)

:static-conds (
  ?s1 (^me is capable of camping in national parks \.)
  ?s2 (^me has the necessary equipment for camping \.)
)

:postconds (
  ?po1 (^me has camped in a national park \.)
  ?po2 (^me has experienced the beauty and wonder of nature \.)
  ?po3 (^me \'s appreciation for nature has increased \.)
)

:goals (
  ?g1 (^me \'s goal is to explore the great outdoors by camping in various national parks \.)
  ?g2 (^me \'s goal is to experience the magic of nature firsthand \.)
  ?g3 (^me \'s goal is to feel rejuvenated and inspired after the camping trip \.)
)

:episodes (
  ?e1 (^me selects a national park to visit \.)
  ?e2 (^me prepares her camping equipment and supplies for the trip \.)
  ?e3 (^me travels to the national park \.)
  ?e4 (^me sets up her campsite in the designated camping area \.)
  ?e5 (^me explores the national park \, hiking and taking in the scenery \.)
  ?e6 (^me encounters wildlife in their natural habitats \.)
  ?e7 (^me makes meals and enjoys them in the wilderness \.)
  ?e8 (^me sleeps under the starry night sky \.)
  ?e9 (^me wakes up and continues exploring the national park \.)
  ?e10 (After exploring \, ^me packs up her camping gear and departs the national park \.)
)

)) ; END has-gone-camping-in-national-parks-across-the-country.v