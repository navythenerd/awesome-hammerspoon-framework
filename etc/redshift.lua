local settings = {}

settings.transition = 3600
settings.colorTemp = 2700
settings.dayColorTemp = 6500

settings.keymap = {
  {hyper = "hyper" key = "-", fn = ahf.mod.redshift.toggleRedshift },
}

return settings
