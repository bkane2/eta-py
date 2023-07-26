;; *discuss-rochester2*: development version 5 (UNDER CONSTRUCTION)
;;
;; After defining *discuss-rochester2*, we create a hash table 
;;       *output-semantics* 
;; containing interpretations of Lissa outputs, under hash keys 
;; like (*discuss-rochester2* ?e1). The main goal is to be able later
;; to match certain user inputs to question interpretations, to
;; see if the inputs already answer the questions, making them
;; redundant.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(store-schema 'discuss-rochester2-unconstrained.v

'(dial-schema :header (((set-of ^me ^you) discuss-rochester2-unconstrained.v) ** ?e)
;`````````````````````````````````````````````````````````````````````````````
; LISSA introduces herself, sets the scene, asks about the user's 
; major, responds to the user's reply, and starts the "Rochester"
; part of the dialog.

; In future, I expect something closer to the following for the
; initial LISSA dialog schema; the acions would be matched and 
; elaborated into text by a language generator:
;  (^me explain-to.v ^you ((nnp lissa) ((nn dialog) framework.n)))
;  (^me tell.v ^you (my academic-major.n))
;  (^me ask.v ^you (id-of (your academic-major.n)))
;  ...
; But since the eventual EL representation allows for quoting, 
; we can make life easy for ourselves at first.

; I'm not sure if the speech generator makes use of upper-/lower-case
; distinctions. If so, we'll eventually have to use character-string
; output here, and a tokenizer that changes this to special Lisp atoms
; like |Hi| I |am| |Lissa|, ... (Using ~a rather than ~s in format
; statements will output such atoms without the escape characters.)
; Note: Lisp atoms with an internal or final '.' are ok, but commas
; and semicolons are not allowed without a preceding '\' or in a |...|
; context.

:episodes ( ; we start execution at this keyword
         ; (I've omitted other schema components for the time being.)
         ; Lissa's lengthy initial utterance may eventually be broken into
         ; a few higher-level (nonprimitive) actions such as introducing
         ; herself, the purpose and structure of the dialog, and the 
         ; explanation of the icons, with each nonprimitive action broken 
         ; down in turn into a number of (primitive) saying-acts.
?e1 (^me say-to.v ^you
      '(If you can\'t tell\, I haven\'t seen much of the city at 
        all\. What would we do if you took me on a tour?))

?e2 (^you reply-to.v ?e1)

?e4 (^me react-to.v ?e2)

?e5 (^me say-to.v ^you
      '(One thing I always wonder about are good places to eat\. You might not think it by looking at me\, but I think restaurants are just great\. I love to watch people enjoy their food\. I also love the way that every place has its own unique atmosphere\. It doesn\'t have to be fancy\. I also love those dirty spoon\, hole in the wall restaurants that have a really fun and cool vibe\! Could you tell me about your favorite place to eat here in Rochester?))

?e6 (^you reply-to.v ?e5)

?e8 (^me react-to.v ?e6)

?e9 (^me say-to.v ^you
      '(And what\'s this whole garbage plate thing about?))

?e10 (^you reply-to.v ?e9)

?e12 (^me react-to.v ?e10) ; no choice tree here yet & perhaps inappropriate,
                            ; in view of the next Lissa output
?e13 (^me say-to.v ^you
      ;That sounds interesting\. I\'m actually curious to try it\. 
      '(By the way\, have you been to Dinosaur Barbecue?))

?e14 (^you reply-to.v ?e13)

?e16 (^me react-to.v ?e14)

?e17 (^me say-to.v ^you
      '(lets pause here so i can give you feedback))

)

)) ; END discuss-rochester2-unconstrained.v