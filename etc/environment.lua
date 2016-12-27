--[[
  !!!Do not move or delete this file!!!

  The core loads this file to load enviroment variable which is injected into
  extension during bootstrap process. Due to this, extensions know where
  config, resource and other extensions are located at.
]]

local env = {}

env.base = os.getenv("HOME") .. "/.hammerspoon/"
env.extensions = "lib/"
env.config = "etc/"
env.resources = "res/"
env.shell = "/bin/bash"

return env
