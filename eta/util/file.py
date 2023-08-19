import json
import os
from pathlib import Path

def read_file(fname):
  with open(fname, 'r') as f:
    return f.read()
  

def read_lines(fname):
  return [l.strip() for l in read_file(fname).split('\n') if l.strip()]
  

def write_file(fname, data):
  with open(fname, 'w+') as f:
    f.write(data)


def append_file(fname, data):
  with open(fname, 'a+') as f:
    f.write(data)
  

def load_json(fname):
  with open(fname, 'r') as f:
    return json.load(f)
  

def write_json(fname, data):
  with open(fname, 'w+') as f:
    json.dump(data, f)


def clear(fname):
  with open(fname, 'w+') as f:
    f.write('')


def exists(fname):
  return os.path.isfile(fname)


def remove(fname):
  if exists(fname):
    os.remove(fname)


def ensure_dir_exists(dirname):
  Path(dirname).mkdir(parents=True, exist_ok=True)


def ensure_file_exists(fname):
  ensure_dir_exists('/'.join(fname.split('/')[:-1]))
  clear(fname)
