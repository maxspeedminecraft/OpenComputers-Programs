local component = require("component")
local event = require("event")
local math = require("math")
local term = require("term")
local sides = require("sides")

local br = component.br_reactor
local rs = component.redstone

local control_inc = 1
local last_energy_percent = 0

local gpu = component.gpu
gpu.setBackground(0x000000)
term.setCursorBlink(false)

function main()

    i = 1
    function gpuPrint(s)
        gpu.set(1,i,s)
        i = i + 1
    end

    term.clear()

    -- automation
    energy_percent = br.getEnergyStored() / br.getEnergyCapacity()
    br.setActive(energy_percent < 0.8)
    if br.getActive() then
        control = br.getControlRodLevel(0)
        if energy_percent > last_energy_percent then control = control + control_inc end
        if energy_percent < last_energy_percent then control = control - control_inc end
        for i=0,br.getNumberOfControlRods()-1 do br.setControlRodLevel(i,control) end
        last_energy_percent = energy_percent
    end

    -- active
    x = br.getActive()
    if x then gpu.setForeground(0xFFFFFF)
    else gpu.setForeground(0x999999) end
    gpuPrint("Active:      " .. tostring(x))

    -- energy produced
    gpu.setForeground(0x00FF00)
    x = math.floor(br.getEnergyProducedLastTick())
    gpuPrint("Generation:  " .. tostring(x) .. " RF/T")

    -- fuel amount
    gpu.setForeground(0xFF0000)
    x = math.floor(br.getFuelAmount()/br.getFuelAmountMax()*100)
    gpuPrint("Fuel Amount: " .. tostring(x) .. " %")

    -- control rods
    gpu.setForeground(0x00FFFF)
    x = br.getControlRodLevel(0)
    gpuPrint("Control:     " .. tostring(x) .. " %")
    
    -- fuel consumed
    gpu.setForeground(0xFF0000)
    x = math.floor(br.getFuelConsumedLastTick()*1000)/1000
    gpuPrint("Consumption: " .. tostring(x) .. " mB/T")

    -- reactivity
    gpu.setForeground(0xFFFF00)
    x = math.floor(br.getFuelReactivity())
    gpuPrint("Reactivity:  " .. tostring(x) .. " %")

    -- fuel temp
    gpu.setForeground(0xFF00FF)
    x = math.floor(br.getFuelTemperature())
    gpuPrint("Fuel Temp:   " .. tostring(x) .. " K")

    i = i-1
    gpu.setResolution(4*i,i)

end

event.timer(0.5,main,math.huge)