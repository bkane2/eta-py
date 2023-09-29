; The rules defined in this file contain module-specific overrides to reactions to statement gist clauses;
; typically involving redirecting the topic when the user's response goes beyond the topic of the module.
;

; Define any useful predicates here:


(READRULES '*reaction-to-prognosis-statement*
;``````````````````````````````````````````````````````
; Assume that SOPHIE has already discussed her prognosis previously to this module.
;
'(
  1 (:or
    (0 I may live for .NUMBER-PLUR .ELAPSED-TIME-PLUR 0)
    (0 the prognosis is that I may live for .NUMBER-TOTAL .ELAPSED-TIME 0)
    (0 the prognosis is that I may live for several .ELAPSED-TIME 0)
    (0 the prognosis is that I .DO not .HAVE .LONG .LEFT to live 0)
    (0 the prognosis is that I may live for a .ELAPSED-TIME 0)
    (0 the prognosis is unfavorable to me 0)
    (0 you are sorry to .INFORM me of a poor prognosis 0)
    (0 the prognosis is that I cannot .BE cured 0)
    (0 the prognosis is that I will survive 0)
    (0 the prognosis is hard to .PREDICT 0)
    (0 my understanding of my prognosis is .INCORRECT 0)
    (0 my understanding of my prognosis is correct 0)
    (0 my understanding of my prognosis may .BE correct 0)
    (0 I will outlive my prognosis 0)
    (0 I will not outlive my prognosis 0)
    (0 I may outlive my prognosis 0)
    (0 the majority of people .DO not .HAVE an accurate prognosis 0)
    (0 the majority of people .HAVE an accurate prognosis 0)
    (0 quitting smoking will not make my prognosis better 0)
    (0 quitting smoking will make my prognosis better 0)
    (0 quitting smoking .MIGHT make my prognosis better 0)
    (0 .GOOD-HEALTH habits will .HELP me outlive my prognosis 0)
    (0 .GOOD-HEALTH habits may .HELP me outlive my prognosis 0)
    )
    2 redirect-to-options.v (100 :schema)

)) ; END *reaction-to-prognosis-statement*