local mod={}

mod.name = "Mouselocator"
mod.signature = "h5pegyy2HDGwA3nBailU"
mod.keymap = {}
mod.config = {}
mod.context = {}

local mouseCircle = nil
local mouseCircleTimer = nil

function mouseHighlight()
  -- Delete an existing highlight if it exists
  if mouseCircle then
    mouseCircle:delete()
    if mouseCircleTimer then
      mouseCircleTimer:stop()
    end
  end
  -- Get the current co-ordinates of the mouse pointer
  mousepoint = hs.mouse.getAbsolutePosition ()
  -- Prepare a big red circle around the mouse pointer
  local diameter = mod.config.diameter
  local radius = math.floor(diameter / 2)
  mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-radius, mousepoint.y-radius, diameter, diameter))
  mouseCircle:setStrokeColor(mod.config.color)
  mouseCircle:setFill(false)
  mouseCircle:setStrokeWidth(mod.config.linewidth)
  mouseCircle:show()

  -- Set a timer to delete the circle after 3 seconds
  mouseCircleTimer = hs.timer.doAfter(2, function() mouseCircle:delete() end)
end

function mod.init(context)
  mod.context = context
  mod.config = require(context.config)
end

mod.keymap = {
  {key = "m", callback = mouseHighlight}
}

return mod
