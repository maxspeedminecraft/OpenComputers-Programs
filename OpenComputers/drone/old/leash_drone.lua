function require(name) return component.proxy(component.list(name)()) end

local drone = require("drone")
local modem = require("modem")
local nav = require("navigation")

modem.open(1)

while true do

    local evt,_,sender,port,dist,cmd,x,y,z = computer.pullSignal()
    local x, y, z = tonumber(x),tonumber(y),tonumber(z)
    if evt == "modem_message" then
        drone.setStatusText(cmd)
        if cmd == "move" then
            drone.move(x,y,z)
        end
        if cmd == "summon" then
            local px,py,pz = nav.getPosition()
            py = py - 2
            local dx = x - px
            local dy = y - py
            local dz = z - pz
            drone.move(dx,dy,dz)
        end
    end

end