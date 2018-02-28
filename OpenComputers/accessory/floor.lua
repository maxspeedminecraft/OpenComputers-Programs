-- import

local math = require("math")
local component = require("component")
local gpu = component.gpu
local term = require("term")
local os = require("os")
local event = require("event")

-- setup

gpu.setResolution(12,6)

local running = true

-- functions

function fill(color)
    gpu.setBackground(color)
    term.clear()
end

function square(x,y,color)
    gpu.setBackground(color)
    gpu.set(x,y,"  ")
end

-- loop

function loop()
   _,_,x,y,_,_ = event.pull("walk")
   fill(0x000000)
   square(x*2-1,y,0x00FF00)
end

-- run

while running do loop() end