;; What part of your education has been most meaningful to you?
;; (0 The most meaningful part 3 education 0)   
;; education-most-meaningful
;; (What part of your education has been most meaningful to you ?)
;; (3 what part 3 education 2 most meaningful 3)
(MAPC 'ATTACHFEAT
'(
  (KNOWLEDGE academics academic rearch intellectual intelligence)
  (SKILL skills tool tools)
  (INTERESTS interest desires passion passions)
  (GROWTH experience)
  (CLASS classes courses curricula curriculas curriculum)
  (PEOPLE friends FRIEND friendship SOCIAL community)
  (COOPERATION cooperative collaborate)
  (COMPETE competitive competitiveness)
  (STRESS disappointed disappointing)
))


(READRULES '*education-most-meaningful-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (What part of my education has been most meaningful to me ?) (0 :gist)
  1 (0 how 2 you think of 0 ?)
    2 (What part of my education has been most meaningful to me ?) (0 :gist)
  ; Specific answers
  1 (0 .KNOWLEDGE 0)
    2 ((The most meaningful part of education is the gain of knowledge \.) (Education-most-meaningful)) (0 :gist)
  1 (0 .KNOWLEDGE 0)
    2 ((The most meaningful part of education is the gain of skills \.) (Education-most-meaningful)) (0 :gist)
  1 (0 .INTERESTS 0)
    2 ((The most meaningful part of education is finding 2 \.) (Education-most-meaningful)) (0 :gist)
  1 (0 .GROWTH 0)
    2 ((The most meaningful part of education is growth \.) (Education-most-meaningful)) (0 :gist)
  1 (0 .CLASS 0)
    2 ((The most meaningful part of education is taking classes \.) (Education-most-meaningful)) (0 :gist)
  1 (0 .PEOPLE 0)
    2 ((The most meaningful part of education is people \.) (Education-most-meaningful)) (0 :gist)
  1 (0 .COOPERATION 0)
    2 ((The most meaningful part of education is learning cooperation \.) (Education-most-meaningful)) (0 :gist)
  1 (0 .STRESS 0)
    2 ((The most meaningful part of education is learning to deal with stress \.) (Education-most-meaningful)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for the most meaningful part of education \.) (Education-most-meaningful)) (0 :gist)
))


(READRULES '*reaction-to-education-most-meaningful-input*
'(
  1 (0 .KNOWLEDGE 0)
    2 (I learned a lot of knowledge from school \. Those skills help me a lot \.) (100 :out)
  1 (0 .SKILL 0)
    2 (A big part of skills that helped me throughout my life were those I learned in primary and high school \.) (100 :out)
  1 (0 .INTERESTS 0)
    2 (It is great that you found your interests from the education you received \.) (100 :out)
  1 (0 .GROWTH 0)
    2 (I can growth and learn a lot from the experience in schoool \.) (100 :out)
  1 (0 classes 0)
    2 (That is sweet to hear that you still remember the courses you took \. It must help you learn a lot \.) (100 :out)
  1 (0 .PEOPLE 0)
    2 (That is great that you met good people in your school life \. Friendship is a treasure of your life \.) (100 :out)
  1 (0 .COOPERATION 0)
    2 (Learning how to cooperate with other people is very meaningful \.) (100 :out)
  1 (0 .STRESS 0)
    2 (Knowing how to deal with stress is useful for your life \.) (100 :out)
  1 (0)
    2 (It\'s good to find meaning in what you learn \.) (100 :out)
))