from eta.util.time import *

def main():
  tp = TimePoint()
  print(tp)
  print(tp.to_num())
  print(tp.to_ulf())
  print(tp.format_date())


if __name__ == '__main__':
  main()