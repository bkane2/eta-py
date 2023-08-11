from time import sleep

from eta.constants import *
import eta.util.file as file
from eta.util.general import listp, atom
from eta.lf import parse_eventuality

def reasoning_loop(ds):
  # TODO: maintain depth limit for facts in inference queue
  while ds.do_continue():
    sleep(.1)

    facts = ds.pop_all_buffer('inferences')
    new_facts = []

    new_facts += infer_top_down(facts, ds)
    new_facts += infer_bottom_up(facts, ds)
    
    ds.add_all_to_context(new_facts)
    ds.add_all_to_buffer(new_facts, 'inferences')


def infer_top_down(facts, ds):
  """Infer new facts in a "top-down" manner, using the current expected/intended
     plan step as context for inferring new facts.
     TODO: make this function more general using transducer."""
  plan = ds.get_plan()
  if not plan or not facts:
    return []
  
  new_facts = []
  wff = plan.step.event.get_wff()

  # If currently pending step is the user replying to some episode e, and facts
  # contains a say-to.v action, infer (^you reply-to.v e).
  # NOTE: this can probably be done with pattern transduction, given each fact and
  # the ULF of the current step
  if reply_to_wff(wff):
    prior_ep = wff[2]
    facts_say_to = [fact for fact in facts if say_to_wff(fact.get_wff())]
    for fact in facts_say_to:
      ep = fact.get_ep()
      new_facts.append(parse_eventuality([YOU, REPLY_TO, prior_ep], ep=ep))

  return new_facts


def infer_bottom_up(facts, ds):
  """Infer new facts in a "bottom-up" manner, using relevant facts in memory.
     TODO: implement retrieval for relevant facts."""
  if not facts:
    return []
  
  new_facts = ds.apply_transducer('reasoning', facts)
  return new_facts


def reply_to_wff(wff):
  return listp(wff) and len(wff) == 3 and wff[0] == YOU and wff[1] == REPLY_TO and atom(wff[2])


def say_to_wff(wff):
  return listp(wff) and len(wff) == 4 and wff[0] == YOU and wff[1] == SAY_TO


def main():
  pass


if __name__ == "__main__":
  main()