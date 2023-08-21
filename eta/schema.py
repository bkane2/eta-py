import glob
from copy import deepcopy

from eta.constants import ME, YOU
from eta.util.general import (gentemp, remove_duplicates, get_keyword_contents, append, 
                              cons, flatten, subst, substall, dict_substall_keys, variablep, dual_var, duplicate_var)
from eta.util.sexpr import read_lisp, list_to_s_expr
from eta.lf import ULF, ELF, parse_eventuality_list

class Schema:
  """
  Defines a basic schema, which contains the following fields:
  id            : a unique ID for this schema
  predicate     : the main predicate of the schema
  participants  : the participant roles of a schema present in the header (e.g., '(^me ^you))
  vars          : the variables scoped within a schema
  bindings      : current bindings for each variable in the schema (initialized to empty hash table)
  header        : the full header of the schema
  contents      : the contents of the schema as an s-expr list
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
    """Reads an s-expr of the schema contents into a parameter dict."""
    kwargs = {}
    kwargs['predicate'] = predicate
    header = get_keyword_contents(schema_contents, [':header'])[0]
    kwargs['participants'] = [x for x in flatten(header)[:-2] if x not in ['set-of', predicate]]
    kwargs['vars'] = remove_duplicates([x for x in flatten(schema_contents) if variablep(x)])
    kwargs['contents'] = schema_contents
    kwargs['header'] = header
    return kwargs
  
  def to_probability_dict(self, eventualities, swap_duals=False):
    """Given a list of eventualities (i.e., certainty or necessity formulas), create a
       probability dict with entries of form {<ep>:<prob>}."""
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
    """Given a list of variable mappings, apply the mappings to each part of the schema."""
    self.participants = substall(self.participants, mappings)
    self.vars = [m[1] for m in mappings]
    self.bindings = dict_substall_keys(self.bindings, mappings)
    self.header = ELF(substall(self.header.get_formula(), mappings))
    self.contents = ELF(substall(self.contents.get_formula(), mappings))
    for sec in self.sections.values():
      for (var1, var2) in mappings:
        [e.replacevar(var1, var2) for e in sec]
  
  def duplicate_variables(self):
    """Duplicate all variables across a schema's sections. Note that this needs to be done
       in two steps in order to avoid a variable getting mapped to another variable in the mappings."""
    mappings = [(var, duplicate_var(var)) for var in self.vars]
    m1 = [(m[0], f'?{m[0]}') for m in mappings]
    m2 = [(f'?{m[0]}', m[1]) for m in mappings]
    self.subst_mappings(m1)
    self.subst_mappings(m2)

  def instantiate(self, args):
    """
    Instantiates a specific instance of a schema given a list of arguments
    corresponding to the variables in the schema header. This creates a copy
    of the general schema with specific variable bindings. All variables in
    the schema are first duplicated to ensure that there are no collisions when
    binding a variable in the plan.
    TODO: previously, this also attempted to instantiate objects from the :types
    and :rigid-conds of the schema based on the dialogue context, adding further
    inferences to the context. This step is still necessary, but should happen
    elsewhere directly after instantiation of a schema.
    """
    schema_instance = deepcopy(self)
    schema_instance.duplicate_variables()
    schema_instance.bind_args(args)
    return schema_instance

  def bind(self, var, val):
    """Binds a variable to a value within a schema and all sub-formulas."""
    if not var in self.vars:
      return self
    self.bindings[var] = val
    for sec in self.sections.values():
      for eventuality in sec:
        eventuality.bind(var, val)
    return self
  
  def unbind(self, var):
    """Unbinds a variable within a schema and all sub-formulas."""
    if not var in self.vars:
      return self
    if var in self.bindings:
      self.bindings.pop(var)
    for sec in self.sections.values():
      for eventuality in sec:
        eventuality.unbind(var)
    return self
  
  def bind_args(self, args):
    """
    Substitute the successive arguments in the 'args' list for successive
    variables occurring in the schema or plan header exclusive of the 
    episode variable characterized by the header predication (for 
    episodic headers).
   
    Generally, 'args' should correspond to the variables in the participants
    list of the schema, but we allow for the possibility of ^me and ^you as
    implicit arguments if fewer arguments than variables are given - in which
    case, they're added to the arguments list in that order.
   
    On the other hand, if more arguments than variables are given, we assume that
    ^me and ^you might be provided as redundant arguments, and remove those from
    the front of the list if present. Otherwise, we remove superfluous arguments
    starting from the end of the list.
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
    """Create embeddings for the schema as a whole, as well as for each eventuality."""
    self.embedding = embedder.embed(self.contents.to_nl())
    for sec in self.sections.values():
      for eventuality in sec:
        eventuality.embed(embedder)

  def get_participants(self, no_bind=False):
    if no_bind:
      return self.participants
    else:
      return substall(self.participants, list(self.bindings.items()))

  def get_contents(self, no_bind=False):
    if no_bind:
      return self.contents.get_formula()
    return substall(self.contents.get_formula(), list(self.bindings.items()))
  
  def get_section(self, sec):
    if isinstance(sec, str):
      sec = [sec]
    return append([self.sections[s] if s in self.sections else [] for s in sec])
  
  def get_section_eps(self, sec, no_bind=False):
    section = self.get_section(sec)
    if no_bind:
      return [e.ep for e in section]
    return [e.get_ep() for e in section]
  
  def get_section_wffs(self, sec, no_bind=False):
    section = self.get_section(sec)
    return [e.get_wff(no_bind) for e in section]
  
  def format(self, no_bind=False):
    return list_to_s_expr(self.get_contents(no_bind))

  def __str__(self):
    return self.format()


