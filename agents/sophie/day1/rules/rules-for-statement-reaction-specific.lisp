(READRULES '*reaction-to-statement-specific-session*
; This tree can be used to define reactions to statements specific to module 1.
;
'(
  1 (0 comfort 1 .CARE 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 medication 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .MED-NARCOTIC 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .TAKE 1 different 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .TREATMENT 1 .OPTION 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .CANCER-GOALS 0)
    2 redirect-to-prognosis.v (0 :schema)
  1 (0 .CHEMOTHERAPY 0)
    2 redirect-to-prognosis.v (0 :schema)
)) ; END *reaction-to-statement-specific-session*