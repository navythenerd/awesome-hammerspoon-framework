local settings = {}

settings.color = {
  red=1,
  blue=0,
  green=0,
  alpha=0.6
}

settings.linewidth = 3
settings.diameter = 80

settings.keymap = {
  {key = "m", callback = mouseHighlight}
}

return settings
