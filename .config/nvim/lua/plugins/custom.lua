local go = require("plugins.lang.go")
local python = require("plugins.lang.python")

local plugins = {}

table.move(go, 1, #go, 1, plugins)
table.move(python, 1, #python, #plugins + 1, plugins)
return plugins
