local lib = {}

lib.namespace = "system"

function lib.sleep(s)
  local ntime = os.clock() + s
  repeat until os.clock() > ntime
end

function lib.toTime(m)
  local time = {}

  time.hours = math.floor(m / 60)
  time.minutes = m % 60
  time.string = string.format("%02d:%02d", time.hours, time.minutes)

  return time
end

return lib
