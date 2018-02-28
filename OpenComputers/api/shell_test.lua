local shell = require("shell")
local args = shell.parse(...)

for k,v in pairs(args) do print(k,v) end