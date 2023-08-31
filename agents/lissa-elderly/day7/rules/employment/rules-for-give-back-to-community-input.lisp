;;	Sometimes work is one way to give back. What are some ways you give back to your community, others in your life, or society as a whole?
;;	(0 way to give back to your community 0)
;;	give-back-to-community
;;	(What are some ways you give back to your community ?)
;;	(3 What 2 ways 3 give back to your community 3)
;; MEETING WITH KIM NOTES (8/4/2017)
;; Volunteer with church / in schools / tutoring / RSVP (organization in town which helps older people volunteer)
;; Involved in politics
;; Visit other older people
;; Help friends in senior living community
;; Help with bills
;; Check on neighbor
;; Take care of a spouse
;; Help with home delivered meals
;; Donate money
;; Help teach
(MAPC 'ATTACHFEAT
'(
  (ORGANIZATION-TYPES church school schools teach teaching community hospital hospitals tutor tutoring charity kitchen rsvp festival)
  (ALT-VOLUNTEER volunteer volunteering assist assisting HELP helping teach teaching SUPPORT supporting)
  (ALT-DONATE donate donating)
  (ALT-POLITICS politics government council committee administration)
  (ALT-VISIT visit visiting meet meeting)
  (ALT-OTHERS others other another)
  (ALT-MONEY MONEY cash income finance financial bills expenses pay paying credit)
  (ALT-NEIGHBOR neighbor neighbors neighbour neighbours)
  (RELATIVE-TYPES relative relatives FAMILY SON DAUGHTER CHILD children kids SPOUSE husband wife grandson granddaughter grandchildren grandchild grandkids cousin niece nephew)
  (ALT-DELIVER deliver delivered delivering)
  (ALT-MEAL meal meals food dinner)
))


(READRULES '*give-back-to-community-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (What are some ways I give back to my community ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What are some ways I give back to my community ?) (0 :gist)
  1 (0 .DO 2 you 2 .ALT-VOLUNTEER 0 ?)
    2 (What are some ways I give back to my community ?) (0 :gist)
  ; Specific answers
  1 (0 .ALT-VOLUNTEER 3 .ORGANIZATION-TYPES 0)
    2 ((A way to give back to your community is to volunteer at organization-types \.) (Give-back-to-community)) (0 :gist)
  1 (0 community service 0)
    2 ((A way to give back to your community is to volunteer at community service \.) (Give-back-to-community)) (0 :gist)
  1 (0 .ALT-POLITICS 0)
    2 ((A way to give back to your community is to get involved in politics \.) (Give-back-to-community)) (0 :gist)
  1 (0 .ALT-VISIT 1 .ALT-OTHERS 0)
    2 ((A way to give back to your community is to visit others \.) (Give-back-to-community)) (0 :gist)
  1 (0 .ALT-VOLUNTEER friends 0)
    2 ((A way to give back to your community is to help friends \.) (Give-back-to-community)) (0 :gist)
  1 (0 .ALT-VOLUNTEER 3 .ALT-MONEY 0)
    2 ((A way to give back to your community is to help with money \.) (Give-back-to-community)) (0 :gist)
  1 (0 check 2 .ALT-NEIGHBOR 0)
    2 ((A way to give back to your community is to check on neighbors \.) (Give-back-to-community)) (0 :gist)
  1 (0 .CARE 2 .RELATIVE-TYPES 0)
    2 ((A way to give back to your community is to care for a 4 \.) (Give-back-to-community)) (0 :gist)
  1 (0 .ALT-DELIVER 1 .ALT-MEAL 0)
    2 ((A way to give back to your community is delivering meals \.) (Give-back-to-community)) (0 :gist)
  1 (0 .ALT-DONATE 0)
    2 ((A way to give back to your community is donating money \.) (Give-back-to-community)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for a way to give back to your community \.) (Give-back-to-community)) (0 :gist)
))


(READRULES '*reaction-to-give-back-to-community-input*
'(
  1 (0 volunteer at .ORGANIZATION-TYPES 0)
    2 (0 church 0)
      3 (Helping with church seems like a good experience \. You get to have a direct part in spreading good morality \.) (100 :out)
    2 (0 school 0)
      3 (It\'s great that you are able to pass down your knowledge to future generations \!) (100 :out)
    2 (0 schools 0)
      3 (It\'s great that you are able to pass down your knowledge to future generations \!) (100 :out)
    2 (0 teach 0)
      3 (It\'s great that you are able to pass down your knowledge to future generations \!) (100 :out)
    2 (0 teaching 0)
      3 (It\'s great that you are able to pass down your knowledge to future generations \!) (100 :out)
    2 (0 tutor 0)
      3 (It\'s great that you are able to pass down your knowledge to future generations \!) (100 :out)
    2 (0 tutoring 0)
      3 (It\'s great that you are able to pass down your knowledge to future generations \!) (100 :out)
    2 (0 hospital 0)
      3 (It must be nice helping at a hospital \, knowing that you are helping people get healthy again \.) (100 :out)
    2 (0 hospitals 0)
      3 (It must be nice helping at a hospital \, knowing that you are helping people get healthy again \.) (100 :out)
    2 (0 charity 0)
      3 (Giving to charity is a great way to help those who need it most \.) (100 :out)
    2 (0 kitchen 0)
      3 (Helping make food for other people to eat is an awesome way to give back \!) (100 :out)
    2 (Volunteering is a great way to give back \, it\'s very satisfying to do work to help other people \.) (100 :out)
  1 (0 volunteer at community service 0)
    2 (Community service is a great way to give back \, it\'s very satisfying to do work to help other people \.) (100 :out)
  1 (0 get involved in politics 0)
    2 (Getting involved in local politics is pretty important \. You get to use your experience to help make important decisions about your community \.) (100 :out)
  1 (0 visit others 0)
    2 (Visiting other people is definitely a good way to make friends \!) (100 :out)
  1 (0 .HELP friends 0)
    2 (It\'s always satisfying to help out a friend in need \.) (100 :out)
  1 (0 .HELP with .MONEY 0)
    2 (It can feel pretty good to give financial assistance to people who need it \.) (100 :out)
  1 (0 check on neighbors 0)
    2 (It\'s very kind to check on your neighbords now and then \.) (100 :out)
  1 (0 .CARE for a .RELATIVE-TYPES 0)
    2 (It must make your 5 very happy to know you are there to care for them \!) (100 :out)
  1 (0 delivering meals 0)
    2 (That\'s very kind \, to help deliver food for other people to eat \.) (100 :out)
  1 (0 donating .MONEY 0)
    2 (Giving to charity is a great way to help those who need it most \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I feel very satisfied when I have the chance to give back to the community \.) (100 :out)
))