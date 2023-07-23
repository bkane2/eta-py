class Transducer():
  def __init__(self):
    pass

  def __call__(self, x):
    pass

  def cost(self):
    return 0.


class ReasoningTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, facts):
    # List[Eventuality] -> List[Eventuality]
    new_facts = []
    return new_facts