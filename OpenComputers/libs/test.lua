local shell = require("shell")
local args = shell.parse(...)
local lib = require("l")

lib.connect(args[1])