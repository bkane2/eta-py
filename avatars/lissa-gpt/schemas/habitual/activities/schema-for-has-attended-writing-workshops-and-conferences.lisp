(store-schema 'has-attended-writing-workshops-and-conferences.v

'(event-schema :header ((^me has-attended-writing-workshops-and-conferences.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````````````````````````

:preconds (
  ?pr1 (^me has the ability to attend writing workshops and conferences \.)
  ?pr2 (^me has an interest in writing \.)
)

:static-conds (
  ?s1 (Workshops and conferences are available for ^me to attend \.)
  ?s2 (Each workshop and conference is geared towards writing and improving her writing skills \.)
)

:postconds (
  ?po1 (^me has learned new writing techniques and refined her writing style \.)
  ?po2 (^me has met and developed relationships with other writers \.)
  ?po3 (^me continues to improve her writing skills \.)
)

:goals (
  ?g1 (^me \'s goal is to improve her writing skills \.)
  ?g2 (^me \'s goal is to meet and develop relationships with other writers \.)
  ?g3 (Organizers of the event want attendees to benefit from the event \.)
  ?g4 (Attendees want to learn and improve their writing skills \.)
)

:episodes (
  ?e1 (^me attends a writing workshop or conference \.)
  ?e2 (^me learns new writing techniques and refines her writing style \.)
  ?e3 (^me meets other writers and develops relationships \.)
  ?e4 (Organizers of the event provide opportunities for attendees to improve their writing skills \.)
  ?e5 (Attendees take the workshop or conference seriously to improve their writing skills \.)
  ?e6 (^me uses the knowledge gained from the event to improve her writing abilities \.)
)

)) ; END has-attended-writing-workshops-and-conferences.v