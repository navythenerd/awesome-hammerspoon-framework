local settings = {}

settings.monitorMode = true

settings.keymap = {
  {key = "s", callback = caffeineMenuIconOnClick},
  {key = "l", callback = caffeineLockScreen},
  {key = "s", alt = true, callback = caffeineSleepNow},
  {key = "l", alt = true, callback = caffeineSleepNowAndLock}
}

return settings
