--[[
  Do not change this file!!!
  Preferences can be made in the corresponding files: "etc"-directory.
]]

local kernel = {}

kernel.author = "Cedrik Kaufmann"
kernel.module = {}
kernel.module.signature = "h5pegyy2HDGwA3nBailU"
kernel.config = {}
kernel.config.env = require("etc/environment")
kernel.config.keymap = require("etc/keymap")
kernel.cronjob = {}
kernel.helpers = {}

local charset = {}

function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    kernel.log.i("Watchdog recognized change")
    hs.reload()
  end
end

function startWatchdog()
  kernel.log.i("Starting watchdog")
  hs.pathwatcher.new(kernel.config.env.base, reloadConfig):start()
  kernel.log.i("Watchdog started")
end

function kernel.helpers.randomString(length)
  math.randomseed(os.time())

  if length > 0 then
    return kernel.helpers.randomString(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

function kernel.helpers.getSunrise()
  hs.location.start()
  loc = hs.location.get()
  hs.location.stop()

  local times = {sunrise = "07:00", sunset = "20:00"}

  if loc then
    local tzOffset = tonumber(string.sub(os.date("%z"), 1, -3))
    for i,v in pairs({"sunrise", "sunset"}) do
      times[v] = os.date("%H:%M", hs.location[v](loc.latitude, loc.longitude, tzOffset))
    end
  end

  return times
end

function kernel.bindHotkey(key, alt, fn)
  if alt then
    hs.hotkey.bind(kernel.config.keymap.hyper_shift, key, fn)
  else
    hs.hotkey.bind(kernel.config.keymap.hyper, key, fn)
  end
end

function bootstrapNative(extension)
  if mod.init ~= nil and type(mod.init == 'function') then
    context = {}
    context.id = kernel.helpers.randomString(20)
    context.resources = kernel.config.env.resources .. string.lower(extension.name) .. "/"
    context.config = kernel.config.env.config .. string.lower(extension.name)
    mod.init(context)
  end

  if mod.keymap ~= nil then
    for n, keymap in ipairs(mod.keymap) do
      if keymap.key ~= nil and type(keymap.callback) == 'function' then
        if keymap.alt then
          kernel.bindHotkey(keymap.key, true, keymap.callback)
        else
          kernel.bindHotkey(keymap.key, false, keymap.callback)
        end
      end
    end
  end
end

function kernel.init()
  kernel.log = hs.logger.new('Kernel', 'info')

  startWatchdog()
  kernel.bindHotkey("r", true, hs.reload)

  for i = 48,  57 do table.insert(charset, string.char(i)) end
  for i = 65,  90 do table.insert(charset, string.char(i)) end
  for i = 97, 122 do table.insert(charset, string.char(i)) end
end

function kernel.bootstrap(extensions)
  kernel.log.i("Starting bootstrap process")

  for i, extension in ipairs(extensions.native) do
    mod = require(kernel.config.env.extensions .. extension)

    if (mod ~= nil and mod ~= true and mod.signature ~= nil and mod.signature == kernel.module.signature) then
      kernel.log.i("Signature found, bootstrapping native extension " .. mod.name)

      bootstrapNative(mod)
    else
      kernel.log.e("Don't know how to bootstrap " .. extension .. ". Perhaps manual bootstrapping is necessary.")
    end
  end

  if extensions.thirdparty ~= nil then
    bootstrap = require("etc/bootstrap")

    for i, extension in ipairs(extensions.thirdparty) do
      mod = require(kernel.config.env.extensions .. extension)

      kernel.log.i("Bootstrapping third-party extension " .. extension)

      if bootstrap[extension] ~= nil and type(bootstrap[extension]) == 'function' then
        bootstrap[extension](mod)
      end
    end
  end
end

return kernel