class EpiSchema(Schema):
  """
  Defines an episode schema, which contains the following additional fields:
  types             : the nominal types of each participant/variable
  rigid-conds       : non-fluent conditions relevant to episode
  static-conds      : fluent conditions that are not expected to change during episode
  preconds          : fluent conditions that are expected to hold at the beginning of episode
  postconds         : fluent conditions that are expected to hold at end of episode
  goals             : goals of participants in schema (e.g., (^me want.v (that ...)))
  episodes          : the expected/intended sub-episodes of the schema episode
  episode-relations : the temporal/causal relations between episodes of schema
  obligations       : dialogue obligations associated with particular episodes
  necessities       : probabilities associated with schema formulas
  certainties       : probabilities associated with schema episodes
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
    """Reads an s-expr of the schema contents into a parameter dict."""
    kwargs = Schema.read_param_dict(predicate, schema_contents)
    for section in [':types', ':rigid-conds', ':static-conds', ':preconds', ':postconds', ':goals',
                    ':episodes', ':episode-relations', ':necessities', ':certainties']:
      section_contents = get_keyword_contents(schema_contents, [section])
      if section_contents:
        kwargs[section[1:].replace('-', '_')] = section_contents[0]
    return kwargs


class DialSchema(EpiSchema):
  """
  Defines a dialogue schema, which is a specific type of episode schema that defines an
  expected dialogue event.
  """
  def __init__(self, predicate='', participants=[], vars=[], bindings={}, header=[], contents=[],
               types=[], rigid_conds=[], static_conds=[], preconds=[], postconds=[], goals=[],
               episodes=[], episode_relations=[], obligations=[], necessities=[], certainties=[]):
    super().__init__(predicate, participants, vars, bindings, header, contents,
                     types, rigid_conds, static_conds, preconds, postconds, goals,
                     episodes, episode_relations, necessities, certainties)
    
    self.sections['obligations'] = parse_eventuality_list(obligations)
    
  def read_param_dict(predicate, schema_contents):
    """Reads an s-expr of the schema contents into a parameter dict."""
    kwargs = EpiSchema.read_param_dict(predicate, schema_contents)
    for section in [':obligations']:
      section_contents = get_keyword_contents(schema_contents, [section])
      if section_contents:
        kwargs[section[1:].replace('-', '_')] = section_contents[0]
    return kwargs
  
  def get_obligations_of_ep(self, ep):
    """
    Given an ep var/name, return all obligations attached to that ep via the corresponding
    formulas in :obligations.
    TODO: eventually we may wish to generalize this accessor function to other types of schema
    annotations/episode relations.
    """
    obligations = []
    for wff in self.get_section_wffs('obligations'):
      if wff[0] == ep and len(wff) == 3 and wff[1] == 'obligates':
        obligations.append(ULF(wff[2]))
    return obligations
  
      
class ObjSchema(Schema):
  """
  Defines an object schema, which contains the following additional fields:
  types              : the nominal types of each participant/variable
  rigid-conds        : non-fluent conditions relevant to object
  skeletal-prototype : 3D mesh decomposition of object (.obj filenames)
  purposes           : telic purpose associated with object
  necessities        : probabilities associated with schema formulas
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
    """Reads an s-expr of the schema contents into a parameter dict."""
    kwargs = Schema.read_param_dict(predicate, schema_contents)
    for section in [':types', ':rigid-conds', ':skeletal-prototype', ':purposes', ':necessities']:
      section_contents = get_keyword_contents(schema_contents, [section])
      if section_contents:
        kwargs[section[1:].replace('-', '_')] = section_contents[0]
    return kwargs
  

