# Contains a Python reimplementation of the original Lisp tree transduction (TT) functions
# defined here: https://github.com/bkane2/eta/tree/master/core/tt

import eta.util.tt.preds as preds
from eta.util.general import listp, atom, cons

def flatten_sequences(expr):
  """
  e.g., flatten_sequences([x, [y, z], [:seq, [a, b], c, [d, [f, g]]], u, [:seq, v, [w, w]]])
        -> [x, [y, z], [a, b], c, [d, [f, g]], u, v, [w, w]]

  i.e., lists enclosed by [:seq, ...] are replaced by the sequences they 
  contain. [:seq, ...] expressions are not allowed to contain such 
  expressions as sequence elements. (These would not be flattened. It
  would be easy to allow them, but for the pattern transductions here no
  such embeddings occur, because sequence expressions are match-values of
  single sequence variables, like *atom or +expr, and these are matched
  only against input expressions free of sequence expressions.)

  A top-level expr like [:seq, a] or [:seq, []] or [:seq, [a, b]] becomes
  a, [], or [a, b] respectively, i.e., a 1-element sequence is turned
  into that one element. However, an empty sequence [:seq] or longer
  sequence like [:seq, a, b] is left unchanged, since removing [:seq, ...]
  doesn't leave a single valid expression.
  """
  if atom(expr):
    return expr
  elif expr[0] == ':seq':
    return expr[1] if len(expr) == 2 else expr
  elif atom(expr[0]):
    return cons(expr[0], flatten_sequences(expr[1:]))
  elif expr[0][0] == ':seq':
    return expr[0][1:] + flatten_sequences(expr[1:])
  else:
    return cons(flatten_sequences(expr[0]), flatten_sequences(expr[1:]))


def indexed_element_of(expr, index):
  """
  e.g., indexed_element_of([a, [b, c], d], 2) --> [b, c]
  e.g., indexed_element_of([a, [b, c], d], [2, 1]) --> b
  e.g., indexed_element_of([a, [b, [c, d], e], [f, g]], [2, 2, 2]) --> d
  N.B.: idx is assumed to be an integer or list of integers, like those 
        above, otherwise a crash will occur somewhere along the line.
  """
  if index == 0:
    return flatten_sequences(expr)
  elif not listp(expr):
    raise Exception(f'Bad first argument in indexed_element_of({expr}, {index})')
  elif isinstance(index, int):
    return expr[index-1]
  elif not index or not all([isinstance(i, int) for i in index]):
    raise Exception(f'Bad second argument in indexed_element_of({expr}, {index})')
  else:
    result = expr
    for i in index:
      result = result[i-1]
    return result


def s_variant_of_p_var(p_var):
  """Return the *-variant (allowing 0 or more matches) of the given +-var,
     a (predicative) variable requiring 1 or more matches."""
  return '*' + p_var[1:]


def val(var, expr):
  """
  Determine whether the predicate correspnding to 'var' is true of 'expr'.
  If 'var' is a multi-character atom starting with '!', then it's expected
  to have a function definition corresponding to the string following the '!'.
  If it starts with ?/*/+ then the corresponding !-predicate must be obtained
  through string manipulation. If 'var' is a nonnegative integer then the
  corresponding predicate is !expr, which is true of any expression.
 
  var:  expected to be a nonnegative integer or a match variable formed
        from an atom by prefixing one of {!,?,*,+}; NB: {!,?,*,+} ARE 
        NOT ALLOWED AS MATCH VARIABLES.
  expr: an expression to which the predicate is to be applied.
  """
  if num_var(var):
    return True
  elif var in ['!', '?', '*', '+']:
    raise Exception(f'{var} is not allowed as a variable')
  else:
    fname = var[1:].replace('-', '_')
    # For the pred 'list', the function is 'lst' since the former is reserved.
    if fname == 'list':
      fname = 'lst'
    f = getattr(preds, fname)
    return f(expr)
  
  
def ok(x):
  return x != ':nil'

def dot_atom(x):
  return isinstance(x, str) and x != '.' and x[0] == '.'

