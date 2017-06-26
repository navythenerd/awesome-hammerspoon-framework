local mod = {}

mod.namespace = 'batterypanel'
mod.dependencies = {'std'}

local batteryMenu = nil
local refreshTimer = nil
local batteryWatcher = nil
local remainingTime = -2

local function setTitle()
  if (remainingTime == -2) then
    batteryMenu:setTitle(mod.context.config.powerSupplyTitle)
  elseif (remainingTime == -1) then
    batteryMenu:setTitle(mod.context.config.calulatingTitle)
  else
    batteryMenu:setTitle(string.format(mod.context.config.batteryFormatTitle, core.lib.std.system.toTime(remainingTime).string))
  end
end

local function refreshRemainingTime()
  remainingTime = hs.battery.timeRemaining()

  if batteryMenu then
    setTitle()
  end
end

function mod.showRemainingTime()
  if (remainingTime == -2) then
    hs.alert.show("Connected to power supply")
  elseif (remainingTime == -1) then
    hs.alert.show("Remaining time is beeing calculated...")
  else
    hs.alert.show(string.format("%s remaining", core.lib.std.system.toTime(remainingTime).string))
  end
end

function mod.init()
  batteryWatcher = hs.battery.watcher.new(refreshRemainingTime)
  batteryWatcher:start()
  refreshTimer = hs.timer.doEvery(mod.context.config.refreshInterval, refreshRemainingTime)

  if (mod.context.config.enableMenubar) then
    batteryMenu = hs.menubar.new()
  end

  refreshRemainingTime()
end

return mod
