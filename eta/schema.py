"""Classes and methods for representing and modifying different types of schemas.

A schema is, in general, a collection of sections. Each section is a sequence of eventualities (natural language
expressions or ULF/ELF formulas with associated episode symbols) under a section label, e.g., 'types' or 'preconditions'.

A schema is denoted by a specific predicate string (e.g., 'dog.n' or 'eat.v'), and also has a unique header, which is a
formula characterizing the schema episode potentially containing participant variables, e.g., ((^me eat.v ?x) ** ?e1).
"""

import glob
from copy import deepcopy

from eta.constants import *
from eta.util.general import (gentemp, remove_duplicates, get_keyword_contents, append, 
                              cons, flatten, substall, dict_substall_keys, variablep, dual_var, duplicate_var,
                              argmax)
from eta.util.sexpr import read_lisp, list_to_s_expr
from eta.lf import ULF, ELF, parse_eventuality_list

class Schema:
  """An abstract schema class.
  
  Attributes
  ----------
  id : str
    A unique ID for this schema.
  predicate : str
    The main predicate of the schema (e.g., dog.n or eat.v).
  participants : list[s-expr]
    All participant roles of a schema, i.e., variables and constants present as arguments in the header.
  vars : list[str]
    All variables scoped within a schema.
  bindings : dict
    A mapping from variables to bound values.
  header : ELF
    The ELF formula for the header of the schema.
  contents : ELF
    The ELF formula for the contents of the schema.
  sections : dict[str, list[Eventuality]]
    A dict mapping each section label (e.g., 'types') to a list of eventualities created from the schema contents.
  embedding : list[float]
    A vector embedding of this schema (default is empty embedding).
  """

  def __init__(self, predicate='', participants=[], vars=[], bindings={}, header=[], contents=[]):
    self.id = gentemp('SCHEMA')
    self.predicate = predicate
    self.participants = participants
    self.vars = vars
    self.bindings = bindings
    self.header = ELF(header)
    self.contents = ELF(contents)
    self.sections = {}
    self.embedding = []

  def read_param_dict(predicate, schema_contents):
    """Read an S-expression containing schema contents (for a given predicate) into a dict of schema parameters."""
    kwargs = {}
    kwargs['predicate'] = predicate
    header = get_keyword_contents(schema_contents, [':header'])[0]
    kwargs['participants'] = [x for x in flatten(header)[:-2] if x not in ['set-of', predicate]]
    kwargs['vars'] = remove_duplicates([x for x in flatten(schema_contents) if variablep(x)])
    kwargs['contents'] = schema_contents
    kwargs['header'] = header
    return kwargs
  
  def to_probability_dict(self, eventualities, swap_duals=False):
    """Given a list of certainty or necessity eventualities, create a probability dict with entries of form {<ep>:<prob>}.
    
    If 'swap_duals' is True, swap episode constants in the resulting probability dict with the dual var (e.g., ?e1 for !e1).
    """
    probabilities = {}
    for e in eventualities:
      pair = e.get_wff()
      if isinstance(pair, list) and len(pair) == 2:
        if swap_duals:
          var = dual_var(pair[0])
        else:
          var = pair[0]
        probabilities[var] = float(pair[1])
    return probabilities
  
  def subst_mappings(self, mappings):
    """Given a list of variable replacement mappings, apply the mappings to each part of the schema."""
    self.participants = substall(self.participants, mappings)
    self.vars = [m[1] for m in mappings]
    self.bindings = dict_substall_keys(self.bindings, mappings)
    self.header = ELF(substall(self.header.get_formula(), mappings))
    self.contents = ELF(substall(self.contents.get_formula(), mappings))
    for sec in self.sections.values():
      for (var1, var2) in mappings:
        [e.replacevar(var1, var2) for e in sec]
  
  def duplicate_variables(self):
    """Duplicate all variables across a schema, mapping the original variables to the duplicated ones.
    
    Note that this needs to be done in two steps to avoid mapping conflicts.
    """
    mappings = [(var, duplicate_var(var)) for var in self.vars]
    m1 = [(m[0], f'?{m[0]}') for m in mappings]
    m2 = [(f'?{m[0]}', m[1]) for m in mappings]
    self.subst_mappings(m1)
    self.subst_mappings(m2)

  def instantiate(self, args):
    """Instantiate a specific instance of a schema given a list of argument values for each variable in the header.

    This creates a deep copy of the schema, with duplicate variables to ensure that no collisions occur if
    the events in the schema are added to a plan.

    Parameters
    ----------
    args : list[s-expr]
      A list of expressions to bind to each respective header variable.
    
    Returns
    -------
    Schema
    """
    schema_instance = deepcopy(self)
    schema_instance.duplicate_variables()
    schema_instance.bind_args(args)
    return schema_instance

  def bind(self, var, val):
    """Bind the given variable symbol to the given value."""
    if not var in self.vars:
      return self
    self.bindings[var] = val
    for sec in self.sections.values():
      for eventuality in sec:
        eventuality.bind(var, val)
    return self
  
  def unbind(self, var):
    """Unbind the given variable symbol."""
    if not var in self.vars:
      return self
    if var in self.bindings:
      self.bindings.pop(var)
    for sec in self.sections.values():
      for eventuality in sec:
        eventuality.unbind(var)
    return self
  
  def bind_args(self, args):
    """Bind variables in the schema header with a list of respective argument values.
    
    Generally, we assume that 'args' should correspond to the variables in the participants list of
    the schema, but we allow for the possibility of ^me and ^you as implicit arguments if fewer arguments
    than variables are given - in which case, they're added to the arguments list in that order.

    On the other hand, if more arguments than variables are given, we assume that
    ^me and ^you might be provided as redundant arguments, and remove those from
    the front of the list if present. Otherwise, we remove superfluous arguments
    starting from the end of the list.

    Parameters
    ----------
    args : list[s-expr]
      A list of expressions to bind to each respective header variable.
    """
    participants = self.participants
    vars = [p for p in participants if variablep(p)]

    # Return with warning if no variables in participants list
    if not vars:
      # print(f'@@@ Warning: Attempt to substitute values \n    {args}\n    in participants {participants}, which has no variables.')
      return self
    
    # Case 1: More args than variables
    if len(args) > len(vars):
      # print(f'@@@ Warning: More values supplied, vis.,\n    {args},\n    than participants {participants} has variables.')

      # If ^me or ^you are already in participants of the schema, remove them from the args list
      args = [x for x in args if x != ME] if ME in participants else args
      args = [x for x in args if x != YOU] if YOU in participants else args
      # Otherwise remove superfluous arguments from end of list
      if len(args) > len(vars):
        args = args[:(len(vars)-len(args))]

      # print(f'@@@ Now using args: {args}')

    # Case 2: Fewer args than variables
    elif len(args) < len(vars):
      # print(f'@@@ Warning: Fewer values supplied, vis.,\n    {args},\n    than participants {participants} has variables.')

      # Assume first two missing args are ^me and ^you if they don't appear in the header
      if (len(vars)-len(args)) >= 2 and not YOU in participants:
        args = cons(YOU, args)
      if not ME in participants:
        args = cons(ME, args)
      if len(args) < len(vars):
        vars = vars[:(len(args)-len(vars))]

      # print(f'@@@ Now using args: {args}, for vars: {vars}')

    # Length of 'args' and 'vars' are equal (or have just been equalized)
    for var, arg in zip(vars, args):
      self.bind(var, arg)
    
    return self
    # END bind_args

  def embed(self, embedder):
    """Embed the schema based on the natural language representation of its contents, given an embedder object."""
    self.embedding = embedder.embed(self.contents.to_nl())
    for sec in self.sections.values():
      for eventuality in sec:
        eventuality.embed(embedder)

  def retrieve(self, embedder, query, n=5, header=True):
    """Retrieve some number of facts from the schema according to similarity with a query string, given an embedder object.
    
    Parameters
    ----------
    embedder : Embedder
      An Embedder object.
    query : str
      A query string to use to compute similarity.
    n : int, optional
      The number of facts to retrieve (the default is 5).
    header : bool, optional
      Whether to prefix the retrieved facts with the schema header (the default is True).

    Returns
    -------
    list[s-expr]
      The retrieved schema facts as S-expressions.
    """
    eventualities = self.get_section(':all')
    scores = embedder.score(query, eventualities, [e.embedding for e in eventualities])
    top = argmax(eventualities, scores, n)
    if header:
      return cons(self.header.get_formula(), [e.get_wff() for e in top])
    else:
      return [e.get_wff() for e in top]

  def get_participants(self, no_bind=False):
    """Get the schema participants.
    
    Parameters
    ----------
    no_bind : bool, optional
      Do not make variable substitutions (the default is False).
    
    Returns
    -------
    list[s-expr]
    """
    if no_bind:
      return self.participants
    else:
      return substall(self.participants, list(self.bindings.items()))

  def get_contents(self, no_bind=False):
    """Get the schema contents as an S-expression.
    
    Parameters
    ----------
    no_bind : bool, optional
      Do not make variable substitutions (the default is False).

    Returns
    -------
    s-expr
    """
    if no_bind:
      return self.contents.get_formula()
    return substall(self.contents.get_formula(), list(self.bindings.items()))
  
  def get_section(self, sec):
    """Get the eventualities within a given schema section or list of sections.
    
    Parameters
    ----------
    sec : str or list[str]
      A section label or list of section labels, or the keyword ':all' to return all sections.

    Returns
    -------
    list[Eventuality]
    """
    if sec == ':all':
      return append([eventualities for eventualities in self.sections.values()])
    if isinstance(sec, str):
      sec = [sec]
    return append([self.sections[s] if s in self.sections else [] for s in sec])
  
  def get_section_eps(self, sec, no_bind=False):
    """Get all episode symbols within a schema section or list of sections.
    
    Parameters
    ----------
    sec : str or list[str]
      A section label or list of section labels, or the keyword ':all' to return all sections.
    no_bind : bool, optional
      Do not make variable substitutions (the default is False).

    Returns
    -------
    list[str]
    """
    section = self.get_section(sec)
    if no_bind:
      return [e.ep for e in section]
    return [e.get_ep() for e in section]
  
  def get_section_wffs(self, sec, no_bind=False):
    """Get all wffs within a schema section or list of sections.
    
    Parameters
    ----------
    sec : str or list[str]
      A section label or list of section labels, or the keyword ':all' to return all sections.
    no_bind : bool, optional
      Do not make variable substitutions (the default is False).

    Returns
    -------
    list[s-expr]
    """
    section = self.get_section(sec)
    return [e.get_wff(no_bind) for e in section]
  
  def format(self, no_bind=False):
    """Format the contents of this schema as an S-expression string."""
    return list_to_s_expr(self.get_contents(no_bind))

  def __str__(self):
    return self.format()


