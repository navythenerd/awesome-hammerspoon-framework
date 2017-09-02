local config = {}

config.enableMenubar = true
config.batteryText = "%s remaining"
config.powerSupplyText = "Connected to power supply"
config.calculatingText = "Calculating remaining time of usage"

config.keymap = {
  {hyper = "hyper_shift", key = "b", fn = ahf.mod.batterypanel.showRemainingTime},
}

return config
