local mod = {}

mod.name = "Redshift"

local function startRedshift()
  if mod.context.config.dayColorTemp ~= nil then
    hs.redshift.start(mod.context.config.colorTemp, mod.sunrise.sunset, mod.sunrise.sunrise, mod.context.config.transition, false, nil, mod.context.config.dayColorTemp)
  else
    hs.redshift.start(mod.context.config.colorTemp, mod.sunrise.sunset, mod.sunrise.sunrise, mod.context.config.transition, false)
  end

  mod.enabled = true
end

local function stopRedshift()
  hs.redshift.stop()

  mod.enabled = false
end

local function resetRedshift()
  mod.sunrise = core.helpers.getSunrise()
  hs.redshift.stop()
  hs.timer.doAfter(20, startRedshift)
  hs.timer.doAfter(30, function () mod.cronjob = hs.timer.doAt(hs.timer.seconds(mod.sunrise.sunrise) + hs.timer.hours(2), resetRedshift) end)
end

function toggleRedshift()
  if mod.enabled == true then
    hs.alert.show(mod.name .. " disabled")
    mod.enabled = false
  else
    hs.alert.show(mod.name .. " enabled")
    mod.enabled = true
  end

  hs.redshift.toggle(mod.enabled)
end

function mod.init(context)
  mod.context = context
  resetRedshift()
end

function mod.unload()
  hs.redshift.stop()
end

return mod
