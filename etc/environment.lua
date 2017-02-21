--[[
  !!!Do not move or delete this file!!!

  The core loads this file to load enviroment variable which is injected into
  extension during bootstrap process. Due to this, extensions know where
  config, resource and other extensions are located at.
]]

local env = {}

env.base = os.getenv("HOME") .. "/.hammerspoon/"
env.libraries = "lib/"
env.config = "etc/"
env.modules = "mod/"
env.resources = "res/"

return env
