local mod = {}

mod.namespace = 'redshift'
mod.dependencies = {'stdloc'}

local enabled = false
local watcher = nil

local function stopRedshift()
  if enabled then
    hs.redshift.stop()
    enabled = false
  end
end

local function startRedshift()
  if enabled then
    stopRedshift()
  end

  if mod.context.config.dayColorTemp ~= nil then
    hs.redshift.start(mod.context.config.colorTemp, mod.sunrise.sunset, mod.sunrise.sunrise, mod.context.config.transition, false, nil, mod.context.config.dayColorTemp)
  else
    hs.redshift.start(mod.context.config.colorTemp, mod.sunrise.sunset, mod.sunrise.sunrise, mod.context.config.transition, false)
  end

  enabled = true
end

local function refreshSunrise()
  mod.sunrise = core.lib.stdloc.getSunrise()
end

local function caffeinateHandler(event)
  if (event == hs.caffeinate.watcher.systemWillSleep or event == hs.caffeinate.watcher.screensDidSleep or event == hs.caffeinate.watcher.systemWillSleep or event == hs.caffeinate.watcher.screensDidLock) then
    stopRedshift()
  elseif (event == hs.caffeinate.watcher.systemDidWake or event == hs.caffeinate.watcher.screensDidWake or event == hs.caffeinate.watcher.screensDidUnlock) then
    refreshSunrise()
    startRedshift()
  end
end

function mod.toggleRedshift()
  if enabled == true then
    stopRedshift()
    watcher:stop()
    hs.alert.show("Redshift disabled")
  else
    startRedshift()
    watcher:start()
    hs.alert.show("Redshift enabled")
  end
end

function mod.init()
  refreshSunrise()
  hs.redshift.stop()
  watcher = hs.caffeinate.watcher.new(caffeinateHandler)
  watcher:start()
  startRedshift()
end

function mod.unload()
  watcher:stop()
  stopRedshift()
end

return mod
