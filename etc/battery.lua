local settings = {}

settings.enableMenubar = true
settings.batteryFormatTitle = "%s remaining"
settings.powerSupplyTitle = "Power supply"
settings.calculatingTitle = "Calculating..."

settings.keymap = {
  {hyper = "hyper_shift", key = "b", fn = ahf.mod.batterypanel.showRemainingTime},
}

return settings
