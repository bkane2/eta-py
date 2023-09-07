"""Tools for creating embeddings of Eta documents and scoring embeddings using cosine similarity.

These classes serve as interfaces for invoking various embedding models or APIs.
"""

import os
import json
import requests
import numpy as np

from eta.constants import *
import eta.util.file as file

class Embedder():
  """Defines an abstract embedder class.

  An embedder minimally contains a method for embedding a text or list of texts, and a
  method for scoring a set of documents (possibly with precomputed embeddings) relative to a text.
  """
  def __init__(self):
    pass

  def embed(self, texts):
    """Embed a text or list of texts.
    
    Parameters
    ----------
    texts : str or list[str]
      Either a single text string or a list of text strings to embed.
    
    Returns
    -------
    list[float] or list[list[float]]
      The embedding or embeddings computed from the input.
    """
    if isinstance(texts, (list, np.ndarray)):
      return [[] for _ in texts]
    else:
      return []

  def score(self, text, documents, embeddings=[]):
    """Score a set of documents relative to a text.
    
    Parameters
    ----------
    text : str
      A query text to use in computing scores for each document.
    documents : list[str]
      A list of documents to score.
    embeddings : list[list[float]], optional
      If embeddings for the documents have already been precomputed, passing the embeddings
      as an argument will bypass creating new embeddings for the documents.
    
    Returns
    -------
    list[float]
      Scores for each document.
    """
    if not documents:
      return []
    
    documents = np.array(documents)

    if embeddings and len(embeddings) == len(documents):
      e_d = embeddings
    else:
      e_d = self.embed(documents)
    e_t = self.embed(text)

    scores = sim(e_d, e_t)
    return scores.tolist()


class STEmbedder(Embedder):
  """An embedder that uses a native SentenceTransformer model to compute embeddings.
  
  Parameters
  ----------
  model : str
    The name of a SentenceTransformer model to use.
  parallelism : bool, default=False
    Whether to enable or disable model parallelism.

  Attributes
  ----------
  model : SentenceTransformer
  """

  def __init__(self, model=EMBEDDING_DEFAULT_MODEL, parallelism=False):
    from sentence_transformers import SentenceTransformer
    self.model = SentenceTransformer(model)
    if not parallelism:
      os.environ['TOKENIZERS_PARALLELISM'] = 'false'

  def embed(self, texts):
    return list(self.model.encode(texts))
  

class HFEmbedder(Embedder):
  """An embedder that uses HuggingFace's API to compute embeddings.
  
  Parameters
  ----------
  host : str
    The URL of the embedding API to use.
  model : str
    The name of the specific model to use.

  Attributes
  ----------
  host : str
  model : str
  url : str
  header : dict
  """

  def __init__(self, host=EMBEDDING_DEFAULT_API, model=EMBEDDING_DEFAULT_MODEL):
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
  """An embedder that simply computes empty embeddings."""

  def __init__(self):
    pass
  

def sim(x, y):
  """Compute the cosine similarity between vectors."""
  if not y:
    return np.array(1.) if not x else np.array([sim(x1, y) for x1 in x])
  if not x:
    return np.array([])
  return np.dot(x, y)/(np.linalg.norm(x)*np.linalg.norm(y))