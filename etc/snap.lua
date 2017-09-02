local settings = {}

settings.keymap = {
  {hyper = "hyper", key = "RETURN", fn = ahf.mod.snap.fullscreen},
  {hyper = "hyper", key = "LEFT", fn = ahf.mod.snap.leftHalf},
  {hyper = "hyper", key = "RIGHT", fn = ahf.mod.snap.rightHalf},
  {hyper = "hyper", key = "UP", fn = ahf.mod.snap.topHalf},
  {hyper = "hyper", key = "DOWN", fn = ahf.mod.snap.bottomHalf},
  {hyper = "hyper", key = "u", fn = ahf.mod.snap.leftTopQuarter},
  {hyper = "hyper", key = "i", fn = ahf.mod.snap.rightTopQuarter},
  {hyper = "hyper", key = "j", fn = ahf.mod.snap.leftBottomQuarter},
  {hyper = "hyper", key = "k", fn = ahf.mod.snap.rightBottomQuarter}
}

return settings
