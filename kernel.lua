--[[
  Do not change this file!!!
  Preferences can be made in the corresponding files: "etc"-directory.
]]

local kernel = {}

kernel.config = {}
kernel.config.env  = {}
kernel.config.keymap = {}
kernel.helpers = {}
kernel.shell = {}
kernel.shell.stdOut = {}
kernel.shell.stdErr = {}
kernel.shell.exitCode = {}
kernel.extensions = {}

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

function prequire(...)
  local status, lib = pcall(require, ...)

  if (status) then return lib end

  return nil
end

function startWatchdog()
  kernel.log.i("Starting watchdog")
  hs.pathwatcher.new(kernel.config.env.base, reloadConfig):start()
  kernel.log.i("Watchdog started")
end

function shellCallback(exitCode, stdOut, stdErr)
  table.insert(kernel.shell.stdOut, stdOut)
  table.insert(kernel.shell.stdErr, stdErr)
  table.insert(kernel.shell.exitCode, exitCode)
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

function kernel.unbindHotkey(key, alt)
  if alt then
    hs.hotkey.deleteAll(kernel.config.keymap.hyper_shift, key)
  else
    hs.hotkey.deleteAll(kernel.config.keymap.hyper, key)
  end
end

function kernel.execute(input)
  local shell = hs.task.new(kernel.config.env.shell, shellCallback)
  shell:setInput(input)
  shell:start()
end

function bootstrapExtension(extension)
  if mod.init ~= nil and type(mod.init == 'function') then
    local context = {}
    context.id = kernel.helpers.randomString(20)
    context.resources = kernel.config.env.resources .. string.lower(extension.name) .. "/"
    context.config = prequire(kernel.config.env.config .. string.lower(extension.name))

    mod.init(context)

    table.insert(kernel.extensions, mod)
  end

  if mod.context.config.keymap ~= nil then
    for n, keymap in ipairs(mod.context.config.keymap) do
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

  kernel.config.env = prequire("etc/environment")
  kernel.config.keymap = prequire("etc/keymap")

  startWatchdog()

  for i = 48,  57 do table.insert(charset, string.char(i)) end
  for i = 65,  90 do table.insert(charset, string.char(i)) end
  for i = 97, 122 do table.insert(charset, string.char(i)) end
end

function kernel.bootstrap(extensions)
  kernel.log.i("Starting bootstrap process")

  for i, extension in ipairs(extensions) do
    mod = prequire(kernel.config.env.extensions .. extension)

    if (mod ~= nil and mod ~= true) then
      kernel.log.i("Bootstrapping extension " .. mod.name)

      bootstrapExtension(mod)
    else
      kernel.log.e("Error while trying to boostrap " .. extension .. ".")
    end
  end
end

function kernel.unloadAll()
  for i, extension in ipairs(kernel.extensions) do
    kernel.log.i("Unload extension " .. extension.name)

    if extension.unload ~= nil and type(extension.unload == 'function') then
      extension.unload()
    end

    if extension.context.config.keymap ~= nil then
      for n, keymap in ipairs(extension.context.config.keymap) do
        if keymap.key ~= nil then
          if keymap.alt then
            kernel.unbindHotkey(keymap.key, true)
          else
            kernel.unbindHotkey(keymap.key, false)
          end
        end
      end
    end

    table.remove(kernel.extensions, i)
  end
end

return kernel
