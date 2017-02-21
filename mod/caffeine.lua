local mod = {}

mod.mountpoint = "caffeine"

local caffeineState = false

function mod.sleepNow()
  hs.caffeinate.systemSleep()
end

function mod.sleepNowAndLock()
  hs.caffeinate.lockScreen()
  hs.timer.doAfter(4, mod.sleepNow)
end

function mod.menuIconOnClick()
  local monitorCount = #hs.screen.allScreens()

  if hs.caffeinate.get("displayIdle") then
    hs.caffeinate.set("displayIdle", false, true)

    if (monitorCount == 1) then
      caffeineState = false
    end
  else
    hs.caffeinate.set("displayIdle", true, true)

    if (monitorCount == 1) then
      caffeineState = true
    end
  end

  mod.setIcon()
end

function mod.setIcon()
  if hs.caffeinate.get("displayIdle") then
    mod.menubar:setIcon(mod.context.resources .. "caffeineIconActive.tiff")
  else
    mod.menubar:setIcon(mod.context.resources .. "caffeineIcon.tiff")
  end
end

function mod.screenWatcherListener()
  local monitorCount = #hs.screen.allScreens()

  if (monitorCount > 1) then
    hs.caffeinate.set("displayIdle", true, true)
  else
    if (caffeineState) then
      hs.caffeinate.set("displayIdle", true, true)
    else
      hs.caffeinate.set("displayIdle", false, true)
    end
  end

  mod.setIcon()
end

function mod.lockScreen()
  hs.caffeinate.lockScreen()
end

function mod.init()
  mod.menubar = hs.menubar.new()
  if mod.menubar then
    mod.menubar:setClickCallback(mod.menuIconOnClick)
    mod.setIcon()
  end

  if mod.context.config.monitorMode then
    mod.screenWatcher = hs.screen.watcher.new(mod.screenWatcherListener)
    if mod.screenWatcher then
      mod.screenWatcher:start()
    end
  end
end

function mod.unload()
  hs.caffeinate.set("displayIdle", false, true)
  mod.menubar:delete()
end

return mod