class SchemaLibrary:
  """
  Contains a dictionary of predicate:schema pairs for each type of supported schema.
  """
  def __init__(self, embedder=None):
    self.dial = {}
    self.epi = {}
    self.obj = {}
    self.embedder = embedder

  def add(self, schema):
    if isinstance(schema, DialSchema):
      self.dial[schema.predicate] = schema
    elif isinstance(schema, EpiSchema):
      self.epi[schema.predicate] = schema
    elif isinstance(schema, ObjSchema):
      self.obj[schema.predicate] = schema
    else:
      raise Exception(f'Unsupported schema type for {schema.predicate}')
    
  def create(self, predicate, contents):
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

  def retrieve(self, query=None):
    """TBC"""
    # TODO:
    # should have type of schema as argument
    # 1. use schema embeddings to select top schema
    # 2. combine section eventualities
    # 3. select n top eventualities
    # 4. return schema header + eventualities
    pass

  def from_lisp_file(self, fname):
    """Reads a set of schemas from a .lisp file."""
    for expr in read_lisp(fname):
      if expr[0] == 'store-schema':
        predicate = expr[1].strip("'")
        contents = expr[2]
        if predicate:
          self.create(predicate, contents)
    return self

  def from_lisp_dirs(self, dirs):
    """Recursively reads all .lisp files in a given dir or list of dirs,
      returning a dict of generic schemas."""
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
  

def testschema(schemas):
  sep = '\n----------------------------\n'
  print(sep)

  schema = schemas.dial['test.v']
  print(schema, sep)

  print(schema.get_participants())
  schema.bind_args([ME, YOU, '"this is another test string ."'])
  print(schema.get_participants())
  for f in schema.get_section('episodes'):
    print(f)
  print(sep)

  print(schema.vars, sep)

  schema.bind('?e1', 'e5')
  print(schema.bindings, sep)

  for f in schema.get_section('episodes'):
    print(f)
  print(sep)

  print(schema, sep)

  print(schema.get_section_eps('episodes'), sep)
  print(schema.get_section_wffs('episodes'), sep)
  print(schema.get_section_wffs(['rigid-conds', 'static-conds', 'preconds']), sep)


def testcopy(schemas):
  sep = '\n----------------------------\n'
  print(sep)

  schema = schemas.dial['test.v']
  print(schema, sep)

  print(schema.vars, sep)

  schema.bind('?e1', 'e5')
  print(schema.bindings, sep)

  for f in schema.get_section('episodes'):
    print(f)
  print(sep)

  schema_clone = schema.instantiate([ME, YOU, '"this is another test string ."'])
  print(schema_clone.bindings, sep)

  var = schema_clone.get_section('episodes')[1].get_ep()
  schema_clone.bind(var, 'e7')
  print(schema.bindings)
  print(schema_clone.bindings, sep)

  for f in schema.get_section('episodes'):
    print(f)
  print(sep)

  for f in schema_clone.get_section('episodes'):
    print(f)
  print(sep)


def testcond(schemas):
  sep = '\n----------------------------\n'
  print(sep)

  schema = schemas.dial['test-cond.v']
  print(schema, sep)

  print(schema.participants)
  schema.bind_args([ME, YOU, '"this is another test string ."'])
  print(schema.participants, sep)

  for f in schema.get_section('episodes'):
    print('>', f)
  print(sep)

  print(schema.get_section('episodes')[1].condition, sep)
  for f in schema.get_section('episodes')[1].eventualities:
    print('>', f)
  print(sep)

  for c, fs in schema.get_section('episodes')[1].eventualities[2].conditions:
    print(c)
    for f in fs:
      print('>', f)
  print(sep)

  print(schema.vars, sep)

  schema.bind('?e1', 'e5')
  schema.bind('?e8', 'e90')
  schema.bind('?response', ['test', 'response', '.'])
  print(schema.bindings, sep)

  for f in schema.get_section('episodes'):
    print(f)
  print(sep)

  for c, fs in schema.get_section('episodes')[1].eventualities[2].conditions:
    print(c)
    for f in fs:
      print('>', f)
  print(sep)

  print(schema, sep)

  print(schema.get_section_eps('episodes'), sep)
  print(schema.get_section_wffs('episodes'), sep)
  print(schema.get_section_wffs(['rigid-conds', 'static-conds', 'preconds']), sep)


def main():
  sep = '\n----------------------------\n'
  schemas = SchemaLibrary()
  schemas.from_lisp_dirs(['avatars/test/schemas'])

  print(schemas, sep)

  testschema(schemas)
  # testcopy(schemas)
  # testcond(schemas)


if __name__ == '__main__':
  main()