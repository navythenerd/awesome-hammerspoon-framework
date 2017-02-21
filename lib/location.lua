local lib = {}

lib.namespace = 'location'

function lib.getSunrise()
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

return lib
