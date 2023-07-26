;;	What are your best qualities ?
;;	(your-best-quality)
;; 	from-your-best-quality-input
;;	(0 My best quality is 0)
;;		gist-question: (2 what 1 your best qualities 1)
;; MEETING WITH KIM NOTES (8/4/2017)
;; Younger people would focus more on activities and broad learning things
;; Older people tend to focus on more personally meaningful things, like relationships
;; Helping other people
;; Generous
;; Sharing their knowledge
;; Being a good partner
;; Take care of / Caregiver
;; Good parent
(MAPC 'ATTACHFEAT
'(
  ;; "I'm a good listener"
  (QUALITY-TYPES-ARCHETYPES listener encourager mediator joker helper conversationalist thinker communicator TEACHER motivator learner manager organizer leader speaker)
  ;; "I'm good at encouraging", "I enjoy helping", "one of my best qualities is listening"
  (QUALITY-TYPES-PARTICIPLE listening encouraging mediating joking helping conversing thinking communicating teaching motivating smiling engaging respecting learning understanding managing organizing leading socializing speaking creating focusing)
  ;; "I try to listen", "I like to help people"
  (QUALITY-TYPES-VERB LISTEN encourage mediate joke HELP converse communicate teach motivate engage RESPECT learn manage organize lead socialize speak create concentrate)
  ;; "I have a good sense of humor", "my smile", "I like conversation"
  (QUALITY-TYPES-NOUN humor smile relationship relationships wisdom motivation confidence optimism strength courage character personality passion integrity knowledge ethics morality loyalty charisma humility discipline perspective organization maturity leadership speech honesty boldness empathy compassion responsbility flexibility intuition focus patience kindness concentration independence health EXPERIENCE)
  ;; "I'm very modest", "I just try to be happy"
  (QUALITY-TYPES-ADJ positive funny nice good pleasant intelligent smart comfortable friendly happy easygoing wise motivated confident optimistic strong courageous engaged passionate tall knowledgeable likable ethical moral loyal charismatic humble disciplined organized mature social honest reasonable bold authentic empathetic compassionate trustworthy creative responsible proactive flexible focused patient energetic concentrated independent healthy outgoing experienced resilient productive)
  (QUALITY-TWO-TYPES-ARCHETYPES hard worker)
  (QUALITY-TWO-TYPES-PARTICIPLE working hard getting along making friends helping other OTHERS)
  (QUALITY-TWO-TYPES-VERB WORK hard get along make friends)
  (QUALITY-TWO-TYPES-NOUN hard WORK SELF control open mind social skills)
  (QUALITY-TWO-TYPES-ADJ hard working open minded easy going)
  (BLUR-TYPES try maybe probably)
))


(READRULES '*your-best-quality-input*
'(
  ; Reciprocal questions
  1 (0 what 2 you 0 ?)
    2 (What are my best qualities ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What are my best qualities ?) (0 :gist)
  1 (0 your best qualities 0 ?)
    2 (What are my best qualities ?) (0 :gist)
  ; Specific answers
  ;; Two word
  1 (0 .QUALITY-TWO-TYPES-ARCHETYPES .QUALITY-TWO-TYPES-ARCHETYPES 0)
    2 ((Your best quality is being a 2 3 \.) (Your-best-quality)) (0 :gist)
  1 (0 .QUALITY-TWO-TYPES-PARTICIPLE .QUALITY-TWO-TYPES-PARTICIPLE 0)
    2 ((Your best quality is 2 3 \.) (Your-best-quality)) (0 :gist)
  1 (0 .QUALITY-TWO-TYPES-VERB .QUALITY-TWO-TYPES-VERB 0)
    2 ((Your best quality is trying to 2 3 \.) (Your-best-quality)) (0 :gist)
  1 (0 .QUALITY-TWO-TYPES-NOUN .QUALITY-TWO-TYPES-NOUN 0)
    2 ((Your best quality is having 2 3 \.) (Your-best-quality)) (0 :gist)
  1 (0 .QUALITY-TWO-TYPES-ADJ .QUALITY-TWO-TYPES-ADJ 0)
    2 ((Your best quality is being 2 3 \.) (Your-best-quality)) (0 :gist)
  ;; One word
  1 (0 .QUALITY-TYPES-ARCHETYPES 0)
    2 ((Your best quality is being a 2 \.) (Your-best-quality)) (0 :gist)
  1 (0 .QUALITY-TYPES-PARTICIPLE 0)
    2 ((Your best quality is 2 \.) (Your-best-quality)) (0 :gist)
  1 (0 .QUALITY-TYPES-VERB 0)
    2 ((Your best quality is trying to 2 \.) (Your-best-quality)) (0 :gist)
  1 (0 .QUALITY-TYPES-ADJ .QUALITY-TYPES-NOUN 0)
    2 ((Your best quality is having 2 3 \.) (Your-best-quality)) (0 :gist)
  1 (0 .QUALITY-TYPES-NOUN 0)
    2 ((Your best quality is having 2 \.) (Your-best-quality)) (0 :gist)
  1 (0 .QUALITY-TYPES-ADJ 0)
    2 (0 kind 0)
      3 (0 .BE kind 0)
        4 ((Your best quality is being kind \.) (Your-best-quality)) (0 :gist)
    2 (0 nice 0)
      3 (0 .BE nice 0)
        4 ((Your best quality is being nice \.) (Your-best-quality)) (0 :gist)
    2 ((Your best quality is being 2 \.) (Your-best-quality)) (0 :gist)
  1 (0 doing 1 independently 0)
    2 ((Your best quality is being independent \.) (Your-best-quality)) (0 :gist)
  ;; NOTE 1: Needs more handling of negative answers, e.g. "I'm not sure",
  ;; "I don't think I have one", etc.
  ;; Also there doesn't seem to be a supported gist clause matching these types of answers.
  1 (0 can .NEG 1 think 0)
    2 ((You are not sure what your best quality is \.) (Your-best-quality)) (0 :gist)
  1 (0 .DO .NEG 1 think 0)
    2 ((You are not sure what your best quality is \.) (Your-best-quality)) (0 :gist)
  1 (0 .DO .NEG 1 introspect 0)
    2 ((You are not sure what your best quality is \.) (Your-best-quality)) (0 :gist)
  1 (0 never 1 thought about 0)
    2 ((You are not sure what your best quality is \.) (Your-best-quality)) (0 :gist)
  1 (0 not 1 sure 0)
    2 ((You are not sure what your best quality is \.) (Your-best-quality)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what your best quality is \.) (Your-best-quality)) (0 :gist)
))


