--[[
  Do not change this file!!!
  Preferences can be made in the corresponding files: "etc"-directory.
]]

------------------------------
---   Initializing core    ---
------------------------------
core = require("core")

-------------------------------
--- Boostrapping extensions ---
-------------------------------
local extensions = prequire("etc/extensions")

core.bootstrap(extensions)
