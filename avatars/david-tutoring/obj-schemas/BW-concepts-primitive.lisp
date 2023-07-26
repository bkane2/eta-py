(store-schema 'BW-block.n
  ; Block
  '(obj-schema
    :header (?x BW-block.n)
    :types (
      !t0 (?x block.n)
      !t1 (?c color.n)
      !t2 (?l BW-logo.n)
    )
    :rigid-conds (
      !r0 ((dimensions-of.f ?x) = ($ dim .15 .15 .15))
      !r1 ((color-of.f ?x) = ?c)
      !r2 (?x carry26.v ?l)
    )
)) ; END BW-block.n



(store-schema 'row-of.n
  ; Row-of
  '(obj-schema
    :header (?x row-of.n ?P)
    ; a row of items of type ?P (where ?P is a monadic predicate *name*)
    :types (
        !t0 (?x (maximal.a (sequence-of.n ?P 'abut.v)))
    )
    :rigid-conds (
        !r1 (?x (form7.v (straight.a line.n))); "form" is a predicate-taking verb, like "is"
        !r2 (?x horizontal.a)
    )
    :skeletal-prototype (
        row.obj
    )
)) ; END row-of.n



(store-schema 'stack-of.n
  ; Stack-of
  '(obj-schema
    :header (?x stack-of.n ?P)
    ; a stack of items of type ?P (where ?P is a monadic predicate *name*)
    :types (
      !t0 (?x (maximal.a (sequence-of.n ?P 'on.n)))
    )
    :rigid-conds (
      !r1 (?x (form7.v (straight.a line.n)))
      !r2 (?x vertical.a)
    )
    :skeletal-prototype (
      stack.obj
    )
)) ; END stack-of.n



(store-schema 'BW-row.n
  ; Row
  '(obj-schema
    :header (?x BW-row.n)
    :types (
      !t0 (?x row-of.n 'BW-block.n)
    )
    :skeletal-prototype (
      bw-row1.obj
      bw-row2.obj
      bw-row3.obj
    )
)) ; END BW-row.n



(store-schema 'BW-stack.n
  ; Stack
  '(obj-schema
    :header (?x BW-stack.n)
    :types (
      !t0 (?x stack-of.n 'BW-block.n)
      !t1 (?b (1st ?x)) ; assume 1st is a special primitive function on sequences
      !t2 (?c (lst ?x)) ; assume lst is a special primitive function on sequences
    )
    :skeletal-prototype (
      bw-stack1.obj
      bw-stack2.obj
      bw-stack3.obj
    )
)) ; END BW-stack.n



(create-aliases-of-concept 'BW-block.n '|BW-block|    'BW-concept-primitive.n)
(create-aliases-of-concept 'row-of.n   '|BW-row-of|   'BW-concept-primitive.n)
(create-aliases-of-concept 'stack-of.n '|BW-stack-of| 'BW-concept-primitive.n)
(create-aliases-of-concept 'BW-row.n   '|BW-row|      'BW-concept-primitive.n)
(create-aliases-of-concept 'BW-stack.n '|BW-stack|    'BW-concept-primitive.n)



(create-concept-set '(plur BW-concept-primitive.n) '|BW-concept-set2|
  '(|BW-block| |BW-row-of| |BW-stack-of| |BW-row| |BW-stack|))