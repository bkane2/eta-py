;;  Retirement is a common life transition\. Tell me about the best part of the retirement that you experienced or someone you know\.
;;	(0 best part 2 retirement 0)
;;	retirement-best-part
;;	(what is the best part of the retirement ?)
;;	(3 what 2 best part 2 retirement 3)
;; MEETING WITH KIM NOTES (8/4/2017)
;; New question prompt: "Retirement is a common life transition. Tell me about the best parts of retirement that you've
;; experienced or that someone you know has experienced."
;; There aren't any good things / I hate retirement
;; Response: "Think about the most positive person you know. What would that person say?"
;; Hated their job
;; Really excited to spend more time with family
;; Time to relax
;; To travel
;; To learn new/more things
;; Sleep in
;; Spend time with grandkids / more time to be with grandkids
;; Time for volunteering
(MAPC 'ATTACHFEAT
'(
  (ALT-HATED hated disliked TIRED bored DISLIKE disliked)
  (ALT-WORK WORK working job)
  (ALT-RELAX relax relaxing unwind)
  (ALT-TRAVEL travel travelling vacation vacations)
  (ALT-LEARN learn learning discover discovering experience experiencing)
  (ALT-NEW new more)
  (ALT-SLEEP sleep sleeping rest resting)
  (ALT-SLEEP-IN in more later better)
))


(READRULES '*retirement-best-part-input*
; NOTE: Proposed new gist clause: "(0 best part of retirement is 0)"
; Needs new tag
'(
  ; Questions
  1 (0 are 2 you 2 working ?)
    2 (Am I still working ?) (0 :gist)
  1 (0 .HAVE 2 you 2 retired ?)
    2 (Am I still working ?) (0 :gist)
  1 (0 what 2 you 2 .WORK ?)
    2 (Am I still working ?) (0 :gist)
  1 (0 what 2 you 0 ?)
    2 (What was the best part of retirement ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (What was the best part of retirement ?) (0 :gist)
  ; Specific answers
  1 (0 .ALT-HATED 2 .ALT-WORK 0)
    2 ((The best part of retirement is that you hated working \.) (Retirement-best-part)) (0 :gist)
  1 (0 .ALT-SLEEP 1 .ALT-SLEEP-IN 0)
    2 ((The best part of retirement is that you can get more sleep \.) (Retirement-best-part)) (0 :gist)
  1 (0 .ALT-SLEEP-IN 1 .ALT-SLEEP 0)
    2 ((The best part of retirement is that you can get more sleep \.) (Retirement-best-part)) (0 :gist)
  1 (0 .ALT-LEARN 1 .ALT-NEW 0)
    2 ((The best part of retirement is that you can learn new things \.) (Retirement-best-part)) (0 :gist)
  1 (0 .ALT-RELAX 0)
    2 ((The best part of retirement is that you have time to relax \.) (Retirement-best-part)) (0 :gist)
  1 (0 .ALT-TRAVEL 0)
    2 ((The best part of retirement is that you can travel more \.) (Retirement-best-part)) (0 :gist)
  1 (0 time 3 .RELATIVE-TYPES 0)
    2 ((The best part of retirement is that you can spend more time with 4 \.) (Retirement-best-part)) (0 :gist)
  1 (0 hang out 3 .RELATIVE-TYPES 0)
    2 ((The best part of retirement is that you can spend more time with 5 \.) (Retirement-best-part)) (0 :gist)
  1 (0 time 3 friends 0)
    2 ((The best part of retirement is that you can spend more time with 4 \.) (Retirement-best-part)) (0 :gist)
  1 (0 hang out 3 friends 0)
    2 ((The best part of retirement is that you can spend more time with 5 \.) (Retirement-best-part)) (0 :gist)
  1 (0 .ALT-VOLUNTEER 0)
    2 ((The best part of retirement is that you can spend time volunteering \.) (Retirement-best-part)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for the best part of retirement \.) (Retirement-best-part)) (0 :gist)
))


(READRULES '*reaction-to-retirement-best-part-input*
'(
  1 (0 hated working 0)
    2 (Working can be very stressful sometimes \. It\'s always nice to have more free time \.) (100 :out)
  1 (0 get more sleep 0)
    2 (It\'s always a good feeling when you can sleep in and not feel tired \.) (100 :out)
  1 (0 learn new things 0)
    2 (I am sure retirement leaves plenty of free time to learn and experience new things \.) (100 :out)
  1 (0 time to relax 0)
    2 (Working can be very stressful sometimes \. It\'s always nice to be able to relax more \.) (100 :out)
  1 (0 travel more 0)
    2 (It\'s great to be able to have more free time to take vacations and travel more \.) (100 :out)
  1 (0 spend more time with .RELATIVE-TYPES 0)
    2 (Sometimes you can be so busy with work that you can\'t spend as much time with family \. It must be nice to finally have more time to spend with them \.) (100 :out)
  1 (0 spend time volunteering 0)
    2 (It\'s great to take some time helping with the community \, even after retiring from work \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Working can be very stressful sometimes \. I am sure it must be nice to have some more free time \.) (100 :out)
))