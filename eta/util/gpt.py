import backoff
import openai
from openai.error import RateLimitError, Timeout, ServiceUnavailableError, APIConnectionError, APIError
from transformers import GPT2Tokenizer

import eta.util.file as file

openai.api_key = file.read_file('_keys/openai.txt')

TOKENIZER = GPT2Tokenizer.from_pretrained("gpt2")

MODEL_COSTS = {
  'gpt-3.5-turbo' : 0.002,
  'gpt-4' : 0.06
}

AVG_TOKENS_PER_CHAR = 0.25
  

@backoff.on_exception(backoff.expo, (RateLimitError, Timeout, ServiceUnavailableError, APIConnectionError, APIError))
def generate_gpt(prompt, preamble=None, examples=[], model='gpt-3.5-turbo', stop=None, max_tokens=2048,
                 postprocessors=[], n_retries=2):
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
  return (MODEL_COSTS[model] / 1000) * n_tokens



def main():
  result, cost = generate_gpt('test:')
  print(result)
  print(cost)


if __name__ == "__main__":
  main()