def q_var(x):
  return isinstance(x, str) and x != '?' and x[0] == '?'

def e_var(x):
  return isinstance(x, str) and x != '!' and x[0] == '!'

def s_var(x):
  return isinstance(x, str) and x != '*' and x[0] == '*'

def p_var(x):
  return isinstance(x, str) and x != '+' and x[0] == '+'

def pred_var_any(x):
  chrs = ['!', '?', '*', '+']
  return isinstance(x, str) and x not in chrs and x[0] in chrs

def num_var(x):
  return (isinstance(x, int) or (isinstance(x, str) and x.isdigit())) and int(x) >= 0

def dec_num_var(x):
  if isinstance(x, int):
    return x-1
  else:
    return str(int(x)-1)
  
def match_var(x):
  return num_var(x) or pred_var_any(x)

def seq_var(x):
  return num_var(x) or (match_var(x) and not e_var(x))

def soft_var(x):
  """Return x if it matches the empty sequences (i.e., a number variable
     or a pred xiable beginning with ? or *); otherwise return None."""
  if num_var(x):
    return x
  elif match_var(x) and x[0] in ['?', '*']:
    return x
  else:
    return None

def hard_atom(x):
  return isinstance(x, str) and not soft_var(x)

def underlying_feat(x):
  return x[1:] if isinstance(x, str) else ''


def isa(x, feat, feats):
  """
  x:    a symbol (e.g., 'surgeon' or 'doctor')
  feat: another symbol (e.g., 'professional'). In general, there is
        no clear presumed logical relation between x and feat -- feat
        simply "indicates" the sort of thing x refers to, in some sense.
  feats: a dictionary mapping a word w to a list of features x1, ..., xk, such
         that (w isa xi) for each feature xi.
 
  NB: an atom is always assumed to have itself as a feature  e.g., 
      (isa 'this 'this) is true. So using '.occupation' in a pattern
      will match 'occupation', even if the pattern coder wrote down
        (occupation physicist cobbler poet teacher ...)
      with the intention of using '.occupation' to match 'physicist', etc.,
      in a sentence like "Alice is a physicist", and concluding "Alice
      is employed". The sentence "Computer programming is an occupation"
      would then likewise lead to the conclusion "Computer programming is
      employed"! The moral is, if you want to use a match-predicate that
      is true of various expressions but not itself, define it as a
      !predicate rather than a feature.
  """
  # Base cases: feat is a direct match
  if x == feat:
    return True
  if dot_atom(x):
    x = x[1:]
  if dot_atom(feat):
    feat = feat[1:]
  if x == feat:
    return True
  
  ff = feats[x].copy() if x in feats else []
  # Frequent case: feat is a member of the feature list of x
  if feat in ff:
    return True
  if not ff:
    return False
  
  # Otherwise, perform a BFS to see if any feature in the feature
  # list of x has feat, etc.
  closed = [x, feat]
  while ff:
    f = ff.pop()
    if f not in closed:
      fff = feats[f] if f in feats else []
      if fff:
        if feat in fff:
          return True
        closed.append(f)
        ff = list(set(fff).union(set(ff)))
        ff = [x for x in ff if x != f]
      if not ff:
        return False
  return False
  # END isa


def match1(pa, ex, feats={}):
  """
  Top-level wrapper function for calling match.
  :nil results are also mapped to [], under the assumption that
  the match([], []) case is unnecessary for Eta rule trees.
  """
  res = match(pa, ex, feats)
  return [] if res == ':nil' else res


