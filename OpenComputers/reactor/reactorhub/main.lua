--------------------------------------------------
-- Imports
--------------------------------------------------

local component = require("component")
local gpu = component.gpu
local screen = component.screen
local term = require("term")
local os = require("os")
local reactor = require("reactor")
local paint = require("paint")
local event = require("event")

--------------------------------------------------
-- Globals
--------------------------------------------------

local interval = 0.5
local reactors = {}
local longest_title = 21

-- colors
local border = 0x444444
local fuel = 0x00FF00
local waste = 0x0000FF

--------------------------------------------------
-- Functions
--------------------------------------------------

--
-- Initialize program
--

function init()
    -- screen setup
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
    term.setCursorBlink(false)
    gpu.setResolution(60,20)

    -- connect all reactors
    for addr,_ in pairs(component.list("br_reactor")) do
        connectReactor(addr)
    end
end

-- Steps:
-- - display info about reactors
-- - automate reactors

function update()

end

--
-- Relevant info:
    -- power in storage
    -- total RF/t generation
    -- ...
--
function display()
    paint.clear()
    for _,r in pairs(reactors) do
        ---
        -- info
        ---
        local i = 1
        local info = r:getInfo()
        for _,tbl in pairs(info) do
            paint.write(tbl[1],1,i)
            paint.write(" : " .. tbl[2],longest_title+1,i)
            i = i + 1
        end

        ---
        -- graphics
        ---
        w,h = gpu.getResolution()
        paint.fill(w-3,1,w,h,border)
        -- fuel
        local fuel_percent = r.br.getFuelPercentage()
        local ticks = math.floor((h-1)* fuel_percent/100)
        paint.fill(w-2,h-ticks,2,ticks,fuel)
        -- waste
        local waste_percent = r.br.getWastePercentage()
        -- ticks = math.floor((h-1) * waste_percent/100)
        ticks = math.floor((h-1) * waste_percent/10)
        paint.fill(w-1,h-ticks,1,ticks,waste)
    end
end

function connectReactor(addr)
    local r = reactor:new(addr)
    if r
        then table.insert(reactors,r)
        else print("Connection failed. Invalid address")
    end
end

--------------------------------------------------
-- Main
--------------------------------------------------

function main()
    update()
    display()
end

--------------------------------------------------
-- Run
--------------------------------------------------

init()
-- main()
while true do
    main()
    os.sleep(interval)
end