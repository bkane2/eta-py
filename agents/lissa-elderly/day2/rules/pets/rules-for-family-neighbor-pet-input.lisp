;; Tell me about a pet of a family member or neighbor
;;	family-neighbor-pet
;;	(0 my family member has 0) (0 my neighbor has 0)
;;		gist question: (1 Tell me about 2 pet 3 family 2 neighbor 3) 
(MAPC 'ATTACHFEAT
'(
  (FAMILY-MEMS SON DAUGHTER grandchild grandchildren grandson granddaughter niece nephew cousin relative CHILD children)
  (FAMILY-MEMS-POSSESSIVE son\'s daughter\'s grandchild\'s grandchildren\'s grandson\'s granddaughter\'s niece\'s nephew\'s cousin\'s relative\'s child\'s children\'s)
  (NEIGHBOR-REF neighbor neighbors)
  (HAD has)
  (NOISE noises sound BARK barks barking)
  (BARK barks barking)
))


(READRULES '*family-neighbor-pet-input*
'(
  ; Reciprocal questions
  1 (0 what 2 you 0 ?)
    2 (Tell you about a pet of a family member or neighbor) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (Tell you about a pet of a family member or neighbor) (0 :gist)
  ; Specific answers
  1 (0 .FAMILY-MEMS .VERB-OWN 2 .PET-TYPES 0)
    2 ((Your family member has a 5 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0 .FAMILY-MEMS 1 got 2 .PET-TYPES 0)
    2 ((Your family member has a 6 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0 .FAMILY-MEMS-POSSESSIVE 2 .PET-TYPES 0)
    2 ((Your family member has a 4 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0 .NEIGHBOR-REF .VERB-OWN 2 .PET-TYPES 0)
    2 ((Your neighbor has a 5 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0 .NEIGHBOR-REF 1 got 2 .PET-TYPES 0)
    2 ((Your neighbor has 6 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0 neighbor\'s 2 .PET-TYPES 0)
    2 ((Your neighbor has 4 \.) (Family-neighbor-pet)) (0 :gist)
  ; 1 (0 pet-types 0)
  ;   2 ((Your family or your neighbor has a pet 2 \.)  (Family-neighbor-pet)) (0 :gist)
  ;; NOTE 1: Needs gist clauses for "I'm not sure about my family member/neighbor's pets"
  ;; or "My family member/neighbors don't have pets"
  1 (0 .PET-TYPES 1 died 0) ;
    2 ((Your family member or your neighbor had a 2 but it died \.) (Have-a-pet)) (0 :gist)
  1 (0 killed 0) ;
    2 ((Your family member or your neighbor had a pet but it died \.) (Have-a-pet)) (0 :gist)
  1 (0 put 1 down 0) ;; 
    2 ((Your family member or your neighbor had a pet but it died \.) (Have-a-pet)) (0 :gist)
  1 (0 neighbor 3 .PET-TYPES 5 .NEG clean 2 after 0)
    2 ((Your neighbor has a 2 and they do not clean up after it \.) (Have-a-pet)) (0 :gist)
  1 (0 neighbor 3 .PET-TYPES 5 .BARK 0)
    2 ((Your neighbor has a 2 and it barks a lot \.) (Have-a-pet)) (0 :gist)
  1 (0 neighbor 3 .PET-TYPES 5 .NOISE 0)
    2 ((Your neighbor has a 2 and it makes a lot of noise \.) (Have-a-pet)) (0 :gist)
  1 (0 neighbor 3 .PET-TYPES 5 annoying 0)
    2 ((Your neighbor has a 2 and it is very annoying \.) (Have-a-pet)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what pet your neighbor has \.) (Have-a-pet)) (0 :gist)
))


(READRULES '*reaction-to-family-neighbor-pet-input*
'(
  1 (0 .FAMILY member has 2 .PET-TYPES 0)
    2 (0 .PET-CAT 0)
      3 (It must be nice to be able to pet their cat when you visit \.) (100 :out)
    2 (0 .PET-DOG 0)
      3 (It must be nice to be able to pet their dog when you visit \.) (100 :out)
    2 (0 .PET-BIRD 0)
      3 (That\'s cool \, it must be fun to look at their bird when you visit \.) (100 :out)
    2 (0 .PET-FISH 0)
      3 (That\'s cool \, it must be fun to look at their fish when you visit \.) (100 :out)
    2 (0 .PET-OTHER 0)
      3 (That\'s cool \, it must be fun to look at their pet when you visit \.) (100 :out)
    2 (That\'s cool \, it must be fun to look at their pet when you visit \.) (100 :out)
  1 (0 neighbor has 2 .PET-TYPES 0)
    2 (0 died 0)
      3 (it is always sad when a pet dies \. especially if you .HAVE spent a lot of time with it \.)
    2 (0 .PET-CAT 0)
      3 (Interesting \. I believe cats are the best pets \! They are easy to keep and just cute \.) (100 :out)
    2 (0 .PET-DOG 0)
      3 (Interesting \. I love dogs \. They are loyal and funny \. Though a little bit hard to be taken care of \.) (100 :out)
    2 (0 .PET-BIRD 0)
      3 (Interesting \. My sister used to have two birds as her pet \. She was very happy with them \. I have never had a bird though \.) (100 :out)
    2 (0 .PET-FISH 0)
      3 (Interesting \. My sister used to have some beautiful fishes as her pet \. She was very happy with them \. I haven\'t had a fish though. \.) (100 :out)
    2 (0 .PET-OTHER 0)
      3 (Interesting \. Most of people just like to have a cat or a dog \. It would be a nice experience to have other types of pets \.) (100 :out)
    2 (0 .BARK 0)
      3 (The constant noise of a barking dog can be extremely annoying \. Their owner should definitely fix it \.) (100 :out)
    2 (0 .NOISE 0)
      3 (Some pets make extremely annoying noises \. Their owner should definitely fix it \.) (100 :out)
    2 (0 annoying 0)
      3 (Some pets are really troublesome for the neighbors \. The owners are responsible to take care of that \.) (100 :out)
    2 (0 clean up 0)
      3 (Anyone who has a pet should be responsible to clean up after their pets \. It would be extremely annoying if they don\'t \.) (100 :out)
    2 (Pets in neighborhood are cool \, as long as the owner takes care of them well \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I prefer my neighbors to not have pets because they can be loud \, but they can also be cute too \.) (100 :out)
))