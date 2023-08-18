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
    """str, List[DialogueTurn] -> List[str]"""
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

  def __call__(self, gist, conversation_log, conds, facts):
    """str, List[DialogueTurn], List[Eventuality], List[Eventuality] -> List[str]"""
    utts = []
    return utts
  

class ResponseTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, conversation_log, conds, facts):
    """List[DialogueTurn], List[Eventuality], List[Eventuality] -> List[str]"""
    utts = []
    return utts
  

class AnswerTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, conversation_log, conds, facts):
    """List[DialogueTurn], List[Eventuality], List[Eventuality] -> List[str]"""
    utts = []
    return utts
  

class AskTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, conversation_log, conds, facts):
    """List[DialogueTurn], List[Eventuality], List[Eventuality] -> List[str]"""
    utts = []
    return utts
  

class AffectTransducer(Transducer):
  def __init__(self):
    pass

  def __call__(self, words, conversation_log):
    """str, List[DialogueTurn] -> List[str]"""
    affects = []
    return affects
  

# PlanExpansionTransducer(Transducer):
# history, context, curr-step -> List[Eventuality]