local mod = {}

mod.name = "Caffeine"

local caffeineState = false

function caffeineSleepNow()
  hs.caffeinate.systemSleep()
end

function caffeineSleepNowAndLock()
  hs.caffeinate.lockScreen()
  hs.timer.doAfter(4, caffeineSleepNow)
end

function caffeineMenuIconOnClick()
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

  caffeineSetIcon()
end

function caffeineSetIcon()
  if hs.caffeinate.get("displayIdle") then
    mod.menubar:setIcon(mod.context.resources .. "caffeineIconActive.tiff")
  else
    mod.menubar:setIcon(mod.context.resources .. "caffeineIcon.tiff")
  end
end

function caffeineScreenWatcherListener()
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

  caffeineSetIcon()
end

function caffeineLockScreen()
  hs.caffeinate.lockScreen()
end

function mod.init(context)
  mod.context = context

  mod.menubar = hs.menubar.new()
  if mod.menubar then
    mod.menubar:setClickCallback(caffeineMenuIconOnClick)
    caffeineSetIcon()
  end

  if mod.context.config.monitorMode then
    mod.screenWatcher = hs.screen.watcher.new(caffeineScreenWatcherListener)
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
