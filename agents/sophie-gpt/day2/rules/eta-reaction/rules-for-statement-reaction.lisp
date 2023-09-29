; The rules defined in this file contain module-specific overrides to reactions to statement gist clauses;
; typically involving redirecting the topic when the user's response goes beyond the topic of the module.
;

; Define any useful predicates here:


(READRULES '*reaction-to-chemotherapy-statement*
;``````````````````````````````````````````````````
; Shouldn't get to treatment options in this module; redirect to prognosis.
;
'(
  1 (:or
    (0 you think I need .CHEMOTHERAPY 0)
    (0 you .DO not think I need .CHEMOTHERAPY 3)
    (0 a side .EFFECT of .CHEMOTHERAPY is 0)
    )
    2 redirect-to-prognosis.v (100 :schema)

)) ; END *reaction-to-chemotherapy-statement*



(READRULES '*reaction-to-comfort-care-statement*
;``````````````````````````````````````````````````
; Shouldn't get to treatment options in this module; redirect to prognosis.
;
'(
  1 (:or
    (0 you .DO not think I need comfort .CARE 0)
    (0 you think I need comfort .CARE 0)
    (0 comfort .CARE .SHOULD alleviate my .PAIN 0)
    (0 comfort .CARE is a .TREATMENT .OPTION 0)
    (0 I would need a .REFERRAL to start comfort .CARE 0)
    (0 receiving comfort .CARE .IN a dedicated facility is an .OPTION 0)
    (0 receiving comfort .CARE from a specialized service is an .OPTION 0)
    (0 receiving comfort .CARE .IN my own .HOME is an .OPTION 0)
    (0 receiving comfort .CARE from a .NURSE is an .OPTION 0)
    (0 comfort .CARE allows me to .SPEND time with my .FAMILY 0)
    (0 you .DO not think I need .CHEMOTHERAPY .BECAUSE I .SHOULD get comfort .CARE instead 0)
    )
    2 redirect-to-prognosis.v (100 :schema)

)) ; END *reaction-to-comfort-care-statement*



(READRULES '*reaction-to-treatment-options-statement*
;``````````````````````````````````````````````````````
; Shouldn't get to treatment options in this module; redirect to prognosis.
;
'(
  1 (:or
    (0 maintaining .GOOD quality of .LIFE is a .TREATMENT .OPTION 0)
    (0 you need more tests .BEFORE .TALKING about .TREATMENT options 0)
    (0 radiation is a .TREATMENT .OPTION 0)
    (0 .CHEMOTHERAPY is a .TREATMENT .OPTION 0)
    )
    2 redirect-to-prognosis.v (100 :schema)

)) ; END *reaction-to-treatment-options-statement*