class EpiSchema(Schema):
  """A schema representing a prototypical episode.
  
  Sections
  --------
  types : the nominal types of each participant/variable.
  rigid-conds : non-fluent conditions relevant to episode.
  static-conds : fluent conditions that are not expected to change during episode.
  preconds : fluent conditions that are expected to hold at the beginning of episode.
  postconds : fluent conditions that are expected to hold at end of episode.
  goals : goals of participants in schema (e.g., (^me want.v (that ...))).
  episodes : the expected/intended sub-episodes of the schema episode.
  episode-relations : the temporal/causal relations between episodes of schema.
  necessities : probabilities associated with schema formulas.
  certainties : probabilities associated with schema episodes.
  """
  
  def __init__(self, predicate='', participants=[], vars=[], bindings={}, header=[], contents=[],
               types=[], rigid_conds=[], static_conds=[], preconds=[], postconds=[], goals=[],
               episodes=[], episode_relations=[], necessities=[], certainties=[]):
    super().__init__(predicate, participants, vars, bindings, header, contents)

    self.sections['necessities'] = parse_eventuality_list(necessities)
    self.sections['certainties'] = parse_eventuality_list(certainties)
    prob_dict = {**self.to_probability_dict(self.sections['necessities']),
                 **self.to_probability_dict(self.sections['certainties'], swap_duals=True)}
    
    self.sections['types'] = parse_eventuality_list(types, prob_dict)
    self.sections['rigid-conds'] = parse_eventuality_list(rigid_conds, prob_dict)
    self.sections['static-conds'] = parse_eventuality_list(static_conds, prob_dict)
    self.sections['preconds'] = parse_eventuality_list(preconds, prob_dict)
    self.sections['postconds'] = parse_eventuality_list(postconds, prob_dict)
    self.sections['goals'] = parse_eventuality_list(goals, prob_dict)
    self.sections['episodes'] = parse_eventuality_list(episodes, prob_dict)
    self.sections['episode-relations'] = parse_eventuality_list(episode_relations, prob_dict)

  def read_param_dict(predicate, schema_contents):
    kwargs = Schema.read_param_dict(predicate, schema_contents)
    for section in [':types', ':rigid-conds', ':static-conds', ':preconds', ':postconds', ':goals',
                    ':episodes', ':episode-relations', ':necessities', ':certainties']:
      section_contents = get_keyword_contents(schema_contents, [section])
      if section_contents:
        kwargs[section[1:].replace('-', '_')] = section_contents[0]
    return kwargs


