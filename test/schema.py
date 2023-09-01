from eta.schema import *
from eta.embedding import *

def testschema():
  sep = '\n----------------------------\n'
  print(sep)

  schemas = SchemaLibrary()
  schemas.from_lisp_dirs(['agents/test/schemas'])

  print(schemas, sep)

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

  print(schema.get_section(':all'), sep)


def testcopy():
  sep = '\n----------------------------\n'
  print(sep)

  schemas = SchemaLibrary()
  schemas.from_lisp_dirs(['agents/test/schemas'])

  print(schemas, sep)

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


def testcond():
  sep = '\n----------------------------\n'
  print(sep)

  schemas = SchemaLibrary()
  schemas.from_lisp_dirs(['agents/test/schemas'])

  print(schemas, sep)

  schema = schemas.dial['test-cond.v']
  print(schema, sep)

  print(schema.participants)
  schema.bind_args([ME, YOU, '"this is another test string ."'])
  print(schema.participants, sep)

  for f in schema.get_section('episodes'):
    print('>', f)
  print(sep)

  for (cond, event) in schema.get_section('episodes')[1].conditions:
    print(cond)
    for e in event:
      print('>', e)
  print(sep)

  print(schema.vars, sep)

  schema.bind('?e1', 'e5')
  schema.bind('?e8', 'e90')
  schema.bind('?response', ['test', 'response', '.'])
  print(schema.bindings, sep)

  for f in schema.get_section('episodes'):
    print(f)
  print(sep)

  for (cond, event) in schema.get_section('episodes')[1].conditions:
    print(cond)
    for e in event:
      print('>', e)
  print(sep)

  print(schema, sep)

  print(schema.get_section_eps('episodes'), sep)
  print(schema.get_section_wffs('episodes'), sep)
  print(schema.get_section_wffs(['rigid-conds', 'static-conds', 'preconds']), sep)


def test_retrieval():
  sep = '\n----------------------------\n'

  print('embedding...')
  schemas = SchemaLibrary(STEmbedder())
  schemas.from_lisp_dirs(['agents/sophie-gpt/schemas'])
  print('done')

  print('retrieving...')
  top = schemas.retrieve('dial', 'where is your pain located ?')
  for t in top:
    print(t)
  print(sep)

  facts = schemas.retrieve_knowledge('dial', 'where is your pain located ?', m=3, n=5)
  for f in facts:
    print(f)
  print(sep)



def main():
  sep = '\n----------------------------\n'

  testschema()
  testcopy()
  testcond()
  test_retrieval()


if __name__ == '__main__':
  main()