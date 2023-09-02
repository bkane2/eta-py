"""Methods for choosing a result from a choice tree.

Contains functions for choosing a result using choice trees; primarily a reimplementation of the
original 'choose-result-for' LISP function defined here: https://github.com/bkane2/eta/blob/master/core/eta.lisp
"""

from eta.util.general import listp, atom, cons, subst, random_element
from eta.util.tt.match import match, fill_template

def is_tree_root(x):
  return x and isinstance(x, str) and x[0] == '*'

def is_tree_root_clause(x):
  return x and listp(x) and is_tree_root(x[0])

def is_tree_root_list(x):
  return x and listp(x) and all([is_tree_root(y) for y in x])


def choose_result_for(clause, root, trees, feats):
  """Choose a result for a given clause, starting from a given choice tree root.

  A choice tree consists of a tree of pattern nodes, with the leaves containing templates and associated
  directives specifying how to handle the templates (see ``eta.util.tt.parse`` for the specific format of a choice tree).

  Pattern nodes
  -------------
  A pattern node contains either a pattern (see ``eta.util.tt.match``), or one of the following special keywords:

    - ``[:or, <pattern1>, <pattern2>, ...]``
      Match this node if any of the specified patterns match.
    - ``[:subtree, <subtree-name>]``
      Match this node if the subtree rooted at 'subtree-name' yields a non-null result.

  The choice algorithm attempts to match each pattern node with the given clause. If successful, we recursively
  seek a result from the children of the pattern node. In the case of failure, we recursively seek a result from
  the next sibling of the pattern node.

  Template nodes
  --------------
  Each template node contains a template, latency, and directive.

  The latency is used to determine how long to wait until using that template again. If the number of attempted
  matches to a template node since the last successful match is lower than the latency, the node is skipped and
  we attempt to recur on the next sibling. A latency of '0' means that a node will always be used.

  The directive specifies how the template is to be used. The directive may be either an "internal" directive,
  continuing the choice process by e.g. recurring on some subtree specified by the template, or an "external"
  directive, indicating that the template is a final result of a particular type.

  The following internal directives are currently supported:

    - ``:subtree``
      Given a template of form ``<subtree-name>``, return the result from recurring on that subtree.
    - ``:subtree+clause``
      Given a template of form ``[<subtree-name>, <clause>]``, return the result from recurring
      on that subtree using the given clause as an input.
    - ``:subtree-permute``
      Given a template of form ``[<subtree-name>, [<clause1>, ..., <clausek>]]``, recur on the
      subtree with each given clause, and combine the results into a single ``[:and, ...]`` result.
    - ``:subtrees``
      Given a template of form ``[<expr>, <clause>]``, recur on each subtree specified by <expr> using
      the given clause, and combine the results into a single ``[:and, ...]`` result. Here, <expr> may be:

        - ``[<tree>, <clause1>]``, in which case the given tree is first used to select the subtrees to search.
        - ``[<subtree1>, <subtree2>, ...]``, in which case the given subtrees are searched directly.

    - ``:subtrees-permute``
      Given a template of form ``[<expr>, [<clause1>, ..., <clausek>]]`` (with each arg being
      the same as above), permute each subtree with each clause and combine the results.
    - ``:ulf-recur``
      Given a template of form ``[<parts>, <reassembly-pattern>]``, compute a result for each part in
      <parts>, and then combine them according to <reassembly-pattern>.
      Here, <parts> is a list where each element may be:

        - A subtree followed by a clause, in which case the subtree will be called recursively to obtain a result.
        - Some other template expression.
        
      And <reassembly-pattern> is an S-expression containing only integers, where each integer indices the
      corresponding part in <parts>.

  An external directive may be anything, but the following ones will be common:

    - ``:out``
      Specifies that a result is to be used as a system output (i.e., essentially shorthand for
      using the full ULF ``(^me say-to.v ^you <result>)`` as a template).
    - ``:gist``
      Specifies that a result is to be used as a gist clause (i.e., essentially shorthand for
      using the full ULF ``(^you paraphrase-to.v ^me <result>)`` as a template).
    - ``:nl``
      Specifies that the result is a natural language string.
    - ``:ulf``
      Specifies that the result is a ULF formula.
    - ``:schema``
      Specifies that the result is a schema name, to be instantiated with no arguments.
    - ``:schemas``
      Specifies that the result is a list of schemas.
    - ``:schema+args``
      Specifies that the result is a schema to be instantiated with a list of arguments.
    - ``:raw``
      Specifies that the result is simply a raw output with no additional semantics.
    
  A template can also use the following keywords:

    - ``[:or, <template1>, <template2>, ...]``
      Randomly select one of the provided templates.
    - ``[:and, <template1>, <template2>, ...]``
      Combine each of the provided templates into a single ``[:and, ...]`` result.
    
  Parameters
  ----------
  clause : s-expr
    An S-expression to be matched by the patterns in a choice tree and therefore used to choose a result.
  root : str
    The name of a choice tree (e.g., ``gist``) corresponding to the root node of that tree in `trees`.
  trees : dict
    A dict containing all choice trees, keyed on their root names.
  feats : dict
    A dict mapping words to feature lists.

  Returns
  -------
  s-expr
    Either:

      - ``[]`` if no result is found.
      - ``[:<directive>, <result>]`` if a single result is found.
      - ``[:and, <result1>, ..., <resultk>]`` if multiple results are found.
  """
  def choose_result_for_rec(clause, parts, rule_node, visited, trees, feats):
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
      return choose_result_for_rec(clause, parts, rule_node['next'], visited, trees, feats)
    
    # No directive, i.e., pattern node
    # ````````````````````````````````````
    if not directive:
      newparts = []
      # If pattern is disjunctive, try to match any option within the disjunction
      if pattern[0] == ':or':
        for pattern_option in pattern[1:]:
          newparts_option = match(pattern_option, clause, feats)
          if not newparts and newparts_option:
            newparts = newparts_option
      # If pattern is a subtree to match, try to match that subtree
      elif pattern[0] == ':subtree':
        if atom(pattern[1]) and not pattern[1] in visited:
          subtree = pattern[1].strip('*')
          newparts_option = choose_result_for_rec(clause, parts, trees[subtree], cons(subtree, visited), trees, feats)
          if newparts_option:
            newparts = [':seq']
      # Otherwise, try to match pattern
      else:
        newparts = match(pattern, clause, feats)

      # Pattern does not match 'clause', search siblings recursively
      if not newparts:
        return choose_result_for_rec(clause, parts, rule_node['next'], visited, trees, feats)
      
      # Pattern matched, try to obtain recursive result from children
      result = choose_result_for_rec(clause, newparts, rule_node['child'], visited, trees, feats)
      if result:
        return result
      else:
        return choose_result_for_rec(clause, parts, rule_node['next'], visited, trees, feats)
      
    # The following is a big conditional statement for dealing with all possible directives.
    # First, we reset the countdown for the node using the node's latency.
    rule_node['count'] = latency
      
    # :subtree directive
    # ````````````````````````````
    if directive == ':subtree':
      # Pattern is in wrong format
      if not atom(pattern):
        return []
      # If subtree was already visited, skip rule
      if pattern in visited:
        return choose_result_for_rec(clause, parts, rule_node['next'], visited, trees, feats)
      # Otherwise, go to subtree and add subtree to list of visited subtrees
      subtree = pattern.strip('*')
      if not subtree in trees:
        return []
      return choose_result_for_rec(clause, parts, trees[subtree], cons(subtree, visited), trees, feats)
    
    # :subtree+clause directive
    # ````````````````````````````
    if directive == ':subtree+clause':
      # Pattern is in wrong format
      if not listp(pattern) or not len(pattern) == 2:
        return []
      newclause = fill_template(pattern[1], parts)
      subtree = pattern[0].strip('*')
      if not subtree in trees:
        return []
      return choose_result_for_rec(newclause, [], trees[subtree], cons(subtree, visited), trees, feats)
    
    # :subtree-permute directive
    # ``````````````````````````````
    if directive == ':subtree-permute':
      # Pattern is in wrong format
      if not listp(pattern) or not len(pattern) == 2 or not listp(pattern[1]):
        return []
      newclause = fill_template(pattern[1], parts)
      subtree = pattern[0].strip('*')
      if not subtree in trees:
        return []
      ret = [':and']
      for choice in [choose_result_for_rec(x, [], trees[subtree], cons(subtree, visited), trees, feats) for x in newclause]:
        if choice and listp(choice) and choice[0] == ':and':
          ret = ret + choice[1:]
        else:
          ret.append(choice)
      return ret

    # :subtrees directive
    # ````````````````````````````
    if directive == ':subtrees':
      # Pattern is in wrong format
      if not listp(pattern) or not len(pattern) == 2 or not listp(pattern[0]):
        return []
      newpattern = fill_template(pattern, parts)
      newclause = newpattern[1]
      # [*subtree*, <clause>]
      if not is_tree_root_list(newpattern[0]):
        tree = newpattern[0][0].strip('*')
        result = choose_result_for_rec(newpattern[0][1], [], trees[tree], cons(tree, visited), trees, feats)
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
      for choice in [choose_result_for_rec(newclause, [], trees[x], cons(x, visited), trees, feats) for x in subtrees]:
        if choice and listp(choice) and choice[0] == ':and':
          ret = ret + choice[1:]
        else:
          ret.append(choice)
      return ret
    
    # :subtrees-permute directive
    # ````````````````````````````
    if directive == ':subtrees-permute':
      # Pattern is in wrong format
      if not listp(pattern) or not len(pattern) == 2 or not listp(pattern[0]) or not listp(pattern[1]):
        return []
      newpattern = fill_template(pattern, parts)
      newclause = newpattern[1]
      # [*subtree*, <clause>]
      if not is_tree_root_list(newpattern[0]):
        tree = newpattern[0][0].strip('*')
        result = choose_result_for_rec(newpattern[0][1], [], trees[tree], cons(tree, visited), trees, feats)
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
      for choice in [choose_result_for_rec(x, [], trees[y], cons(y, visited), trees, feats) for x in newclause for y in subtrees]:
        if choice and listp(choice) and choice[0] == ':and':
          ret = ret + choice[1:]
        else:
          ret.append(choice)
      return ret
    
    # :ulf-recur directive
    # ````````````````````````````
    if directive == ':ulf-recur':
      # Pattern is in wrong format
      if not listp(pattern) or not len(pattern) == 2:
        return []
      # Instantiate shallow analysis
      newclause = fill_template(pattern[0], parts)
      # Interpret recursive phrases
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

  root = root.strip('*')
  if not root in trees:
    return []
  return choose_result_for_rec(clause, [], trees[root], set(), trees, feats)