local mod = {}

mod.name = "Caffeine"
mod.context = {}

function menuOnClick()
  if hs.caffeinate.get("displayIdle") then
    hs.caffeinate.set("displayIdle", false, true)
  else
    hs.caffeinate.set("displayIdle", true, true)
  end

  setIcon()
end

function setIcon()
  if hs.caffeinate.get("displayIdle") then
    mod.menubar:setIcon(mod.context.resources .. "caffeineIconActive.tiff")
  else
    mod.menubar:setIcon(mod.context.resources .. "caffeineIcon.tiff")
  end
end

function lockScreen()
  hs.caffeinate.lockScreen()
end

function mod.init(context)
  mod.context = context
  mod.menubar = hs.menubar.new()

  if mod.menubar then
    mod.menubar:setClickCallback(menuOnClick)
    setIcon()
  end
end

function mod.unload()
  hs.caffeinate.set("displayIdle", false, true)
  mod.menubar:delete()
end

return mod
