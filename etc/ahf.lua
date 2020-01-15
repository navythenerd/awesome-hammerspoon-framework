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
    cmd = {"cmd"},
    ctrl = {"ctrl"},
    alt = {"alt"},
    cmd_ctrl = {"cmd", "ctrl"},
    ctrl_alt = {"ctrl", "alt"},
    cmd_ctrl_shift = {"cmd", "ctrl", "shift"},
    cmd_alt_shift = {"cmd", "alt", "shift"},
    hyper = {"cmd", "alt", "ctrl"},
    hyper_shift = {"shift", "cmd", "alt", "ctrl"},
}

--Hotkeys for internal framework functions
config.hotkeys = {
    reload = {hyper = "hyper_shift", key = "1"},
}

--Framework libraries
config.libraries = {
    { "std", {"system", "random", "location"} },
}

--Auto-Bootstrap modules
config.loadModules = {
    "caffeine",
    "battery",
    "snap",
}

return config
