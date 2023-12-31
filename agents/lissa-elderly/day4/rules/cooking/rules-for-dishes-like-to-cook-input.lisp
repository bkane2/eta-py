;;	What kinds of dishes do you like to cook?
;;	(0 I 2 like to cook 0) (0 I 2 like to bake 0) (0 I 1 do not 1 know how to cook 0)
;;	dishes-like-to-cook
;;		gist-question: (2 what 2 dishes 2 like to cook 3)
(MAPC 'ATTACHFEAT
'(
  (FOOD-DESCS sweet sour savory salty bitter dry crunchy spicy bbq bbq barbecue butters cheese cheeses)
  (BREAKFAST sandwich sandwiches panini pancake pancakes egg eggs omelette milk cheddar pudding)
  (AMERICAN-DISHES burgers burger cheeseburger cheeseburgers hamburger hamburgers pizza pizzas wings)
  (FOOD-ETHNICITY asian chinese mexican japanese italian korean peruvian thai ethiopian indian mediterranean greek cambodian german polish spanish)
  (MEAT meats pork chicken turkey steaks steak beefs beef lamb lobster ribs rib pepperoni ham salami bacon meatball meatballs sausage sausages)
  (SEAFOOD salmon salmons tuna bass lobster lobsters shrimp shrimps crab crabs fish fishes shellfish shellfishes cod eel herring sardines swordfish tilapia trout caviar oyster clam clams squid octopus calamari)
  (VEGETABLE VEGETABLE-SINGL VEGETABLE-PLUR)
  (VEGETABLE-SINGL salad tomato mushroom mushrooms onion onions spinich lettuce asparagus broccoli carrot vegan vegetarian avocado eggplant pepper quinoa soy pickle corn pea leek pumpkin beet kale zucchini cabbage celery garlic cauliflower cucumber)
  (VEGETABLE-PLUR salads tomatos mushrooms onions broccolis carrots peppers pickles peas beets kales cabbages)
  (JAPANESE-FOOD sushi seaweed ramen sashimi tempora matcha)
  (MEXICAN-FOOD burrito burritos taco tacos enchilada enchiladas)
  (SOUP soups chowder succotash)
  (TANGERINE cantaloupe honeydew olive olives plantains)
  (FOOD-DESSERT dessert desserts candy pie chocolate custard pastry pastries ice cream yogart FOOD-DESSERT-BAKING)
  (FOOD-DESSERT-BAKING cookie cookies brownies CAKE cakes)
  (CAKE cakes doughnut donut doughnuts donuts shortcake sundae cheesecake)
  (FOOD-GRAIN pasta spaghetti rice noodles oats oatmeal bread toast cereal bran pancake pancakes waffle waffles fries sub subs bagel bagels curry)
  (FOOD-WAY-OF-COOKING boiled smoked baked steamed grilled strip french stew buffalo sweet salty spicy sirloin stuffing curry curried chili)
  (FOOD-TWO apple pie pies hot dog dogs sweet mashed potato potatos)
  (COOK cooking)
  (BAKE baking)
))


