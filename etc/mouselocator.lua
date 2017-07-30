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
  {key = "m", fn = core.mod.mouselocator.mouseHighlight}
}

return settings