def match(pa, ex, feats):
  """
  pa: a pattern, which is any atom or list structure. 
      As a first special case, pa or some atoms in pa may be of form 
      !<pred>, ?<pred>, *<pred>, or +<pred>, interpreted as a match 
      variables that can match one expression, 0 or 1 expression,
      0 or more expressions, or 1 or more expressions respectively, 
      with each matched expression satisfying !<pred> (i.e., yielding 
      a non-nil value). Predicates !expr, !atom, and !lst have fixed
      meanings, being true respectively of any expression, an atom,
      or a list. 'Defpred' automatically creates their sequance variants
      *expr, ?expr, +expr, *atom, ?atom, +atom, and so on.
 
      Second, pa or some atoms embedded in pa may be integers >= 0, 
      where 0, 1, 2, 3, ... respectively mean "zero or more expressions", 
      "at most one expression", "at most 2 expressions", at most 3 
      expressions", etc. Since *expr and ?expr are assumed to have fixed
      meanings "0 or more expressions" and "at most one expression", 
      therefore {0, *expr} are synonyms, and so are {1, ?expr}.
 
      Third, pa or some atoms embedded in pa may be dotted atoms,
      such as .verb or .branch-of-math, i.e., starting with a dot and
      denoting features of atoms. Dot-atom features may themselves be
      assigned dot-atom features, and matching such features to an atom
      involves checking for a chain of 'isa' connections.
 
      Fourth, pa may be or contain atoms not having any of the above
      special meanings, and these just match identical atoms in ex.
 
  ex: any atom or list structure  NB: if any atoms of ex are integers
      >= 0, or are of form !<chars>, ?<chars>, *<chars>, or +<chars>,
      they won't necessarily be matched by idential atoms in pa, because
      such atoms in pa are match variables, and what they match depends
      on how the corresponding predicates are defined. E.g.,
        match('*h, '*h)
      might well be :nil (match failure), if the !-predicate corresponding
      to sequence variable *h, namely !h, is nil for argument *h.
      Similarly, whereas match(3.14, 3.14) = 3.14 (match success),
        match(3, 3)
      will be [:seq, 3] rather than 3, because as a pattern element, 3 is a
      sequence variable that matches any sequence of 3 or fewer expressions.

  feats: a dictionary mapping a word w to a list of features x1, ..., xk, such
         that (w isa xi) for each feature xi.
 
  Result: Failure is :nil, because we want match([], []) = [] (success).
      The (successful) match value for a sequence variable (an integer
      >= 0 or an atom of form ?<chars>, *<chars>, or +<chars>) always
      starts with [:seq, ...] (for the empty sequence this is just [:seq]),
      whereas the (successful) match value for a !-variable is just the
      unique expression for which application of the !-variable, as an
      expression predicate, yielded a non-nil value. As noted already,
      for non-variable pattern atoms and for numbers other than 0, 1, 2, 
      3 , ..., matching succeeds only for those same atoms.
 
      Thus for a successful (non-:nil) result, the result will resemble the
      input expression 'ex' that was matched, except that sequences of 0 or
      more constituents matched by variables of type *<pred>, ?<pred>, +<pred>
      or 0, 1, 2, 3, ... will be encoded as (:seq <item1> <item2> ...).
      If 'ex' is nil and 'pa' matched it, the result will be either nil
      (success, with pa itself nil or a predicate true of nil), or of form
      [[:seq], [:seq], ... [:seq]] if pa was a list of "soft" variables, i.e.,
      ones that can match the empty sequence -- viz., integers 0, 1, 2, ...,
      or match variables starting with * or ?. Note that if we "flatten"
      a successful match by eliminating (:seq ...) wrappers around sequences,
      we get back ex, the matched expression.
 
  The form of the result allows retrieval of values of matched pattern 
  elements by the positions of the pattern elements. E.g., 3 indexes 
  whatever matched the 3rd top-level element of the pattern  e.g.,
  '3.2.2 (note: a symbol) indexes whatever matched the second element of
  the second element of the 3rd top-level element of the given pattern.
 
  The match produced, if any, is the leftmost one  as noted, :nil = failure.

  TODO: the following examples should be adjusted for Python syntax from Lisp.
 
  e.g., (match '(!expr *list (f g) ?atom !atom) 
               '((a) (b c) (d e) (f g) h))
        --> ((A) (:SEQ (B C) (D E)) (F G) (:SEQ) H)
                                   (:seq) is the place-holder for the empty
                                   sequence  w/o it, we couldn't retrieve
                                   matched pa elements by their positions
  e.g., (match '(?expr a 3 e *list) 
               '((x (y z)) a (b c) d e ()))
        --> ((:SEQ (X (Y Z))) A (:SEQ (B C) D) E (:SEQ NIL))
 
  e.g., (match '(+expr !atom 0) 
               '((a b) c d e f g))
        --> ((:SEQ (A B)) C (:SEQ D E F G))
 
  e.g., (match '(+expr !atom) 
               '((a b) c))
       --> ((:SEQ (A B)) C)  note the 1-element sequence
 
  e.g., (match '(*expr +atom) '(a b c)) 
       --> ((:SEQ) (:SEQ A B C)) 
 
  e.g., (match '(!atom (a b *list c) ?atom) '(x (a b (u) (v w) c) d))
       --> (X (A B (:SEQ (U) (V W)) C) (:SEQ D))
 
  e.g., (match '(?atom +expr (*list (d (*atom (?atom)))) ?expr) 
               '(      (a) b ( (c)  (d ( e f  (  g  )))) ((h))))
       --> ((:SEQ) (:SEQ (A) B) ((:SEQ (C)) (D ((:SEQ E F) ((:SEQ G))))) 
                                                              (:SEQ ((H))))
 
  e.g. (dot-atoms), (match '(.ADVP +expr) '(PP (IN on) (NNP Monday)))
       --> (PP (:SEQ (IN ON) (NNP MONDAY)))
 
  Special cases for atomic ex (matching ?/*/+ var's gives a sequence):
  e.g., (match 'a 'a) --> A
  e.g., (match '!atom 'a) --> a
  e.g., (match '?atom ()) --> (:SEQ nil)  single-element sequence
  e.g., (match '!expr ()) --> NIL (success wth empty list)
  e.g., (match '!atom 3.14) --> 3.14
  e.g., (match '?atom 'a) --> (:SEQ A)  single-element sequence 
  e.g., (match '*atom 'a) --> (:SEQ A)  single-element sequence
  e.g., (match '+atom 'a) --> (:SEQ A)  single-element sequence
 
  Basic match variables are {!atom, !list, !expr}, where '!' means 
  exactly 1 occurrence, and may be replaced by '?' (0 or 1 occurrences),
  '*' (0 or more occurrences), or '+' (1 or more occurrences). The three
  !-variables respectively match a Lisp atom, list, or any expression.
 
  In addition, user-defined match variables (see above) can be used in
  the same ways (!, ?, *, +).
  """

  # An empty pa is a success if and only if matched with an empty ex
  if not pa:
    return [] if not ex else ':nil'
  
  # A null ex can be matched by non-null pa only if either pa is a hard
  # match variable that succeeds on [], or it is a list of "soft" variables
  # that can match empty sequences.
  if not ex:
    if num_var(pa):
      return [':seq', []]
    elif match_var(pa) and val(pa, []):
      return [':seq', []] if seq_var(pa) else []
    elif listp(pa):
      if any([listp(x) or hard_atom(x) for x in pa]):
        return ':nil'
      return [[':seq'] for x in pa]
    else:
      return ':nil'
    
  # Both pa and ex are non-null atoms
  if atom(pa) and not match_var(pa) and pa == ex:
    return ex
  
  # pa is a feature (dot-atom) not equivalent to ex
  if dot_atom(pa):
    feat = underlying_feat(pa)
    if atom(ex) and isa(ex, feat, feats):
      return ex
    else:
      return ':nil'
    
  # pa, ex are non-null, pa doesn't test a feature of ex, and if pa = ex and they
  # are atoms, then pa is a match variable & ex happens to "look like" a match variable
  # but is just an expression (or part of an expression) being matched.
  if atom(pa):
    if match_var(pa) and val(pa, ex):
      return [':seq', ex] if seq_var(pa) else ex
    else:
      return ':nil'
    
  # Either pa is an atom not matching ex, or is a non-null list; so it can't match an atom
  if atom(ex):
    return ':nil'
  
  # At this point, pa and ex are lists. So there are 7 cases depending on the first element
  # of pa (p) and the first element of ex (e):
  if not listp(pa) or not listp(ex):
    raise Exception(f'Unexpected condition in match({pa}, {ex})')
  p = pa[0]
  e = ex[0]

  # 1. If p is a list, try matching it to e, and if successful, recurse on the tails of pa and ex.
  if listp(p):
    m = match(p, e, feats)
    if ok(m):
      mm = match(pa[1:], ex[1:], feats)
      if ok(mm):
        return cons(m, mm)
    return ':nil'
  
  # In remaining cases 2-7, initial element p is a non-nil atom.
  # ````````````````````````````````````````````````````````````

  # 2. For non-variable p, if it is equal to, or successfully tests a feature
  # of the 1st element of ex, we recurse on the tails of pa and ex, otherwise fail
  if not match_var(p):
    feat = None
    if dot_atom(p):
      feat = underlying_feat(p)
    if p == e or (feat and isa(e, feat, feats)):
      mm = match(pa[1:], ex[1:], feats)
      if ok(mm):
        return cons(e, mm)
    return ':nil'
  
  # 3. For integer p >= 0: if p = 0, do the match with p replaced by *expr;
  # for p = 1, do the match with p replaced by ?expr; for an integer
  # (numeric var) >= 2, we try an empty match, and try to recurse using the
  # tail of pa; if this fails, we try matching [p-1, ...] to the tail of ex,
  # combining [:seq, e] with the match result for p-1 if successful; otherwise fail
  if num_var(p):
    if int(p) == 0:
      return match(cons('*expr', pa[1:]), ex, feats)
    elif int(p) == 1:
      return match(cons('?expr', pa[1:]), ex, feats)
    else:
      mm = match(pa[1:], ex, feats)
      if ok(mm):
        return cons([':seq'], mm)
      else:
        p = '?expr' if int(p) == 2 else dec_num_var(p)
        mm = match(cons(p, pa[1:]), ex[1:], feats)
        if ok(mm):
          return cons(cons(':seq', cons(e, mm[0][1:])), mm[1:])
    return ':nil'

  # 4. For a !-variable p, we try an initial element match, and if successful,
  # recurse on the tails of pa and ex.
  if e_var(p):
    m = match(p, e, feats)
    if ok(m):
      mm = match(pa[1:], ex[1:], feats)
      if ok(mm):
        return cons(m, mm)
    return ':nil'
  
  # 5. For a ?-variable, we try preprending [:seq] to a recursive match of the
  # the tail of pa to ex; if the recursion fails, we try an initial-element match,
  # and if successful, recurse on the tails of pa & ex.
  if q_var(p):
    mm = match(pa[1:], ex, feats)
    if ok(mm):
      return cons([':seq'], mm)
    else:
      m = match(p, e, feats)
      if ok(m):
        mm = match(pa[1:], ex[1:], feats)
        if ok(mm):
          return cons(m, mm)
    return ':nil'
  
  # 6. For a *-variable, we try prepending [:seq] to a recursive match of the tail
  # of pa to ex; if the recursion fails, we try an initial-element match, and if
  # successful, recurse on pa (unchanged) and the tail of ex.
  if s_var(p):
    mm = match(pa[1:], ex, feats)
    if ok(mm):
      return cons([':seq'], mm)
    else:
      m = match(p, e, feats)
      if ok(m):
        mm = match(pa, ex[1:], feats)
        if ok(mm):
          return cons(m + mm[0][1:], mm[1:])
    return ':nil'
  
  # 7. For a +-variable, we try an initial element match, and if successful,
  # recurse on pa and the tail of ex with the initial +-variable of pa replaced
  # by the corresponding *-variable.
  if p_var(p):
    m = match(p, e, feats)
    if ok(m):
      sv = s_variant_of_p_var(p)
      mm = match(cons(sv, pa[1:]), ex[1:], feats)
      if ok(mm):
        return cons(m + mm[0][1:], mm[1:])
    return ':nil'
  
  # This exception should never be reached, as the above conditions should be exhaustive.
  raise Exception(f'Unexpected: match({pa}, {ex}) gave neither success nor failure')
  # END match


