"""Utilities for interacting with the OpenAI GPT API.

We assume that GPT prompts are specified as text strings, possibly including the following special constructs:
  - ``<var>``
    A placeholder in the prompt to be replaced by a value at a later point, where that value may be a string, or
    a list of strings such that each string is placed on a new line.
  - ``@zip(<var1>, <var2>, ...)``
    A placeholder to be replaced by the string formed by zipping the strings within the argument lists, and placing
    each combined string on a new line.
  - ``@startexamples ... @endexamples``
    The text between these annotations is treated as an example template, to be later replaced by a list of examples
    formatted according to the template.
"""

import re
import backoff
import openai
from openai.error import RateLimitError, Timeout, ServiceUnavailableError, APIConnectionError, APIError
from transformers import GPT2Tokenizer

from eta.constants import *
import eta.util.file as file

openai.api_key = file.read_file(f'{KEY_PATH}openai.txt')

TOKENIZER = GPT2Tokenizer.from_pretrained("gpt2")

MODEL_COSTS = {
  'gpt-3.5-turbo' : 0.002,
  'gpt-4' : 0.06
}

AVG_TOKENS_PER_CHAR = 0.25
  

@backoff.on_exception(backoff.expo, (RateLimitError, Timeout, ServiceUnavailableError, APIConnectionError, APIError))
def generate_gpt(prompt, preamble=None, examples=[], model='gpt-3.5-turbo', stop=None, max_tokens=2048,
                 postprocessors=[], n_retries=2):
  """Generate a response from GPT.
  
  Parameters
  ----------
  prompt : str
    The prompt to use for generation (coded as a "user" message).
  preamble : str, optional
    An initial prompt to give GPT as a "system" message.
  examples : list[tuple[str, str]], optional
    A list of example pairs, each consisting of a "user" message and an "assistant" response.
  model : str, default='gpt-3.5-turbo'
    The model name to use for generation.
  stop : list[str], optional
    A list of stop sequences to use in generation.
  max_tokens : int, default=2048
    The maximum number of tokens to generate.
  postprocessors : list[function], optional
    A list of functions to apply to any generated content. If a postprocessor returns 'None',
    then generation is retried, up to `n_retries` times. Otherwise, the final result after applying
    each function is returned.
  n_retries : int, default=2
    The number of times to retry if a postprocessor determines that a generation is invalid.
  
  Returns
  -------
  result : object
    The result of the final postprocessor function (if any), or the direct result string from GPT.
  cost : float
    The total cost of this generation call.
  """
  messages=[]
  if preamble:
    messages.append({"role": "system", "content": preamble})
  for example in examples:
    messages.append({"role": "user", "content": example[0]})
    messages.append({"role": "assistant", "content": example[1]})
  messages.append({"role": "user", "content": prompt})

  result = None
  cost = 0.
  i = 0
  while result is None and i < n_retries:

    resp = openai.ChatCompletion.create(
      model=model,
      messages=messages,
      stop=stop,
      max_tokens=max_tokens
    )

    if 'usage' in resp and resp['usage']:
      cost += cost_tokens(model, resp['usage']['total_tokens'])

    if 'choices' in resp and resp['choices'] and 'message' in resp['choices'][0]:
      result = resp['choices'][0]['message']['content']

    for func in postprocessors:
      if result is not None:
        result = func(prompt, result)

    i += 1

  return result, cost


def cost_gpt(prompt, avg_resp_len, preamble=None, examples=[], model='gpt-3.5-turbo', stop=None, max_tokens=2048,
             postprocessors=[], n_retries=2, tokenizer=TOKENIZER):
  """Estimate the cost of a given prompt from GPT.

  Parameters
  ----------
  prompt : str
    The prompt to use for generation (coded as a "user" message).
  avg_resp_len : int
    The estimated length of a response from GPT for the given prompt.
  preamble : str, optional
    An initial prompt to give GPT as a "system" message.
  examples : list[tuple[str, str]], optional
    A list of example pairs, each consisting of a "user" message and an "assistant" response.
  model : str, default='gpt-3.5-turbo'
    The model name to use for generation.
  stop : list[str], optional
    A list of stop sequences to use in generation.
  max_tokens : int, default=2048
    The maximum number of tokens to generate.
  postprocessors : list[function], optional
    A list of functions to apply to any generated content. If a postprocessor returns 'None',
    then generation is retried, up to `n_retries` times. Otherwise, the final result after applying
    each function is returned.
  n_retries : int, default=2
    The number of times to retry if a postprocessor determines that a generation is invalid.
  tokenizer : object, default=GPT2Tokenizer
    The tokenizer used for estimating the number of tokens created from the prompt.
  
  Returns
  -------
  tuple[float, float]
    The minimum and maximum estimated costs, respectively, based on the range of possible retries.
  """
  n_tokens = 0
  if preamble:
    n_tokens += len(tokenizer(preamble)['input_ids'])
  for example in examples:
    n_tokens += len(tokenizer(example[0])['input_ids'])
    n_tokens += len(tokenizer(example[1])['input_ids'])
  n_tokens += len(tokenizer(prompt)['input_ids'])
  n_tokens += AVG_TOKENS_PER_CHAR * min(avg_resp_len, max_tokens)
  cost = (MODEL_COSTS[model] / 1000) * n_tokens
  return (cost, n_retries*cost)


def cost_tokens(model, n_tokens):
  """Estimate the cost of a given number of tokens."""
  return (MODEL_COSTS[model] / 1000) * n_tokens


def apply_zip(prompt, kwargs):
  """Replace any @zip annotations in a prompt with the zipped arguments."""
  zip_regex = re.compile(r'@zip\((((<[a-zA-Z0-9_-]+>)(,[ ]*)?)+)\)')
  prompt1 = prompt
  for m in zip_regex.finditer(prompt):
    vars = [v.strip() for v in m.group(1).split(',')]
    vals = [''.join(t) for t in zip(*[kwargs[v.strip('<').strip('>')] for v in vars])]
    prompt1 = re.sub(fr'@zip\({m.group(1)}\)', '\n'.join(vals), prompt1)
  return prompt1


def subst_kwargs(prompt, kwargs):
  """Replace variables within a GPT prompt with the corresponding values in `kwargs`."""
  prompt = apply_zip(prompt, kwargs)
  for kw, arg in kwargs.items():
    if isinstance(arg, list):
      val = '\n'.join(arg) if arg else 'None'
    else:
      val = arg
    prompt = prompt.replace(f'<{kw}>', val)
  return prompt


def subst_examples(prompt, examples):
  """Fill in any prompt content between ``@startexamples`` and ``@endexamples`` annotations with examples."""
  if not '@startexamples' in prompt or not '@endexamples' in prompt:
    return prompt
  prompt1, template = prompt.split('@startexamples')
  template, prompt2 = template.split('@endexamples')
  template = template.strip()
  return prompt1 + '\n\n'.join([subst_kwargs(template, e) for e in examples]) + prompt2