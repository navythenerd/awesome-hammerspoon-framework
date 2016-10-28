local settings = {}

settings.brew = "/usr/local/Homebrew/bin/"
settings.updateFreq = hs.timer.hours(24)
settings.updateTime = "12:00"

settings.keymap = {
  {key = "u", alt = true, callback = updateBrew}
}

return settings