def spec_function(x):
  """Does atm end with '!', exclusive of (stand-alone) '!' ? If so, it is treated as a
     user-defined function in tt output templates."""
  return isinstance(x, str) and x and x != '!' and x[-1] == '!'


def position_index(i):
  """
  Determine whether i is a position index, and if so, if i is simply an integer,
  return it, and if it contains dots and conforms with the syntax of position
  indices, return the list of integers it encodes.
  Otherwise, return [].
  """
  if (isinstance(i, int) or (isinstance(i, str) and i.isdigit())):
    return int(i)
  elif not check_position_index_syntax(i):
    return []
  else:
    return [int(c) for c in i.split('.')]


def check_position_index_syntax(i):
  """
  Syntax: position indices in tree transductions are here
  0, 1, 2, 3, ...,
    (equivalently, 0., 1., 2., 3., ..., but NOT 0.0, 1.0, 2.0, 3.0, ...)
  or 1.1, 1.2, 1.3, ..., 2.1, 2.2, 2.3, ..., etc.,
    (equivalently 1.1., 1.2., 1.3., ..., 2.1., 2.2., 2.3., ...)
  or 1.1.1, 1.1.2, ..., 1.2.1, 1.2.2, ..., 2.1.1, 2.1.2, ... etc.
    (equivalently 1.1.1., 1.1.2., ..., 1.2.1., 1.2.1., 1.2.2., ... )
  etc. (for as many integers chained together with dots as we like,
  not in general limited to single digits). To allow for SBCL, we
  also allow outside pipes, e.g., |2.3.1|.
 
  BUT: NO ISOLATED OR TRAILING 0 DIGITS, except for a standalone 0.
  Something like '13.20.4' is definitely permitted, though position
  indices as large as this -- i.e., linguistic or logical expressions --
  with that many elements -- are unlikely. Not usable: '13.20', because
  this will give result (13 2)  but we can use '13.20.' in such a case.
  Note that the issue of "illegal" trailing 0's arises only for indices
  containing one dot, because as soon as we have two dots, Lisp treats
  this as a symbolic atom.

  NOTE: this function is a pretty direct port from the Lisp version; it
  could probably be optimized here.
  """
  if (isinstance(i, int) or (isinstance(i, str) and i.isdigit())):
    return True
  if not i or not isinstance(i, str):
    return False
  else:
    if any([c.isalpha() for c in i]):
      return False
    i = i.replace('|', '')
    n = len(i)
    if n < 2:
      return False
    if not num_var(i[0]):
      return False
    ndots = 0
    prev_dot = False
    for c in i:
      if c == '.':
        ndots += 1
        if prev_dot:
          return False
        else:
          prev_dot = True
      elif not num_var(c):
        return False
      elif prev_dot and num_var(c) and int(c) == 0:
        return False
      else:
        prev_dot = False
    if ndots == 1 and num_var(i[-1]) and int(i[-1]) == 0:
      return False
  return True


