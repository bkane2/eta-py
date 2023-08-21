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
  
  def retrieve(self, text, documents, embeddings=[], n=5, header=False):
    """TBC"""
    documents = np.array(documents)

    head = ''
    if header:
      head = documents[0]
      documents = documents[1:]

    if embeddings and len(embeddings) == len(documents):
      e_d = embeddings
    else:
      e_d = self.embed(documents)
    e_t = self.embed(text)

    scores = sim(e_d, e_t)
    scores_top = np.argsort(scores)[:-(min(n, len(scores))+1):-1]

    if header:
      return [head] + list(documents[scores_top])
    else:
      return list(documents[scores_top])
    
  def retrieve_multilevel(self, text, document_sets, embedding_sets=[], embeddings=[], n=5, header=False):
    """TBC"""
    document_agg = np.array([' '.join(ds) for ds in document_sets])
    document_sets = np.array([np.array(ds) for ds in document_sets], dtype=object)

    if embeddings and len(embeddings) == len(document_agg):
      e_ds = embeddings
    else:
      e_ds = self.embed(document_agg)
    e_t = self.embed(text)

    documents = document_sets[np.argmax(sim(e_ds, e_t))]

    if embedding_sets and len(embedding_sets) == len(document_sets):
      embeddings_docs = embedding_sets[np.argmax(sim(e_ds, e_t))]
      return self.retrieve(text, documents, embeddings=embeddings_docs, n=n, header=header)
    else:
      return self.retrieve(text, documents, n=n, header=header)


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
  print(test.retrieve('test sentence', test_set1, n=2))

  test_set2 = ['visiting other countries', 'booking a flight', 'exploring different cuisines', 'how to organize a trip']
  test_set3 = ['all about sports', 'playing soccer', 'attending the world cup', 'watching a basketball game']
  test_sets = [test_set1, test_set2, test_set3]
  print(test.retrieve_multilevel('i like travel', test_sets, n=2, header=True))

  e_ts1 = test.embed(test_set1)
  e_ts2 = test.embed(test_set1)
  e_ts3 = test.embed(test_set1)
  e_sets = [e_ts1, e_ts2, e_ts3]
  e_agg = test.embed([' '.join(t) for t in test_sets])
  print(test.retrieve_multilevel('i like travel', test_sets, embedding_sets=e_sets, embeddings=e_agg, n=2, header=True))


if __name__ == '__main__':
  main()
