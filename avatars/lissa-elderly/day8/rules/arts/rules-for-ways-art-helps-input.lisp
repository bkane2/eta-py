;;	Tell me about ways art helps you cope with stress or negative emotions. 
;;	(0 art helps one cope with stress 0)
;;	ways-art-helps
;;	(How does art help you cope with negative emotions ?)
;;	(3 How 2 art help 2 cope 2 negative emotions 3)
;; MEETING WITH KIM NOTES (8/4/2017)
;; It doesn't help
;; Response: "Tell me about someone you know who uses art this way. / Use your imagination, tell me what you think someone who uses art this way might think."
;; Offering art lessons at senior living community
;; Gets them out of the house
;; Relaxation
;; Creativity / Imagination
;; Helps give you a purpose
;; Is fun
(MAPC 'ATTACHFEAT
'(
  (PER-REF me us we you them people person artist artists)
  (VERB-MAKE make makes making cause causes causing HELP helps helping keep keeps keeping GET gets getting)
  (VERB-SHOW show shows showing give gives giving)
  (SYN-HAPPINESS happiness wellness pleasure delight gladness satisfaction contentness joy FUN)
  (SYN-PROBLEMS problems troubles)
  (SYN-CREATIVITY creativity creative imagination imaginative express expression)
  (SYN-TEACH teach teaching lesson lessons)
))


(READRULES '*ways-art-helps-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (How does art help me cope with negative emotions ?) (0 :gist)
  1 (0 how 1 art 1 you 0 ?)
    2 (How does art help me cope with negative emotions ?) (0 :gist)
  ; Specific answers
  1 (0 .VERB-MAKE 1 .PER-REF 2 active 0)
    2 ((Art helps one cope with stress by keeping them active \.) (Ways-art-helps)) (0 :gist)
  1 (0 .VERB-MAKE 1 .PER-REF 2 out of 2 house 0)
    2 ((Art helps one cope with stress by keeping them active \.) (Ways-art-helps)) (0 :gist)
  1 (0 .SYN-CREATIVITY 0)
    2 ((Art helps one cope with stress by letting them be creative \.) (Ways-art-helps)) (0 :gist)
  1 (0 .RELAXATION 0)
    2 ((Art helps one cope with stress by being relaxing \.) (Ways-art-helps)) (0 :gist)
  1 (0 .VERB-MAKE 1 .PER-REF 2 noun-purpose 0)
    2 ((Art helps one cope with stress by giving them a purpose \.) (Ways-art-helps)) (0 :gist)
  1 (0 .VERB-SHOW 1 .PER-REF 2 noun-purpose 0)
    2 ((Art helps one cope with stress by giving them a purpose \.) (Ways-art-helps)) (0 :gist)
  1 (0 .VERB-MAKE 1 .PER-REF 2 .GOODSTATE 0)
    2 ((Art helps one cope with stress by making them happy \.) (Ways-art-helps)) (0 :gist)
  1 (0 .VERB-MAKE 1 .PER-REF 2 less .BADSTATE 0)
    2 ((Art helps one cope with stress by making them happy \.) (Ways-art-helps)) (0 :gist)
  1 (0 .VERB-SHOW 1 .PER-REF 2 noun-happiness 0)
    2 ((Art helps one cope with stress by making them happy \.) (Ways-art-helps)) (0 :gist)
  1 (0 forget 3 noun-problems 0)
    2 ((Art helps one cope with stress by making them happy \.) (Ways-art-helps)) (0 :gist)
  1 (0 .SYN-TEACH 2 at 0)
    2 ((Art helps one cope with stress by letting them teach \.) (Ways-art-helps)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how art helps one cope with stress \.) (Ways-art-helps)) (0 :gist)
))


(READRULES '*reaction-to-ways-art-helps-input*
'(
  1 (0 keeping them active 0)
    2 (It\'s good to have a hobby like art to keep you busy \! Otherwise \, life can get quite boring \.) (100 :out)
  1 (0 letting them .BE creative 0)
    2 (I think everyone should have a creative outlet of some sort \. People are naturally creative \, they just have to find which art they\'re talented in \.) (100 :out)
  1 (0 being relaxing 0)
    2 (I love the relaxed feeling I get when making art \. Focusing on just that one thing helps me forget about all my worries \.) (100 :out)
  1 (0 giving them a purpose 0)
    2 (The sense of purpose that comes from creating art and contributing to the world is a great feeling \.) (100 :out)
  1 (0 making them happy 0)
    2 (Making art can be a lot of fun \! It\'s good to have things like that to entertain you \.) (100 :out)
  1 (0 letting them teach 0)
    2 (It\'s cool that there are so many opportunities available for learning or giving lessons on art \. It\'s important for artists to pass on their skill \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I personally think one of the most important ways art helps is just giving me a fun and creative thing to look forward to every day \.) (100 :out)
))