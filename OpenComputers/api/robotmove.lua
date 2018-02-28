-- imports

local os = require("os")
local component = require("component")
local term = require("term")
local robot = require("robot")
local even = require("event")
local shell = require("shell")
local args = shell.parse(...)

-- functions

function move(d,dist)

    if d == "l" or d == "r" or d == "b" or d == "f" then
        if d == "l" then robot.turnLeft() end
        if d == "r" then robot.turnRight() end
        if d == "b" then robot.turnAround() end

        for i=1,dist do robot.forward() end
    end
    
    if d == "u" then
        for i=1,dist do robot.up() end
    end
    if d == "d" then
        for i=1,dist do robot.down() end
    end

end

function main()

    direction = args[1] or "f"
    distance = tonumber(args[2]) or 1
    move(direction, distance)

end

main()