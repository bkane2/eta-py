(store-schema 'often-goes-to-museums-and-art-galleries.v

'(event-schema :header ((^me often-goes-to-museums-and-art-galleries.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me intends to visit a museum or art gallery \.)
  ?pr2 (^me \'s city has at least one museum or art gallery \.)
  ?pr3 (The museum or art gallery is open to the public \.)
)

:static-conds (
  ?s1 (^me is interested in art and culture \.)
  ?s2 (^me has the ability to pay for admission to the museum or art gallery \.)
  ?s3 (The museum or art gallery is equipped to handle public visitors \.)
)

:postconds (
  ?po1 (^me has visited the museum or art gallery \.)
  ?po2 (^me has learned something new about art and culture \.)
)

:goals (
  ?g1 (^me \'s goal is to visit the museum or art gallery \.)
  ?g2 (^me \'s goal is to learn something new about art and culture \.)
)

:episodes (
  ?e1 (^me plans to visit a museum or art gallery \.)
  ?e2 (^me determines the location and hours of operation of the museum or art gallery \.)
  ?e3 (^me travels to the museum or art gallery \.)
  ?e4 (^me pays for admission to the museum or art gallery \.)
  ?e5 (^me explores the museum or art gallery \, interacting with art pieces and other exhibition offerings \.)
  ?e6 (^me learns new things about art and culture from the exhibitions and/or other people at the museum \.)
  ?e7 (^me completes her visit and exits the museum \.)
)

)) ; END often-goes-to-museums-and-art-galleries.v