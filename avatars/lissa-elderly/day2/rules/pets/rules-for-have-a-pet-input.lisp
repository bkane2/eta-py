;; Do you have a pet at home ?
;;	(have-a-pet)
;; 	from-have-a-pet-input
;;	(0 I do not have a pet 0)  (0 my pet is 0)
;;		gist question: (2 do 1 have 1 pet 3)
(MAPC 'ATTACHFEAT
'(
  (FIRST-PER-PRON I we)
  (FIRST-PER-PRON-POS my our)
  (VERB-OWN HAVE has own owns keep keeps VERB-OWN-PAST)
  (VERB-OWN-PAST HAD owned kept)
  (VERB-GOT got adopted)
  (ALT-ALLERGIES allergies allergic)
  (PET-TYPES PET-CAT PET-DOG PET-BIRD PET-FISH PET-OTHER pet pets)
  (PET-CAT cat cats kitten kittens kitty kitty kitties)
  (PET-DOG dog dogs puppy puppies pup mutt mutts hound hounds lab labs labrador husky huskies pug pugs beagle beagles poodle poodles bulldog bulldogs terrier terriers chihuahua chihuahuas retriever retrievers)
  (PET-BIRD bird birds parakeet parakeets parrot parrots canary canaries)
  (PET-FISH fish goldfish)
  (PET-OTHER bunny bunnies rabbit rabbits gerbil gerbils hamster hamsters guinea lizard lizards snake snakes turtle turtles)
  (FEW a ONE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN ELEVEN)
))


