----------------
 --- Tunnel ---
----------------

---- This program takes 2 optional parameter:
---- [1]: Length of tunnel.
---- [2]: Width of tunnel (number of iterations).

-- imports

local os = require("os")
local component = require("component")
local term = require("term")
local robot = require("robot")
local event = require("event")
local math = require("math")
local shell = require("shell")
local args = shell.parse(...)

-- parameters

local tunnel_length = tonumber(args[1]) or 16
local tunnel_width  = tonumber(args[2]) or 1
local tunnel_iter   = 0

-- x is left/right
-- y is for/back
local position = {0,0}

function printPosition() print(position[1],position[2]) end

-- resources

-- functions

function translate(distance)
    if distance < 0 then f = robot.back end
    if distance > 0 then f = robot.forward end
    if f then for i = 1,math.abs(distance) do f() end end
end

function rotate(turns)
    if turns < 0 then f = robot.turnRight end
    if turns > 0 then f = robot.turnLeft end
    if f then for i = 1,math.abs(turns) do f() end end
end

function move(direction,distance)
    local dir, turns
    -- left/right
    if direction == "x" then
        dir = 1
        turns = {-1,1}
    end
    if direction == "y" then
        dir = 2
        turns = {0,0}
    end
    rotate(turns[1])
    translate(distance)
    rotate(turns[2])
    position[dir] = position[dir] + distance
end

function swing(direction)
    local f, turns
    if direction == "f" then f, turns = robot.swing,     { 0, 0} end
    if direction == "l" then f, turns = robot.swing,     {-1, 1} end
    if direction == "r" then f, turns = robot.swing,     { 1,-1} end
    if direction == "u" then f, turns = robot.swingUp,   { 0, 0} end
    if direction == "d" then f, turns = robot.swingDown, { 0, 0} end
    rotate(turns[1]) -- turn
    f()              -- swing
    rotate(turns[2]) -- turn back
end

function mineForward()
    swing("f")  -- forward
    move("y",1) -- move
    swing("u")  -- swing up
    swing("d")  -- swing down
    swing("l")  -- swing left
    swing("r")  -- swing right
end

function depositAll()
    rotate(2)
    for i=1,robot.inventorySize() do
        robot.select(i)
        robot.drop(i)
    end
    rotate(2)
end

-- main

function main()

    for i = 1,tunnel_width do

        -- mine tunnel length
        while position[2] < tunnel_length do
            mineForward()
        end
        -- return home and empty items
        print("exiting y")
        printPosition()
        move("y",-tunnel_length)
        
        print("exiting x")
        printPosition()
        move("x",-tunnel_iter*3)
        print("exitted")
        printPosition()
        depositAll()

        -- go to next mining position
        if i ~= tunnel_width then
            tunnel_iter = tunnel_iter + 1
            move("x",tunnel_iter*3)
        end

    end

end

-- run

main()