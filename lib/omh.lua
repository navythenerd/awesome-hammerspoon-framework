local lib = {}

lib.namespace = "omh"

lib.plugin_cache={}
local OMH_PLUGINS={}
local OMH_CONFIG={}

local function load_plugins(plugins)
   plugins = plugins or {}
   for i,p in ipairs(plugins) do
      table.insert(OMH_PLUGINS, p)
   end
   for i,plugin in ipairs(OMH_PLUGINS) do
      logger.df("Loading plugin %s", plugin)
      -- First, load the plugin
      mod = require(plugin)
      -- If it returns a table (like a proper module should), then
      -- we may be able to access additional functionality
      if type(mod) == "table" then
         -- If the user has specified some config parameters, merge
         -- them with the module's 'config' element (creating it
         -- if it doesn't exist)
         if OMH_CONFIG[plugin] ~= nil then
            if mod.config == nil then
               mod.config = {}
            end
            for k,v in pairs(OMH_CONFIG[plugin]) do
               mod.config[k] = v
            end
         end
         -- If it has an init() function, call it
         if type(mod.init) == "function" then
            logger.i(string.format("Initializing plugin %s", plugin))
            mod.init()
         end
      end
      -- Cache the module
      lib.plugin_cache[plugin] = mod
   end
end

function lib.config(name, config)
   logger.df("omh_config, name=%s, config=%s", name, hs.inspect(config))
   OMH_CONFIG[name]=config
end

function lib.go(plugins)
   load_plugins(plugins)
end

return lib
