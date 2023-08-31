(store-schema 'loves-to-read-novels-by-her-favorite-authors.v

'(event-schema :header ((^me loves-to-read-novels-by-her-favorite-authors.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me has novels available to her \.)
  ?pr2 (^me has time to read \.)
)

:static-conds (
  ?s1 (^me is capable of reading \.)
)

:postconds (
  ?po1 (^me has read a novel \.)
)

:goals (
  ?g1 (^me \'s goal is to be transported to a different world and be captivated by the story \.)
)

:episodes (
  ?e1 (^me selects a novel written by her favorite author \.)
  ?e2 (^me curls up on her couch with the novel \, a warm cup of tea \, and her imagination for company \.)
  ?e3 (^me starts to read the novel \, losing herself in the story \.)
  ?e4 (^me imagines herself as part of the story as she continues reading \.)
  ?e5 (^me finishes the novel and may feel satisfied or ready to read another \.)
)

)) ; END loves-to-read-novels-by-her-favorite-authors.v