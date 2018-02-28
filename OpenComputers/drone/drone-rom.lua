------------------------------------------------------
-- Imports
------------------------------------------------------

function require(name) return component.proxy(component.list(name)()) end

local drone = require("drone")
local modem = require("modem")
local nav = require("navigation")

------------------------------------------------------
-- Globals
------------------------------------------------------

local port = 100
modem.open(port)

local server = nil
local connected = false

------------------------------------------------------
-- Functions
------------------------------------------------------

--
-- Beeps
--
function beepOn()
    computer.beep(330)
    computer.beep(400)
    computer.beep(530)
end

function beepConnect()
    computer.beep(400)
    computer.beep(400)
end

function beepOff()
    computer.beep(530)
    computer.beep(400)
    computer.beep(330)
end

--
-- Communicate with Server
--
function sendMessage(title,res1,res2,res3,res4,res5)
    modem.send(server,port,title,res1,res2,res3,res4,res5)
end

--
-- Reply about the execution of a command
-- 
function commandReply(obj,cmd,succ,res1,res2,res3,res4,res5)
    modem.send(server,port,obj,cmd,succ,res1,res2,res3,res4,res5)
end

--
-- Establish connection with main server
--
function connectToServer()
    while not connected do
        drone.setStatusText("srching...") -- set status
        drone.setLightColor(0xFFFF00)       -- set light
        -- get signal
        local evt,_,sender,port,dist,name = computer.pullSignal()
        if evt == "modem_message" then
            if name == drone.name() then
                -- connect
                server = sender                   -- set server
                connected = true                  -- set connected
                drone.setStatusText("cnncted!")   -- set status
                beepConnect()                     -- beep
                drone.move(0,1,0)                 -- float up a bit
                drone.setLightColor(0x00FF00)     -- set light to green
                sendMessage("connect",true)                 -- reply to server
            end
        end
    end
end

--
-- Handle commands from server
--
function handleSignal()
    -- inputs from server
    local evt,_,sender,port,dist,obj,cmd,arg1,arg2,arg3,arg4,arg5 = computer.pullSignal()
    if evt == "modem_message" and sender == server then

        -- object to call command of
        if         obj == "computer" then o = computer
            elseif obj == "drone"    then o = drone
            elseif obj == "modem"    then o = modem
            elseif obj == "nav"      then o = nav
        end

        local succ,res1,res2,res3,res4,res5

        -- execute recognized command
        if o and o[cmd] then
            -- for computer.shutdown, need to reply before executing!
            if cmd == "shutdown" then
                succ = true
                commandReply(obj,cmd,succ,res1,res2,res3,res4,res5)
                o[cmd](arg1,arg2,arg3,arg4,arg5)
            -- normal command
            else
                res1,res2,res3,res4,res5 = o[cmd](arg1,arg2,arg3,arg4,arg5)
                succ = true
            end
        -- unrecognized command
        else
            succ = false
        end

        -- reply to server about execution, with command as title
        commandReply(obj,cmd,succ,res1,res2,res3,res4,res5)
    end
end

------------------------------------------------------
-- Main
------------------------------------------------------

function main()
    if connected
        then handleSignal()
        else connectToServer()
    end
end

------------------------------------------------------
-- Run
------------------------------------------------------

beepOn()
while true do main() end
