; The rules defined in this file contain module-specific overrides to reactions to question gist clauses;
; typically involving redirecting the topic when the user's response goes beyond the topic of the module.
;

; Define any useful predicates here:


(READRULES '*reaction-to-prognosis-question*
;``````````````````````````````````````````````````````
; Assume that SOPHIE has already discussed her prognosis previously to this module.
;
'(
  1 (:or
    (0 how .DO I feel about my prognosis 0)
    (0 how .SPECIFIC .DO I .WANT you to .BE about my prognosis 0)
    (0 how .MUCH information .DO I .WANT about my prognosis 0)
    (0 .DO I .HAVE a .QUESTION about my prognosis 0)
    (0 .DO I .UNDERSTAND my prognosis 0)
    (0 .DO I .WANT my .FAMILY to .BE present when you .TELL me about the prognosis 0)
    (0 .DO I .WANT anyone to .BE present when you .TELL me about the prognosis 0)
    )
    2 redirect-to-options.v (100 :schema)

)) ; END *reaction-to-prognosis-question*