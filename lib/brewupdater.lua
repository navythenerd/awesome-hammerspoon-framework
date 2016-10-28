local mod = {}

mod.name = "BrewUpdater"
mod.signature = "h5pegyy2HDGwA3nBailU"
mod.keymap = {}
mod.settings = {}
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
  mod.settings = require(context.config)
  mod.binary = mod.settings.brew .. "./brew"
  mod.keymap = mod.settings.keymap
  mod.cronjob = hs.timer.doAt(mod.settings.updateTime, mod.settings.updateFreq, updateBrew)
end

return mod
