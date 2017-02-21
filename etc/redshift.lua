local settings = {}

settings.transition = 3600
settings.colorTemp = 3700
settings.dayColorTemp = 5500

settings.keymap = {
  { key = "-", fn = core.mod.redshift.toggleRedshift },
}

return settings
