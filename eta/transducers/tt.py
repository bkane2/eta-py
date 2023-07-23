from eta.transducers.base import *
from eta.lf import Eventuality

class TTTransducer(Transducer):
  def __init__(self, tree):
    self.tree = tree

  def __call__(self, facts):
    """List[Eventuality] -> List[Eventuality]"""
    pass
    

class TTReasoningTransducer(TTTransducer, ReasoningTransducer):
  def __init__(self, tree):
    self.tree = tree

  def __call__(self, facts):
    """List[Eventuality] -> List[Eventuality]"""
    pass