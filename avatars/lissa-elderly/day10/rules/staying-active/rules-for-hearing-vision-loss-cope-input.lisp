;;  What ways have you, or someone close to you, coped with hearing or vision loss? For example some people ask for help or put their glasses in their purse.
;;	(0 to cope with hearing or vision loss 0)
;;	hearing-vision-loss-cope 
;;	(How one can cope with hearing or vision loss ?)
;;	(3 how 2 cope with hearing 2 vision loss 3)
;; MEETING WITH KIM NOTES (8/8/2017)
;; Have their glasses
;; Not go to noisy environments
;; Accepting that it is part of growing older
;; Focusing on the positives
;; Get several glasses
;; Ask other people for help
(MAPC 'ATTACHFEAT
'(
  (ALT-ENVIRONMENTS environments places venues areas)
  (ALT-FOCUS focus focusing looking)
  (ALT-POSITIVES positives positive good)
  (ALT-HAVE HAVE having get getting buy buying)
  (ALT-AID aid aids)
))


(READRULES '*hearing-vision-loss-cope-input*
'(
  ; Questions
  1 (0 what 2 you 0 ?)
    2 (How one can cope with hearing or vision loss ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (How one can cope with hearing or vision loss ?) (0 :gist)
  ; Specific answers
  1 (0 .ALT-HAVE 2 glasses 0)
    2 ((To cope with hearing or vision loss you have your glasses \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0 hearing 1 .ALT-AID 0)
    2 ((To cope with hearing or vision loss you have your hearing aids \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0 .NEG 2 noisy .ALT-ENVIRONMENTS 0)
    2 ((To cope with hearing or vision loss you avoid noisy environments \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0 avoid 2 noisy .ALT-ENVIRONMENTS 0)
    2 ((To cope with hearing or vision loss you avoid noisy environments \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0 stay away 2 noisy .ALT-ENVIRONMENTS 0)
    2 ((To cope with hearing or vision loss you avoid noisy environments \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0 accepting 5 growing older 0)
    2 ((To cope with hearing or vision loss you accept that it is part of growing older \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0 .ALT-FOCUS 2 .ALT-POSITIVES 0)
    2 ((To cope with hearing or vision loss you focus on the positives \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0 ask 2 for 1 .HELP 0)
    2 ((To cope with hearing or vision loss you ask for help \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0 .NEG 2 .HAVE 2 hearing or vision loss 0)
    2 ((You do not need to cope with hearing or vision loss \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0 .NEG 3 cope 0)
    2 ((To cope with hearing or vision loss you do not do anything \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0 .NEG 2 .DO anything 0)
    2 ((To cope with hearing or vision loss you do not do anything \.) (Hearing-vision-loss-cope)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how to cope with hearing or vision loss \.) (Hearing-vision-loss-cope)) (0 :gist)
))


(READRULES '*reaction-to-hearing-vision-loss-cope-input*
'(
  1 (0 to cope with hearing or vision loss 2 .HAVE your glasses 0)
    2 (Glasses are a very easy fix to vision loss \. They can be quite stylish too \!) (100 :out)
  1 (0 to cope with hearing or vision loss 2 .HAVE your hearing aids 0)
    2 (It seems like hearing aids can help very much with hearing loss \.) (100 :out)
  1 (0 to cope with hearing or vision loss 2 avoid noisy environments 0)
    2 (I hate noisy environments myself \, they give me headaches \.) (100 :out)
  1 (0 to cope with hearing or vision loss 2 accept 3 part of growing older 0)
    2 (It\'s true that there are some things that are unavoidable with growing older \. Hopefully you can make the best of it though \.) (100 :out)
  1 (0 to cope with hearing or vision loss 2 focus on the positives 0)
    2 (It\'s always good to focus on the positives of anything that happens \.) (100 :out)
  1 (0 to cope with hearing or vision loss 2 ask for .HELP 0)
    2 (It\'s good that you understand that people are happy to help you if you need it \.) (100 :out)
  1 (0 to cope with hearing or vision loss 2 .NEG .DO anything 0)
    2 (Sometimes coping with changes can be difficult \. If you have problems with hearing or vision loss \, I hope you can find a way to cope successfully \.) (100 :out)
  1 (0 .NEG need to cope with hearing or vision loss 0)
    2 (That\'s awesome that you don\'t have any major problems with hearing or vision loss \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Sometimes coping with changes can be difficult \. If you have problems with hearing or vision loss \, I hope you can find a way to cope successfully \.) (100 :out)
))