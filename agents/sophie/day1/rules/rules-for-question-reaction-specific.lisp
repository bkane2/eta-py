(READRULES '*reaction-to-question-specific-session*
; This tree can be used to define reactions to questions specific to module 1.
;
'(
  1 (0 .COMFORT-CARE-WORD 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .TREATMENT 1 options 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .TREATMENT 1 goals 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .MEDICINE 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .PAIN-MED 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .PAIN-MED-OTHER 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .BLOOD-PRESSURE-MED 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .MED-NARCOTIC 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 medication 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .CHEMOTHERAPY 0)
    2 redirect-to-prognosis.v (0 :schema)
)) ; END *reaction-to-question-specific-session*