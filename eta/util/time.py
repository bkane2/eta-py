from datetime import datetime,timezone

def now():
  return datetime.now(timezone.utc).timestamp()


def main():
  print(now())


if __name__ == '__main__':
  main()