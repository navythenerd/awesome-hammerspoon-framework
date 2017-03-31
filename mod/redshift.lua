local mod = {}

mod.namespace = 'redshift'
mod.dependencies = {'stdloc'}

local enabled = false

local function startRedshift()
  if mod.context.config.dayColorTemp ~= nil then
    hs.redshift.start(mod.context.config.colorTemp, mod.sunrise.sunset, mod.sunrise.sunrise, mod.context.config.transition, false, nil, mod.context.config.dayColorTemp)
  else
    hs.redshift.start(mod.context.config.colorTemp, mod.sunrise.sunset, mod.sunrise.sunrise, mod.context.config.transition, false)
  end

  enabled = true
end

local function stopRedshift()
  hs.redshift.stop()
  enabled = false
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
    hs.alert.show("Redshift disabled")
  else
    startRedshift()
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
