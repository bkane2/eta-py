; The rules in this tree are used to match generic statements from the user
;

; Define any useful predicates here:


(READRULES '*statement-input*
'(
; ````````````````````         topic         ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````        general        ```````````````````````
; ``````````````````````````````````````````````````````````````````

  ; Continue (for when conversation is paused)
  1 (Continue \.)
    2 ((Continue \.)) (0 :gist)
  1 (Continue)
    2 ((Continue \.)) (0 :gist)

  ; Goodbye
  1 (3 .BYE 3)
    2 ((Goodbye \.) (Exchange-goodbyes)) (0 :gist)
  1 (1 talk 2 again 2 soon 2)
    2 ((Goodbye \.) (Exchange-goodbyes)) (0 :gist)
  1 (1 talk to you 1 soon 2)
    2 ((Goodbye \.) (Exchange-goodbyes)) (0 :gist)
  1 (1 until next time 2)
    2 ((Goodbye \.) (Exchange-goodbyes)) (0 :gist)

  1 (0)
    2 ((NIL Statement \.)) (0 :gist)

)) ; END *statement-input*