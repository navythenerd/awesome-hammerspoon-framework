local mod = {}

mod.namespace = 'batterypanel'
mod.dependencies = {'std'}

function mod.showRemainingTime()
  local timeRemaining = hs.battery.timeRemaining()

  if (timeRemaining == -2) then
    hs.alert.show("Connected to power supply")
  elseif (timeRemaining == -1) then
    hs.alert.show("Time is beeing calculated")
  else
    local time = core.lib.std.system.toTime(timeRemaining)
    hs.alert.show(string.format("%s remaining", time.string))
  end
end

return mod
