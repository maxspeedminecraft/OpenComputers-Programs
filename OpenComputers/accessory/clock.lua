---------------
 --- Clock ---
---------------

-- imports

local os = require("os")
local component = require("component")
local event = require("event")
local gpu = component.gpu

-- parameters

local sw, sh = 9, 3
local color = 0x00FF00

-- setup

local clock_delay = 1
local running = true

component.gpu.setResolution(sw,sh)

gpu.setBackground(0x000000)
gpu.setForeground(color)

-- main

function main()
    -- display date
    date = os.date("%I:%M %p")
    gpu.set(1,2,date)
  
    -- touch cancels program
    local evt, id, side, prev, new = event.pull(clock_delay,"touch")
    if evt then running = false end
end

-- loop

while running do main() end