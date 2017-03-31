local lib = {}

lib.namespace = "audio"

local logger = hs.logger.new("STDDEV_AUDIO", "info")
local audio = require("hs.audiodevice")
local devs = {}

lib.device = audio

function lib.setAudioEventHandler(fn)
  if (type(fn) == 'function') then
    for i,dev in ipairs(audio.allOutputDevices()) do
       if dev.watcherCallback ~= nil then
          logger.f("Setting up watcher for audio device %s (UID %s)", dev:name(), dev:uid())
          devs[dev:uid()]=dev:watcherCallback(fn)
          devs[dev:uid()]:watcherStart()
       else
          logger.w("Skipping audio device watcher setup because you have an older version of Hammerspoon")
       end
    end
  else
    logger.e("Valid function is needed as callback")
  end
end

return lib
