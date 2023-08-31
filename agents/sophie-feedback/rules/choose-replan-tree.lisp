; Transduction tree for selecting an appropriate subplan conditional on the quoted contents of a
; (^me want.v (that (^me know.v (ans-to '(...))))) goal statement, in the case of a failure of a
; schema to accomplish that goal.
;
; TODO: currently this only supports goal statements above the above type, due to the lack of support
; for matching LFs to patterns in transduction trees, but once this support is added, these rules
; should support any (^me want.v (that ...)) goal statement.
;
(READRULES '*replan-tree*
'(
))