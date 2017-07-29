local settings = {}

settings.monitorMode = true

settings.keymap = {
  {key = "s", fn = core.mod.caffeine.menuIconOnClick},
  {key = "l", fn = core.mod.caffeine.lockScreen}, --Lock only
  {key = "s", alt = true, fn = core.mod.caffeine.sleepNow}, --Sleep immediatly repspecting default sleep lock time
  {key = "l", alt = true, fn = core.mod.caffeine.sleepNowAndLock} --Sleep immediatly but lock before
}

return settings
