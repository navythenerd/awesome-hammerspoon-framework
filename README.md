# Awesome Hammerspoon Framework!

## A framework for [Hammerspoon](http://www.hammerspoon.org)

This is a framework for your Hammerspoon configuration. The aims of this framework are to unitize the structure of Hammerspoon functionalities (called `modules` in this framework). So everyone can include modules from other developers with ease.
The framework does the rest for you, e.g. loading dependencies, binding the hotkeys etc..

### Instructions

1. Check out this repository onto your `~/.hammerspoon` directory:
   ```
   git clone https://github.com/navythenerd/hammerspoon-framework.git ~/.hammerspoon
   ```
2. Edit `etc/ahf.lua` to enable/disable the modules you want (by default all supplied extensions except `Redshift` are enabled) or change other framework related settings such as hotkeys.
3. Edit the corresponding config files for the extensions in `etc` directory (Read below to learn more about configuration).

### Modules included

By default the following modules are supplied (Inspiration by [Hammerspoon's sample configurations page](https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations)):

Since macOS natively supports some kind of `Redshift` functionality with its `Night Shift` feature, the `Redshift` module isn't going to be supported anymore and marked as deprecated. Nevertheless the module should work properly.



- Redshift [DEPRECATED, see note above] - Adjust screen brightness and gamma based on sunrise information (Inspired by [Redshift](https://github.com/jonls/redshift) and [f.lux](https://justgetflux.com/)).
  - Temporally toggling off of Redshift is provided through `[CMD][ALT][CTRL][-]`
  - Redshift config is located at `etc/redshift.lua`.
- Caffeine - Disable standby time for your screen.
  - Caffeine can be toggled through menubar icon (Cup) or through hotkey `[SHIFT][CMD][ALT][CTRL][C]`.
  - Furthermore through `[CMD][ALT][CTRL][L]` you can lock your screen immediately.
  - Through `[CMD][ALT][CTRL][S]` Caffeine starts your Mac´s screensaver.
  - Through `[SHIFT][CMD][ALT][CTRL][S]` Caffeine puts your Mac into sleep-idle immediately.
  - MonitorMode automatically disables/enables the display idle at connection/disconnection of an external monitor (Can be disabled through config)
  - Config is located at `etc/caffeine.lua`.
- MouseLocator - Hightlights your cursor with a surrounding circle (Inspired by [Locator](https://github.com/zzamboni/oh-my-hammerspoon/blob/master/plugins/mouse/locator.lua)).
  - Hightlight is triggered by `[CMD][ALT][CTRL][M]`.
  - Config is located at `etc/mouselocator.lua`.
- Snap - Provides simple window management with full-screen, half-screen, quarter-screen.
  - Manage focused window through one of the following short-keys:
    - full-screen: `[CMD][ALT][CTRL][RETURN]`
    - half-screen-left: `[CMD][ALT][CTRL][LEFT]`
    - half-screen-right: `[CMD][ALT][CTRL][RIGHT]`
    - half-screen-top: `[CMD][ALT][CTRL][UP]`
    - half-screen-bottom: `[CMD][ALT][CTRL][DOWN]`
    - quarter-screen-left-top: `[CMD][ALT][CTRL][U]`
    - quarter-screen-right-top: `[CMD][ALT][CTRL][I]`
    - quarter-screen-left-bottom: `[CMD][ALT][CTRL][J]`
    - quarter-screen-right-bottom: `[CMD][ALT][CTRL][K]`
  - Config is located at `etc/snap.lua`.

## General stucture

The framework provides some default files which are needed to get the framework working. These main files are `init.lua` and `ahf.lua` (Framework file). Through `etc/ahf.lua` the framework can be configured.

### init.lua

This file is the main entry point of every Hammerspoon configuration. This file is used to load and initialize the ahf framework. So it is not necessary to change this file.

### ahf.lua

This is the main framework file which is managing and bootstrapping any further extensions/libraries. The `AHF` comes with some other pre-configured helper functions.

### etc/ahf.lua

This is the configuration file for the Framework. Hotkeys, environment vars can be specified here.
You may also specify your modules which are going to be bootstrapped by the framework at init time.

#### AHF Features

- Hot-reloading of configuration: This function is triggered every time a file has changed. This causes a reload of the whole Hammerspoon configuration.
- Own require function which can be called through: `prequire(...)`, this function will return the loaded file if its exist otherwise the return value is `nil`.
- Hotkey-binding: This function can bind any function to the provided key and global hotkey. There is no need to use this function if you use extensions which are following the development guidelines described below, otherwise you can use `core.bindHotkey(hyper, alt, fn)` (hyper - string (Hypername defined in `keymap.lua`), key - keystring, fn - function) to manually bootstrap third-party extensions.
- Library support: The framework supports libraries which are intended to seperate core functionality and further functions which may be needed by more than one module (Have a look at `lib` directory for shipped libraries and `etc/library.lua` for library definition).



## Module Development

1. Create your own module file `mod/myfirstmod.lua`.
2. Create your corresponding configuration file `etc/myfirstmod.lua` (Same file name as the mod file!).
3. Edit main module file:
  ```
    local mod = {}

    mod.namespace = "myfirstmod" -- Is used for mounting your mod into core.mod, so every module is accessibly through ahf.mod.<namespace>
    mod.dependencies = {'std', <foo>, <bar>, ...} -- Dependency list, these dependencies are mounted by ahf, only necessary if your extension needs some libs (E.g. std is used for getRandomString() function)

    function mod.foo()
      hs.alert.show('foo triggered')
    end

    function mod.bar()
      hs.alert.show('Bar says:' .. core.lib.stdlib.random.getRandomString(5))
    end

    function mod.init()
      -- Called automatically by core to bootstrap extension
      -- Config accessible through mod.context.config

      -- Keymap will automatically be loaded and bound by the core, further you have access to your config through mod.context.config
      -- Resource path for your application is provided through mod.context.resources
    end

    function mod.unload()
      -- This function is called by ahf if the mod will be unmounted, so it should quit all necessary operations
      -- Unload all created timers, menubars, etc.
      -- Don't unload keymap manually, this will be automatically done by ahf
    end

    return mod
  ```
4. Configuration file `etc/myfirstmod.lua`.
  ```
    local settings = {}

    -- Make sure functions foo and bar are available
    -- This will bind [CMD][ALT][CTRL][A] to function 'foo' and [CMD][ALT][CTRL][SHIFT][B] to function 'bar'
    settings.keymap = {
      {hyper = "hyper", key = "a", fn = ahf.mod.myfirstmod.foo},
      {hyper = "hyper_shift", key = "b", fn = ahf.mod.myfirstmod.bar}
    }

    -- You may also specify pathwatchers, these are gonna be started automatically
    settings.pathwatcher = {
      {path = "/root/dir", fn = ahf.mod.myfirstmod.foo},
      {path = "/usr/local/bin", fn = ahf.mod.myfirstmod.bar},
      ...
    }

    -- You can add other settings, which then can be used by your extension
    setting.language = {
      "en", "de"
    }

    setting.someProperty = 3

    return settings
  ```
3. Add your new created extension to the `loadModules` table in `etc/ahf.lua` to load it.
  ```
    ...
    config.loadModules = {
      "...",
      "...",
      "myfirstextension",
      "..."
    }
    ...
  ```
4. `AHF` will automatically reload configuration and your extension is going to be loaded, otherwise reload config through `[CMD][ALT][CTRL][1]`.


## Library Development

1. Create your own lib file `lib/myfirstlib.lua`.
2. Add the base information needed to provide a working library:
  ```
    local lib = {}

    lib.namespace = "myfirstlib" -- Is used for mounting your lib into core.lib, so every module is accessibly through core.lib.<namespace>.<namespace>

    function lib.foo()
      hs.alert.show('foo triggered')
    end

    return lib
  ```
4. Add a library definition in `etc/ahf.lua`.
  ```
    ...
    config.libraries = {
      { "std", {"system", "random", "location"} },
      { "mylib", "myfirstlib" } -- Second param can also be a table see std, then you can add many lib-files and bundle them to one namspaced lib
    }
    ...
  ```
