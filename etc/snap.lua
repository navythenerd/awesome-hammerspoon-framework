local settings = {}

settings.keymap = {
  {hyper = "hyper", key = "f", fn = ahf.mod.snap.fullscreen},
  {hyper = "hyper", key = "d", fn = ahf.mod.snap.leftHalf},
  {hyper = "hyper", key = "g", fn = ahf.mod.snap.rightHalf},
  {hyper = "hyper", key = "e", fn = ahf.mod.snap.leftTopQuarter},
  {hyper = "hyper", key = "r", fn = ahf.mod.snap.rightTopQuarter},
  {hyper = "hyper", key = "c", fn = ahf.mod.snap.leftBottomQuarter},
  {hyper = "hyper", key = "v", fn = ahf.mod.snap.rightBottomQuarter}
}

return settings
