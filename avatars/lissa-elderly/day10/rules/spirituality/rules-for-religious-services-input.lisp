;;  Do you attend religious services?
;;	(0 go to 3 religious services 0) 
;;	religious-services
;;	(Do you attend religious services ?)
;;	(3 Do you 3 religious services 3)
;; MEETING WITH KIM NOTES (8/8/2017)
;; Temple, church, synagogue, etc.
;; Just once a while
;; Used to go but now they can’t drive, 
(MAPC 'ATTACHFEAT
'(
))


(READRULES '*religious-services-input*
'(
  ; Questions
  1 (0 what religion 2 you 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 are 2 you 2 religious 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 .DO 2 you 2 follow 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 what 2 you 0 ?)
    2 (Do I attend religious services ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (Do I attend religious services ?) (0 :gist)
  1 (0 .DO 2 you 2 attend 0 ?)
    2 (Do I attend religious services ?) (0 :gist)
  ; Specific answers
  1 (0 synagogue 0)
    2 ((You go to synagogue for religious services \.) (Religious-services)) (0 :gist)
  1 (0 church 0)
    2 ((You go to church for religious services \.) (Religious-services)) (0 :gist)
  1 (0 christian 0)
    2 ((You go to church for religious services \.) (Religious-services)) (0 :gist)
  1 (0 mosque 0)
    2 ((You go to mosque for religious services \.) (Religious-services)) (0 :gist)
  1 (0 once in a while 0)
    2 ((You go to religious services once in a while \.) (Religious-services)) (0 :gist)
  1 (0 used to 2 but 5 .NEG drive 0)
    2 ((You used to go to religious services but now do not drive \.) (Religious-services)) (0 :gist)
  1 (0 .POS 2 attend 0)
    2 ((You go to religious services \.) (Religious-services)) (0 :gist)
  1 (0 .NEG 1 attend 0)
    2 ((You do not go to religious services \.) (Religious-services)) (0 :gist)
  1 (0 .NEG 1 go 0)
    2 ((You do not go to religious services \.) (Religious-services)) (0 :gist)
  1 (0 .NEG religious 0)
    2 ((You do not go to religious services \.) (Religious-services)) (0 :gist)
  1 (0 athiest 0)
    2 ((You do not go to religious services \.) (Religious-services)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for if you go to religious services \.) (Religious-services)) (0 :gist)
))


(READRULES '*reaction-to-religious-services-input*
'(
  1 (0 go to synagogue for religious services 0)
    2 (It\'s nice that you still go to synagogue \, I think religion can give someone hope in bad times \.) (100 :out)
  1 (0 go to church for religious services 0)
    2 (It\'s nice that you still go to church \, I think religion can give someone hope in bad times \.) (100 :out)
  1 (0 go to mosque for religious services 0)
    2 (It\'s nice that you still go to a mosque \, I think religion can give someone hope in bad times \.) (100 :out)
  1 (0 go to religious services once in a while 0)
    2 (It\'s nice that you still go to religious services \, I think religion can give someone hope in bad times \.) (100 :out)
  1 (0 used to go to religious services 3 .NEG drive 0)
    2 (It\'s too bad that you can\'t go to services anymore \. Maybe someone can drive you once in a while though \.) (100 :out)
  1 (0 .NEG go to religious services 0)
    2 (It\'s perfectly fine to not go to religious services \, everyone has their own way of introspection I think \.) (100 :out)
  1 (0 go to religious services 0)
    2 (It\'s nice that you still go to religious services \, I think religion can give someone hope in bad times \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I think religion can give someone hope in bad times \, though I don\'t go to religious services myself \.) (100 :out)
))