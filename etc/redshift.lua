local settings = {}

settings.transition = 3600
settings.colorTemp = 2700
--settings.dayColorTemp = 6500

settings.keymap = {
  { key = "-", fn = core.mod.redshift.toggleRedshift },
}

return settings
