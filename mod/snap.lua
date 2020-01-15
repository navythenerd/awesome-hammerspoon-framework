local mod = {}

mod.namespace = 'snap'

local function divide(xMax, yMax, x, y)
  if hs.window.focusedWindow() then
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / xMax) * (x - 1)
    f.y = max.y + (max.h / yMax) * (y - 1)
    f.w = max.w / xMax
    f.h = max.h / yMax

    win:setFrame(f)
  else
    hs.alert.show("No active window")
  end
end

function mod.init()
  profile = mod.context.config.profiles[mod.context.config.use]

  for n, entry in ipairs(profile) do
    if (entry.hyper ~= nil and entry.key ~= nil and entry.xSplit ~= nil and entry.ySplit ~= nil and entry.xPos ~= nil and entry.yPos ~= nil and type(entry.hyper) == 'string' and type(entry.key) == 'string' and type(entry.xSplit) == 'number' and type(entry.ySplit) == 'number' and type(entry.xPos) == 'number' and type(entry.yPos) == 'number') then
      wrapperFn = function() divide(entry.xSplit, entry.ySplit, entry.xPos, entry.yPos) end
      ahf.bindHotkey(entry.hyper, entry.key, wrapperFn)
    else
      mod.context.logger.e("Error in snap profile: " .. mod.context.config.use)
    end
  end
end

return mod
