"""Utilities for recording and modifying times."""

import copy
from datetime import date,datetime,timezone

DATETIME_ARGS = ['year', 'month', 'day', 'hour', 'minute', 'second']
DATETIME_VARS = ['?y', '?mo', '?d', '?h', '?mi', '?s']
DATETIME_LOWER = {
  'year' : 1,
  'month' : 1,
  'day' : 1,
  'hour' : 0,
  'minute' : 0,
  'second' : 0
}
DATETIME_UPPER = {
  'year' : date.today().year,
  'month' : 12,
  'day' : 31,
  'hour' : 23,
  'minute' : 59,
  'second' : 59
}


class TimePoint:
  """A specific point in time.

  Parameters
  ----------
  time : datetime, tuple[datetime, datetime], list[str], or None
    Initialize with a given datetime, or otherwise use the current time. The following formats are supported:

      - datetime : a single instantaneous timestamp.
      - (datetime, datetime) : lower and upper bound timestamps for this time point.
      - [$, date+time, <year>, <month>, <day>, <hour>, <minute>, <second>] : a date+time record structure, where
        each slot may be either a number string or a variable string.
      - None : the time point will be initialized to the current time.

  Attributes
  ----------
  lower : datetime
    A timestamp for the lower bound on this timepoint.
  upper : datetime
    A timestamp for the upper bound on this timepoint.
  """

  def __init__(self, time=None):
    self.update(time)

  def update(self, time=None):
    """Update this TimePoint to the given time (or current if none is given)."""
    if isinstance(time, datetime):
      self.lower = time
      self.upper = time
    elif time_pair_p(time):
      self.lower, self.upper = time
    elif time_tuple_p(time):
      self.lower, self.upper = time_pair_from_tuple(time)
    elif time_record_p(time):
      self.lower, self.upper = time_pair_from_record(time)
    elif time is None:
      now = datetime.now(timezone.utc)
      self.lower = now
      self.upper = now
    else:
      raise Exception("Invalid format given for 'time'.")
  
  def to_num(self, bound='upper'):
    """Convert this TimePoint to a numerical POSIX representation (using the upper bound by default)."""
    if bound == 'upper':
      return self.upper.timestamp()
    else:
      return self.lower.timestamp()
    
  def get_duration(self):
    return self.to_num(bound='upper') - self.to_num(bound='lower')
  
  def format(self):
    """Format this TimePoint as a year/month/day/hour/minute/second representation."""
    y, mo, d, h, mi, s = tuple_from_time_pair(self.lower, self.upper)
    return f":year/{y}/:month/{mo}/:day/{d}/:hour/{h}/:minute/{mi}/:sec/{s}"
  
  def format_date(self):
    """Format this TimePoint as a human-readable year/month/day/hour/minute/second representation."""
    y, mo, d, h, mi, s = tuple_from_time_pair(self.lower, self.upper)
    return f"{y}-{mo}-{d}-{h}-{mi}-{s}"
  
  def to_ulf(self):
    """Convert this TimePoint to a ULF record structure."""
    time = self.format().split('/')
    return ['$', 'date+time']+time
  
  def copy(self):
    return copy.copy(self)
  
  def __str__(self):
    return self.format().replace('/', ' ')
  

def get_elapsed(tp1, tp2):
  """Get lower and upper bounds on the elapsed time between two timepoints."""
  vals = [abs(tp2.lower-tp1.upper), abs(tp2.lower-tp1.lower), abs(tp2.upper-tp1.upper), abs(tp2.upper-tp1.lower)]
  return min(vals), max(vals)
  

def time_pair_p(x):
  return isinstance(x, tuple) and len(x) == 2 and all([isinstance(t, datetime) for t in x])

def time_tuple_p(x):
  return isinstance(x, tuple) and len(x) == 6 and all([isinstance(t, str) for t in x])

def time_record_p(x):
  return (isinstance(x, list) and len(x) == 14 and x[0] == '$' and x[1] == 'date+time'
          and all([isinstance(t, str) for t in x[2:]])
          and all([t in [':'+a for a in DATETIME_ARGS] for t in x[2::2]]))
  

def time_pair_from_tuple(tuple):
  """Given a year/month/day/hour/minute/second tuple, possibly containing "variables", return the lower and upper bound datetimes."""
  args_lower = { k:v for k,v in zip(DATETIME_ARGS, tuple) }
  args_upper = { k:v for k,v in zip(DATETIME_ARGS, tuple) }
  for k, v in args_lower.items():
    if v.isdigit():
      args_lower[k] = int(v)
    else:
      args_lower[k] = DATETIME_LOWER[k]
  for k, v in args_upper.items():
    if v.isdigit():
      args_upper[k] = int(v)
    else:
      args_upper[k] = DATETIME_UPPER[k]
  return datetime(**args_lower), datetime(**args_upper)


def time_pair_from_record(record):
  """Given a ULF date+time record structure, possibly containing "variables", return the lower and upper bound datetimes."""
  return time_pair_from_tuple(tuple(record[3::2]))
  

def tuple_from_time_pair(lower, upper):
  """Given a lower and upper bound datetime objects, create a year/month/day/hour/minute/second tuple."""
  tup = [_ for _ in range(len(DATETIME_ARGS))]
  args_lower = lower.strftime("%Y-%m-%d-%H-%M-%S").split('-')
  args_upper = upper.strftime("%Y-%m-%d-%H-%M-%S").split('-')
  for idx, (arg_l, arg_u) in enumerate(zip(args_lower, args_upper)):
    if arg_l != arg_u:
      tup[idx] = DATETIME_VARS[idx]
    else:
      tup[idx] = arg_u
  return tuple(tup)


def record_from_time_pair(lower, upper):
  """Given a lower and upper bound datetime objects, create a ULF date+time record structure."""
  tup = tuple_from_time_pair(lower, upper)
  record = [sub[item] for item in range(len(tup)) for sub in [[':'+x for x in DATETIME_ARGS], tup]]
  return ['$', 'date+time'] + record
  

def now():
  """Return a POSIX timestamp corresponding to the time of the function call."""
  return datetime.now(timezone.utc).timestamp()