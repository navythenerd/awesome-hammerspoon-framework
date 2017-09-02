local ahf = {}

local logger = hs.logger.new('AHF', 'info')
local init = false
local environment = nil
local keymap = nil
local libDb = nil

ahf.lib = {}
ahf.mod = {}

function reloadConfig(files)
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

function ahf.registerPathwatcher(mod, path, fn)
  local pathwatcher = hs.pathwatcher.new(path, fn)
  table.insert(ahf.mod[mod]['context']['pathwatcher'], pathwatcher)

  pathwatcher:start()
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
      ahf.mod[mod.namespace].context.pathwatcher = {}
      
      if (ahf.mod[mod.namespace].context.config ~= nil and ahf.mod[mod.namespace].context.config.pathwatcher ~= nil and type(ahf.mod[mod.namespace].context.config.pathwatcher) == 'table') then
        for n, pathwatcher in ipairs(ahf.mod[mod.namespace].context.config.pathwatcher) do
          logger.i("Register pathwatcher for " .. pathwatcher.path)
          ahf.registerPathwatcher(mod.namespace, pathwatcher.path, pathwatcher.fn)
        end
      end

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

    if (ahf.mod[namespace].context.config ~= nil and type(ahf.mod[namespace].context.config) == 'table') then
        if (ahf.mod[namespace].context.config.keymap ~= nil and type(ahf.mod[namespace].context.config.keymap) == 'table') then
          logger.i("Keymap for "  .. namespace .. " found")
          for n, keymap in ipairs(ahf.mod[namespace].context.config.keymap) do
            if (keymap.hyper ~= nil and keymap.key ~= nil and type(keymap.hyper) == 'string' and type(keymap.key) == 'string') then
              ahf.ubindHotkey(keymap.hyper, keymap.key)
            else
              logger.e("Error in keymap of " .. namespace)
            end
          end
        end
      end

    if (ahf.mod[namespace]['unload'] ~= nil and type(ahf.mod[namespace]['unload']) == 'function') then
      ahf.mod[namespace]['unload']()
    end

    ahf.mod[namespace] = nil
  end
end

function ahf.bootstrap(modules)
  if (init) then
    if (type(modules) == 'table') then 
      for n, module in ipairs(modules) do
        bootstrapModule(module)
      end
    elseif (type(modules) == 'string') then
      bootstrapModule(modules)
    else
      logger.e("Cannot bootstrap modules from given datatype")
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
    elseif (type(modules) == 'string') then
      unloadModule(modules)
    else
      logger.e("Cannot unload modules from given datatype")
    end
  else
    logger.e("ahf needs to be initialized")
  end
end

function ahf.init(conf)
  if (conf ~= nil and type(conf) == 'table') then
    environment = conf.env
    logger.i("Enviroment has been set")
    keymap = conf.keymap
    logger.i("Keymap has been set")
    libDb = conf.libraries
    logger.i("Libraries have been registered")

    hs.pathwatcher.new(environment.base, reloadConfig):start()
    ahf.bindHotkey(conf.hotkeys.reload.hyper, conf.hotkeys.reload.key, hs.reload)
    logger.i("Pathwatcher has been started")

    init = true
    logger.i("Successful initialized")

    logger.i("Auto bootstrap modules")
    ahf.bootstrap(conf.loadModules)
  else
    logger.e("Config table is needed for initialization")
  end
end

return ahf