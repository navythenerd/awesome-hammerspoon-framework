local config = {}

--Environment variables
config.env = {
    base = os.getenv("HOME") .. "/.hammerspoon/",
    libraries = "lib/",
    config = "etc/",
    modules = "mod/",
    resources = "res/",
}

--Global hotkeys
config.keymap = {
    hyper = {"cmd", "alt", "ctrl"},
    hyper_shift = {"shift", "cmd", "alt", "ctrl"},
}

--Hotkeys for internal framework functions
config.hotkeys = {
    reload = {hyper = "hyper", key = "1"},
}

--Framework libraries
config.libraries = {
    { "std", {"system", "random", "location"} },
}

--Auto-Bootstrap modules
config.loadModules = {
    "caffeine",
    "battery",
    "mouselocator",
    "snap",
}

return config