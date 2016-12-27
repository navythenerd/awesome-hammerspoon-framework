local settings = {}

settings.sunrise = {}
settings.transition = 3600
settings.colorTemp = 3700
--settings.dayColorTemp = 5500
settings.sunriseRefreshTime = "08:00"

settings.keymap = {
  { key = "-", callback = toggleRedshift },
}

return settings
