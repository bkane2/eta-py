import os
import json
import requests
import numpy as np

from eta.constants import *
import eta.util.file as file

class Embedder:
  def __init__(self, model=EMBEDDING_DEFAULT_MODEL, parallelism=False):
    """TBC"""
    from sentence_transformers import SentenceTransformer
    self.model = SentenceTransformer(model)
    if not parallelism:
      os.environ['TOKENIZERS_PARALLELISM'] = 'false'

  def embed(self, texts):
    return list(self.model.encode(texts))
  
  def score(self, text, documents, embeddings=[]):
    """TBC"""
    documents = np.array(documents)

    if embeddings and len(embeddings) == len(documents):
      e_d = embeddings
    else:
      e_d = self.embed(documents)
    e_t = self.embed(text)

    scores = sim(e_d, e_t)
    return scores.tolist()


class HFEmbedder(Embedder):
  def __init__(self, host=EMBEDDING_DEFAULT_API, model=EMBEDDING_DEFAULT_MODEL):
    """TBC"""
    self.host = host
    self.model = model
    self.url = host+model
    self.header = { "Authorization" : f"Bearer {file.read_file(f'{KEY_PATH}hf.txt')}" }
    self.embed_api('init')

  def embed(self, texts):
    if isinstance(texts, np.ndarray):
      texts = texts.tolist()
    return self.embed_api(texts)
  
  def embed_api(self, texts):
    return self.query_api({"inputs" : texts, "options" : {"wait_for_model" : True}})

  def query_api(self, query):
    data = json.dumps(query)
    response = requests.request("POST", self.url, headers=self.header, data=data)
    return json.loads(response.content.decode("utf-8"))
  

class DummyEmbedder(Embedder):
  def __init__(self):
    pass

  def embed(self, texts):
    if isinstance(texts, (list, np.ndarray)):
      return [[] for _ in texts]
    else:
      return []
  

def sim(x, y):
  if not y:
    return 1. if not x else [sim(x1, y) for x1 in x]
  return np.dot(x, y)/(np.linalg.norm(x)*np.linalg.norm(y))


def main():
  print(sim([1., .5], [1., .3]))
  print(sim([[1., .5], [.3, .2], [.9, .01]], [1., .3]))
  print(sim([], []))
  print(sim([[], [], []], []))

  test = Embedder()

  print(len(test.embed('test sentence 1')))
  print(len(test.embed(['test sentence 2', 'test sentence 3'])))

  test_set1 = ['how to test systems', 'this is a sentence for testing', 'have you ever tested code before', 'debugging code']
  print(test.score('test sentence', test_set1))


if __name__ == '__main__':
  main()
