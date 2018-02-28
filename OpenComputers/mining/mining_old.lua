----------------
 --- Mining ---
----------------

---- This program takes 3 optional arguments:
---- [1]: Depth to mine (in increments of 3). Default: 1
---- [2]: Breadth to mine. Default: 16
---- [3]: Durability threshold of tool. Default: 0.1 (scales 0-1).

---- The robot will mine a breadth*(3*depth)*breadth volume.
---- When the robot's tool's durability drops below the durability threshold,
----   the robot will stop mining and wait for you to replace it's tool.

---- When the robot is done mining, it will return to its original position.

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

local depth = tonumber(args[1]) or 1
local breadth = tonumber(args[2]) or 16
local durability_threshold = tonumber(args[3]) or 0.1

local position = {0,0,0}
local orientation = 0

-- resources

local moves = {
    f = { robot.forward, 1, 0, 0 },
    b = { robot.back,   -1, 0, 0 },
    u = { robot.up,      0,-1, 0 },
    d = { robot.down,    0, 1, 0 }
}

local turns = {
    r = { robot.turnRight,-1 },
    l = { robot.turnLeft,  1 }
}

-- angles
local th = math.pi/2
local cos = math.cos(th)
local sin = math.sin(th)

-- functions

function vectorPrint(v)
    print(v[1],v[2],v[3])
end

function vectorAdd(v1,v2)
    return { v1[1]+v2[1], v1[2]+v2[2], v1[3]+v2[3] }
end

function vectorScale(s,v)
    return { s*v[1], s*v[2], s*v[3] }
end

function vectorQuarterTurn(v)
    return {
        math.floor(v[1]*cos - v[3]*sin),
        v[2],
        math.floor(v[1]*sin + v[3]*cos)
    }
end

function applyOrientation(dm,ori)
    for i=1,ori do dm = vectorQuarterTurn(dm) end
    return dm
end

function move(d,dist)
    -- get move data
    m = moves[d]
    dist = dist or 1
    for i=1,dist do
        -- move
        m[1]()
        -- update position
        dm = {m[2],m[3],m[4]}
        dp = applyOrientation(dm,orientation)
        position = vectorAdd(position, dp)
    end
end

function turn(d)
    -- get turn data
    t = turns[d]
    -- turn
    t[1]()
    -- update orientation
    dt = t[2]
    orientation = (orientation + dt) % 4
end

function waitForTool()
    dur = robot.durability()
    -- display warning
    if (dur == nil) or (dur < durability_threshold) then
        print("waiting for new pickaxe!")
    end
    -- wait for new pickaxe
    while ((dur == nil) or (dur < durability_threshold)) do
        os.sleep(5)
        dur = robot.durability()
    end
end

function swing(d)
    waitForTool()
    if d == "u" then robot.swingUp() end
    if d == "d" then robot.swingDown() end
    if d == "f" then robot.swing() end
end

function mineForward()
    swing("f")  -- forward
    move("f")   -- move
    swing("u")  -- up
    swing("d")  -- down
end

function turnTo(target)
    n = (target - orientation) % 4
    for i=1,n do turn("l") end
end

function moveTo(target)
    -- reset orientation
    turnTo(0)
    -- vector to move along
    dm = vectorAdd(target,vectorScale(-1,position))
    -- y
    if dm[2] < 0 then diry = "u" else diry = "d" end
    move(diry,math.abs(dm[2]))
    -- -- z
    -- move("b",math.abs(dm[3])+1)
    -- -- x
    -- turn("r")
    -- move("b",math.abs(dm[1])+1)
end

-- main

function main()

    swing("u")
    swing("d")

    -- mine volume
    for i=1,depth do

        -- mine area
        for j=1,breadth do

            -- mine row
            for k=1,(breadth-1) do
                mineForward()
            end

            -- turn
            if j~=breadth then
                if j%2==0 then
                    turn("l")
                    mineForward()
                    turn("l")
                else
                    turn("r")
                    mineForward()
                    turn("r")
                end
            end
        end

        -- next level
        if i~=depth then
            -- go down
            move("d")
            swing("d")
            move("d")
            swing("d")
            move("d")
            swing("d")

            -- turn
            if breadth%2==0 then
                turn("r")
            else
                turn("l")
                turn("l")
            end
        end
    end

    -- return to start
    moveTo({0,0,0})
end

-- run

main()