(READRULES '*dishes-like-to-cook-input*
;; NOTE: ADD "(0 I 1 do not 1 know how to cook 0)" TO GIST CLAUSES
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (What kinds of dishes do I like to cook ?) (0 :gist)
  1 (0 how 2 you .COOK 0 ?)
    2 (How can I cook ?) (0 :gist)
  1 (0 .WH_ 4 dishes 0 ?)
    2 (What kinds of dishes do I like to cook ?) (0 :gist)
  ; Specific answers
  1 (0 .NEG 3 know 3 .COOK 0)
    2 ((You do not know how to cook \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .NEG 2 .LIKE 2 .COOK 0)
    2 ((You do not like to cook \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .NEG .COOK 0)
    2 ((You do not know how to cook \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .FOOD-ETHNICITY 0)
    2 ((You like to cook 2 dishes \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .FOOD-WAY-OF-COOKING 1 .MEAT 0)
    2 ((You like to cook 2 3 4 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .FOOD-WAY-OF-COOKING 1 .SEAFOOD 0)
    2 ((You like to cook 2 3 4 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .MEAT 1 grain 0)
    2 ((You like to cook 2 3 4 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .SEAFOOD 1 grain 0)
    2 ((You like to cook 2 3 4 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .MEAT 1 .SOUP 0)
    2 ((You like to cook 2 3 4 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .SEAFOOD 1 .SOUP 0)
    2 ((You like to cook 2 3 4 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .VEGETABLE 1 .SOUP 0)
    2 ((You like to cook 2 3 4 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .FOOD-TWO .FOOD-TWO 0)
    2 ((You like to cook 2 3 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .MEAT 3 .VEGETABLE 0)
    2 ((You like to cook 2 3 4 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .AMERICAN-DISHES 0)
    2 ((You like to cook 2 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .MEAT 0)
    2 ((You like to cook 2 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .SEAFOOD 0)
    2 ((You like to cook 2 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .FOOD-DESCS 0)
    2 ((You like to cook 2 foods \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .JAPANESE-FOOD 0)
    2 ((You like to cook 2 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .FOOD-GRAIN 0)
    2 ((You like to cook 2 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .SOUP 0)
    2 ((You like to cook 2 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .FOOD-DESSERT 0)
    2 (0 .FOOD-DESSERT-BAKING 0)
      3 ((0 you like to bake 2 \.) (Dishes-like-to-cook)) (0 :gist)
    2 (0 .FOOD-DESSERT 0)
      3 ((You like to cook 2 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .VEGETABLE 0)
    2 ((You like to cook 2 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .MEXICAN-FOOD 0)
    2 ((You like to cook 2 \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0 .BAKE 0)
    2 ((You like to bake cakes \.) (Dishes-like-to-cook)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what you like to cook \.) (Dishes-like-to-cook)) (0 :gist)
))


(READRULES '*reaction-to-dishes-like-to-cook-input*
'(
  1 (you 1 .NEG 1 know how to .COOK 0)
    2 (Some people don\'t cook \. Nothing wrong with that \.) (100 :out)
  1 (0 .FOOD-ETHNICITY 0)
    2 (I live in a multicultural community and I love eating 2 food \.) (100 :out)
  1 (0 .FOOD-WAY-OF-COOKING 1 .MEAT 0)
    2 (I can\'t eat a meal without meat \.) (100 :out)
  1 (0 .FOOD-WAY-OF-COOKING 1 .SEAFOOD 0)
    2 (Seafood is good for your health beacuse it has low calories \. It tastes good as well \!) (100 :out)
  1 (0 .MEAT 1 grain 0)
    2 (I eat 2 with 4 \. They taste great \.) (100 :out)
  1 (0 .SEAFOOD 1 grain 0)
    2 (2 and 4 sound like a really delicious combination \.) (100 :out)
  1 (0 .MEAT 1 .SOUP 0)
    2 (I think 2 4 can be a delicious appetizer \.) (100 :out)
  1 (0 .SEAFOOD 1 .SOUP 0)
    2 (2 4 sounds really nutritious \.) (100 :out)
  1 (0 .VEGETABLE 1 .SOUP 0)
    2 (2 4 must be healthy to eat \. Wise choice \.) (100 :out)
  1 (0 .FOOD-TWO .FOOD-TWO 0)
    2 (I found many americans love to eat 2 4 \.) (100 :out)
  1 (0 .MEAT 3 .VEGETABLE 0)
    2 (I used to have 2 and 4 regularly at work \.) (100 :out)
  1 (0 .AMERICAN-DISHES 0)
    2 (My granddaughter love to eat 2 at college \.) (100 :out)
  1 (0 .MEAT 0)
    2 (I love to cook various kinds of meat at weekends \. My family loves it \.) (100 :out)
  1 (0 .SEAFOOD 0)
    2 (I feel healthier eating 2 because I usually eat meats like pork or chicken \.) (100 :out)
  1 (0 .FOOD-DESCS 0)
    2 (I love salty or sweet food \, but I don\'t really appreciate sour food that much \.) (100 :out)
  1 (0 .JAPANESE-FOOD 0)
    2 (I love japanese food \. I just ate sashimi yesterday \. Their flavour can be very delicate and generous \.) (100 :out)
  1 (0 .FOOD-GRAIN 0)
    2 (2 sounds like a nice thing to eat \.) (100 :out)
  1 (0 .SOUP 0)
    2 (I love soups \. Mushroom and cheese chicken soup can be very delicious \.) (100 :out)
  1 (0 .FOOD-DESSERT 0)
    2 (0 .FOOD-DESSERT-BAKING 0)
      3 (I have never been good in baking 2 \. It seems super hard to me \.) (100 :out)
    2 (It\'s always nice to have some sweet desserts after a meal \.) (100 :out)
  1 (0 .VEGETABLE 0)
    2 (0 .VEGETABLE-SINGL 0)
      3 (2 is good for my health \. It can be also very tasty if cooked in the right way \.) (100 :out)
    2 (0 .VEGETABLE-PLUR 0)
      3 (2 are good for my health \. They can be also very tasty if cooked in the right way \.) (100 :out)
  1 (0 .MEXICAN-FOOD 0)
    2 (I don\'t particularly like mexican food \, but I will be good as long as I eat with my friends \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I love a good home cooked meal \. I\'re not super good at cooking myself \, but my friends sometimes cook for me \.) (100 :out)
))