(READRULES '*reaction-to-your-best-quality-input*
'(
  ;; Two word
  1 (0 .QUALITY-TWO-TYPES-ARCHETYPES .QUALITY-TWO-TYPES-ARCHETYPES 0)
    2 (I think being a 2 3 is extremely important \. I am sure we would get along quite well \.) (100 :out)
  1 (0 .QUALITY-TWO-TYPES-PARTICIPLE .QUALITY-TWO-TYPES-PARTICIPLE 0)
    2 (I think being good at 2 3 is extremely important \. I am sure we would get along quite well \.) (100 :out)
  1 (0 .QUALITY-TWO-TYPES-VERB .QUALITY-TWO-TYPES-VERB 0)
    2 (0 get along 0)
      3 (I think being able to get along well with others is extremely important \. That is something that I should improve in me \.) (100 :out)
    2 (I think being able to 2 3 is extremely important \. I am sure we would get along quite well \.) (100 :out)
  1 (0 .QUALITY-TWO-TYPES-NOUN .QUALITY-TWO-TYPES-NOUN 0)
    2 (0 hard .WORK 0)
      3 (I think doing hard work is extremely important \. I am sure we would get along quite well \.) (100 :out)
    2 (0 open mind 0)
      3 (I think having an open mind extremely important \. I am sure we would get along quite well \.) (100 :out)
    2 (I think having 2 3 is extremely important \. I am sure we would get along quite well \.) (100 :out)
  1 (0 .QUALITY-TWO-TYPES-ADJ .QUALITY-TWO-TYPES-ADJ 0)
    2 (I think being 2 3 is extremely important \. I am sure we would get along quite well \.) (100 :out)
  ;; One word
  1 (0 .QUALITY-TYPES-ARCHETYPES 0)
    2 (I think being a 2 is extremely important \. I am sure we would get along quite well \.) (100 :out)
  1 (0 .QUALITY-TYPES-PARTICIPLE 0)
    2 (I think being good at 2 is extremely important \. I am sure we would get along quite well \.) (100 :out)
  1 (0 .QUALITY-TYPES-VERB 0)
    2 (I think trying to 2 is extremely important \. I am sure we would get along quite well \.) (100 :out)
  1 (0 .QUALITY-TYPES-ADJ .QUALITY-TYPES-NOUN 0)
    2 (I think having 2 3 is extremely important \. I am sure we would get along quite well \.) (100 :out)
  1 (0 .QUALITY-TYPES-NOUN 0)
    2 (0 humor 0)
      3 (I think having a good sense of humor is extremely important \. I am sure we would get along quite well \.) (100 :out)
    2 (0 smile 0)
      3 (I think having a nice smile is extremely important \. I am sure we would get along quite well \.) (100 :out)
    2 (0 relationship 0)
      3 (I think having a good relationship with someone is extremely important \. I am sure we would get along quite well \.) (100 :out)
    2 (0 health 0)
      3 (I think having good health is extremely important \, especially in old age \.) (100 :out)
  1 (0 .QUALITY-TYPES-ADJ 0)
    2 (I think being 2 is extremely important \. I am sure we would get along quite well \.) (100 :out)
  ;; NOTE: Need proper handling for "I'm not sure" answers
  1 (0 you are not sure 0)
    2 (I am sure you have a lot of nice qualities \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Thank you for telling me \. I am sure we would get along quite well \.) (100 :out)
))