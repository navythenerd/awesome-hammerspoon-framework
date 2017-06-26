local settings = {}

settings.enableMenubar = true
settings.refreshInterval = 300
settings.batteryFormatTitle = "%s remaining"
settings.powerSupplyTitle = "Power supply"
settings.calulatingTitle = "Calculating..."

settings.keymap = {
  {key = "b", fn = core.mod.batterypanel.showRemainingTime},
}

return settings
