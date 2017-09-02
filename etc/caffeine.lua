local config = {}

config.monitorMode = true

config.keymap = {
  {hyper = "hyper_shift", key = "c", fn = ahf.mod.caffeine.caffeineMenuOnClick}, --Activate caffeine
  {hyper = "hyper", key = "s", fn = ahf.mod.caffeine.startScreensaver}, --Start screensaver
  {hyper = "hyper_shift", key = "s", fn = ahf.mod.caffeine.systemSleep}, --Sleep immediatly
  {hyper = "hyper", key = "l", fn = ahf.mod.caffeine.lockScreen} --Lock only
}

return config
