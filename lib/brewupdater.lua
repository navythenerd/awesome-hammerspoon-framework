local mod = {}

mod.name = "BrewUpdater"
mod.context = {}
mod.cronjob = {}
mod.binary = {}

function updateBrew()
  local update = mod.binary .. " update;"
  local upgrade = mod.binary .. " upgrade;"
  local cleanup = mod.binary .. " cleanup;"

  local command = update .. upgrade .. cleanup

  kernel.execute(command)
end

function mod.init(context)
  mod.context = context
  mod.binary = mod.context.config.brew .. "./brew"
  mod.cronjob = hs.timer.doAt(mod.context.config.updateTime, mod.context.config.updateFreq, updateBrew)
end

function mod.unload()
  mod.cronjob:stop()
end

return mod
