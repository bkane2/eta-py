;; 	I like to exercise my brain as well as my body. What are some ways you keep your brain active as you age?
;;	(0 to keep my mind active 0)
;;	keep-brain-active
;;	(How can you keep your brain active ?)
;;	(3 How 2 keep your brain active 3)
;; MEETING WITH KIM NOTES (8/8/2017)
;; Reading the newspaper
;; Reading book
;; Groups activity
;; Play card games
;; Sudoku
;; Church
;; Work volunteer
;; Puzzles
(MAPC 'ATTACHFEAT
'(
  (ALT-RELIGION church synagogue mosque)
  (ALT-LEARN learn learning education course courses study studying research researching)
))


(READRULES '*keep-brain-active-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (How can I keep my brain active ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (How can I keep my brain active ?) (0 :gist)
  ; Specific answers
  1 (0 read 2 newspaper 0)
    2 ((To keep your mind active you read newspaper \.) (Keep-brain-active)) (0 :gist)
  1 (0 read 2 book 0)
    2 ((To keep your mind active you read books \.) (Keep-brain-active)) (0 :gist)
  1 (0 group 2 activity 0)
    2 ((To keep your mind active you do group activities \.) (Keep-brain-active)) (0 :gist)
  1 (0 card games 0)
    2 ((To keep your mind active you play card games \.) (Keep-brain-active)) (0 :gist)
  1 (0 board games 0)
    2 ((To keep your mind active you play board games \.) (Keep-brain-active)) (0 :gist)
  1 (0 sudoku 0)
    2 ((To keep your mind active you play sodoku \.) (Keep-brain-active)) (0 :gist)
  1 (0 crossword 0)
    2 ((To keep your mind active you do crossword puzzles \.) (Keep-brain-active)) (0 :gist)
  1 (0 puzzles 0)
    2 ((To keep your mind active you play puzzles \.) (Keep-brain-active)) (0 :gist)
  1 (0 .ALT-RELIGION 0)
    2 ((To keep your mind active you go to 2 \.) (Keep-brain-active)) (0 :gist)
  1 (0 volunteer 0)
    2 ((To keep your mind active you volunteer \.) (Keep-brain-active)) (0 :gist)
  1 (0 .ALT-LEARN 0)
    2 ((To keep your mind active you learn more \.) (Keep-brain-active)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how to keep your mind active \.) (Keep-brain-active)) (0 :gist)
))


(READRULES '*reaction-to-keep-brain-active-input*
'(
  1 (0 to keep your mind active 2 read newspaper 0)
    2 (It\'s great that you read the newspaper \, it\'s important to stay in touch with the news \.) (100 :out)
  1 (0 to keep your mind active 2 read books 0)
    2 (There are so many good books out there \, I just wish I could read them all \.) (100 :out)
  1 (0 to keep your mind active 2 .DO group activities 0)
    2 (Doing group activities is good for keeping your social skills sharp \.) (100 :out)
  1 (0 to keep your mind active 2 play card games 0)
    2 (Card games are a lot of fun \, I am not great at them though \.) (100 :out)
  1 (0 to keep your mind active 2 play board games 0)
    2 (I\'m generally not a big fan of board games \. I love chess though \!) (100 :out)
  1 (0 to keep your mind active 2 play sodoku 0)
    2 (Sodoku is a nice way to pass time \, it can be challenging sometimes though \.) (100 :out)
  1 (0 to keep your mind active 2 .DO crossword puzzles 0)
    2 (You have to have a lot of random knowledge to do crossword puzzles \. They\'re lots of fun though \.) (100 :out)
  1 (0 to keep your mind active 2 play puzzles 0)
    2 (Doing puzzles is an excellent way to sharpen your mind and have fun at the same time \.) (100 :out)
  1 (0 to keep your mind active 2 go to .ALT-RELIGION 0)
    2 (I think going to religious services is a good way to stay part of a community too \.) (100 :out)
  1 (0 to keep your mind active 2 volunteer 0)
    2 (It\'s great that you can still maintain a sense of your community by volunteering \.) (100 :out)
  1 (0 to keep your mind active 2 learn more 0)
    2 (It\'s amazing how even when you think you know it all \, there\'s always something more to learn \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I love doing small puzzles every day to try to keep my brain active \.) (100 :out)
))