class DialSchema(EpiSchema):
  """A schema representing a prototypical episode.
  
  Sections
  --------
  types : the nominal types of each participant/variable.
  rigid-conds : non-fluent conditions relevant to episode.
  static-conds : fluent conditions that are not expected to change during episode.
  preconds : fluent conditions that are expected to hold at the beginning of episode.
  postconds : fluent conditions that are expected to hold at end of episode.
  goals : goals of participants in schema (e.g., (^me want.v (that ...))).
  episodes : the expected/intended sub-episodes of the schema episode.
  episode-relations : the temporal/causal relations between episodes of schema.
  obligations : the dialogue obligations associated with episodes within the schema.
  necessities : probabilities associated with schema formulas.
  certainties : probabilities associated with schema episodes.
  """

  def __init__(self, predicate='', participants=[], vars=[], bindings={}, header=[], contents=[],
               types=[], rigid_conds=[], static_conds=[], preconds=[], postconds=[], goals=[],
               episodes=[], episode_relations=[], obligations=[], necessities=[], certainties=[]):
    super().__init__(predicate, participants, vars, bindings, header, contents,
                     types, rigid_conds, static_conds, preconds, postconds, goals,
                     episodes, episode_relations, necessities, certainties)
    
    self.sections['obligations'] = parse_eventuality_list(obligations)
    
  def read_param_dict(predicate, schema_contents):
    kwargs = EpiSchema.read_param_dict(predicate, schema_contents)
    for section in [':obligations']:
      section_contents = get_keyword_contents(schema_contents, [section])
      if section_contents:
        kwargs[section[1:].replace('-', '_')] = section_contents[0]
    return kwargs
  
  def get_obligations_of_ep(self, ep):
    """Return all obligations attached to a given episode symbol.

    TODO: it may be better to create a generalized accessor function for other types of schema
    annotations/episode relations.

    Parameters
    ----------
    ep : str
      An episode symbol.

    Returns
    -------
    list[Eventuality]
    """
    obligations = []
    for wff in self.get_section_wffs('obligations'):
      if wff[0] == ep and len(wff) == 3 and wff[1] == 'obligates':
        obligations.append(ULF(wff[2]))
    return obligations
  
      
