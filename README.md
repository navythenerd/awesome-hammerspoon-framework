# Hammerspoon Framework!

## A framework for [Hammerspoon](http://www.hammerspoon.org)

This is an early version with a very basic feature set.

### Instructions

1. Check out this repository onto your `~/.hammerspoon` directory:
   ```
   git clone https://gitlab.com/ckaufmann/hammerspoon-framework.git ~/.hammerspoon
   ```
2. Edit `etc/extensions.lua` to enable/disable the extensions you want (by default all supplied extensions, excepting `BrewUpdater`, are enabled).
3. Edit the corresponding config files for the extensions in `etc` directory (Read below to learn more about configuration).

### Extensions included

By default the following extensions are supplied (Inspiration by [Hammerspoon's sample configurations page](https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations)):

- Redshift - Adjust screen brightness and gamma based on sunrise information or manual in three steps (Inspired by [Redshift](https://github.com/jonls/redshift) and [Flux](https://github.com/calvinwyoung/.dotfiles/blob/master/darwin/hammerspoon/flux.lua)).
  - Redshift is able to switch between automatic `Redshift-Mode` and `Flux-Mode` through the menubar items. In `Flux-Mode` you can decrease level using `[CMD][ALT][CTRL][Ö]` and increased using `[CMD][ALT][CTRL][Ä]`.
  - Temporally toggling off of Redshift is provided through `[CMD][ALT][CTRL][-]`
  - Redshift config is located at `etc/redshift.lua`.
- Caffeine - Disable standby time for your screen (Inspired by [Caffeine](https://de.wikipedia.org/wiki/Caffeine)).
  - Caffeine can be toggled through menubar icon (Cup) or through hotkey `[CMD][ALT][CTRL][S]`.
  - Furthermore through `[CMD][ALT][CTRL][L]` you can lock your screen immediately
  - Config located at `etc/caffeine.lua`
- MouseLocator - Hightlights your cursor with a circle (Inspired by [Locator](https://github.com/zzamboni/oh-my-hammerspoon/blob/master/plugins/mouse/locator.lua)).
  - Hightlight is triggered by `[CMD][ALT][CTRL][M]`.
  - Config is located at `etc/mouselocator.lua`.
- Snap - Provides simple window managment with full-screen, half-screen, quarter-screen.
  - Manage focused through one of the following short-keys:
    - full-screen: `[CMD][ALT][CTRL][F]`
    - half-screen-left: `[CMD][ALT][CTRL][D]`
    - half-screen-right: `[CMD][ALT][CTRL][G]`
    - quarter-screen-left-top: `[CMD][ALT][CTRL][E]`
    - quarter-screen-right-top: `[CMD][ALT][CTRL][R]`
    - quarter-screen-left-bottom: `[CMD][ALT][CTRL][C]`
    - quarter-screen-right-bottom: `[CMD][ALT][CTRL][V]`
  - Config can be found at `etc/snap.lua`.
- BrewUpdater - Simple cronjob like task to frequently upgrade installed homebrew packages
  - Manual update through `[CMD][ALT][CTRL][SHIFT][U]`
  - Settings located at `etc/brewupdater.lua`

## General stucture

The framework provides some default files which are needed to get the framework working. These main files are `init.lua`, `kernel.lua`, `etc/bootstrap.lua`, `etc/environment.lua`, `etc/extensions.lua` and `keymap.lua`.

### Init.lua

This file is the main entry point for the hammerspoon configuration. This file I use to load the `Kernel` and boostrap all the needed extensions. So it is not necessary to change this file.

### Kernel.lua

This is the main framework file which is managing and bootstrapping any further extensions. The kernel comes with some other pre-configured helper functions and hot-reloading if some file changes are recognized.

#### Kernel Features

- Hot-realoding of configuration: This function is triggered everytime any file changes in the configuration is detetected and causes a reload of the hammerspoon configuration.
- Kernel own require function called through: `kernel.prequire(...)`, this function will return the loaded file if its exist otherwise the return value is `nil`.
- Hotkey-binding: This function can bind any function to the provided key and global hotkey. There is no need to use this function if you use native-extensions, otherwise you can use `kernel.bindHotkey(key, alt, fn)` (key - string, alt - boolean, fn - function) to manually bootstrap third-party-extensions.
- Shell: Kernel provides basic command execution through default shell defined in environment table.
  - Command-Execution: `kernel.execute(input)`
  - STD/IO (Table): `kernel.shell.stdOut`, `kernel.shell.stdIn`, `kernel.shell.exitCode`
- Helper-functions: This functions should provide some easy-to-use features not natively supplied by lua
  - `kernel.helpers.randomString(length)`: Generates a random string of the given length.
  - `kernel.helpers.getSunrise()`: Get sunrise information based on your location.

### Extensions.lua

This file is used to load extensions. There are provided two tables `extensions.native` and `extensions.thirdparty` add your extensions as string to the table and the kernel will bootstrap them from `lib` directory.

### Bootstrap.lua

This file is used to provide further boostrap function for third-party-extensions.

### Environment.lua

This file is used for environment configuration, feel free to change the environment entries even it is not recommended.

### Keymap.lua

The keymap provided by this file is used by the `Kernel` as global hotkey-configuration

## Extensions Development

1. Create your own extension file `lib/myfirstextension.lua`.
2. Create your configuration file.
2. Add the base information needed to provide a native extension:
  ```
    local mod = {}

    mod.name = "MyFirstExtension" // Is used as lowercase string for `res` context and configuration
    mod.signature = "h5pegyy2HDGwA3nBailU" // Is checked by kernel to identify native extension
    mod.context = {}

    function mod.init(context)
      // Called by kernel to bootrap extension

      // Save the provided context information injected from kernel, this includes config file through mod.context.config and keymap through mod.context.keymap
      // Keymap will automatically loaded by the kernel
      mod.context = context
    end

    return mod
  ```
4. Add a keymap to your configuration file `etc/myfirstextension.lua`.
  ```
    local settings = {}

    // Make sure functions foo and bar are available
    // This will bind [CMD][ALT][CTRL][A] to function 'foo' and [CMD][ALT][CTRL][SHIFT][B] to function 'bar'
    settings.keymap = {
      {key = "a", callback = foo},
      {key = "b", alt = true, callback = bar}
    }

    return settings
  ```
3. Add your new created extension to the `extensions.native` table in `etc/extensions.lua` to load it.
  ```
    ...
    extensions.native = {
      "...",
      "...",
      "myfirstextension",
      "..."
    }
    ...
  ```
