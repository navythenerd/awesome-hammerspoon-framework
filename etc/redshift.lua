local config = {}

config.transition = 3600
config.colorTemp = 2700
config.dayColorTemp = 6500

config.keymap = {
  {hyper = "hyper" key = "-", fn = ahf.mod.redshift.toggleRedshift },
}

return config