(READRULES '*have-a-pet-input*
'(
  ; Reciprocal questions
  1 (0 .DO 2 you 0 ?)
    2 (Do I have a pet at home ?) (0 :gist)
  1 (0 what 2 you 0 ?)
    2 (Do I have a pet at home ?) (0 :gist)
  1 (0 how 2 you 0 ?)
    2 (Do I have a pet at home ?) (0 :gist)
  1 (0 your pet 0 ?)
    2 (Do I have a pet at home ?) (0 :gist)
  ; Specific answers
  1 (0 .FIRST-PER-PRON 1 .NEG 1 .VERB-OWN 0) ;; I do not have any pets
    2 ((You do not have a pet \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON .VERB-OWN 2 robotic .PET-TYPES 0) ;; I have a robotic cat
    2 ((Your pet is a robotic 6 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON 2 .VERB-GOT 2 robotic .PET-TYPES 0) ;; I got a robotic cat
    2 ((Your pet is a robotic 7 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON .VERB-OWN 2 .PET-TYPES and 2 .PET-TYPES 0) ;; I own a dog and two lovely cats
    2 ((Your pet is a 5 and 8 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON 2 .VERB-GOT 2 .PET-TYPES and 2 .PET-TYPES 0) ;; I adopted a dog and a cat
    2 ((Your pet is a 6 and 9 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON .VERB-OWN 2 .PET-TYPES 0) ;; We have two birds
    2 ((Your pet is a 5 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON 2 .VERB-GOT 2 .PET-TYPES 0) ;; I went and adopted a small dog
    2 ((Your pet is a 6 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON-POS 1 .PET-TYPES 1 died 0) ;; Our poor cat died
    2 ((You do not have a pet because your 4 died \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON .VERB-OWN-PAST 2 .PET-TYPES 3 died 0) ;; I had a lovely poodle but unfortunately it died
    2 ((You do not have a pet because your 5 died \.) (Have-a-pet)) (0 :gist)
  1 (0 .FEW 2 robotic .PET-TYPES 0) ;; I have a robotic cat
    2 ((Your pet is a robotic 5 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FEW 2 robotic .PET-TYPES 0) ;; I got a robotic cat
    2 ((Your pet is a robotic 5 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FEW 2 .PET-TYPES 1 and 1 .FEW 2 .PET-TYPES 0) ;; I own a dog and two lovely cats
    2 ((Your pet is 2 4 and 8 10 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FEW 2 .PET-TYPES 0) ;; We have two birds
    2 ((Your pet is 2 4 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FEW 2 .PET-TYPES 3 died 0) ;; I had a lovely poodle but unfortunately it died
    2 ((You do not have a pet because your 4 died \.) (Have-a-pet)) (0 :gist)
  1 (0 killed 0) ;; I used to have a cat, but it was killed by a car
    2 ((You do not have a pet because it died \.) (Have-a-pet)) (0 :gist)
  1 (0 put 1 down 0) ;; I used to have a dog, but we had to put it down
    2 ((You do not have a pet because it died \.) (Have-a-pet)) (0 :gist)
  1 (0 .NEG 1 allow 1 pets 0) ;; My apartment didn't allow any pets
    2 ((You do not have a pet because where you live does not allow pets \.) (Have-a-pet)) (0 :gist)
  1 (0 .NEG 1 allow 1 .PET-TYPES 0) ;; My apartment doesn't really allow cats
    2 ((You do not have a pet because where you live does not allow pets \.) (Have-a-pet)) (0 :gist)
  1 (0 .NEG 10 .ALT-ALLERGIES 0) ;; No, I would get a cat but I have really bad allergies
    2 ((You do not have a pet because you have allergies \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON 1 .VERB-OWN-PAST 2 .PET-TYPES but 0)
    2 ((You do not have a pet but you used to have a 6 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON 1 used to 3 .PET-TYPES but 0)
    2 ((You do not have a pet but you used to have a 7 \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON never 2 pets 0) ;; I never wanted any pets
    2 ((You do not have a pet \.) (Have-a-pet)) (0 :gist)
  1 (0 .FIRST-PER-PRON .DO not 0) ;; I never wanted any pets
    2 ((You do not have a pet \.) (Have-a-pet)) (0 :gist)
  1 (no 1 .FIRST-PER-PRON 0) ;; I never wanted any pets
    2 ((You do not have a pet \.) (Have-a-pet)) (0 :gist)
  ; Unbidden answers
  1 (0 .FAMILY-MEMS .VERB-OWN 2 .PET-TYPES 0)
    2 ((Your family member has a pet 5 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0 .FAMILY-MEMS 1 got 2 .PET-TYPES 0)
    2 ((Your family member has a pet 6 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0 .FAMILY-MEMS-POSSESSIVE 2 .PET-TYPES 0)
    2 ((Your family member has a pet 4 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0 .NEIGHBOR-REF .VERB-OWN 2 .PET-TYPES 0)
    2 ((Your neighbor has a pet 5 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0 .NEIGHBOR-REF 1 got 2 .PET-TYPES 0)
    2 ((Your neighbor has a pet 6 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0 neighbor\'s 2 .PET-TYPES 0)
    2 ((Your neighbor has a pet 4 \.) (Family-neighbor-pet)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for what your pet is \.) (Have-a-pet)) (0 :gist)
))


(READRULES '*reaction-to-have-a-pet-input*
'(
  1 (0 robotic .PET-TYPES 0)
    2 (Oh \, a robotic pet seems interesting \. Must be a lot easier to take care of too \.) (100 :out)
  1 (0 .PET-TYPES and .PET-TYPES 0)
    2 (Wow \, you have a lot of pets \. I would like to have many pets one day \.) (100 :out)
  1 (0 .PET-TYPES 0)
    2 (0 .PET-CAT 0)
      3 (I love cats \, they\'re so small and cute \.) (100 :out)
    2 (0 .PET-DOG 0)
      3 (I am more of a cat person myself \, but your 2 must be really cute \.) (100 :out)
    2 (0 .PET-BIRD 0)
      3 (Having a pet bird seems really cool \. I think the ones that mimic their owners are funny \.) (100 :out)
    2 (0 .PET-FISH 0)
      3 (Fish must make a nice pet \. They\'re easy to take care of but fun to watch \.) (100 :out)
    2 (0 .PET-OTHER 0)
      3 (That sounds pretty neat \. I don\'t meet many people with that type of pet \.) (100 :out)
  1 (0 .DO not .HAVE 1 pet 3 died 0)
    2 (I am sorry for your loss \. It\'s always sad when a pet dies \.) (100 :out)
  1 (0 .DO not .HAVE 1 pet 5 not allow 0)
    2 (That\'s too bad \. I guess sometimes you have to make sacrifices when moving to a new home \.) (100 :out)
  1 (0 .DO not .HAVE 1 pet 3 allergies 0)
    2 (I understand \. Having allergies can make owning a pet difficult \.) (100 :out)
  1 (0 .DO not .HAVE 1 pet 2 used to 2 .PET-TYPES 0)
    2 (Your 11 must have been nice while you had them \. It\'s too bad you don\'t anymore \.) (100 :out)
  1 (0 .DO not .HAVE 1 pet 0)
    2 (I understand \. I think having a pet can be difficult sometimes \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (Pets can be nice companions \, though not everyone decides to have them \.) (100 :out)
))