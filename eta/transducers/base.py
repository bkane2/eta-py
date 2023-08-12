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
    """List[Eventuality] -> List[Eventuality]"""
    new_facts = []
    return new_facts
  

class GistTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, utt, conversation_log):
    """str, List[DialogueTurn] -> str"""
    gists = []
    return gists
  

class SemanticTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, gist):
    """str -> List"""
    ulf = []
    return ulf
  

class PragmaticTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, gist):
    """str -> List"""
    ulf = []
    return ulf
  

class ReactionTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, observation):
    """Eventuality -> List"""
    action = []
    return action
  

class ExpandStepTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, step):
    """Eventuality -> List[Eventuality]"""
    substeps = []
    return substeps
  

class ParaphraseTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, gist, prev_gist, history):
    """str, str, List[str] -> Eventuality"""
    utt = None
    return utt
  

# PlanExpansionTransducer(Transducer):
# history, context, curr-step -> List[Eventuality]