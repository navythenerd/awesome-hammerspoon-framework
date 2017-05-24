--[[
  Do not change this file!!!
  Preferences can be made in the corresponding files: "etc"-directory.
]]

------------------------------
---   Initializing core    ---
------------------------------
core = require("core")
core.init("etc/environment", "etc/keymap")

------------------------------
---   Register libraries   ---
------------------------------
core.registerLibraries("etc/libraries")

------------------------------
---  Bootstrapping modules ---
------------------------------
core.bootstrap("etc/modules")
