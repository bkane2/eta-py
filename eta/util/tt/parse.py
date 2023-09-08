"""Methods for parsing choice trees and word features from LISP definitions."""

import glob
import importlib
from transduction.tt import isa

from eta.util.general import remove_duplicates
from eta.util.sexpr import read_lisp


def init_node(pattern):
  """Initialize a node of a choice tree."""
  return {
    'pattern' : pattern,
    'directive' : None,
    'latency' : 0,
    'count' : 0,
    'child' : {},
    'next' : {}
  }


def readrules(packet):
  """Create a choice tree from a packet of pattern and template rules.

  Parameters
  ----------
  packet : list[str]
    A list of form ``[depth, pattern, optional-pair, depth, pattern, optional-pair, ...]``,
    where:
    
      - ``depth`` is 1 for top-level rules, 2 for direct children, etc.,
      - ``pattern`` is a decomposition pattern or other output,
      - ``optional-pair`` is present iff ``pattern`` is a reassembly pattern or other output,
        and consists of a ``(latency, directive)`` tuple, where latency is an integer >= 0
        specifying how long to wait to use a rule again, and directive is a symbol such
        as ``:out``, ``:subtree``, ``:gist``, etc. specifying how the output should be used.

  Returns
  -------
  root : dict
    The root of the choice tree (a nested dict structure) created from the packet.
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
  """Stores a feature list in a dictionary of word features, modifying the dictionary in-place.

  Parameters
  ----------
  feat_xx : list[str]
    A list of form ``[feat, x1, x2, ..., xk]``,
    where:

      - ``feat`` is a string, regarded as a feature.
      - ``x1``, ``x2``, ... are words that will be assigned ``feat`` as a feature,
        i.e., ``isa(xi, feat)`` will be True for each xi among x1, x2, ..., xk.

  feats : dict
    A dict mapping words to features, to be modified in-place.
  """
  feat = feat_xx[0]
  for x in feat_xx[1:]:
    if not isa(x, feat, feats):
      if x in feats:
        feats[x].append(feat)
      else:
        feats[x] = [feat]


def merge_feats(feats1, feats2):
  """Merges two feature dicts."""
  for x, f in feats2.items():
    if x in feats1:
      feats1[x] = remove_duplicates(feats1[x]+f)
    else:
      feats1[x] = f
  return feats1


def merge_trees(trees1, trees2):
  """Merges two choice tree dicts (overriding any duplicates)."""
  for x, t in trees2.items():
    trees1[x] = t
  return trees1


def merge_preds(preds1, preds2):
  """Merges two predicate dicts (overriding any duplicates)."""
  for x, t in preds2.items():
    preds1[x] = t
  return preds1


def from_lisp_file(fname):
  """Read a LISP file and parse the rule trees and feature definitions contained within.

  Parameters
  ----------
  fname : str
    The filename to read.
  
  Returns
  -------
  trees : dict
    A dict containing all choice trees, keyed on their root names.
  feats : dict
    A dict mapping words to feature lists.
  """
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


def read_preds_file(fname):
  """Read a Python file containing predicate function definitions, and return a predicate dict.
  
  Parameters
  ----------
  fname : str
    The filename to read.
  
  Returns
  -------
  preds : dict
    A dict mapping predicate names to functions.
  """
  mod_name = fname.split('.py')[0].replace("/", ".")
  mod = importlib.import_module(mod_name)
  funcs = [f for f in dir(mod) if callable(getattr(mod, f)) and f[0] != '_']
  return { f.replace('_', '-') : getattr(mod, f) for f in funcs }


def from_lisp_dirs(dirs):
  """Recursively read choice trees and word features from all LISP files in a directory or list of directories.

  Parameters
  ----------
  dirs : str or list[str]
    The directory or directories to read.
  
  Returns
  -------
  trees : dict
    A dict containing all choice trees, keyed on their root names.
  feats : dict
    A dict mapping words to feature lists.
  preds : dict
    A dict mapping predicate names to functions.
  """
  trees = {}
  feats = {}
  preds = {}
  if isinstance(dirs, str):
    dirs = [dirs]
  for dir in dirs:
    fnames = glob.glob(dir + '/**/*.lisp', recursive=True)
    for fname in fnames:
      trees_new, feats_new = from_lisp_file(fname)
      trees = merge_trees(trees, trees_new)
      feats = merge_feats(feats, feats_new)
    pred_fnames = glob.glob(dir + '/**/preds.py', recursive=True)
    for pred_fname in pred_fnames:
      preds_new = read_preds_file(pred_fname)
      preds = merge_preds(preds, preds_new)
  return trees, feats, preds