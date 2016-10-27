local settings = {}

settings.color = {
  red=1,
  blue=0,
  green=0,
  alpha=1
}

settings.linewidth = 5
settings.diameter = 80

settings.keymap = {
  {key = "m", callback = mouseHighlight}
}

return settings
