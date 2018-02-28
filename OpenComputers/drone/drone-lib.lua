------------------------------------------------------
-- Module DroneLib
------------------------------------------------------
local DroneLib = {}

------------------------------------------------------
-- Imports
------------------------------------------------------

local component = require("component")
local event = require("event")
local modem = component.modem

------------------------------------------------------
-- Globals
------------------------------------------------------

local port = 100
modem.open(port)

------------------------------------------------------
-- Class: Drone
------------------------------------------------------

local Drone = {}

function Drone:new(name,address)
    local o = {}
    setmetatable(o, self)
    
    self.__index = self
    self.name = name
    self.address = address

    return o
end

--
-- Get reply from drone after it attempts to execute command 
--
function Drone:getCommandReply(_obj,_cmd)
    while true do
        local evt,_,sender,port,dist,obj,cmd,succ,res1,res2,res3,res4,res5 = event.pull("modem_message")
        if sender == self.address and obj == _obj and cmd == _cmd then
            return succ,res1,res2,res3,res4,res5
        end
    end
end

--
-- Send a command to drone
--
function Drone:command(obj,cmd,arg1,arg2,arg3,arg4,arg5)
    -- send command
    modem.send(self.address,port,obj,cmd,arg1,arg2,arg3,arg4,arg5)
    -- return reply
    return self:getCommandReply(obj,cmd)
end

--
-- Get distance between server and drone
--
function Drone:getDistance()
    modem.send(self.address,port,"getDistance")
    while true do
        local evt,_,sender,port,dist,cmd = event.pull("modem_message")
        if sender == self.address and cmd == "getDistance" then
            return dist
        end
    end
end

--------------------------------------------------
-- Functions
--------------------------------------------------

--
-- Connect to a drone by name
-- return Drone instance
--
function DroneLib.connect(name)
    modem.broadcast(port, name)
    print("connecting to "..name.."...")
    local evt,_,sender,port,dist,succ = event.pull(5,"modem_message")
    if succ then
        print("connected!")
        return Drone:new(name, sender)
    else
        print("connection failed :(")
        return nil
    end
end

return DroneLib