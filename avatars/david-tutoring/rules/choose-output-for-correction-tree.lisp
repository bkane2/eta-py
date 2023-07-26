(MAPC 'ATTACHFEAT
'(
  (SOME a)
  (PUT putting)
  (MOVE moving)
))


(READRULES '*output-for-correction-tree*
'(
  1 (the next .STEP .BE 0 \.)
    ; corrections (e.g. "make the Twitter block by one block to the left")
    2 (0 .MAKE 6 .NOUN-BW 0 \.)
      ; unary change to a block
      3 (0 .MAKE 6 .BLOCK by 6 .NOUN-BW 0 \.)
        4 (You need to move 3 4 6 7 8 \.) (4 :out)
        4 (Well \, no \, 3 4 should be 6 7 8 \.) (4 :out)
        4 (Almost \, but not quite \. 3 4 should be 6 7 8 \.) (4 :out)
        4 (You need to move 3 4 6 7 8 \.) (0 :out)
      ; unary change to some other structure (e.g. a chimney)
      3 (0 .MAKE 6 .NOUN-BW by 6 .NOUN-BW 0 \.)
        4 (Well \, no \, 3 4 should be 6 7 8 \.) (4 :out)
        4 (Almost \, but not quite \. 3 4 should be 6 7 8 \.) (4 :out)
        4 (You need to make 3 4 6 7 8 \.) (4 :out)
        4 (3 4 should be 6 7 8 \.) (0 :out)
      ; relative change to something
      3 (Well \, no \, 3 4 should be 5 \.) (4 :out)
      3 (Almost \, but not quite \. 3 4 should be 5 \.) (4 :out)
      3 (You need to move 3 4 so that it\'s 5 \.) (4 :out)
      3 (3 4 should be 5 \.) (0 :out)
    ; undo commands (e.g. "move the Twitter block back on the Target block")
    2 (0 .MOVE 6 back 0 \.)
      3 NIL (0 :out) ; "undo" actions are to be suppressed, since undoing a
    ; move doesn't necessarily mean putting it back exactly
    ; where it was before.
    ; ordinary proposals
    2 (0 .PUT 0 \.)
      ; indefinite reference (e.g. "put some block on the Twitter block")
      ; TODO: need to support adj modifiers, but planner doesn't yet support these
      3 (.PUT .SOME .BLOCK 0 \.)
        4 (Not quite \. You need to put a block 5 \.) (4 :out)
        4 (Well \, no \, there needs to be a block 5 \.) (5 :out)
        4 (Some block should be 5 \.) (7 :out)
        4 (That doesn\'t seem to be right \. A block should be 5 \.) (4 :out)
        4 (A block needs to be 5 \.) (0 :out)
      ; specific reference (e.g. "put the Twitter block on the Texaco block")
      3 (0 .PUT 0 \.)
        4 (Not quite \. You need to put 3 \.) (4 :out)
        4 (Well \, no \, you have to place 3 \.) (5 :out)
        4 (You should put 3 \.) (7 :out)
        4 (That doesn\'t seem to be right \. You should put 3 \.) (4 :out)
        4 (You need to put 3 \.) (0 :out)
))