local component = require("component")
local gpu = component.gpu

local shell = require("shell")
local args = shell.parse(...)

local w,h = gpu.maxResolution()
if #args == 2 then w,h = tonumber(args[1]), tonumber(args[2]) end

print(w,h)
gpu.setResolution(w,h)