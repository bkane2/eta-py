;;	How do pets help their owners ?
;;	pets-help-owners
;;	(0 I believe pets help their owners 0)
;;	from-pets-help-owners-input
;;		gist question: (1 how 2 pets help 3)
(MAPC 'ATTACHFEAT
'(
  (PER-REF me us we you them people person owner owners)
  (VERB-MAKE make makes making cause causes causing HELP helps helping keep keeps keeping get gets getting)
  (VERB-SHOW show shows showing give gives giving)
  (VERB-LOVE LOVE loves APPRECIATE appreciates)
  (NOUN-LOVE LOVE kindness appreciation)
  (NOUN-PROBLEMS problems troubles)
  (NOUN-PURPOSE purpose meaning)
  (NOUN-EXERCISE exercise busy outside activity)
  (NOUN-HAPPINESS happiness wellness pleasure delight gladness satisfaction contentness joy therapy)
  (NOUN-PARTNER partner partners helper helpers therapist therapists company companion)
  (RELAX relaxing relaxed RELAXATION)
  (STRESS stressed anxious)
  (PROTECT protecting protects)
))


(READRULES '*pets-help-owners-input*
'(
  ; Reciprocal questions
  1 (0 what .DO you 0 ?)
    2 (How do pets help their owners ?) (0 :gist)
  ; Specific answers
  1 (0 .VERB-MAKE 1 .PER-REF 2 .NOUN-EXERCISE 0) ;; "getting us to go outside", "keeps me busy"
    2 ((You believe pets help their owners by getting them exercise \.) (Pets-help-owners)) (0 :gist)
  1 (0 .VERB-SHOW 1 .PER-REF 2 .NOUN-EXERCISE 0) ;; "giving us much needed exercise"
    2 ((You believe pets help their owners by getting them exercise \.) (Pets-help-owners)) (0 :gist)
  1 (0 .VERB-MAKE 1 .PER-REF 2 .GOODSTATE 0) ;; "make me really happy", "keeping us cheerful"
    2 ((You believe pets help their owners by making them happy \.) (Pets-help-owners)) (0 :gist)
  1 (0 .VERB-MAKE 1 .PER-REF 2 less .BADSTATE 0) ;; "making me feel less sad"
    2 ((You believe pets help their owners by making them happy \.) (Pets-help-owners)) (0 :gist)
  1 (0 .VERB-SHOW 1 .PER-REF 2 .NOUN-HAPPINESS 0) ;; "show me happiness", "giving me therapy"
    2 ((You believe pets help their owners by making them happy \.) (Pets-help-owners)) (0 :gist)
  1 (0 forget 3 .NOUN-PROBLEMS 0) ;; "help me forget about all my troubles"
    2 ((You believe pets help their owners by making them happy \.) (Pets-help-owners)) (0 :gist)
  1 (0 get 4 .NOUN-LOVE 0) ;; 
    2 ((You believe pets help their owners by showing them love \.) (Pets-help-owners)) (0 :gist)
  1 (0 .VERB-SHOW 1 .PER-REF 2 .NOUN-LOVE 0) ;; "show us lots of love", "give me kindness"
    2 ((You believe pets help their owners by showing them love \.) (Pets-help-owners)) (0 :gist)
  1 (0 .PER-REF 1 .VERB-LOVE 0) ;; "owners love their pets", "we love our pets"
    2 ((You believe pets help their owners by showing them love \.) (Pets-help-owners)) (0 :gist)
  1 (0 .VERB-MAKE 1 .PER-REF 2 .NOUN-PURPOSE 0) ;; "helping us have a purpose"
    2 ((You believe pets help their owners by helping them have a purpose \.) (Pets-help-owners)) (0 :gist)
  1 (0 .VERB-SHOW 1 .PER-REF 2 .NOUN-PURPOSE 0) ;; "showing me meaning in life"
    2 ((You believe pets help their owners by helping them have a purpose \.) (Pets-help-owners)) (0 :gist)
  1 (0 being 2 .NOUN-PARTNER 0) ;; "being a good partner", "being my best therapist"
    2 ((You believe pets help their owners by keeping them company \.) (Pets-help-owners)) (0 :gist)
  1 (0 keeping 2 company 0) ;; "keeping us company"
    2 ((You believe pets help their owners by keeping them company \.) (Pets-help-owners)) (0 :gist)
  1 (0 keeping 1 .PER-REF 2 lonely 0) ;; "keeping a person from being lonely"
    2 ((You believe pets help their owners by keeping them company \.) (Pets-help-owners)) (0 :gist)
  1 (0 helping 3 loneliness 0) ;; "helping with my loneliness"
    2 ((You believe pets help their owners by keeping them company \.) (Pets-help-owners)) (0 :gist)
  1 (0 good company 0) ;; "they are good company"
    2 ((You believe pets help their owners by keeping them company \.) (Pets-help-owners)) (0 :gist)
  1 (0 companionship 0) ;; "their companionship"
    2 ((You believe pets help their owners by keeping them company \.) (Pets-help-owners)) (0 :gist)
  1 (0 .RELAX 0) ;; 
    2 ((You believe pets help their owners by making them relaxed \.) (Pets-help-owners)) (0 :gist)
  1 (0 .STRESS 0) ;; 
    2 ((You believe pets help their owners by making them relaxed \.) (Pets-help-owners)) (0 :gist)
  1 (0 .PROTECT 0) ;; 
    2 ((You believe pets help their owners by protecting their owners \.) (Pets-help-owners)) (0 :gist)
  1 (0)
    2 ((NIL Gist \: nothing found for how you believe pets help their owners \.) (Pets-help-owners)) (0 :gist)
))


(READRULES '*reaction-to-pets-help-owners-input*
'(
  1 (0 getting them exercise 0)
    2 (I think getting exercise as you get older is important and pets definitely help with that \.) (100 :out)
  1 (0 making them happy 0)
    2 (That\'s great \. It\'s awesome how pets can give their owners joy even during unhappy times \.) (100 :out)
  1 (0 showing them .LOVE 0)
    2 (The relationship that a person can form with their pet really is quite amazing \.) (100 :out)
  1 (0 helping 3 purpose 0)
    2 (It\'s great how pets can help show us meaning in life \.) (100 :out)
  1 (0 keeping them company 0)
    2 (It really is nice that our pets can also be such loyal partners \.) (100 :out)
  1 (0 making them relaxed 0)
    2 (It\'s really nice that pets can help in soothing their ownser\'s stress \.) (100 :out)
  1 (0 .PROTECT 2 owners 0)
    2 (It\'s great how pets can help us in everyday life \.) (100 :out)
  1 (0 NIL Gist 0)
    2 (I think pets can help people quite a lot \.) (100 :out)
))