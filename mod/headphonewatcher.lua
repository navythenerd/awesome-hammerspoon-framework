local mod = {}

mod.namespace = "headphonewatcher"
mod.dependencies = {"stddev"}

local spotify = require("hs.spotify")
local itunes = require("hs.itunes")

local spotify_was_playing = false
local itunes_was_playing = false

local audio = nil
local logger = hs.logger.new("HeadphoneWatcher", "info")

function audiodevwatch(dev_uid, event_name, event_scope, event_element)
   logger.f("Audiodevwatch args: %s, %s, %s, %s", dev_uid, event_name, event_scope, event_element)
   dev = audio.findDeviceByUID(dev_uid)
   if event_name == 'jack' then
      if dev:jackConnected() then
         logger.d("Headphones connected")
         if mod.config.control_spotify and spotify_was_playing then
            logger.d("Resuming playback in Spotify")
            notify("Headphones plugged", "Resuming Spotify playback")
            spotify.play()
         end
         if mod.config.control_itunes and itunes_was_playing then
            logger.d("Resuming playback in iTunes")
            notify("Headphones plugged", "Resuming iTunes playback")
            itunes.play()
         end
      else
         logger.d("Headphones disconnected")
         -- Cache current state to know whether we should resume
         -- when the headphones are connected again
         spotify_was_playing = spotify.isPlaying()
         itunes_was_playing = itunes.isPlaying()
         logger.f("spotify_was_playing=%s", spotify_was_playing)
         logger.f("itunes_was_playing=%s", itunes_was_playing)
         if mod.context.config.control_spotify and spotify_was_playing then
            logger.d("Pausing Spotify")
            notify("Headphones unplugged", "Pausing Spotify")
            spotify.pause()
         end
         if mod.context.config.control_itunes and itunes_was_playing then
            logger.d("Pausing iTunes")
            notify("Headphones unplugged", "Pausing iTunes")
            itunes.pause()
         end
      end
   end
end

function mod.init()
  audio = core.lib.stddev.audio.device
  core.lib.stddev.audio.setAudioHandler(audiodevwatch)
end

return mod
