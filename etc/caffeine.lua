local settings = {}

settings.monitorMode = true

settings.keymap = {
  {key = "s", fn = core.mod.caffeine.menuIconOnClick},
  {key = "l", fn = core.mod.caffeine.lockScreen},
  {key = "s", alt = true, fn = core.mod.caffeine.sleepNow},
  {key = "l", alt = true, fn = core.mod.caffeine.sleepNowAndLock}
}

return settings
