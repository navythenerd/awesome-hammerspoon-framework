local core = {}

local init = false
local log = hs.logger.new('Core', 'info')
local environment
local keymap
local libDb = {}

core.lib = {}
core.mod = {}

local function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    log.i("Some files have been changed, reloading them.")
    hs.reload()
  end
end

function prequire(...)
  local status, lib = pcall(require, ...)
  if (status) then return lib end
  return nil
end

function core.bindHotkey(key, alt, fn)
  if alt then
    hs.hotkey.bind(keymap.hyper_shift, key, fn)
  else
    hs.hotkey.bind(keymap.hyper, key, fn)
  end
end

function core.unbindHotkey(key, alt)
  if alt then
    hs.hotkey.deleteAll(keymap.hyper_shift, key)
  else
    hs.hotkey.deleteAll(keymap.hyper, key)
  end
end

function core.registerLibraries(lib)
  if (type(lib) == 'table') then
    libDb = lib
    log.i("Libraries have been registered")
  elseif (type(lib) == 'string') then
    local libDef = prequire(lib)

    if (libDef ~= nil and type(libDef) == 'table') then
      libDb = libDef
      log.i("Libraries have been registered")
    else
      log.e("Cannot register libraries from given file")
    end
  else
    log.e("Cannot register libraries from given datatype")
  end
end

function core.mountLibrary(libName)
  if (init) then
    for i, lib in ipairs(libDb) do
      if lib[1] == libName then
        if (core.lib[libName] == nil) then
          log.i("Mounting library " .. libName)
          core.lib[libName] = {}

          if (type(lib[2]) == 'table') then
            for i, libDep in ipairs(lib[2]) do
              local library = prequire(environment.libraries .. '/' .. libDep)
              core.lib[libName][library.namespace] = library
            end
          elseif (type(lib[2]) == 'string') then
            local library = prequire(environment.libraries .. '/' .. lib[2])
            core.lib[libName] = library
          end
        else
          log.i("Library " .. libName .. " already mounted")
        end
      end
    end
  else
    log.e("Not initialised")
  end
end

function core.umountLibrary(libName)
  if (init) then
    if (core.lib[libName] ~= nil) then
      core.lib[libName] = nil
      log.i("Library " .. libName .. " unmounted")
    else
      log.e("No library with name " .. libName .. " found")
    end
  else
    log.e("Not initialised")
  end
end

local function bootstrapModule(file)
  local mod = prequire(environment.modules .. file)

  if (mod ~= nil and type(mod) == 'table') then
    log.i("Boostrapping " .. file)

    if (core.mod[mod.mountpoint] == nil) then
      core.mod[mod.mountpoint] = mod
      core.mod[mod.mountpoint].context = {}
      core.mod[mod.mountpoint].context.config = prequire(environment.config .. file)
      core.mod[mod.mountpoint].context.resources = environment.resources .. file .. '/'

      if (core.mod[mod.mountpoint].dependencies ~= nil and type(core.mod[mod.mountpoint].dependencies) == 'table') then
        for n, lib in ipairs(core.mod[mod.mountpoint].dependencies) do
          core.mountLibrary(lib)
        end
      end

      if (core.mod[mod.mountpoint].init ~= nil and type(core.mod[mod.mountpoint].init) == 'function') then
        log.i("Initializing " .. file)
        core.mod[mod.mountpoint].init()
      end

      if (core.mod[mod.mountpoint].context.config.keymap ~= nil and type(core.mod[mod.mountpoint].context.config.keymap) == 'table') then
        log.i("Keymap for "  .. file .. " found")
        for n, keymap in ipairs(core.mod[mod.mountpoint].context.config.keymap) do
          if (keymap.key ~= nil and keymap.fn ~= nil and type(keymap.key) == 'string' and type(keymap.fn) == 'function') then
            if (keymap.alt) then
              core.bindHotkey(keymap.key, true, keymap.fn)
            else
              core.bindHotkey(keymap.key, false, keymap.fn)
            end
          else
            log.e("Error in keymap of " .. file)
          end
        end
      end
    else
      log.i("Module " .. file .. " already mounted or mountpoint used by another module")
    end
  else
    log.e("Error while trying to bootstrap " .. file)
  end
end

function core.bootstrap(modules)
  if (type(modules) == 'string') then
    file = prequire(modules)

    if (file ~= nil and type(file) == 'table') then
      core.bootstrap(file)
    else
      log.e("Cannot bootstrap from given datatype")
    end
  elseif (type(modules) == 'table') then
    for n, module in ipairs(modules) do
      bootstrapModule(module)
    end
  else
    log.e("Cannot bootstrap from given datatype")
  end
end

function core.setEnvironment(env)
  if (type(env) == 'table') then
    environment = env
    log.i("Environemnt has been loaded")
  elseif (type(env) == 'string') then
    environment = prequire(env)
    if (environment ~= nil and type(environment) == 'table') then
      log.i("Environment has been loaded")
    else
      log.e("Failed loading environment from given file")
    end
  else
    log.e("Failed loading environment from given datatype")
  end
end

function core.setKeymap(map)
  if (type(map) == 'table') then
    keymap = map
    log.i("Keymap has been loaded")
  elseif (type(map) == 'string') then
    keymap = prequire(map)
    if (keymap ~= nil and type(keymap) == 'table') then
      log.i("Keymap has been loaded")
    else
      log.e("Failed loading keymap from given file")
    end
  else
    log.e("Failed loading keymap from given datatype")
  end
end

function core.init(env, map)
  if (env ~= nil) then
    core.setEnvironment(env)
  end

  if (map ~= nil) then
    core.setKeymap(map)
  end

  if (environment ~= nil and type(environment) == 'table') then
    hs.pathwatcher.new(environment.base, reloadConfig):start()
    log.i("Pathwatcher has been started")
    init = true
    log.i("Successful initialised ")
  end
end

return core
