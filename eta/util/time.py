"""Utilities for recording and modifying times."""

import math
import numpy as np
from datetime import datetime,timezone

from eta.constants import EXPECTED_STEP_FAILURE_PERIOD_COEFFICIENT

class TimePoint:
  """A specific point in time.

  Parameters
  ----------
  time : Datetime, optional
    Initialize with a given Datetime object if given, otherwise use the current time.

  Attributes
  ----------
  time : Datetime
    A Datetime object storing the time corresponding to this TimePoint.
  """

  def __init__(self, time=None):
    if time:
      self.time = time
    else:
      self.update()

  def update(self):
    """Update this TimePoint to the current time."""
    self.time = datetime.now(timezone.utc)
  
  def to_num(self):
    """Convert this TimePoint to a numerical POSIX representation."""
    return self.time.timestamp()
  
  def format(self):
    """Format this TimePoint as a year/month/day/hour/minute/second representation."""
    return self.time.strftime(":year/%Y/:month/%m/:day/%d/:hour/%H/:minute/%M/:sec/%S")
  
  def format_date(self):
    """Format this TimePoint as a human-readable year/month/day/hour/minute/second representation."""
    return self.time.strftime("%Y-%m-%d-%H-%M-%S")
  
  def to_ulf(self):
    """Convert this TimePoint to a ULF record structure."""
    time = self.format().split('/')
    return ['$', 'date+time']+time
  
  def __str__(self):
    return self.format().replace('/', ' ')
  

def now():
  """Return a POSIX timestamp corresponding to the time of the function call."""
  return datetime.now(timezone.utc).timestamp()


def certainty_to_period(certainty):
  """Map a certainty in [0,1] to a period (in seconds) that an expected event should occur within.

  The proportion between the period and the quantity ``-log(1 - certainty)`` is determined by the global
  constant EXPECTED_STEP_FAILURE_PERIOD_COEFFICIENT, defined in ``eta.constants``.

  Parameters
  ----------
  certainty : float
    A certainty value in [0,1]
  
  Returns
  -------
  float or np.inf
    The period (in seconds), or infinity if the certainty is 1.
  """
  if certainty >= 1 or certainty < 0:
    return np.inf
  else:
    return -EXPECTED_STEP_FAILURE_PERIOD_COEFFICIENT * math.log(1-certainty)
  

def has_elapsed_certainty_period(time, certainty):
  """Check whether a given time delta has elapsed the period corresponding to a given certainty.

  Parameters
  ----------
  time : float
    The difference between two times (POSIX timestamps).
  certainty : float
    A certainty value in [0,1]

  Returns
  -------
  bool
  """
  if certainty >= 1 or certainty < 0:
    return False
  else:
    period = certainty_to_period(certainty)
    return time >= period