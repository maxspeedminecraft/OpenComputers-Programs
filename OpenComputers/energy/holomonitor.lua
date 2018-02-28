local component = require("component")
local os = require("os")
local holo = component.hologram
local cell = component.energy_device

holo.clear()

-- resources

local color = 2

local col_size = 10

local col_width = 48
local col_half_width = 24
local col_height = 32

local x_start = col_half_width - col_size/2
local x_finish = col_half_width + col_size/2

local nrg_max = cell.getMaxEnergyStored()

-- functions

function getEnergy()
    return cell.getEnergyStored()
end

function setEnergyDisplay()
    h = getEnergy() / nrg_max * col_height
    for x = x_start,x_finish do for z = x_start,x_finish do
        holo.fill(x,z,h,col_height,0) -- empty
        holo.set(x,col_height,z,3)    -- fill bar
        holo.fill(x,z,h,2)            -- energy level
    end end
end

-- main

function main()
    while true do
        setEnergyDisplay()
        os.sleep(0.1)
    end
end

-- run

main()