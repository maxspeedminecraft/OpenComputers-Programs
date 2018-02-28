-- component = require("component")
-- os = require("os")
-- math = require("math")

function import(name) return component.proxy(component.list(name)()) end

local gls = import("glasses")
local batt = import("induction_matrix")

local energy = gls.addTextLabel()
energy.setScale(1)
energy.setPosition(10,100)
energy.setColor(0,1,0)

local netchange = gls.addTextLabel()
netchange.setScale(1)
netchange.setPosition(10,100+10)
netchange.setColor(0,1,1)

local input = gls.addTextLabel()
input.setScale(1)
input.setPosition(10,100+20)
input.setColor(0,0,1)

local output = gls.addTextLabel()
output.setScale(1)
output.setPosition(10,100+30)
output.setColor(1,0,0)


function getBattStats()
    m = batt.getMaxEnergy()
    n = batt.getEnergy()
    i = batt.getInput()
    o = batt.getOutput()
    return m,n,i,o
end

function round(x)
    return math.floor(x)
end

function toScientificNot(x)
    decimals = 4
    digits = round(math.log(x,10) - decimals)
    y = x / math.pow(10,digits)
    y = round(y)
    y = y / 100
    return tostring(y) .. "e" .. tostring(digits+decimals)
end

-- local counter = 0



while true do
    m, n, i, o = getBattStats()
    net = i - o
    if net >= 0 then
        netchange.setColor(0,1,0)
    else
        netchange.setColor(1,0,0)
    end
    percent = n / m * 100
    energy.setText("Energy: (" .. tostring(round(percent)) .. "%) " .. toScientificNot(n))
    netchange.setText("Net: " .. tostring(net))
    input.setText("Input: " .. tostring(i))
    output.setText("Output: " .. tostring(o))
    os.sleep(2)
end

