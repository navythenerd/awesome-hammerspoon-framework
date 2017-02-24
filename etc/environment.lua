local env = {}

env.base = os.getenv("HOME") .. "/.hammerspoon/"
env.libraries = "lib/"
env.config = "etc/"
env.modules = "mod/"
env.resources = "res/"

return env
