# Contains functions for choosing a result using choice trees; primarily a reimplementation of the
# original 'choose-result-for' Lisp function defined here: https://github.com/bkane2/eta/blob/master/core/eta.lisp
#
# In contrast with the original function, the full set of named choice (sub)trees, as well as word features,
# must be explicitly provided as arguments to this function, as opposed to stored as global variables.

from eta.util.general import listp, atom, cons, subst, random_element
from eta.util.tt.match import match1, fill_template


def is_tree_root(x):
  return x and isinstance(x, str) and x[0] == '*'

def is_tree_root_clause(x):
  return x and listp(x) and is_tree_root(x[0])

def is_tree_root_list(x):
  return x and listp(x) and all([is_tree_root(y) for y in x])


def choose_result_for(clause, root, trees, feats):
  """Wrapper function for calling choose_result_for1"""
  root = root.strip('*')
  if not root in trees:
    return []
  return choose_result_for1(clause, [], trees[root], set(), trees, feats)


def choose_result_for1(clause, parts, rule_node, visited, trees, feats):
  """
  TODO: update description

  This is a generic choice-tree search program, used both for
  (i) finding gist clauses in user inputs (starting with selection
  of appropriate subtrees as a function of Eta's preceding
  question, simplified to a gist clause), and (ii) in selecting
  outputs in response to (the gist clauses extracted from) user 
  inputs. Outputs in the latter case may be verbal responses
  obtained with reassembly rules, or names (possibly with
  arguments) of other choice trees for response selection, or
  the names (possibly with arguments) of schemas for planning 
  an output. The program works in essentially the same way for
  purposes (i) and (ii), but returns
       (cons <directive keyword> result)
  where the directive keyword (:out, :subtree, :subtree+clause,
  :schema, ...) is the one associated with the rule node that
  provided the final result to the calling program. (The calling
  program is presumed to ensure that the appropriate choice tree
  is supplied  as 'rule-node' argument, and that the result is
  interpreted and used as intended for that choice tree.)
 
  So, given an input clause 'clause', a list 
  'parts' of matched parts from application of the superordiate
  decomposition rule (initially, nil), and the choice tree node 
  'rule-node' in a tree of decomposition/result rules, we generate
  a verbal result or other specified result starting at that rule,
  prefixed with the directive keyword.
 
  Decomposition rules (as opposed to result rules) have no
  'directive' property (i.e., it is NIL). Note that in general
  a decomposition rule will fail if the pattern it supplies fails
  to match 'clause', while a result rule will fail if its
  latency requirements prevent its (re)use until more system
  outputs have been generated. (This avoids repetitive outputs.)
 
  Note also that result rules can have siblings, but not children,
  since the "downward" direction in a choice tree corresponds to
  successive refinements of choices. Further, note that if the
  given rule node provides a decomposition rule (as indicated by
  a NIL 'directive' property), then it doesn't make any direct
  use of the 'parts' list supplied to it -- it creates its own
  'newparts' list via a new pattern match. However, if this
  match fails (or succeeds but the recursion using the children 
  returns NIL), then the given 'parts' list needs to be passed
  to the siblings of the rule node -- which after all may be 
  result rules, in particular reassembly rules.
 
  Method:
 ````````
  If the rule has a NIL 'directive' property, then its 'pattern'
  property supplies a decomposition rule. We match this pattern,
  and if successful, recursively seek a result from the children
  of the rule node (which may be result rules or further decomp-
  osition rules), returning the result if it is non-nil  in case
  of failure, we recursively return a result from the siblings
  of the rule node (via the 'next' property)  these siblings
  represent alternatives to the current rule node, and as such
  may be either alternative decomposition rules, or result rules 
  (with a non-nil 'directive' property) -- perhaps intended as
  a last resort if the decomposition rules at the current level
  fail.
 
  In all cases of non-nil directives, if the latency requirement
  is not met, i.e., the rule cannot be reused yet, the recursive
  search for a result continues with the siblings of the rule.
 
  If the rule node has directive property :out, then its 'pattern'
  property supplies a reassembly rule. If the latency requirement 
  of the rule is met, the result based on the reassembly rule and
  the 'parts' list is returned (after updating time-last-used). 
  The latency criterion uses the 'latency' property of 'rule-node' 
  jointly with the (ds-time-last-used (get-ds)) hash table and the
  result count, (ds-count (get-ds)).
 
  If the rule node has directive property :subtree, then 'pattern'
  will just be the name of another choice tree. If the latency 
  requirement is met, a result is recursively computed using the
  named choice tree (with the same 'clause' as input).
  The latency will usually be 0 in this case, i.e., a particular
  choice subtree can usually be used again right away.
 
  If the rule node has directive property :subtree+clause, then
  'pattern' supplies both the name of another choice tree and
  a reassembly pattern to be used to construct a clause serving
  as input in the continued search (whereas for :subtree the
  recursion continues with the original clause). Again the
  latency will usually be 0.
 
  (June 9/19) If the rule node has directive property :ulf-recur,
  then 'pattern' supplies two reassembly rules, the first of which,
  upon instantiation with 'parts', is a list such as
   ((*be-ulf-tree* ((is be pres))) 
    (*np-ulf-tree* (the det def) (Nvidia name corp-name) (block cube obj))
    (*rel-ulf-tree* (to prep dir loc) (the det def) (left noun loc) (of prep))
    (*np-ulf-tree* (a det indef) (red adj color) (block cube obj)) 
    (*end-punc-ulf-tree* (? end-punc ques-punc))),
  ie., a list of sublists of words, with each sublist prefaced by
  the name of a rule tree to be used to produce a ulf for that sublist of
  words. The instantiated reassembly rule is then processed
  further, by successively trying to get a result for each of the rule
  trees named in the sublists  if all succeed, the individual results
  are assembled into an overall ULF, and this is the result returned
  (otherwise, the result is nil -- failure). The second reassembly rule
  provides the right bracketing structure for putting together the
  individual ULFs. Example: ((1 2 (3 4)) 5)  result for the above:
      (((pres be.v) (the.d (|NVidia| block.n)) 
                    (to_the_left_of.p (a.d (red.a block.n)))) ?)
 
  Other directives (leading to direct return of a successful result
  rather than possible failure, leading to continuing search) are 
  - :subtrees (returning the names of multiple subtrees (e.g., 
    for extracting different types of gist clauses from a 
    potentially lengthy user input)  
  - :schema (returning the name of a schema to be instantiated, 
    where this schema requires no arguments)  
  - :schemas (returning multiple schema names, perhaps as 
    alternatives)  
  - :schema+args (a schema to be instantiated for the specified 
    args derived from the given 'clause')  
  - :gist (a gist clause extracted from the given 'clause,
    plus possibly a list of topic keys for storage) 
  - :ulf (June 9/19) (returning a ulf for a phrase simple enough
    to be directly interpreted) 
  - perhaps others will be added, such as :subtrees+clauses or
    :schemas+args
 
  These cases are all treated uniformly -- a result is returned
  (with the directive) and it is the calling program's responsib-
  ility to use it appropriately. Specifically, if the latency
  requirement is met, the value supplied as 'pattern', instantiated
  with the supplied 'parts', is returned. (Thus integers appearing
  in the value pattern are interpreted as references to parts
  obtained from the prior match.) 
 
  The function maintains a list of visited subtrees
  (for a particular path) to avoid entering infinite recursion, as well
  as a list of matched nodes that are returned for debugging purposes.
  (NOTE: the latter is not yet implemented for ULF directives)

  TODO: some of this is rather messy and can be cleaned/standardized;
        particularly some of the various :subtree directives
  """
  if not rule_node:
    return []
  
  # Get directive and pattern from rule node
  directive = rule_node['directive']
  pattern = rule_node['pattern']
  count = rule_node['count']
  latency = rule_node['latency']

  # Skip rule if it has a non-zero latency and the countdown for that rule hasn't yet reached zero
  if directive and min(count, latency) > 0:
    rule_node['count'] -= 1
    return choose_result_for1(clause, parts, rule_node['next'], visited, trees, feats)
  
  # No directive, i.e., pattern node
  # ````````````````````````````````````
  if not directive:
    newparts = []
    # If pattern is disjunctive, try to match any option within the disjunction
    if pattern[0] == ':or':
      for pattern_option in pattern[1:]:
        newparts_option = match1(pattern_option, clause, feats)
        if not newparts and newparts_option:
          newparts = newparts_option
    # If pattern is a subtree to match, try to match that subtree
    elif pattern[0] == ':subtree':
      if atom(pattern[1]) and not pattern[1] in visited:
        subtree = pattern[1].strip('*')
        newparts_option = choose_result_for1(clause, parts, trees[subtree], cons(subtree, visited), trees, feats)
        if newparts_option:
          newparts = [':seq']
    # Otherwise, try to match pattern
    else:
      newparts = match1(pattern, clause, feats)

    # Pattern does not match 'clause', search siblings recursively
    if not newparts:
      return choose_result_for1(clause, parts, rule_node['next'], visited, trees, feats)
    
    # Pattern matched, try to obtain recursive result from children
    result = choose_result_for1(clause, newparts, rule_node['child'], visited, trees, feats)
    if result:
      return result
    else:
      return choose_result_for1(clause, parts, rule_node['next'], visited, trees, feats)
    
  # The following is a big conditional statement for dealing with all possible directives.
  # First, we reset the countdown for the node using the node's latency.
  rule_node['count'] = latency
    
  # :subtree directive
  # ````````````````````````````
  # Recursively obtain a result from the choice tree specified via its
  # root name, given as 'pattern'
  if directive == ':subtree':
    # Pattern is in wrong format
    if not atom(pattern):
      return []
    # If subtree was already visited, skip rule
    if pattern in visited:
      return choose_result_for1(clause, parts, rule_node['next'], visited, trees, feats)
    # Otherwise, go to subtree and add subtree to list of visited subtrees
    subtree = pattern.strip('*')
    if not subtree in trees:
      return []
    return choose_result_for1(clause, parts, trees[subtree], cons(subtree, visited), trees, feats)
  
  # :subtree+clause directive
  # ````````````````````````````
  # Similar to :subtree, except that 'pattern' is not simply the root
  # name of a tree to be searched, but rather a pair of form
  # [<root name of tree>, <reassembly pattern>], indicating that the
  # reassembly pattern should be used together with 'parts' to reassemble
  # some portion of 'clause', whose results should then be used
  if directive == ':subtree+clause':
    # Pattern is in wrong format
    if not listp(pattern) or not len(pattern) == 2:
      return []
    newclause = fill_template(pattern[1], parts)
    subtree = pattern[0].strip('*')
    if not subtree in trees:
      return []
    return choose_result_for1(newclause, [], trees[subtree], cons(subtree, visited), trees, feats)
  
  # :subtree-permute directive
  # ``````````````````````````````
  # Given a pattern of the form [<root name of tree>, <reassembly pattern>],
  # where <reassembly pattern> here is assumed to contain a list of sub-lists,
  # recursively search the subtree for each sub-list and conjoin the results
  # as [:and ...].
  if directive == ':subtree-permute':
    # Pattern is in wrong format
    if not listp(pattern) or not len(pattern) == 2 or not listp(pattern[1]):
      return []
    newclause = fill_template(pattern[1], parts)
    subtree = pattern[0].strip('*')
    if not subtree in trees:
      return []
    ret = [':and']
    for choice in [choose_result_for1(x, [], trees[subtree], cons(subtree, visited), trees, feats) for x in newclause]:
      if choice and listp(choice) and choice[0] == ':and':
        ret = ret + choice[1:]
      else:
        ret.append(choice)
    return ret

  # :subtrees directive
  # ````````````````````````````
  # Given a pattern of the form [<expr>, <reassembly pattern>], use each subtree
  # specified by <expr> to match the pattern, conjoining the results as [:and ...].
  # Here, <expr> may be in one of the following formats:
  # [*subtree*, <clause>], in which case *subtree* is searched using the given clause as input.
  # [*tree1*, *tree2*, ..., *treek*], in which case they specify root trees to be used directly.
  if directive == ':subtrees':
    # Pattern is in wrong format
    if not listp(pattern) or not len(pattern) == 2 or not listp(pattern[0]):
      return []
    newpattern = fill_template(pattern, parts)
    newclause = newpattern[1]
    # [*subtree*, <clause>]
    if not is_tree_root_list(newpattern[0]):
      tree = newpattern[0][0].strip('*')
      result = choose_result_for1(newpattern[0][1], [], trees[tree], cons(tree, visited), trees, feats)
      if not result:
        return []
      else:
        _, subtrees = result
    # [*tree1*, *tree2*, ..., *treek*]
    else:
      subtrees = newpattern[0]
    if not is_tree_root_list(subtrees):
      return []
    subtrees = [x.strip('*') for x in subtrees]
    ret = [':and']
    for choice in [choose_result_for1(newclause, [], trees[x], cons(x, visited), trees, feats) for x in subtrees]:
      if choice and listp(choice) and choice[0] == ':and':
        ret = ret + choice[1:]
      else:
        ret.append(choice)
    return ret
  
  # :subtrees-permute directive
  # ````````````````````````````
  # Combines the :subtrees and :subtree-permute directives, applying many subtrees
  # to multiple sub-lists, returning all results in one conjoined [:and ...] list.
  if directive == ':subtrees-permute':
    # Pattern is in wrong format
    if not listp(pattern) or not len(pattern) == 2 or not listp(pattern[0]) or not listp(pattern[1]):
      return []
    newpattern = fill_template(pattern, parts)
    newclause = newpattern[1]
    # [*subtree*, <clause>]
    if not is_tree_root_list(newpattern[0]):
      tree = newpattern[0][0].strip('*')
      result = choose_result_for1(newpattern[0][1], [], trees[tree], cons(tree, visited), trees, feats)
      if not result:
        return []
      else:
        _, subtrees = result
    # [*tree1*, *tree2*, ..., *treek*]
    else:
      subtrees = newpattern[0]
    if not is_tree_root_list(subtrees):
      return []
    subtrees = [x.strip('*') for x in subtrees]
    ret = [':and']
    for choice in [choose_result_for1(x, [], trees[y], cons(y, visited), trees, feats) for x in newclause for y in subtrees]:
      if choice and listp(choice) and choice[0] == ':and':
        ret = ret + choice[1:]
      else:
        ret.append(choice)
    return ret
  
  # :ulf-recur directive
  # ````````````````````````````
  # Find the instance of the rule pattern determined by 'parts',
  # which will be a shallow analysis of a text segment, of the
  # form described in the initial commentary; try to find results
  # (ULFs) for the component phrases, and if successful assemble
  # these into a complete ULF for the input. NB: (first pattern)
  # supplies the top-level phrasal segments to be further analyzed
  # (using the ulf rule trees heading each phrasal segment), while
  # (second pattern) supplies the bracketing structure for the
  # phrasal ULFs.
  if directive == ':ulf-recur':
    # Pattern is in wrong format
    if not listp(pattern) or not len(pattern) == 2:
      return []
    # Instantiate shallow analysis
    newclause = fill_template(pattern[0], parts)
    # Interpret recursive phrases; the car of each nonatomic phrase
    # either gives the name of the relevant rule tree to use, or it is
    # a ULF; in the former case we proceed recursively; in the latter
    # case we keep as-is
    ulfs = []
    for phrase in newclause:
      if is_tree_root_clause(phrase):
        ulf = choose_result_for(phrase[1:], phrase[0], trees, feats)[1]
      else:
        ulf = phrase
      # Failure case
      if not ulf:
        return []
      ulfs.append(ulf)
    # Assemble the list of phrasal ULFs into a ULF for the entire input,
    # using the second reassembly rule
    result = []
    if ulfs:
      result = pattern[1]
      for i, ulf in enumerate(ulfs):
        result = subst(ulf, str(i+1), result)
    return (':ulf', result)
  
  # :misc non-recursive directives
  # ``````````````````````````````````
  # For any other directive, we concatenate the directive to the result and return,
  # allowing the transducer implementation to handle the directive appropriately. Some
  # common examples of directives used by the avatars may be (but are not limited to):
  # :out -> creates a (^me say-to.v ^you <result>) ULF Eventuality
  # :gist -> creates a (^you paraphrase-to.v ^me <result>) ULF Eventuality
  # :nl  -> creates a <result> natural language Eventuality
  # :ulf -> creates a <result> ULF Eventuality
  # :schema -> selects the schema corresponding to <result> with no arguments
  # :schemas -> selects a list of schemas corresponding to <result>
  # :schema+args -> selects a schema with arguments specified by <result>
  # :subtrees -> returns a list of subtrees to try for further matching
  #              (redundant with below, but kept for legacy support)
  # :raw -> returns the result as a raw list
  if directive and isinstance(directive, str) and directive[0] == ':':
    result = fill_template(pattern, parts)
    # If result is disjunctive, randomly choose one element
    if listp(result) and result[0] == ':or':
      result = random_element(result[1:])
    # If result is conjunctive, return conjunction with :and prefix
    if listp(result) and result[0] == ':and':
      return cons(':and', [(directive, r) for r in result[1:]])
    return (directive, result)

  # Unexpected
  raise Exception(f'Unsupported directive {directive} encountered for rule with pattern {pattern} for clause {clause}')
  # END choose_result_for1