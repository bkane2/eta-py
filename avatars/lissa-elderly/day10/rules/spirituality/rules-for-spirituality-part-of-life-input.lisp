;; 	Many people I've talked with, tell me they find ways to experience and express some form of spirituality either parts of organized religion or not.
;;	What ways is spirituality a part of your life?
;;	(0 spirituality is not a part of my life 0)
;;	(0 spirituality is a part of my life 0)
;;	spirituality-part-of-life
;;	(What ways is spirituality a part of your life ?)
;;	(3 What ways 2 spirituality a part of your life 3)
;; MEETING WITH KIM NOTES (8/8/2017)
;; Pray
;; Go to services
;; Watching tv programs
;; Doing meditation
;; Reading books
;; Being in nature
(MAPC 'ATTACHFEAT
'(
  (ALT-WATCH watch watching LISTEN listening)
  (ALT-READ read reading)
  (ALT-GIVE give giving show showing teach teaching)
  (ALT-HOPE hope purpose meaning belonging belong mission destiny)
  (ALT-CHARITY charity volunteer volunteering)
))


(READRULES '*spirituality-part-of-life-input*
'(
  ; Questions
  1 (0 what religion 2 you 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 are 2 you 2 religious 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 .DO 2 you 2 follow 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 are 2 you 2 spiritual 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 is spirituality 4 your life 0 ?)
    2 (Am I religious ?) (0 :gist)
  1 (0 what 2 you 0 ?)
    2 (What ways is spirituality a part of my life ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What ways is spirituality a part of my life ?) (0 :gist)
  ; Specific answers
  1 (0 pray 0)
    2 ((Spirituality is a part of your life by praying \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 go 1 services 0)
    2 ((Spirituality is a part of your life by going to services \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 .ALT-WATCH 3 programs 0)
    2 ((Spirituality is a part of your life by watching programs \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 meditation 0)
    2 ((Spirituality is a part of your life by doing meditation \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 being 2 nature 0)
    2 ((Spirituality is a part of your life by being in nature \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 .ALT-READ 1 books 0)
    2 ((Spirituality is a part of your life by reading books \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 .ALT-GIVE 4 .ALT-HOPE 0)
    2 ((Spirituality is a part of your life by giving you hope \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 .ALT-CHARITY 0)
    2 ((Spirituality is a part of your life by doing charity \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 giving 1 back 0)
    2 ((Spirituality is a part of your life by doing charity \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 .NEG 1 sure 0)
    2 ((Spirituality is not a part of your life \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 .NEG 1 know 0)
    2 ((Spirituality is not a part of your life \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 it 2 .NEG 0)
    2 ((Spirituality is not a part of your life \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 .NEG 1 spiritual 0)
    2 ((Spirituality is not a part of your life \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0 am 2 athiest 0)
    2 ((Spirituality is not a part of your life \.) (Spirituality-part-of-life)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for if spirituality is a part of your life \.) (Spirituality-part-of-life)) (0 :gist)
))


(READRULES '*reaction-to-spirituality-part-of-life-input*
'(
  1 (0 spirituality is a part of your life 2 praying 0)
    2 (Sometimes praying can help guide your choice in tough decisions \.) (100 :out)
  1 (0 spirituality is a part of your life 2 going to services 0)
    2 (Going to services sounds like a good way of being part of a community \.) (100 :out)
  1 (0 spirituality is a part of your life 2 watching programs 0)
    2 (Watching programs about spirituality must be very educational \.) (100 :out)
  1 (0 spirituality is a part of your life 2 doing meditation 0)
    2 (I think it\'s very good for a person to spend some time meditating every day \.) (100 :out)
  1 (0 spirituality is a part of your life 2 being in nature 0)
    2 (Spending time in nature every day can be very refreshing \.) (100 :out)
  1 (0 spirituality is a part of your life 2 reading books 0)
    2 (Reading books about spirituality must be very educational \.) (100 :out)
  1 (0 spirituality is a part of your life 2 giving you hope 0)
    2 (It\'s good to stay hopeful about the future and to understand your purpose in the world \.) (100 :out)
  1 (0 spirituality is a part of your life 2 doing charity 0)
    2 (It\'s awesome that giving back to the community is meaningful to you \!) (100 :out)
  1 (0 spirituality is .NEG 2 part of your life 0)
    2 (It\'s okay to not be spiritual \, there are other ways to find meaning in life \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (It\'s important to find meaning in your life \. I think spirituality is a common way to do this \, though there are others too \.) (100 :out)
))