local settings = {}

settings.keymap = {
  {key = "f", callback = snapFullscreen},
  {key = "d", callback = snapLeftHalf},
  {key = "g", callback = snapRightHalf},
  {key = "e", callback = snapLeftTopQuarter},
  {key = "r", callback = snapRightTopQuarter},
  {key = "c", callback = snapLeftBottomQuarter},
  {key = "v", callback = snapRightBottomQuarter}
}

return settings