def fill_template(template, match_result):
  """
  template: an expression, in general containing position indicators 
    like 3, 3.2, 3.3.2, where pieces of the match-result are to be placed
    e.g., here, the references are to the 3rd element of match-result, 
    the 2nd element of the third element of the match-result, etc. The 
    index 0 is special -- it refers to match-result as a whole, with
    sequences (:seq ...) flattened, i.e., the expression that was matched.
  match-result: an expression in general containing sequence expressions
    such as [:seq, [a, b], c, [d, [f, g]]] (a 3-element sequence)  [:seq] is
    the empty sequence.
 
  result: the template is filled in with "pieces" from match-result, as
    indicated by the position indices it contains. Where a position index
    indexes a sequence, i.e., [:seq, ...], the elements of the sequence
    (if any) are inserted in the result, without the [:seq, ...] wrapper.
  """
  if template == 0 or template == '0':
    return flatten_sequences(match_result)
  ii = position_index(template)
  if ii:
    return flatten_sequences(indexed_element_of(match_result, ii))
  if atom(template):
    return template
  if listp(template[0]):
    return cons(fill_template(template[0], match_result), fill_template(template[1:], match_result))
  ii = position_index(template[0])
  if ii:
    val = indexed_element_of(match_result, ii)
    if listp(val) and val[0] == ':seq':
      return flatten_sequences(val[1:]) + fill_template(template[1:], match_result)
    else:
      return cons(flatten_sequences(val), fill_template(template[1:], match_result))
  if spec_function(template[0]):
    fname = template[0][:-1].replace('-', '_')
    f = getattr(preds, fname)
    return f(*fill_template(template[1:], match_result))
  
  return cons(template[0], fill_template(template[1:], match_result))  
  # END fill_template


