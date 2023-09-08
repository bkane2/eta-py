NON_ALCOHOLIC = ['water', 'coffee', 'milk', 'tea', 'soda', 'pop']

MEDICINE_GEN = ['medicine', 'medicines', 'medication', 'medications', 'drug', 'drugs', 'pill',
                'pills', 'med', 'meds', 'dose', 'doses', 'dosage', 'dosages', 'lortab', 'vicodin',
                'norco', 'ibuprofen', 'aleve', 'cozar', 'narcotic', 'narcotics', 'oxycodone', 'morphine']

def not_non_alcoholic(x):
  """Matches any word for a non-alcoholic beverage."""
  return x not in NON_ALCOHOLIC

def not_medicine_gen(x):
  """Matches any word that doesn't refer to a generic medicine."""
  return x not in MEDICINE_GEN