--[[
  Do not change this file!!!
  Preferences can be made in the corresponding files: "etc"-directory.
]]

------------------------------
---   Initializing core    ---
------------------------------
ahf = require("ahf")
ahf.init("etc/environment", "etc/keymap")

------------------------------
---   Register libraries   ---
------------------------------
ahf.registerLibraries("etc/libraries")

------------------------------
---  Bootstrapping modules ---
------------------------------
ahf.bootstrap("etc/modules")
