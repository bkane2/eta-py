(store-schema 'BW-arch.n
  ; Arch
  '(obj-schema
    :header (?x BW-arch.n)
    :types (
      !t0 (?stack1 BW-stack.n)
      !t1 (?stack2 BW-stack.n)
      !t2 (?top BW-block.n)
      ;!r3 (?table (-er (much.adv big.a)) ?b)
    )
    :rigid-conds (
      !r0 (?top on.p ?stack1)
      !r1 (?top on.p ?stack2)  
      !r2 (?stack1 next-to.p ?stack2)
      !r3 (not (?stack1 touching.p ?stack2))
      !r4 (?top clear.a)
      !r5 ((height-of.f ?stack1) = (height-of.f ?stack2))  ; assume height-of.f is a function that acts on stacks, and return # of items
    )
    :skeletal-prototype (
      bw-arch1.obj
      bw-arch2.obj
    )
)) ; END BW-arch.n



(store-schema 'BW-staircase.n
  ; Staircase
  '(obj-schema
    :header (?x BW-staircase.n)
    :types (
      !t0 (?x row-of.n 'BW-stack.n)
    )
    :rigid-conds (
      !r0 ((height-of.f (1st ?x)) = 1) ; assume height-of.f is a function that acts on stacks, and return # of blocks
      !r1 (all ?y (all ?z (((?y part-of ?x) and (?z part-of ?x) (?y successor-of ?z ?x))
                            ((height-of.f ?y) = ((height-of.f ?z) + 1)))))
    )
    :skeletal-prototype (
      bw-staircase1.obj
      bw-staircase2.obj
    )
)) ; END BW-staircase.n



(store-schema 'BW-wedge.n
  ; Wedge
  '(obj-schema
    :header (?x BW-wedge.n)
    :types (
      !t0 (?x BW-block.n)
      !t1 (?y BW-row.n)
    )
    :rigid-conds (
      !r0 (?x on.p ?y)
      !r1 ((length-of.f ?y) = 2) ; assume length-of.f is a function that acts on row-of-blocks, and return # of blocks
      !r2 (?x vertically-center-aligned.p ?y)
    )
    :skeletal-prototype (
      bw-wedge1.obj
      bw-wedge2.obj
    )
)) ; END BW-wedge.n



(store-schema 'BW-pyramid.n
  ; Pyramid
  '(obj-schema
    :header (?x BW-pyramid.n)
    :types (
      !t0 (?x stack-of.n 'BW-row.n)
    )
    :rigid-conds (
      ;Each next row is shorter than the previous
      !r0 (all ?y (all ?z (((?y part-of ?x) and (?z part-of ?x) (?y successor-of ?z ?x))
                           ((length-of.f ?y) < (length-of.f ?z)))))
      !r1 ((length-of.f ?y) > 1)
      !r2 (?x vertically-center-aligned.a)
    )
    :skeletal-prototype (
      bw-pyramid1.obj
      bw-pyramid2.obj
      bw-pyramid3.obj
    )
)) ; END BW-pyramid.n



(create-aliases-of-concept 'BW-arch.n      '|BW-arch|      'BW-concept-structure.n)
(create-aliases-of-concept 'BW-staircase.n '|BW-staircase| 'BW-concept-structure.n)
(create-aliases-of-concept 'BW-wedge.n     '|BW-wedge|     'BW-concept-structure.n)
(create-aliases-of-concept 'BW-pyramid.n   '|BW-pyramid|   'BW-concept-structure.n)



(create-concept-set '(plur BW-concept-structure.n) '|BW-concept-set1|
  '(|BW-arch| |BW-staircase| |BW-wedge| |BW-pyramid|))