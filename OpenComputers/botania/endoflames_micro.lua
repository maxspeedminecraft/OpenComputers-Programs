-- parameters

local delay = 8
local flowers = 9

-- utilities

function import(name) return component.proxy(component.list(name)()) end

local sides = {
    top   = 1,
    bot   = 0,
    front = 3,
    back  = 2,
    left  = 4,
    right = 5
}

local function sleep(timeout)
  local deadline = computer.uptime() + (timeout or 0)
  repeat
    computer.pullSignal(deadline - computer.uptime())
  until computer.uptime() >= deadline
end

-- imports

local rs = import("redstone")

local side_input = sides.bot
local side_output = sides.top

-- functions

function getRS(side)
    return rs.getInput(side)
end

function setRS(side,value)
    rs.setOutput(side,value)
end

function dropFuel()
    for i=1,flowers do
        setRS(side_output,15)
        sleep(0.1)
        setRS(side_output,0)
        sleep(0.1)
    end
end

-- main

function main()
    setRS(sides.left,0)
    evt = computer.pullSignal(delay)
    if evt == nil then
        setRS(sides.left,15)
        dropFuel()
    end
    setRS(sides.left,15)
    -- computer.beep()
end

-- run

while true do main() end