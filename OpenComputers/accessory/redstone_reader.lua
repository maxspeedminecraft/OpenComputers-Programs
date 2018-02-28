local os = require("os")
local term = require("term")
local component = require("component")
local event = require("event")
local gpu = component.gpu
local rs = component.redstone
local sides = require("sides")

sw, sh = gpu.maxResolution()

local clock_delay = 0.5

local running = true

gpu.setResolution(sw,sh)

local colors = {}
colors["white"] = 0xFFFFFF
colors["black"] = 0x000000
colors["red"]   = 0xFF0000

function fill(c,x,y,w,h)
    gpu.setBackground(colors[c])
    gpu.fill(x,y,w,h," ")
end

function clear()
    fill("black",1,1,sw,sh)
end

while running do

    evt, id, side, prev, new = event.pull(clock_delay,"redstone")

    if not (evt == null) then
        clear()
        h = new * (sh/15)
        fill("red",1,sh-h,sw,h)
    end

end