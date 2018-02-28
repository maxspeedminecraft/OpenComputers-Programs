-- imports

local math = require("math")
local component = require("component")
local gpu = component.gpu
local term = require("term")
local os = require("os")
local event = require("event")
local sides = require("sides")

-- settings

local elevator_delay = 2

-- redstone io's

local rios = {
    floor1 = component.proxy(component.get("10d")),
    floor2 = component.proxy(component.get("de3")),
    wall = component.proxy(component.get("bcf"))
}

local rios_sides = {
    floor1 = sides.west,
    floor2 = sides.west,
    wall = sides.up
}

function setOutput(target,v)
    if v then rsval = 15 else rsval = 0 end
    rios[target].setOutput(rios_sides[target],rsval)
end

-- functions

-- true:  displaying armor
-- false: hiding armor
local active = true

function toggleActive()
    active = not active
    if active then
        updateWall()
        os.sleep(elevator_delay)
        updateElevator()
    else
        updateElevator()
        os.sleep(elevator_delay)
        updateWall()
    end
end

function updateWall()
    setOutput("wall",not active)
end

function updateElevator()
    setOutput("floor1",active)
    setOutput("floor2",not active)
end

-- main

local running = true

gpu.setResolution(14,8)

local icon_inactive = {
    "____    ____",
    "|  |____|  |",
    "|        # |",
    "|          |",
    "|    #     |",
    "|__________|"
}

local icon_active = {
    "     /\\",
    "    /  \\",
    "   /    \\",
    "  /      \\",
    " /        \\",
    "/__________\\"
}


while running do

    term.clear()
    x = 2
    y = 2
    if active then icon = icon_active else icon = icon_inactive end
    for i=1,#icon do
        line = icon[i]
        gpu.set(x,y,line)
        y = y + 1
    end

    _ = event.pull("touch")
    toggleActive()

end