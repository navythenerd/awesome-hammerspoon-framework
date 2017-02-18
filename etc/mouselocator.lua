local settings = {}

settings.color = {
  red=1,
  blue=0,
  green=0,
  alpha=0.8
}

settings.linewidth = 4
settings.diameter = 80

settings.keymap = {
  {key = "m", callback = mouseHighlight}
}

return settings
