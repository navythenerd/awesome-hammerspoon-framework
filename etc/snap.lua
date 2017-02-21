local settings = {}

settings.keymap = {
  {key = "f", fn = core.mod.snap.fullscreen},
  {key = "d", fn = core.mod.snap.leftHalf},
  {key = "g", fn = core.mod.snap.rightHalf},
  {key = "e", fn = core.mod.snap.leftTopQuarter},
  {key = "r", fn = core.mod.snap.rightTopQuarter},
  {key = "c", fn = core.mod.snap.leftBottomQuarter},
  {key = "v", fn = core.mod.snap.rightBottomQuarter}
}

return settings
