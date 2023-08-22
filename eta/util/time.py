from datetime import datetime,timezone

class TimePoint:
  def __init__(self, time=None):
    if time:
      self.time = time
    else:
      self.update()

  def update(self):
    self.time = datetime.now(timezone.utc)
  
  def to_num(self):
    return self.time.timestamp()
  
  def format(self):
    return self.time.strftime(":year/%Y/:month/%m/:day/%d/:hour/%H/:minute/%M/:sec/%S")
  
  def to_ulf(self):
    time = self.format().split('/')
    return ['$', 'date+time']+time
  
  def __str__(self):
    return self.format().replace('/', ' ')
  

def now():
  return datetime.now(timezone.utc).timestamp()