class ObjSchema(Schema):
  """A schema representing a prototypical object.
  
  Sections
  --------
  types : the nominal types of each participant/variable.
  rigid-conds : non-fluent conditions relevant to object.
  skeletal-prototype : 3D mesh decomposition of object (.obj filenames).
  purposes : telic purpose associated with object.
  necessities : probabilities associated with schema formulas.
  """

  def __init__(self, predicate='', participants=[], vars=[], bindings={}, header=[], contents=[],
               types=[], rigid_conds=[], skeletal_prototype='', purposes=[], necessities=[]):
    super().__init__(predicate, participants, vars, bindings, header, contents)

    self.sections['necessities'] = parse_eventuality_list(necessities)
    prob_dict = self.to_probability_dict(self.sections['necessities'])
    
    self.sections['types'] = parse_eventuality_list(types, prob_dict)
    self.sections['rigid-conds'] = parse_eventuality_list(rigid_conds, prob_dict)
    self.sections['skeletal-prototype'] = parse_eventuality_list(skeletal_prototype, prob_dict)
    self.sections['purposes'] = parse_eventuality_list(purposes, prob_dict)

  def read_param_dict(predicate, schema_contents):
    kwargs = Schema.read_param_dict(predicate, schema_contents)
    for section in [':types', ':rigid-conds', ':skeletal-prototype', ':purposes', ':necessities']:
      section_contents = get_keyword_contents(schema_contents, [section])
      if section_contents:
        kwargs[section[1:].replace('-', '_')] = section_contents[0]
    return kwargs
  

