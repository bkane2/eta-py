;;	How far did you go in school?
;;	(0 I went to school 0)   
;;	education-how-far
;;	(How far did you go in school ?)
;;	(3 how far 3 go in school 3)
(MAPC 'ATTACHFEAT
'(
  (YEAR-NUM ONE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN ELEVEN TWELVE THIRTEEN FOURTEEN FIFTEEN SIXTEEN SEVENTEEN EIGHTEEN NINETEEN TWENTY)
  (GRADE-NUM first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelveth)
  (ALT-GRADE grade year years)
  (COLLEGE university)
  (SCHOOL-TYPE high secondary primary graduate public private)
  (DEGREE-TYPE bachelor bachelors master masters phd doctor postdoctor postdoc)
))


(READRULES '*education-how-far-input*
'(
  ; Questions
  1 (0 how 2 you 2 go 1 school 0 ?)
    2 (How can I go to school ?) (0 :gist)
  1 (0 how 2 you 2 taking classes 0 ?)
    2 (How can I go to school ?) (0 :gist)
  1 (0 what 2 you 0 ?)
    2 (How far did I go in school ?) (0 :gist)
  1 (0 how 2 you 3 school 0 ?)
    2 (How far did I go in school ?) (0 :gist)
  ; Specific answers
  1 (0 .COLLEGE 0)
    2 ((You went to school for college \.) (Education-how-far)) (0 :gist)
  1 (0 .SCHOOL-TYPE school 0)
    2 ((You went to school for 2 school \.) (Education-how-far)) (0 :gist)
  1 (0 .SCHOOL-TYPE 0)
    2 ((You went to school for 2 \.) (Education-how-far)) (0 :gist)
  1 (0 .DEGREE-TYPE 0)
    2 ((You went to school for 2 degree \.) (Education-how-far)) (0 :gist)
  1 (0 .GRADE-NUM .ALT-GRADE 0)
    2 ((You went to school for 2 grade \.) (Education-how-far)) (0 :gist)
  1 (0 .YEAR-NUM .ALT-GRADE 0)
    2 ((You went to school for 2 years \.) (Education-how-far)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how far you went to school \.) (Education-how-far)) (0 :gist)
))


(READRULES '*reaction-to-education-how-far-input*
'(
  1 (0 .COLLEGE 0)
    2 (It is so cool that you went to college \. You must have been very much into studying \.) (100 :out)
  1 (0 .GRADE-NUM grade 0)
    2 (2 grade is still a decent enough education \. Enough to get you where you are today \.) (100 :out)
  1 (0 .YEAR-NUM years 0)
    2 (2 years is a decent amount of time for education \. I am sure you must have learned a lot in that time \.) (100 :out)
  1 (0 .SCHOOL-TYPE school 0)
    2 (I really enjoyed 2 school \. I hope you had a good time there \.) (100 :out)
  1 (0 .SCHOOL-TYPE 0)
    2 (I really enjoyed 2 \. I hope you had a good time there \.) (100 :out)
  1 (0 .DEGREE-TYPE degree 0)
    2 (Getting your 2 degree sounds like an impressive goal \. I am sure you must have worked hard to get there \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (It\'s good that your education helped you get where you are today \.) (100 :out)
))