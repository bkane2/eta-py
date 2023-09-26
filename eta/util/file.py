"""Utilities for reading from and writing to external files."""

import json
import os
from pathlib import Path

def get_path(fname, in_module):
  """Get the absolute file path for files within this module if `in_module` is given as True."""
  if in_module:
    modpath = os.path.dirname(os.path.abspath(__file__)).strip('util/')
    return '/'+os.path.join(modpath, fname)
  else:
    return fname


def read_file(fname, in_module=False):
  """Read the contents of a given file as a string.
  
  Parameters
  ----------
  fname : str
  in_module : bool, default=False

  Returns
  -------
  str
  """
  fname = get_path(fname, in_module)
  if exists(fname):
    with open(fname, 'r') as f:
      return f.read()
  else:
    return ''
  

def read_lines(fname, in_module=False):
  """Read the lines of a file as a list, removing whitespace lines.
  
  Parameters
  ----------
  fname : str
  in_module : bool, default=False

  Returns
  -------
  list[str]
  """
  fname = get_path(fname, in_module)
  if exists(fname):
    return [l.strip() for l in read_file(fname).split('\n') if l.strip()]
  else:
    return []
  

def write_file(fname, data, in_module=False):
  """Write a string to a given file.
  
  Parameters
  ----------
  fname : str
  data : str
  in_module : bool, default=False
  """
  fname = get_path(fname, in_module)
  with open(fname, 'w+') as f:
    f.write(data)


def append_file(fname, data, in_module=False):
  """Append a string to a given file.

  Parameters
  ----------
  fname : str
  data : str
  in_module : bool, default=False
  """
  fname = get_path(fname, in_module)
  with open(fname, 'a+') as f:
    f.write(data)
  

def load_json(fname, in_module=False):
  """Load data from a JSON file.
  
  Parameters
  ----------
  fname : str
  in_module : bool, default=False

  Returns
  -------
  dict
  """
  fname = get_path(fname, in_module)
  if exists(fname):
    with open(fname, 'r') as f:
      return json.load(f)
  else:
    return {}
  

def write_json(fname, data, in_module=False, pretty=False):
  """Write data to a JSON file.
  
  Parameters
  ----------
  fname : str
  data : dict
  in_module : bool, default=False
  pretty : bool, default=False
    Whether to pretty-print the JSON by indenting new lines.
  """
  fname = get_path(fname, in_module)
  with open(fname, 'w+') as f:
    if pretty:
      json.dump(data, f, indent=2)
    else:
      json.dump(data, f)


def clear(fname, in_module=False):
  """Clear the contents of a file.
  
  Parameters
  ----------
  fname : str
  in_module : bool, default=False
  """
  fname = get_path(fname, in_module)
  with open(fname, 'w+') as f:
    f.write('')


def exists(fname, in_module=False):
  """Check if a file exists.
  
  Parameters
  ----------
  fname : str
  in_module : bool, default=False

  Returns
  -------
  bool
  """
  fname = get_path(fname, in_module)
  return os.path.isfile(fname)


def remove(fname, in_module=False):
  """Remove a file if it exists.

  Parameters
  ----------
  fname : str
  in_module : bool, default=False
  """
  fname = get_path(fname, in_module)
  if exists(fname):
    os.remove(fname)


def ensure_dir_exists(dirname, in_module=False):
  """Ensure that a directory exists, creating it if it doesn't.
  
  Parameters
  ----------
  dirname : str
  in_module : bool, default=False
  """
  dirname = get_path(dirname, in_module)
  Path(dirname).mkdir(parents=True, exist_ok=True)


def ensure_file_exists(fname, in_module=False):
  """Ensure that a file exists, creating an empty file if it doesn't.
  
  Parameters
  ----------
  fname : str
  in_module : bool, default=False
  """
  fname = get_path(fname, in_module)
  ensure_dir_exists('/'.join(fname.split('/')[:-1]))
  clear(fname)
