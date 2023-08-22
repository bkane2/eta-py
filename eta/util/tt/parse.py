import glob

from eta.util.general import remove_duplicates
from eta.util.sexpr import read_lisp
from eta.util.tt.match import isa


def init_node(pattern):
  return {
    'pattern' : pattern,
    'directive' : None,
    'latency' : 0,
    'count' : 0,
    'child' : {},
    'next' : {}
  }


def readrules(packet):
  """
  This reads in the set of decomposition and output rules. 
  It embeds these rules in a tree structure, i.e., nested
  dictionaries where first children are reached via the
  'child' property, and subsequent children are connected via
  the 'next' property. Decomposition and output patterns
  are stored under the 'pattern' property, and output rules are
  distinguished by having a non-None 'directive' property.

  Each node also has 'latency' and 'count' properties, which
  are jointly used to enforce a "cooldown" time before a rule
  can be used again. As indicated below, in the data set the numeric
  value of latency and the directive symbol are supplied jointly
  as a 2-element list, but these become separate properties
  in the choice tree that is built. The count is always initialized
  to 0 so that any rule can be initially chosen.
 
  'packet' is of form [depth, pattern, optional-pair,
 	                     depth, pattern, optional-pair, ...]
  where "depth" is a number =1 for top-level rules, =2 for
  direct descendants of top-level rules, etc.  "pattern" is
  a decomposition pattern or other output  and optional-pair
  is present iff "pattern" is a reassembly pattern or other 
  output. The first element of optional-pair, if present, is 
  the latency of the rule. The second element is the directive,
  such as :out, :subtree, :subtree+clause, :schema, :gist, etc.
  """
  if len(packet) < 2:
    return {}
  root = init_node(packet[1])
  stack = [(1, root)]
  # Advance past the 1st dept-# and pattern
  rest = packet[2:]

  # Loop until full rule tree is built
  while rest:
    n = rest[0]
    rest = rest[1:]

    # If n is a number, it is the depth of a new rule
    if (isinstance(n, int) or (isinstance(n, str) and n.isdigit())) and int(n) > 0:
      n = int(n)
      node = init_node(rest[0])
      # Advance past the current pattern
      rest = rest[1:]

      # New rule at same depth?
      if n == stack[-1][0]:
        # Let 'next' of previous rule point to new rule,
        # pop the previous rule and push new rule onto stack
        stack.pop()[1]['next'] = node
        stack.append((n, node))

      # New rule at greater depth?
      elif n > stack[-1][0]:
        # Let 'child' of previous rule point to new rule, and
        # push the new rule onto stack
        stack[-1][1]['child'] = node
        stack.append((n, node))

      # New rule at lower depth?
      else:
        # Pop a number of stack elements equal to depth differential
        for _ in range(stack[-1][0] - n):
          stack.pop()
        # Resulting top element must be same depth, so set 'next' pointer to new rule
        stack.pop()[1]['next'] = node
        stack.append((n, node))

    # If n is a [latency, directive] pair rather than depth number,
    # set the latency and directive of the rule at the top of the stack
    else:
      stack[-1][1]['latency'] = int(n[0])
      stack[-1][1]['directive'] = n[1]

  return root
  # END readrules


def attachfeat(feat_xx, feats):
  """
  feat-xx: a list of form [feat, x1, x2, ..., xk]
        where feat is a symbol, regarded as a feature
        & x1, x2, ... are symbols (perhaps allowing expressions in future?) 
        that will hereby be assigned feat, i.e., isa(xi, feat) will be
        true for each xi among x1, x2, ..., xk.
  We store feat as a feature of x1, x2, ..., xk in the feats dictionary.
  We avoid duplication, for any xi that already has that feature.
  """
  feat = feat_xx[0]
  for x in feat_xx[1:]:
    if not isa(x, feat, feats):
      if x in feats:
        feats[x].append(feat)
      else:
        feats[x] = [feat]


def from_lisp_file(fname):
  """Reads a Lisp file and parses the rule tree(s) contained within"""
  trees = {}
  feats = {}
  contents = read_lisp(fname)
  for decl in contents:
    if decl[0] == 'readrules':
      name = decl[1].strip("'").strip('*')
      tree = readrules(decl[2])
      trees[name] = tree
    elif decl[0] == 'attachfeat':
      feat_xx = decl[1]
      attachfeat(feat_xx, feats)
    elif (decl[0] == 'mapc' or decl[0] == 'mapcar') and decl[1].strip("'").strip('*') == 'attachfeat':
      for feat_xx in decl[2]:
        attachfeat(feat_xx, feats)
  return trees, feats


def merge_feats(feats1, feats2):
  """Merges two feature dicts"""
  for x, f in feats2.items():
    if x in feats1:
      feats1[x] = remove_duplicates(feats1[x]+f)
    else:
      feats1[x] = f
  return feats1


def merge_trees(trees1, trees2):
  """Merges two tree dicts. For now, we simply override any duplicates"""
  for x, t in trees2.items():
    trees1[x] = t
  return trees1


def from_lisp_dirs(dirs):
  """Recursively reads all .lisp files in a given dir or list of dirs,
     returning combined trees and feats dicts."""
  trees = {}
  feats = {}
  if isinstance(dirs, str):
    dirs = [dirs]
  for dir in dirs:
    fnames = glob.glob(dir + '/**/*.lisp', recursive=True)
    for fname in fnames:
      trees_new, feats_new = from_lisp_file(fname)
      trees = merge_trees(trees, trees_new)
      feats = merge_feats(feats, feats_new)
  return trees, feats