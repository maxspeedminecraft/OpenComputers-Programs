local math = require("math")

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

if false
    then print("hello")
    else print("not hellow")
end