from eta.util.time import *

def main():
  # tp = TimePoint(['$', 'date+time', ':year', '1993', ':month', '3', ':day', '?x', ':hour', '12', ':minute', '?y', ':second', '?z'])
  tp = TimePoint(('1993', '3', '?x', '12', '?y', '?z'))
  print(tp.lower)
  print(tp.upper)
  print(record_from_time_pair(tp.lower, tp.upper))
  print(tp.get_duration())
  print(tp.format_date())
  print(tp)
  print(tp.to_ulf())

  tp1 = TimePoint(('1995', '?x', '4', '12', '?y', '1'))
  print(tp1)
  tp2 = TimePoint(('1996', '?x', '3', '12', '?y', '1'))
  print(tp2)
  print(get_elapsed(tp2, tp1))

  tpcopy = tp.copy()
  tpcopy.update()
  print(tp)
  print(tpcopy)


if __name__ == '__main__':
  main()