class SchemaLibrary:
  """A library of all generic episode, dialogue, and object schemas.

  Attributes
  ----------
  dial : dict[str, DialSchema]
    A dict mapping dialogue schema predicates to dialogue schemas.
  epi : dict[str, EpiSchema]
    A dict mapping episode schema predicates to episode schemas.
  obj : dict[str, ObjSchema]
    A dict mapping object schema predicates to object schemas.
  embedder : Embedder, optional
    If provided, an embedder to embed all schemas that are added.
  """

  def __init__(self, embedder=None):
    self.dial = {}
    self.epi = {}
    self.obj = {}
    self.embedder = embedder

  def add(self, schema):
    """Add a schema object to the library."""
    if isinstance(schema, DialSchema):
      self.dial[schema.predicate] = schema
    elif isinstance(schema, EpiSchema):
      self.epi[schema.predicate] = schema
    elif isinstance(schema, ObjSchema):
      self.obj[schema.predicate] = schema
    else:
      raise Exception(f'Unsupported schema type for {schema.predicate}')
    
  def create(self, predicate, contents):
    """Create a schema object from the given predicate and contents (an S-expression) and add it to the library."""
    if contents[0] in ['dialogue-schema', 'dial-schema']:
      typ = DialSchema
    elif contents[0] in ['event-schema', 'episode-schema', 'epi-schema']:
      typ = EpiSchema
    elif contents[0] in ['object-schema', 'obj-schema']:
      typ = ObjSchema
    else:
      raise Exception(f'Schema for {predicate} must begin with either dial-schema, epi-schema or obj-schema')
    schema = typ(**typ.read_param_dict(predicate, contents))
    if self.embedder:
      schema.embed(self.embedder)
    self.add(schema)

  def get_schemas(self, type):
    """Get all schemas of a particular type or list of types.
    
    Parameters
    ----------
    type : str or list[str]
      A schema type ('dial', 'epi', or 'obj'), or a list of types.

    Returns
    -------
    list[Schema]
    """
    if isinstance(type, list):
      return append([self.get_schemas(t) for t in type])
    
    if type=='dial':
      return list(self.dial.values())
    elif type=='epi':
      return list(self.epi.values())
    elif type=='obj':
      return list(self.obj.values())
    
  def is_schema(self, predicate, type=None):
    """Check whether a given predicate exists in the schema library.
    
    Parameters
    ----------
    predicate : str
      The predicate to check.
    type : str, optional
      If a type is given, only check that type of schema.
    
    Returns
    -------
    bool
    """
    if type=='dial':
      return predicate in self.dial
    elif type=='epi':
      return predicate in self.epi
    elif type=='obj':
      return predicate in self.obj
    else:
      return predicate in self.dial or predicate in self.epi or predicate in self.obj

  def retrieve(self, type, query=None, m=1):
    """Retrieve some number of schemas of a particular type (or list of types).
    
    Parameters
    ----------
    type : str or list[str]
      A schema type ('dial', 'epi', or 'obj'), or a list of types.
    query : str, optional
      A query string to use to compute similarity. If not given (default), or if no embedder is
      defined, an arbitrary schema is retrieved.
    m : int, optional
      The number of schemas to retrieve (the default is 1).

    Returns
    -------
    list[Schema]
      The retrieved schemas.
    """
    schemas = list(self.get_schemas(type))
    if not schemas:
      return None
    if not query or not self.embedder:
      return schemas[0]
    scores = self.embedder.score(query, schemas, [s.embedding for s in schemas])
    return argmax(schemas, scores, m)
  
  def retrieve_knowledge(self, type, query=None, m=1, n=5, header=True):
    """Retrieve some number of facts from some number of retrieved schemas of a particular type (or list of types).
    
    Parameters
    ----------
    type : str or list[str]
      A schema type ('dial', 'epi', or 'obj'), or a list of types.
    query : str, optional
      A query string to use to compute similarity. If not given (default), or if no embedder is
      defined, an arbitrary schema is retrieved.
    m : int, optional
      The number of schemas to retrieve (the default is 1).
    n : int, optional
      The number of facts to retrieve from each retrieved schema (the default is 5).
    header : bool, optional
      Whether to prefix the retrieved facts with the schema header (the default is True).

    Returns
    -------
    list[s-expr]
      The facts retrieved from each retrieved schema, as S-expressions.
    """
    schemas = self.retrieve(type, query, m)
    if not schemas:
      return None
    return append([s.retrieve(self.embedder, query, n, header) for s in schemas])

  def from_lisp_file(self, fname):
    """Read a set of schemas from a LISP file, storing them in the library.
    
    Parameters
    ----------
    fname : str
      The LISP file to read.
    """
    for expr in read_lisp(fname):
      if expr[0] == 'store-schema':
        predicate = expr[1].strip("'")
        contents = expr[2]
        if predicate:
          self.create(predicate, contents)
    return self

  def from_lisp_dirs(self, dirs):
    """Recursively read schemas from all LISP files in a given directory or list of directories.
    
    Parameters
    ----------
    dirs : str or list[str]
      Either a directory name or a list of directory names to read.
    """
    if isinstance(dirs, str):
      dirs = [dirs]
    for dir in dirs:
      fnames = glob.glob(dir + '/**/*.lisp', recursive=True)
      for fname in fnames:
        self.from_lisp_file(fname)
    return self

  def __str__(self):
    ret = []
    for name, d in zip(['dialogue:', 'episode:', 'object:'], [self.dial, self.epi, self.obj]):
      ret.append(name+'\n'+'\n'.join([predicate for predicate in d.keys()]))
    return '\n\n'.join(ret)