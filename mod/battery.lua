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
    batteryMenu:setTitle(mod.context.config.calculatingTitle)
  else
    batteryMenu:setTitle(string.format(mod.context.config.batteryFormatTitle, core.lib.std.system.toTime(remainingTime).string))
  end
end

local function refreshRemainingTime()
  remainingTime = hs.battery.timeRemaining()

  if mod.context.config.enableMenubar then
    setTitle()
  end
end

function mod.showRemainingTime()
  if (remainingTime == -2) then
    hs.alert.show(mod.context.config.powerSupplyTitle)
  elseif (remainingTime == -1) then
    hs.alert.show(mod.context.config.calculatingTitle)
  else
    hs.alert.show(string.format(mod.context.config.batteryFormatTitle, core.lib.std.system.toTime(remainingTime).string))
  end
end

function mod.init()
  if (mod.context.config.enableMenubar) then
    batteryMenu = hs.menubar:new()
  end

  refreshRemainingTime()

  batteryWatcher = hs.battery.watcher.new(refreshRemainingTime)
  batteryWatcher:start()
end

return mod
