from eta.plan import *
from eta.lf import *
from eta.schema import *

def make_test_plan_tree():
  """Creates an artificial plan tree for testing purposes."""
  pe1 = PlanStep(event=parse_eventuality('step 1'))
  pe2a = PlanStep(event=parse_eventuality('step 2a'))
  pe2b = PlanStep(event=parse_eventuality('step 2b'))
  pe3a = PlanStep(event=parse_eventuality('step 3a'))
  pe3b = PlanStep(event=parse_eventuality('step 3b'))
  pe1.supersteps = [pe2a, pe2b]
  pe2a.supersteps = [pe3a]
  pe2b.supersteps = [pe3a, pe3b]
  pe2a.substeps = [pe1]
  pe2b.substeps = [pe1]
  pe3a.substeps = [pe2a, pe2b]
  pe3b.substeps = [pe2b]
  return pe1, pe3a, pe3b


def make_test_plan():
  """Creates an artificial plan structure for testing purposes."""
  schema_instances = {}
  s1 = DialSchema(**DialSchema.read_param_dict('schema1.v', ['dial-schema', ':header', ['schema1.v', '**', '?e']]))
  s2 = DialSchema(**DialSchema.read_param_dict('schema2.v', ['dial-schema', ':header', ['schema2.v', '**', '?e']]))
  s3 = DialSchema(**DialSchema.read_param_dict('schema3.v', ['dial-schema', ':header', ['schema3.v', '**', '?e']]))
  s4 = DialSchema(**DialSchema.read_param_dict('schema4.v', ['dial-schema', ':header', ['schema4.v', '**', '?e']]))
  sid1 = s1.id
  sid2 = s2.id
  sid3 = s3.id
  sid4 = s4.id
  pe1 = PlanStep(event=parse_eventuality('(test ?e1)', ep='?e1'))
  pe2 = PlanStep(event=parse_eventuality('(test ?e1)', ep='?e2'))
  pe3 = PlanStep(event=parse_eventuality('(test ?e1 ?e2 ?words)', ep='?e3'))
  pe4 = PlanStep(event=parse_eventuality('(test ?e1 ?e2 ?e3)', ep='?e4'))
  pe5 = PlanStep(event=parse_eventuality('(test ?e1 ?e2 ?e3 ?e4 ?words)', ep='?e5'))
  pe6 = PlanStep(event=parse_eventuality('(test ?e4 ?words ?e5)', ep='?e6'))
  pe7 = PlanStep(event=parse_eventuality('(test ?e1 ?e6)', ep='?e7'))
  pe8 = PlanStep(event=parse_eventuality('(test ?e9 ?e7)', ep='?e8'))
  pe9 = PlanStep(event=parse_eventuality('(test ?e1 ?e12)', ep='?e9'))
  pe10 = PlanStep(event=parse_eventuality('(test ?e7 ?e8 ?e9)', ep='?e10'))
  pe11 = PlanStep(event=parse_eventuality('(test ?e1 ?words)', ep='?e11'))
  pe12 = PlanStep(event=parse_eventuality('(test ?e1 ?e11)', ep='?e12'))
  n8 = PlanNode(pe8)
  n9 = PlanNode(pe9)
  n10 = PlanNode(pe10)
  n11 = PlanNode(pe11)
  n12 = PlanNode(pe12)
  n7 = PlanNode(pe7)
  pe1.substeps = [pe3, pe4, pe5]
  pe2.substeps = [pe4, pe6, pe7]
  pe3.substeps = [pe8, pe9]
  pe4.substeps = [pe10]
  pe5.substeps = [pe9, pe11]
  pe6.substeps = [pe12]
  pe3.supersteps = [pe1]
  pe4.supersteps = [pe1, pe2]
  pe5.supersteps = [pe1]
  pe6.supersteps = [pe2]
  pe7.supersteps = [pe2]
  pe8.supersteps = [pe3]
  pe9.supersteps = [pe3, pe5]
  pe10.supersteps = [pe4]
  pe11.supersteps = [pe5]
  pe12.supersteps = [pe6]
  pe1.schemas = [s1]
  pe2.schemas = [s2]
  pe3.schemas = [s1, s3]
  pe4.schemas = [s1, s2]
  pe5.schemas = [s1, s2, s4]
  pe6.schemas = [s2]
  pe7.schemas = [s2]
  pe8.schemas = [s1, s3]
  pe9.schemas = [s1, s3, s4]
  pe10.schemas = [s1, s2]
  pe11.schemas = [s1, s2, s4]
  pe12.schemas = [s2]
  n8.next = n9
  n9.prev = n8
  n9.next = n10
  n10.prev = n9
  n10.next = n11
  n11.prev = n10
  n11.next = n12
  n12.prev = n11
  n12.next = n7
  n7.prev = n12
  for schema in [s1, s2, s3, s4]:
    schema_instances[schema.id] = schema
  plan_vars = [
    ('?e1', '?ea1', sid1),
    ('?e2', '?eb1', sid2),
    ('?e3', '?ea2', sid1),
    ('?e3', '?ec1', sid3),
    ('?words', '?w', sid1),
    ('?words', '?w', sid3),
    ('?e4', '?ea3', sid1),
    ('?e4', '?eb2', sid2),
    ('?e5', '?ea4', sid1),
    ('?e5', '?eb3', sid2),
    ('?e5', '?ed1', sid4),
    ('?e6', '?eb4', sid2),
    ('?e7', '?eb5', sid2),
    ('?e8', '?ea5', sid1),
    ('?e8', '?ec2', sid3),
    ('?e9', '?ea6', sid1),
    ('?e9', '?ec3', sid3),
    ('?e9', '?ed2', sid4),
    ('?e10', '?ea7', sid1),
    ('?e10', '?eb6', sid2),
    ('?e11', '?ea8', sid1),
    ('?e11', '?eb7', sid2),
    ('?e11', '?ed3', sid4),
    ('?e12', '?eb8', sid2),
  ]
  return n11, schema_instances


def test_formatting():
  sep = '\n----------------------------\n'

  step_surface, step_root1, step_root2 = make_test_plan_tree()
  print(step_surface.serialize(), sep)
  print(step_root1.serialize(), sep)
  print(step_root1.serialize(reverse=True), sep)
  print(step_root2.serialize(reverse=True), sep)

  plan, schema_instances = make_test_plan()

  print(plan.step.serialize(), sep)

  print(plan.serialize_subtree(), sep)

  print('\n'.join(plan.serialize_from_roots()), sep)

  print(plan, sep)

  print(plan.serialize_subtree(schema_instances), sep)

  # visualize_plan(plan)


def test_bind():
  sep = '\n----------------------------\n'

  plan, schema_instances = make_test_plan()

  print(plan, sep)
  print(plan.serialize_subtree(), sep)

  plan.bind('?words', ['this', 'is', 'a', 'test', 'sentence', '.'])
  
  print(plan, sep)
  print(plan.serialize_subtree(), sep)

  plan.bind('?e7', 'e100')
  plan.bind('?e1', 'e101')

  print(plan, sep)
  print(plan.serialize_subtree(), sep)



def main():
  test_formatting()
  test_bind()


if __name__ == "__main__":
  main()
