;; *discuss-getting-to-know*: development version 5 (UNDER CONSTRUCTION)
;;
;; After defining *discuss-getting-to-know*, we create a hash table 
;;       *output-semantics* 
;; containing interpretations of Lissa outputs, under hash keys 
;; like (*discuss-getting-to-know* ?e1). The main goal is to be able later
;; to match certain user inputs to question interpretations, to
;; see if the inputs already answer the questions, making them
;; redundant.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(store-schema 'discuss-getting-to-know-unconstrained.v

'(dial-schema :header (((set-of ^me ^you) discuss-getting-to-know-unconstrained.v) ** ?e)
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
      '(Hi I am Lissa\. I am a computer character\. I am here to help you practice talking about yourself when you meet new 
	   people in your community\, so we will have a conversation focused on you\. This will be more helpful if you give longer answers\.))
?e2 (^me say-to.v ^you 
       '(The people who programmed me have spoken with adults who have recently moved to a senior living community\.))
?e3 (^me say-to.v ^you 
       '(I may sound choppy\, but I am still able to have a conversation with you\. During the conversation\, I will try to 
	   help you talk with me in a way that will be good practice when you are meeting new people\. To do that\, I will 
	   give you feedback during breaks in our conversation\. I will show you a picture on the screen and tell you some 
	   areas to work on\, as well\! Try not to take the feedback personally\, I just want to help\. My feedback will focus 
	   on eye contact\, speaking voice\, smiling\, and staying positive\.))
?e4 (^me say-to.v ^you 
        '(Now that we have gotten through the basics\, I would like to know more about you\. Could you tell me what your
	      name is?))

?e6 (^you reply-to.v ?e4)  

?e7 (^me react-to.v ?e6);
?e8 (^me say-to.v ^you 
      '(Tell me a bit about your day today\. For example\, what did you have for breakfast?))

?e9 (^you reply-to.v ?e8)   ; This is a nonprimitive action by the user, to be
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

?e11 (^me react-to.v ?e9); react to the "gist" of the user's input

     ; This may be particularized to a response of type '(^me say-to.v ^you '...).
     ; But we don't want to discard the original action specification; so it
     ; seems we want to have a link from (the name introduced for) '?e5' to
     ; its particularization as '(^me say-to.v ^you '...) and possibly further
     ; actions -- a subplan. [WHAT ABOUT INTERLEAVING OF MULTIPLE PLANS
     ; AIMED AT DIFFERENT GOALS?]

?e12 (^me say-to.v ^you '(Speaking of food\, what is your favorite flavor of ice cream?))

?e13 (^you reply-to.v ?e12) ; again leads to a (READWORDS) call, and 
                         ; formation of a subordinate 
                         ; (^you say-to.v ^me '(...)) plan
?e15 (^me react-to.v ?e13)

?e16 (^me say-to.v ^you '(And do you have a favorite food? What is it and why do you like it?))

?e17 (^you reply-to.v ?e16) ; again leads to a (READWORDS) call, and
                             ; formation of a subordinate
                             ; (^you say-to.v ^me '(...)) plan

?e19 (^me react-to.v ?e17)

?e20 (^me say-to.v ^you '(How did you get here today? Did someone drive you\, or did you take the bus?))

?e21 (^you reply-to.v ?e20)

?e23 (^me react-to.v ?e21)

?e24 (^me say-to.v ^you
      '(lets pause here so i can give you feedback))

)

)) ; END discuss-getting-to-know-unconstrained.v