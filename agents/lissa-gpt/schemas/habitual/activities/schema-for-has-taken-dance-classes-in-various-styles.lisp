(store-schema 'has-taken-dance-classes-in-various-styles.v

'(event-schema :header ((^me has-taken-dance-classes-in-various-styles.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (Dance classes are available in various styles \.)
  ?pr2 (^me has access to facilities and resources to attend dance classes \.)
)

:static-conds (
  ?s1 (^me is physically capable of dancing \.)
  ?s2 (^me has a passion for dance \.)
)

:postconds (
  ?po1 (^me has taken dance classes in various styles \.)
  ?po2 (^me has increased her knowledge and skill in dance \.)
  ?po3 (^me has become a well-rounded dancer \.)
  ?po4 (^me has shared her passion for dance by teaching and choreographing \.)
)

:goals (
  ?g1 (^me \'s goal is to learn and grow as a dancer \.)
  ?g2 (^me \'s goal is to share her passion for dance with others \.)
  ?g3 (^me \'s goal is to become a well-rounded dancer \.)
)

:episodes (
  ?e1 (^me takes dance classes in various styles (from ballet to tap \, jazz to modern \, and hip-hop to salsa) \.)
  ?e2 (Each style presents ^me with unique challenges and learning opportunities \.)
  ?e3 (^me incorporates techniques and styles from each discipline into her own unique dance style \.)
  ?e4 (^me grows into a well-rounded dancer \.)
  ?e5 (^me shares her passion for dance by teaching and choreographing for aspiring dancers \.)
)

)) ; END has-taken-dance-classes-in-various-styles.v