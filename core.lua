--[[
  Do not change this file!!!
  Preferences can be made in the corresponding files: "etc"-directory.
]]

local core = {}

core.config = {}
core.config.env  = {}
core.config.keymap = {}
core.helpers = {}
core.shell = {}
core.shell.stdOut = {}
core.shell.stdErr = {}
core.shell.exitCode = {}
core.extensions = {}

local charset = {}

function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    core.log.i("Watchdog recognized change")
    hs.reload()
  end
end

function prequire(...)
  local status, lib = pcall(require, ...)

  if (status) then return lib end

  return nil
end

local function startWatchdog()
  core.log.i("Starting watchdog")
  hs.pathwatcher.new(core.config.env.base, reloadConfig):start()
  core.log.i("Watchdog started")
end

local function shellCallback(exitCode, stdOut, stdErr)
  table.insert(core.shell.stdOut, stdOut)
  table.insert(core.shell.stdErr, stdErr)
  table.insert(core.shell.exitCode, exitCode)
end

function core.helpers.randomString(length)
  math.randomseed(os.time())

  if length > 0 then
    return core.helpers.randomString(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

function core.helpers.getSunrise()
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

function core.bindHotkey(key, alt, fn)
  if alt then
    hs.hotkey.bind(core.config.keymap.hyper_shift, key, fn)
  else
    hs.hotkey.bind(core.config.keymap.hyper, key, fn)
  end
end

function core.unbindHotkey(key, alt)
  if alt then
    hs.hotkey.deleteAll(core.config.keymap.hyper_shift, key)
  else
    hs.hotkey.deleteAll(core.config.keymap.hyper, key)
  end
end

function core.execute(input)
  local shell = hs.task.new(core.config.env.shell, shellCallback)
  shell:setInput(input)
  shell:start()
end

local function bootstrapExtension(extension)
  if mod.init ~= nil and type(mod.init == 'function') then
    local context = {}
    context.id = core.helpers.randomString(20)
    context.resources = core.config.env.resources .. string.lower(extension.name) .. "/"
    context.config = prequire(core.config.env.config .. string.lower(extension.name))

    mod.init(context)

    table.insert(core.extensions, mod)
  end

  if mod.context.config.keymap ~= nil then
    for n, keymap in ipairs(mod.context.config.keymap) do
      if keymap.key ~= nil and type(keymap.callback) == 'function' then
        if keymap.alt then
          core.bindHotkey(keymap.key, true, keymap.callback)
        else
          core.bindHotkey(keymap.key, false, keymap.callback)
        end
      end
    end
  end
end

function core.bootstrap(extensions)
  core.log.i("Starting bootstrap process")

  if extensions ~= nil then
    for i, extension in ipairs(extensions) do
      mod = prequire(core.config.env.extensions .. extension)

      if (mod ~= nil and mod ~= true) then
        core.log.i("Bootstrapping extension " .. mod.name)

        bootstrapExtension(mod)
      else
        core.log.e("Error while trying to boostrap " .. extension .. ".")
      end
    end
  else
    core.log.e("Cannot bootstrap from given extension table")
  end
end

function core.unloadAll()
  for i, extension in ipairs(core.extensions) do
    core.log.i("Unload extension " .. extension.name)

    if extension.unload ~= nil and type(extension.unload == 'function') then
      extension.unload()
    end

    if extension.context.config.keymap ~= nil then
      for n, keymap in ipairs(extension.context.config.keymap) do
        if keymap.key ~= nil then
          if keymap.alt then
            core.unbindHotkey(keymap.key, true)
          else
            core.unbindHotkey(keymap.key, false)
          end
        end
      end
    end

    table.remove(core.extensions, i)
  end
end

--[[
  Start Initialization & Auto-Bootstrapping
]]
core.log = hs.logger.new('Core', 'info')

core.config.env = prequire("etc/environment")
core.config.keymap = prequire("etc/keymap")

startWatchdog()

for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end
--[[
  End Initialization & Auto-Bootstrapping
]]

return core
