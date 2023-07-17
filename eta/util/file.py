import json

def read_file(fname):
  with open(fname, 'r') as f:
    return f.read()
  

def read_lines(fname):
  return [l.strip() for l in read_file(fname).split('\n') if l.strip()]
  

def write_file(fname, data):
  with open(fname, 'w') as f:
    f.write(data)
  

def load_json(fname):
  with open(fname, 'r') as f:
    return json.load(f)
  

def write_json(fname, data):
  with open(fname, 'w') as f:
    json.dump(data, f)


def clear(fname):
  with open(fname, 'w') as f:
    f.write('')