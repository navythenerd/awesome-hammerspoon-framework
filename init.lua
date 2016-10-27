--[[
  Do not change this file!!!
  Preferences can be made in the corresponding files: "etc"-directory.
]]

-----------------------------
---  Initializing Kernel  ---
-----------------------------
kernel = require("kernel")
kernel.init()

-----------------------------
---     Bootstrapping     ---
-----------------------------
extensions = require("etc/extensions")
kernel.bootstrap(extensions)
