-- imports

local os = require("os")
local component = require("component")
local event = require("event")
local gpu = component.gpu

-- functions

gpu.setBackground(0x00FF00)

local beep_tone1 = 200
local beep_tone2 = 300
local beep_duration = 0.05

function clickNoise()
    component.computer.beep(beep_tone1,beep_duration)
    component.computer.beep(beep_tone2,beep_duration)
end

function waitForScreenPress()
    local _,_,x,y = event.pull("touch")
    gpu.set(x,y," ")
    clickNoise()
end

while true do waitForScreenPress() end