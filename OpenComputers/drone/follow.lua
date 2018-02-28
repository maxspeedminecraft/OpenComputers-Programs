--------------------------------------------------
-- Imports
--------------------------------------------------

local component = require("component")
local dronelib = require("drone-lib")
local shell = require("shell")
local args = shell.parse(...)
local os = require("os")
local nav = component.navigation

--------------------------------------------------
-- Globals
--------------------------------------------------

local drone

local radius = 4

--------------------------------------------------
-- Main
--------------------------------------------------

function main()
    if not args[1] then
        print("please provide target drone's name")
        return
    end
    drone = dronelib.connect(args[1])
    if not drone then return end

    while true do
        local dist = drone:getDistance()
        if dist > radius then
            local x,y,z = nav.getPosition()
            local _, dx, dy, dz = drone:command("nav","getPosition")
            local mx, my, mz = x-dx, y-dy+2, z-dz
            drone:command("drone","move",mx,my,mz)
        end
        os.sleep(tonumber(args[2]) or 1)
    end
end

--------------------------------------------------
-- Run
--------------------------------------------------

main()