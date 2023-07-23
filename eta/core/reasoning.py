from time import sleep

def reasoning_loop(ds):
  while not ds.get_quit_conversation():
    sleep(.1)

    # Make inferences from queue of interpretations
    facts = ds.pop_all_buffer('perceptions')
    new_facts = ds.apply_transducer('reasoning', facts)
    ds.add_all_to_context(new_facts)


def main():
  pass


if __name__ == "__main__":
  main()