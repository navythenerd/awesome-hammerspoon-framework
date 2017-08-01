local settings = {}

settings.color = {
  red=1,
  blue=0,
  green=0,
  alpha=.8
}

settings.linewidth = 8
settings.diameter = 60

settings.keymap = {
  {hyper = "hyper", key = "m", fn = ahf.mod.mouselocator.mouseHighlight}
}

return settings