def test_match():
  print(match1('a', 'a'))      # --> 'a'
  print(match1('!atom', 'a'))  # --> 'a'
  print(match1('?atom', []))   # --> [':seq', []]
  print(match1('!expr', []))   # --> []
  print(match1('!atom', '3.14')) # --> 3.14
  print(match1('?atom', 'a'))  # --> [':seq', 'a']
  print(match1('*atom', 'a'))  # --> [':seq', 'a']
  print(match1('+atom', 'a'))  # --> [':seq', 'a']

  print(match1(['!expr', '*list', ['f', 'g'], '?atom', '!atom'],
               [['a'], ['b', 'c'], ['d', 'e'], ['f', 'g'], 'h']))
  # --> [['a'], [':seq', ['b', 'c'], ['d', 'e']], ['f', 'g'], [':seq'], 'h']

  print(match1(['?expr', 'a', '3', 'e', '*list'],
               [['x', ['y', 'z']], 'a', ['b', 'c'], 'd', 'e', []]))
  # --> [[':seq', ['x', ['y', 'z']]], 'a', [':seq', ['b', 'c'], 'd'], 'e', [':seq', []]]

  print(match1(['+expr', '!atom', '0'],
               [['a', 'b'], 'c', 'd', 'e', 'f', 'g']))
  # --> [[':seq', ['a', 'b']], 'c', [':seq', 'd', 'e', 'f', 'g']]
 
  print(match1(['+expr', '!atom'],
               [['a', 'b'], 'c']))
  # --> [[':seq', ['a', 'b']], 'c']
 
  print(match1(['*expr', '+atom'],
               ['a', 'b', 'c']))
  # --> [[':seq'], [':seq', 'a', 'b', 'c']]
 
  print(match1(['!atom', ['a', 'b', '*list', 'c'], '?atom'],
               ['x', ['a', 'b', ['u'], ['v', 'w'], 'c'], 'd']))
  # --> ['x', ['a', 'b', [':seq', ['u'], ['v', 'w']], 'c'], [':seq', 'd']]
  
  print(match1(['?atom', '+expr', ['*list', ['d', ['*atom', ['?atom']]]], '?expr'],
               [['a'], 'b', [['c'], ['d', ['e', 'f', ['g']]]], [['h']]]))
  # --> [[':seq'], [':seq', ['a'], 'b'], [[':seq', ['c']], ['d', [[':seq', 'e', 'f'], [[':seq', 'g']]]]], [':seq', [['h']]]]
 
  print(match1(['.ADVP', '+expr'],
               ['PP', ['IN', 'on'], ['NNP', 'Monday']],
               feats={'PP':['ADVP']}))
  # --> ['PP', [':seq', ['IN', 'on'], ['NNP', 'Monday']]]

  print(match1(['.dog', '.reptile', '.animal', '.animal', 'animal', 'lizard'],
               ['dog', 'snake', 'cat', 'lizard', 'animal', 'lizard'],
               feats={'dog':['animal'], 'cat':['animal'], 'reptile':['animal'], 'lizard':['reptile'], 'snake':['reptile']}))
  # --> ['dog', 'snake', 'cat', 'lizard', 'animal', 'lizard']

  print(match1(['.dog', '.reptile', '.animal', '.animal', 'animal', 'lizard'],
               ['dog', 'cat', 'animal', 'animal', 'animal', 'lizard'],
               feats={'dog':['animal'], 'cat':['animal'], 'reptile':['animal'], 'lizard':['reptile'], 'snake':['reptile']}))
  # --> []

  print(match1(['you', '!modal', '3', 'not', '0'],
               'you can not do that .'.split()))
  # --> ['you', 'can', [':seq'], 'not', [':seq', 'do', 'that', '.']]

  print(match1(['you', '!modal', '3', 'not', '0'],
               'you can really not do that .'.split()))
  # --> ['you', 'can', [':seq', 'really'], 'not', [':seq', 'do', 'that', '.']]

  print(match1(['you', '!modal', '3', 'not', '0'],
               'you can really really really really not do that .'.split()))
  # --> []

  print(match1(['you', '!modal', '3', 'not', '0'],
               'you can not'.split()))
  # --> ['you', 'can', [':seq'], 'not', [':seq']]

  print(match1(['i', 'have', '.num', 'dollars'],
               ['i', 'have', '5', 'dollars'],
               feats={'5':['num']}))
  # --> ['i', 'have', '5', 'dollars']

  print(match1(['i', 'have', '5', 'dollars'],
               ['i', 'have', 'no', 'dollars'],
               feats={'5':['num']}))
  # --> ['i', 'have', [':seq', 'no'], 'dollars']

  m = match1(['i', 'have', '.num', 'dollars'],
             ['i', 'have', '5', 'dollars'],
             feats={'5':['num']})
  print(fill_template(['I', 'believe', 'you', 'have', '3', 'dollars'], m))
  # --> ['I', 'believe', 'you', 'have', '5', 'dollars']

  m = match1(['you', '!modal', '3', 'not', '0'],
               'you can really not do that thing .'.split())
  print(fill_template(['I', 'want', 'to', '5'], m))
  # --> ['I', 'want', 'to', 'do', 'that', 'thing', '.']

  m = match1(['you', '!modal', '3', 'not', '0'],
               'you can really not do that thing .'.split())
  print(fill_template(['I', 'want', 'to', 'test!', '5'], m))
  # --> ['I', 'want', 'to', 'do that thing ._test']

  m = match1(['!atom', ['a', 'b', '*list', 'c'], '?atom'],
             ['x', ['a', 'b', ['u'], ['v', 'w'], 'c'], 'd'])
  print(fill_template(['1', '2', '2.1', '2.3'], m))
  # --> ['x', ['a', 'b', ['u'], ['v', 'w'], 'c'], 'a', ['u'], ['v', 'w']]

  m = match1(['where', '1', 'the', 'twitter', 'block', '?'],
             ['where', 'is', 'the', 'twitter', 'block', '?'])
  print(fill_template([['where.pro', [['lex-ulf!', 'v', '2'], ['the.d', [['lex-ulf!', 'name', '4'], 'block.n']]]], '?'], m))
  # --> [['where.pro', [['pres', 'be.v'], ['the.d', ['|Twitter|', 'block.n']]]], '?']


 

def main():
  # print(flatten_sequences(['x', ['y', 'z'], [':seq', ['a', 'b'], 'c', ['d', ['f', 'g']]], 'u', [':seq', 'v', ['w', 'w']]]))

  # print(indexed_element_of(['a', ['b', 'c'], 'd'], 2))
  # print(indexed_element_of(['a', ['b', 'c'], 'd'], [2, 1]))
  # print(indexed_element_of(['a', ['b', ['c', 'd'], 'e'], ['f', 'g']], [2, 2, 2]))

  # print(val('*non-neg', 'alfalfa'))

  # feats = {'dog':['animal'], 'cat':['animal'], 'reptile':['animal'], 'lizard':['reptile'], 'snake':['reptile']}
  # print(isa('dog', 'dog', feats))
  # print(isa('dog', 'cat', feats))
  # print(isa('dog', 'animal', feats))
  # print(isa('dog', 'reptile', feats))
  # print(isa('snake', 'reptile', feats))

  test_match()

  # print(check_position_index_syntax('1.2.5'))
  # print(position_index('test'))
  # print(position_index('3'))
  # print(position_index('1.3.2'))


if __name__ == '__main__':
  main()