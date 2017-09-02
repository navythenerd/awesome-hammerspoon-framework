local config = {}

config.color = {
  red=1,
  blue=0,
  green=0,
  alpha=.8
}

config.linewidth = 8
config.diameter = 60

config.keymap = {
  {hyper = "hyper", key = "m", fn = ahf.mod.mouselocator.mouseHighlight}
}

return config
