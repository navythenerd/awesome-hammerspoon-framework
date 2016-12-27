local mod = {}

mod.name = "Redshift"

function startRedshift()
  if mod.context.config.dayColorTemp ~= nil then
    hs.redshift.start(mod.context.config.colorTemp, mod.sunrise.sunset, mod.sunrise.sunrise, mod.context.config.transition, false, nil, mod.context.config.dayColorTemp)
  else
    hs.redshift.start(mod.context.config.colorTemp, mod.sunrise.sunset, mod.sunrise.sunrise, mod.context.config.transition)
  end
end

function refreshSunrise()
  hs.redshift.stop()
  mod.sunrise = core.helpers.getSunrise()
  startRedshift()
end

function toggleRedshift()
  hs.redshift.toggle()
end

function mod.init(context)
  mod.context = context
  mod.sunrise = core.helpers.getSunrise()
  mod.cronjob = hs.timer.doAt(mod.context.config.sunriseRefreshTime, hs.timer.hours(12), refreshSunrise)
  startRedshift()
end

function mod.unload()
  hs.redshift.stop()
end

return mod
