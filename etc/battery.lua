local settings = {}

settings.enableMenubar = true
settings.batteryFormatTitle = "%s remaining"
settings.powerSupplyTitle = "Power supply"
settings.calculatingTitle = "Calculating..."

settings.keymap = {
  {key = "b", alt = true, fn = core.mod.batterypanel.showRemainingTime},
}

return settings
