local settings = {}

settings.enableMonitorMode = true

settings.keymap = {
  {key = "s", callback = caffeineMenuIconOnClick},
  {key = "l", callback = caffeineLockScreen}
}

return settings
