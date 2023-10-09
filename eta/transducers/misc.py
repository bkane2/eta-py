"""Contains miscellaneous transducer implementations not based on TT or GPT.

Notes
-----
TODO: since some of these are domain-specific (e.g., the SkillPragmaticTransducer for SOPHIE),
perhaps they ought to be defined outside of the Eta package? This will likely need to be sorted
out once this is deployed as a package that developers can extend with their own custom
transducers and configurations.
"""

import eta.util.file as file
from eta.constants import *
from eta.transducers.base import *
from eta.transducers.gpt import GPTResponseTransducer
from eta.util.gpt import generate_gpt, subst_kwargs

def _sophie_check_validator(prompt, resp):
  if 'yes' in resp.lower():
    return True
  elif 'no' in resp.lower():
    return False
  return None


class SkillTransducer(PragmaticTransducer):
  """A special type of pragmatic transducer used for inferring "skills" in the SOPHIE domain.

  These skills include showing empathy, being explicit, and empowering the user. This relies
  on a multilabel BERT-based classifier that was fine-tuned on doctor-patient conversation
  transcripts, with turns annotated for skills.

  Parameters
  ----------
  threshold : float, default=.5
    The threshold to use for model outputs.

  Attributes
  ----------
  classifier
    A transformers text classification pipeline for classifying skills.
  skill_enum : list[s-expr]
    A list enumerating the pragmatic inferences corresponding to each index in the model output.
  threshold : float
  """

  def __init__(self, threshold=.5):
    from transformers import AutoTokenizer, AutoModelForSequenceClassification, pipeline

    tokenizer = AutoTokenizer.from_pretrained("bkane2/skills-trainer", problem_type="multi_label_classification")
    model = AutoModelForSequenceClassification.from_pretrained("bkane2/skills-trainer", problem_type="multi_label_classification")
    self.classifier = pipeline("text-classification", model=model, tokenizer=tokenizer, top_k=None)

    self.skill_enum = [
      ['^you', 'be.v', 'empathetic.a'],
      ['^you', 'be.v', 'explicit.a'],
      ['^you', 'be.v', 'empowering.a']
    ]
    self.threshold = threshold

  def __call__(self, gist):
    self._validate(gist)
    ulf = self._classify_skills(gist)
    return ulf
  
  def _classify_skills(self, sentence):
    skills = self.classifier(sentence)[0]
    skills = sorted(skills, key=lambda x: x['label'])
    skills = [skill[1] for skill in zip(skills, self.skill_enum) if skill[0]['score'] > self.threshold]
    return skills
  

class SOPHIEGPTResponseTransducer(GPTResponseTransducer):
  """This is a SOPHIE-specific version of the GPTResponseTransducer that uses a hack to avoid role-switching hallucinations."""

  def __call__(self, conversation_log, facts_bg, facts_fg):
    utt = super().__call__(conversation_log, facts_bg, facts_fg)

    prompt_check = f'Could the following utterance plausibly have come from a lung cancer patient? Answer "yes" or "no".\n\n{utt}'
    result_check, cost_check = generate_gpt(prompt_check, postprocessors=[_sophie_check_validator], model='gpt-4')
    if self.debug:
      file.append_file(GPT_DEBUG_FILE, str(self.idx)+':\n\n'+prompt_check+'\n\n')
      file.append_file(GPT_DEBUG_FILE, 'result: '+str(result_check)+'\n\n-------------------\n\n')
      self.idx += 1
    self._cost += cost_check

    if result_check:
      return utt
    
    else:
      history = [turn.utterance.words for turn in conversation_log]
      agents = [f'{turn.agent}: ' for turn in conversation_log]
      kwargs = {
        'facts-bg' : [fact.get_nl() for fact in facts_bg],
        'facts-fg' : [fact.get_nl() for fact in facts_fg],
        'agents' : agents,
        'history' : history
      }
      stop = ['^you:', '^me:']
      prompt = subst_kwargs(self.prompt, kwargs)
      result, cost = generate_gpt(prompt, postprocessors=self.validators, stop=stop, model='gpt-4')
      if self.debug:
        file.append_file(GPT_DEBUG_FILE, str(self.idx)+':\n\n'+prompt+'\n\n')
        file.append_file(GPT_DEBUG_FILE, 'result: '+str(result)+'\n\n-------------------\n\n')
        self.idx += 1
      self._cost += cost
      return [self._standardize_gpt(result)]