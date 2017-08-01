local ahf = {}

local logger = hs.logger.new('AHF', 'info')
local init = false
local environment = nil
local keymap = nil
local libDb = {}

ahf.lib = {}
ahf.mod = {}

local function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    logger.i("Some files have been changed, reloading them.")
    hs.reload()
  end
end

function prequire(...)
  local status, lib = pcall(require, ...)
  if (status) then return lib end
  return nil
end

function ahf.bindHotkey(hyper, key, fn)
  if (keymap[hyper] ~= nil) then
    hs.hotkey.bind(keymap[hyper], key, fn)
  else
    logger.e("Invalid hyper name for keymap binding")
  end
end

function ahf.ubindHotkey(hyper, key)
  if (keymap[hyper] ~= nil) then
    hs.hotkey.deleteAll(keymap[hyper], key)
  else
    logger.e("Invalid hyper name for keymap unbinding")
  end
end

function ahf.registerLibraries(lib)
  if (type(lib) == 'table') then
    libDb = lib
    logger.i("Libraries have been registered")
  elseif (type(lib) == 'string') then
    local libDef = prequire(lib)

    if (libDef ~= nil and type(libDef) == 'table') then
      libDb = libDef
      logger.i("Libraries have been registered")
    else
      logger.e("Cannot register libraries from given file")
    end
  else
    logger.e("Cannot register libraries from given datatype")
  end
end

function ahf.mountLibrary(libName)
  if (init) then
    for i, lib in ipairs(libDb) do
      if lib[1] == libName then
        if (ahf.lib[libName] == nil) then
          logger.i("Mounting library " .. libName)
          ahf.lib[libName] = {}

          if (type(lib[2]) == 'table') then
            for i, libDep in ipairs(lib[2]) do
              local library = prequire(environment.libraries .. '/' .. libDep)
              ahf.lib[libName][library.namespace] = library
            end
          elseif (type(lib[2]) == 'string') then
            local library = prequire(environment.libraries .. '/' .. lib[2])
            ahf.lib[libName] = library
          end
        else
          logger.i("Library " .. libName .. " already mounted")
        end
      end
    end
  else
    logger.e("ahf needs to be initialized")
  end
end

function ahf.umountLibrary(libName)
  if (init) then
    if (lib[libName] ~= nil) then
      lib[libName] = nil
      logger.i("Library " .. libName .. " unmounted")
    else
      logger.e("No library with name " .. libName .. " found")
    end
  else
    logger.e("ahf needs to be initialized")
  end
end

local function bootstrapModule(file)
  local mod = prequire(environment.modules .. file)

  if (mod ~= nil and type(mod) == 'table') then
    logger.i("Boostrapping " .. file)

    if (ahf.mod[mod.namespace] == nil) then
      ahf.mod[mod.namespace] = mod
      ahf.mod[mod.namespace].context = {}
      ahf.mod[mod.namespace].context.logger = hs.logger.new(mod.namespace, 'info')
      ahf.mod[mod.namespace].context.config = prequire(environment.config .. file)
      ahf.mod[mod.namespace].context.resources = environment.resources .. file .. '/'

      if (ahf.mod[mod.namespace].dependencies ~= nil and type(ahf.mod[mod.namespace].dependencies) == 'table') then
        for n, lib in ipairs(ahf.mod[mod.namespace].dependencies) do
          ahf.mountLibrary(lib)
        end
      end

      if (ahf.mod[mod.namespace].init ~= nil and type(ahf.mod[mod.namespace].init) == 'function') then
        logger.i("Initializing " .. file)
        ahf.mod[mod.namespace].init()
      end

      if (ahf.mod[mod.namespace].context.config ~= nil and type(ahf.mod[mod.namespace].context.config) == 'table') then
        if (ahf.mod[mod.namespace].context.config.keymap ~= nil and type(ahf.mod[mod.namespace].context.config.keymap) == 'table') then
          logger.i("Keymap for "  .. file .. " found")
          for n, keymap in ipairs(ahf.mod[mod.namespace].context.config.keymap) do
            if (keymap.hyper ~= nil and keymap.key ~= nil and keymap.fn ~= nil and type(keymap.hyper) == 'string' and type(keymap.key) == 'string' and type(keymap.fn) == 'function') then
              ahf.bindHotkey(keymap.hyper, keymap.key, keymap.fn)
            else
              logger.e("Error in keymap of " .. file)
            end
          end
        end
      end
    else
      logger.i("Module " .. file .. " already mounted or namespace used by another module")
    end
  else
    logger.e("Error while trying to bootstrap " .. file)
  end
end

local function unloadModule(namespace)
  if (ahf.mod[namespace] ~= nil) then
    logger.i("Unloading module " .. namespace)

    if (ahf.mod[namespace]['unload'] ~= nil and type(ahf.mod[namespace]['unload']) == 'function') then
      ahf.mod[namespace]['unload']()
    end

    ahf.mod[namespace] = nil
  end
end

function ahf.bootstrap(modules)
  if (init) then
    if (type(modules) == 'string') then
      file = prequire(modules)

      if (file ~= nil and type(file) == 'table') then
        ahf.bootstrap(file)
      else
        logger.e("Cannot bootstrap from given datatype")
      end
    elseif (type(modules) == 'table') then
      for n, module in ipairs(modules) do
        bootstrapModule(module)
      end
    else
      logger.e("Cannot bootstrap from given datatype")
    end
  else
    logger.e("ahf needs to be initialized")
  end
end

function ahf.unload(modules)
  if (init) then
    if (type(modules) == 'table') then
      for n, module in ipairs(modules) do
        unloadModule(module)
      end
    end
  else
    logger.e("ahf needs to be initialized")
  end
end

function ahf.setEnvironment(env)
  if (type(env) == 'table') then
    environment = env
    logger.i("Environemnt has been loaded")
  elseif (type(env) == 'string') then
    environment = prequire(env)
    if (environment ~= nil and type(environment) == 'table') then
      logger.i("Environment has been loaded")
    else
      logger.e("Failed loading environment from given file")
    end
  else
    logger.e("Failed loading environment from given datatype")
  end
end

function ahf.setKeymap(map)
  if (type(map) == 'table') then
    keymap = map
    logger.i("Keymap has been loaded")
  elseif (type(map) == 'string') then
    keymap = prequire(map)
    if (keymap ~= nil and type(keymap) == 'table') then
      logger.i("Keymap has been loaded")
    else
      logger.e("Failed loading keymap from given file")
    end
  else
    logger.e("Failed loading keymap from given datatype")
  end
end

function ahf.init(env, map)
  if (env ~= nil) then
    ahf.setEnvironment(env)
  end

  if (map ~= nil) then
    ahf.setKeymap(map)
  end

  if (environment ~= nil and type(environment) == 'table' and keymap ~= nil and type(keymap) == 'table') then
    hs.pathwatcher.new(environment.base, reloadConfig):start()
    ahf.bindHotkey("hyper", '1', hs.reload)
    logger.i("Pathwatcher has been started")
    init = true
    logger.i("Successful initialized")
  end
end

return ahf
