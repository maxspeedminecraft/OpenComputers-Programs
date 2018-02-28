local component = require("component")
local os = require("os")
local event = require("event")
local sides = require("sides")

local endos_count = 9
local input_buffer = 0.2

-- clock

local clock_interval = 5

-- mana detector

local side_mana = sides.left

-- foods

local side_food1 = sides.down
local side_food2 = sides.back

local i = true

function pulseFood()
    -- choose food
    if i then s = side_food1 else s = side_food2 end
    -- drop food
    component.redstone.setOutput(s,15)
    os.sleep(0.05)
    component.redstone.setOutput(s,0)
    -- switch food
    i = not i
end

-- control

local side_control = sides.front

function sleepBuffer()
    os.sleep(input_buffer)
end

-- main

local running = true

local STATE_IDLE = 0
local STATE_PRIMED = 1

local state = STATE_IDLE

while running do

    evt, id, side, prev, new = event.pull(clock_interval,"redstone")

    if evt == null then

        if state == STATE_IDLE then
            state = 1
            sleepBuffer()
            print("clock ticked once.")
        elseif state == STATE_PRIMED then
            pulseEndos()
            state = STATE_IDLE
            print("clock ticked twice!!")
            print("pulsed food.")
        end


    elseif side == side_mana then

        if state == STATE_IDLE then
            -- nothing
        elseif state == STATE_PRIMED then
            state = STATE_IDLE
            print("got mana, resetting clock.")
        end

    elseif side == side_control then

        running = false

    end

end