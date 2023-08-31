; November 25, 2019
;=================================================================
; Word data used in the context of the blocksworld dialogue.
; Factored out so as to avoid duplication in the various rule files.
;
(MAPC 'ATTACHFEAT
'(
  (CORP adidas burger_king esso heineken hp mcdonalds mercedes nvidia pepsi shell sri sri_international starbucks texaco target toyota twitter)
  (BLOCK blocks)
  (TABLE tables)
  (STACK stacks)
  (ROW rows)
  (EDGE edges)
  (FACE faces)
  (PLANE planes)
  (LINE lines)
  (CIRCLE circles)
  (PILE piles)
  (OBJECT objects)
  (COLOR colors)
  (STRUCTURE structures)
  (DIRECTION DIRECTIONS)
  (WAY ways)
  (OTHER others)
  (ONE ones)
  (THING things)
  (TURN turns)
  (TIME times)
  (STAGE stages)
  (STEP steps)
  (QUESTION questions)
  (UTTERANCE utterances)
  (ITERATION iterations)
  (MOVE moves)
  (ACTION actions)
  (PERIOD periods)
  (START starts)
  (BEGINNING beginnings)
  (WHILE whiles)
  (SECOND seconds)
  (MINUTE minutes)
  (HOUR hours)
  (UNDER underneath supporting SUPPORT)
  (CLOSE next)
  (TOUCHING face-to-face abutting against flush)
  (FARTHEST furthest)
  (ROTATED angled swivelled turned)
  (TOUCH touches touched)
  (SUPPORT supports supported)
  (CONNECT connects connected)
  (CONSIST_OF consists_of consisted_of)
  (SIT sits sat)
  (ADJOIN adjoins adjoined)
  (FLANK flanks flanked)
  (FACE faces faced)
  (MOVE moves moved)
  (PUT puts)
  (CHANGE changes changed)
  (PICK_UP picks_up picked_up)
  (ROTATE rotates ROTATED)
  (PLACE places placed)
  (VERB-REL-PAST touched supported connected consisted_of sat adjoined flanked faced moved puts changed picked_up ROTATED placed)
  (PREP-BW on on_to UNDER in behind near TOUCHING facing abutting between from below beneath above next_to close_to near_to visible on_top_of to_the_left_of to_the_right_of in_front_of adjacent_to flush_with towards)
  (PREP-WHERE-ADV relative_to with_respect_to)
  (REL-ADJ near CLOSE TOUCHING facing adjacent flush central)
  (QUAL-ADJ purple blue green yellow orange red pink gray grey black white brown clear visible nearby)
  (NUM-ADJ TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN ELEVEN TWELVE many)
  (SUP-ADJ leftmost rightmost furthest FARTHEST nearest closest highest tallest nearest topmost top uppermost smallest lowest largest centermost shortest backmost longest fewest frontmost)
  (SUP-ADJ-BASE left right far near CLOSE high tall near small low large center central short back long few front)
  (ORD-ADJ first SECOND third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth thirteenth fourteenth fifteenth sixteenth seventeens eighteenth nineteenth twentieth)
  (DIFF-ADJ OTHER different same distinct separate unique)
  (ADJ-BW QUAL-ADJ REL-ADJ NUM-ADJ SUP-ADJ ORD-ADJ DIFF-ADJ)
  (MOD-N ADJ-BW CORP)
  (NOUN-BW BLOCK TABLE STACK ROW EDGE FACE PLANE LINE CIRCLE PILE OBJECT COLOR STRUCTURE left center right back front DIRECTION WAY OTHER ONE THING pyramid wedge arch tower concept)
  (NOUN-TOTAL total all)
  (VERB BE VERB-REL)
  (BE is are was were)
  (VERB-REL TOUCH SUPPORT CONNECT CONSIST_OF SIT ADJOIN FLANK FACE MOVE PUT CHANGE PICK_UP ROTATE PLACE)
  (AUX-BW DO MODAL)
  (ADV-E-NUMBER first SECOND third fourth fifth sixth seventh eighth ninth tenth)
  (ADV-E previously before originally initially currently now recently ever since last finally ADV-E-NUMBER)
  (ADV-F-NUMBER once twice thrice)
  (ADV-F always never ADV-F-NUMBER)
  (ADV-HISTORY ADV-F ADV-E)
  (NOUN-HISTORY TURN TIME STAGE STEP QUESTION UTTERANCE ITERATION MOVE ACTION PERIOD START BEGINNING WHILE past now SECOND MINUTE HOUR MOMENT present future)
  (PREP-HISTORY at in on PREP-HISTORY-SIMPLE)
  (PREP-HISTORY-SIMPLE during within before after when where WHILE prior_to following preceding since from until)
  (PREP-HISTORY-ADJ ago before previously after later)
  (ADJ-HISTORY-MODIFIER-NUMBER ONE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN TWENTY THIRTY FORTY FIFTY SIXTY SEVENTY EIGHTY NINETY hundred)
  (ADJ-HISTORY-MODIFIER few couple ADJ-HISTORY-MODIFIER-NUMBER)
  (ADJ-HISTORY-NUMBER first SECOND third fourth fifth sixth seventh eighth ninth tenth)
  (ADJ-HISTORY previous next current initial original following preceding future last final recent ADJ-HISTORY-NUMBER ADJ-HISTORY-MODIFIER)
  (ADV-HIST-MODIFIER just right directly most)
  (ADV-HIST-NUMBER ONE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN)
  (ADV-HIST-WORD ADV-HISTORY PREP-HISTORY ADJ-HISTORY ADV-HIST-MODIFIER ADV-HIST-NUMBER)
  (ADV_ ADV ADV-HISTORY ADV-HIST-MODIFIER)
  (PREP PREP-BW PREP-HISTORY PREP-WHERE-ADV)
  (ADJ ADJ-BW ADJ-HISTORY)
  (NOUN NOUN-BW NOUN-HISTORY NOUN-TOTAL)
  (NP-BW NP_ NOUN-BW CORP)
))