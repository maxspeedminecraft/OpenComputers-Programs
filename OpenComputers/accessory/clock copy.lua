local component = require("component")
local gpu = component.gpu
local sw, sh = gpu.getResolution()

local colors = {}
colors["white"] = 0xFFFFFF
colors["black"] = 0x000000

function fill(c,x,y,w,h)
    gpu.setBackground(colors[c])
    gpu.fill(x,y,w,h," ")
end

function line()

fill("white",1,1,sw,sh)