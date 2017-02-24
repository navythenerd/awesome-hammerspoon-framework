local lib = {}

lib.namespace = "system"

function sleep(s)
  local ntime = os.clock() + s
  repeat until os.clock() > ntime
end

lib.sleep = sleep

return lib
