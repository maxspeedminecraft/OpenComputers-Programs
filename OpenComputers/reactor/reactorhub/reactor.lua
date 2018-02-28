--------------------------------------------------
-- Module: Reactor
--------------------------------------------------
local Reactor = {}

--------------------------------------------------
-- Imports
--------------------------------------------------

local component = require("component")
local os = require("os")
local math = require("math")

--------------------------------------------------
-- Globals
--------------------------------------------------

-- {name, parse function, units}
local data_formatting = {}

--------------------------------------------------
-- Initialization
--------------------------------------------------

function init()
    data_formatting = {
        {"getActive","Active",nil,""},

        {"getEnergyProducedLastTick","Generation Rate",scinot,"RF/t"},
        {"getFuelConsumedLastTick","Fuel Consumption Rate",round,"mB"},
        {"getFuelPercentage","Fuel Percentage",round,"%"},
        {"getFuelAmount","Fuel Amount",scinot,"mB"},
        {"getWastePercentage","Waste Percentage",round,"%"},
        {"getWasteAmount","Waste Amount",scinot,"mB"},

        {"getAverageControlRodLevel","Control Rod Level",nil,"%"},
        {"getNumberOfControlRods","Control Rod Count",nil,""},
        {"getFuelTemperature","Fuel Temperature",round,"C"},
        {"getFuelReactivity","Fuel Reactivity",round,"%"},
    }   
end

--------------------------------------------------
-- Class: Reactor
--------------------------------------------------

--
-- Constructor
--
function Reactor:new(address)
    local o = {}
    setmetatable(o, self)
    
    self.__index = self
    self.br = component.proxy(address)
    if self.br then
        --
        -- special functions
        --
        self.br.getAverageControlRodLevel = function()
            local average_control = 0
            local rods = self.br.getNumberOfControlRods()
            for i=0,rods-1 do
                average_control = average_control + self.br.getControlRodLevel(i)
            end
            return math.floor(average_control/rods) -- average level
        end

        self.br.getFuelPercentage = function()
            local fuel = self.br.getFuelAmount()
            local fuel_max = self.br.getFuelAmountMax()
            return fuel/fuel_max*100
        end

        self.br.getWastePercentage = function()
            local waste = self.br.getWasteAmount()
            local waste_max = self.br.getFuelAmountMax()
            return waste/waste_max*100
        end

        return o
    end
end

--
-- Automatically optimize reactor
--
function Reactor:update()

end

--
-- Gets relevant info for main display
--
function Reactor:getInfo()
    local info = {}
    for i, tbl in pairs(data_formatting) do
        local cmd = self.br[tbl[1]]
        local title = tbl[2]
        local parser = tbl[3] or identity
        local value = tostring(parser( cmd() ))
        table.insert(info,{ title, value .. " " .. tbl[4] })
    end
    return info
end

--------------------------------------------------
-- Utlities
--------------------------------------------------

function identity(x) return x end

function round(x,decimals)
    decimals = decimals or 3
    power = math.pow(10,decimals)
    hang = (x % 1)
    newhang = math.floor(hang * power)/power
    return x - hang + newhang
end

function scinot(x,decimals)
    decimals = decimals or 1
    digits = math.ceil(math.log(x,10))
    power = math.pow(10,digits-3)
    x = round(x/power, decimals-3)
    return tostring(x) .. "e" .. tostring(digits-3)
end

--------------------------------------------------
--------------------------------------------------
init()
return Reactor