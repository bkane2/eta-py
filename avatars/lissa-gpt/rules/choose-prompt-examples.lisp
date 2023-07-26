; TODO: change examples

(READRULES '*paraphrase-prompt-examples-tree*
;`````````````````````````````````````````````````
; A tree for selecting relevant GPT3 prompt examples based on the gist-clause to paraphrase.
; 
; A prompt-examples directive consists of several tuples, each consisting of a context gist-clause,
; a response gist-clause, and a surface form version of the response gist-clause.
;
; Currently, only a single set of prompt-examples are used, but in the future different sets could
; be created tailored for different Eta gist-cluses in order to improve performance.
;
'(
  1 (0)
    2 (
        ; 1
        ((It\'s nice to meet you \.)
         (What hobbies do you have ?)
         (Great to meet you ! I really like to try out different kinds of activities \. What kinds of things do you like to do for fun ?))
        ; 2
        ((I\'m pretty into skiing \.)
         (I enjoy skiing as well \. Last year I went skiing in Utah \. It was a lot of fun \. Do you like video games ?)
         (That\'s awesome ! I\'m actually really into skiing as well \. Just last year I went skiing in Utah\, which was a lot of fun \. What are some other types of activities you like ? Do you like playing video games ?))
        ; 3
        ((Nope \.)
         (I used to play flute \. I played at a concert in the city music hall \. I was nervous but got an applause at the end \. Do you watch television ?)
         (I used to play flute pretty often \. I played at a concert in the city music hall once \. I was pretty nervous but got a big applause at the end \. Anyways\, going back to the topic\, do you watch a lot of television ?))
        ; 4
        ((Sometimes I like to paint \. Have you ever painted anything ?)
         (Yes\, I used to paint a lot ! What do you paint ? One time I made a painting of the farm near my home \. Have you ever had lessons in art ?)
         (Yes\, I used to paint a lot ! What sorts of things do you paint ? One time I made a beautiful painting of the farm near my home \. Also \, I think lessons are a really good way to improve in art \. have you ever had lessons ?))
      )
      (0 :prompt-examples)
))



(READRULES '*gist-prompt-examples-tree*
;`````````````````````````````````````````````````
; A tree for selecting relevant GPT3 prompt examples for gist clause interpretation, based on the
; context gist clause.
; 
; A prompt-examples directive consists of several tuples, each consisting of a context gist clause,
; a response utterance, and the rephrased gist clause for the response.
;
; Currently, only a single set of prompt-examples are used, but in the future different sets could
; be created tailored for different contexts in order to improve performance.
;
'(
))