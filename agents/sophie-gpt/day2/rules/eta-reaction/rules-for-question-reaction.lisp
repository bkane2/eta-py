; The rules defined in this file contain module-specific overrides to reactions to question gist clauses;
; typically involving redirecting the topic when the user's response goes beyond the topic of the module.
;

; Define any useful predicates here:


(READRULES '*reaction-to-chemotherapy-question*
;``````````````````````````````````````````````````
; Shouldn't get to treatment options in this module; redirect to prognosis.
;
'(
  1 (:or
    (0 did my doctor .MENTION .CHEMOTHERAPY 0)
    (0 .DO I .UNDERSTAND how .CHEMOTHERAPY works 0)
    (0 .DO I .HAVE a .QUESTION about .CHEMOTHERAPY 0)
    (0 what are my feelings about .CHEMOTHERAPY 0)
    )
    2 redirect-to-prognosis.v (100 :schema)

)) ; END *reaction-to-chemotherapy-question*



(READRULES '*reaction-to-comfort-care-question*
;``````````````````````````````````````````````````
; Shouldn't get to treatment options in this module; redirect to prognosis.
;
'(
  1 (:or
    (0 .HAVE I considered comfort .CARE 0)
    (0 .DO I .UNDERSTAND how comfort .CARE works 0)
    (0 .DO I .HAVE a .QUESTION about comfort .CARE 0)
    )
    2 redirect-to-prognosis.v (100 :schema)

)) ; END *reaction-to-comfort-care-question*



(READRULES '*reaction-to-treatment-options-question*
;``````````````````````````````````````````````````````
; Shouldn't get to treatment options in this module; redirect to prognosis.
;
'(
  1 (:or
    (0 what .DO I .UNDERSTAND about my .TREATMENT options 0)
    (0 .DO I .HAVE a .QUESTION about my .TREATMENT options 0)
    (0 am I .READY to start discussing .TREATMENT options 0)
    (0 am I .READY to .DISCUSS my .TREATMENT goals 0)
    (0 what are my .TREATMENT goals 0)
    )
    2 redirect-to-prognosis.v (100 :schema)
    
)) ; END *reaction-to-treatment-options-question*