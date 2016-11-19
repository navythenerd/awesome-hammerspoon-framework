local mod = {}

mod.name = "Redshift"
mod.signature = "h5pegyy2HDGwA3nBailU"
mod.context = {}
mod.cronjob = {}
mod.menu = {}
mod.enabled = true
mod.mode = {}
mod.mode.sunrise = true
mod.mode.flux = false
mod.fluxLevel = {}

-- RGB values for whitepoint colors at different color temperatures.
-- This table is the same one used in Redshift:
-- https://github.com/jonls/redshift/blob/master/README-colorramp
local WHITEPOINT_COLORS = {
    -- 1000k
    {1.00000000,  0.18172716,  0.00000000},
    -- 1100k
    {1.00000000,  0.25503671,  0.00000000},
    -- 1200k
    {1.00000000,  0.30942099,  0.00000000},
    {1.00000000,  0.35357379,  0.00000000},
    {1.00000000,  0.39091524,  0.00000000},
    {1.00000000,  0.42322816,  0.00000000},
    {1.00000000,  0.45159884,  0.00000000},
    {1.00000000,  0.47675916,  0.00000000},
    {1.00000000,  0.49923747,  0.00000000},
    {1.00000000,  0.51943421,  0.00000000},
    {1.00000000,  0.54360078,  0.08679949},
    {1.00000000,  0.56618736,  0.14065513},
    {1.00000000,  0.58734976,  0.18362641},
    {1.00000000,  0.60724493,  0.22137978},
    {1.00000000,  0.62600248,  0.25591950},
    {1.00000000,  0.64373109,  0.28819679},
    {1.00000000,  0.66052319,  0.31873863},
    {1.00000000,  0.67645822,  0.34786758},
    {1.00000000,  0.69160518,  0.37579588},
    {1.00000000,  0.70602449,  0.40267128},
    {1.00000000,  0.71976951,  0.42860152},
    {1.00000000,  0.73288760,  0.45366838},
    {1.00000000,  0.74542112,  0.47793608},
    {1.00000000,  0.75740814,  0.50145662},
    {1.00000000,  0.76888303,  0.52427322},
    {1.00000000,  0.77987699,  0.54642268},
    {1.00000000,  0.79041843,  0.56793692},
    {1.00000000,  0.80053332,  0.58884417},
    {1.00000000,  0.81024551,  0.60916971},
    {1.00000000,  0.81957693,  0.62893653},
    {1.00000000,  0.82854786,  0.64816570},
    {1.00000000,  0.83717703,  0.66687674},
    {1.00000000,  0.84548188,  0.68508786},
    {1.00000000,  0.85347859,  0.70281616},
    {1.00000000,  0.86118227,  0.72007777},
    {1.00000000,  0.86860704,  0.73688797},
    {1.00000000,  0.87576611,  0.75326132},
    {1.00000000,  0.88267187,  0.76921169},
    {1.00000000,  0.88933596,  0.78475236},
    {1.00000000,  0.89576933,  0.79989606},
    {1.00000000,  0.90198230,  0.81465502},
    {1.00000000,  0.90963069,  0.82838210},
    {1.00000000,  0.91710889,  0.84190889},
    {1.00000000,  0.92441842,  0.85523742},
    {1.00000000,  0.93156127,  0.86836903},
    {1.00000000,  0.93853986,  0.88130458},
    {1.00000000,  0.94535695,  0.89404470},
    {1.00000000,  0.95201559,  0.90658983},
    {1.00000000,  0.95851906,  0.91894041},
    {1.00000000,  0.96487079,  0.93109690},
    {1.00000000,  0.97107439,  0.94305985},
    {1.00000000,  0.97713351,  0.95482993},
    {1.00000000,  0.98305189,  0.96640795},
    {1.00000000,  0.98883326,  0.97779486},
    {1.00000000,  0.99448139,  0.98899179},
    -- 6500k (default)
    {1.00000000,  1.00000000,  1.00000000}
}

function setFluxLevel(level)
    mod.fluxLevel = level

    local targetBrightness, targetColorTemp = table.unpack(mod.context.config.flux[level])

    local targetColorTempIx = math.floor((targetColorTemp - 1000) / 100)
    local targetWhitepoint = WHITEPOINT_COLORS[targetColorTempIx + 1]

    local targetWhitepointWithBrightness = {
        red = targetWhitepoint[1] * targetBrightness,
        green = targetWhitepoint[2] * targetBrightness,
        blue = targetWhitepoint[3] * targetBrightness
    }

    local targetBlackpoint = {
        alpha = 1,
        red = 0,
        green = 0,
        blue = 0
    }

    for i, screen in ipairs(hs.screen.allScreens()) do
        screen:setGamma(targetWhitepointWithBrightness, targetBlackpoint)
    end
end

function fluxDecreaseLevel()
  if mod.fluxLevel > 1 and mod.mode.flux and mod.enabled then
    setFluxLevel(mod.fluxLevel - 1)
  end
end

function fluxIncreaseLevel()
  if mod.fluxLevel < #mod.context.config.flux and mod.mode.flux and mod.enabled then
    setFluxLevel(mod.fluxLevel + 1)
  end
end

function startRedshift()
  if mod.context.config.dayColorTemp ~= nil then
    hs.redshift.start(mod.context.config.colorTemp, mod.sunrise.sunset, mod.sunrise.sunrise, mod.context.config.transition, false, nil, mod.context.config.dayColorTemp)
  else
    hs.redshift.start(mod.context.config.colorTemp, mod.sunrise.sunset, mod.sunrise.sunrise, mod.context.config.transition)
  end
end

function refreshSunrise()
  mod.sunrise = kernel.helpers.getSunrise()
  hs.redshift.stop()
  startRedshift()
  hs.alert.show("Refresh sunrise triggered")
end

function toggleRedshift()
  if mod.mode.sunrise then
    hs.redshift.toggle()
  end

  if mod.mode.flux then
    setFluxLevel(#mod.context.config.flux)
  end

  if mod.enabled then
    mod.enabled = false
  else
    mod.enabled = true
  end
end

function switchMode(mode)
  if mode == "sunrise" then
    setFluxLevel(#mod.context.config.flux)
    startRedshift()
    mod.mode.flux = false
    mod.mode.sunrise = true
  end
  if mode == "flux" then
    hs.redshift.stop()
    mod.mode.flux = true
    mod.mode.sunrise = false
  end
end

function populateMenu()
  menuData = {
    { title = "Sunrise-Mode", checked = mod.mode.sunrise, fn = function() switchMode("sunrise") end } ,
    { title = "Flux-Mode", checked = mod.mode.flux, fn = function() switchMode("flux") end }
  }

  return menuData
end

function mod.init(context)
  mod.context = context
  mod.sunrise = kernel.helpers.getSunrise()
  setFluxLevel(#mod.context.config.flux)
  mod.fluxLevel = #mod.context.config.flux
  mod.cronjob = hs.timer.doAt(mod.context.config.sunriseRefreshTime, hs.timer.hours(24), refreshSunrise)
  mod.menu = hs.menubar.new()
  mod.menu:setTitle("Redshift")
  mod.menu:setMenu(populateMenu)

  if mod.context.config.mode == "sunrise" then
    mod.mode.flux = false
    mod.mode.sunrise = true
    switchMode("sunrise")
  elseif mod.context.config.mode == "flux" then
    mod.mode.flux = true
    mod.mode.sunrise = false
    switchMode("flux")
  end
end

return mod
