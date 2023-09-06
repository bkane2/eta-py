"""Contains miscellaneous transducer implementations not based on TT or GPT.

Notes
-----
TODO: since some of these are domain-specific (e.g., the SkillPragmaticTransducer for SOPHIE),
perhaps they ought to be defined outside of the Eta package? This will likely need to be sorted
out once this is deployed as a package that developers can extend with their own custom
transducers and configurations.
"""

from eta.transducers.base import *

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