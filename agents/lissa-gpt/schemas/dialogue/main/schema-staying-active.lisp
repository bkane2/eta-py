
;; *discuss-staying-active*: development version 5 (UNDER CONSTRUCTION)
;;
;; After defining *discuss-staying-active*, we create a hash table 
;;       *output-semantics* 
;; containing interpretations of Lissa outputs, under hash keys 
;; like (*discuss-staying-active* ?e1). The main goal is to be able later
;; to match certain user inputs to question interpretations, to
;; see if the inputs already answer the questions, making them
;; redundant.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(store-schema 'discuss-staying-active.v

'(dial-schema :header (((set-of ^me ^you) discuss-staying-active.v) ** ?e)
;````````````````````````````````````````````````````````````````````````````````
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
      '(I visited my doctor yesterday\, and she told me that I need to be more active\. What ways have you found to stay physically active as you get older?))

?e2 (^you reply-to.v ?e1)   ; This is a nonprimitive action by the user, to be
                             ; elaborated by creation of an action description
                             ; subordinate to '?e4' (or rather, to a new action-
                             ; proposition name Gensym'd for ?e4'), followed by
                             ; a (READWORDS) call that obtains the user input,
                             ; insertion of a wff of type (^you say-to.v ^me '(...))
                             ; as the content of the subordinate action description,
                             ; and "interpretation" (expansion) of the input, where
                             ; this interpretation consists of a list of clauses
                             ; attached (as 'interpretation') to the new subordinate
                             ; action description, the first clause being the main
                             ; content (answer to Lissa's question), and the rest
                             ; being any potentially useful supplementary pieces
                             ; of information extracted from the input.

     ; At this point we want to allow for selection and insertion of 
     ; a subdialog (usually just a 1-utterance reaction, if any) that is
     ; appropriate for the user's reply, viewed as an answer to question
     ; ?e3 We branch to the right choice tree by use of the "gist clause"
     ; of the question the user has just replied to -- here '(What is your
     ; major ?)', as per ?e3 (which is referenced in ?e4).

?e4 (^me react-to.v ?e2); react to the "gist" of the user's input

     ; This may be particularized to a response of type '(^me say-to.v ^you '...).
     ; But we don't want to discard the original action specification; so it
     ; seems we want to have a link from (the name introduced for) '?e5' to
     ; its particularization as '(^me say-to.v ^you '...) and possibly further
     ; actions -- a subplan. [WHAT ABOUT INTERLEAVING OF MULTIPLE PLANS
     ; AIMED AT DIFFERENT GOALS?]

?e5 (^me say-to.v ^you '(I like to exercise my brain as well as my body\. What are some ways you keep your brain active as you age?))

?e6 (^you reply-to.v ?e5) ; again leads to a (READWORDS) call, and 
                         ; formation of a subordinate 
                         ; (^you say-to.v ^me '(...)) plan
?e8 (^me react-to.v ?e6)

?e9 (^me say-to.v ^you '(What ways have you\, or someone close to you\, coped with hearing or vision loss? For example some people ask for help or put their glasses in their purse\.))


?e10 (^you reply-to.v ?e9)
?e11 (^me react-to.v ?e10)


?e13 (^me say-to.v ^you
      '(lets pause here so i can give you feedback))

)

)) ; END discuss-staying-active.v