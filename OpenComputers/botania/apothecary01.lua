local component = require("component")
local sides = require("sides")
local os = require("os")
local shell = require("shell")
local args = shell.parse(...)
local rs = component.redstone
local tr = component.transposer
local note = component.note_block

side = {
    dispenser = sides.north,
    interface = sides.up,
    output = sides.east,
    input = sides.west
}

function pulse(s)
    rs.setOutput(s,15)
    os.sleep(0.5)
    rs.setOutput(s,0)
end

function fillWater()
    -- pick up water
    pulse(sides.north)
    -- water bucket : dispenser -> interface
    tr.transferItem(side.dispenser,side.interface,1,1,1)
    -- sleep
    os.sleep(0.5)
    -- empty bucket : interface -> dispenser
    tr.transferItem(side.interface,side.dispenser,1,1,1)    
    os.sleep(0.1)
end

local input_slots = {
    white       =1,
    orange      =2,
    magenta     =3,
    lightblue   =4,
    yellow      =5,
    lime        =6,
    pink        =7,
    grey        =8,
    lightgrey   =9,
    cyan        =10,
    purple      =11,
    blue        =12,
    brown       =13,
    green       =14,
    red         =15,
    black       =16,
    seeds       =17
}

local recipes = {
    puredaisy = {"white","white","white","white"},
    exoflame   = {"brown","brown","red","lightgrey"}
}

function loadInput(name)
    tr.transferItem(side.input,side.interface,1,input_slots[name])
end

function unloadOutput()
    local succ = false
    while not succ do
        succ = tr.transferItem(side.interface,side.output)
    end
    os.sleep(0.2)
end

function craft(name)
    local recipe = recipes[name]
    if recipe then
        fillWater()
        for _,input in pairs(recipe) do loadInput(input) end
        loadInput("seeds")
        unloadOutput()
        return true
    else
        return false
    end
end

function beepDone()
    note.trigger(5)
    os.sleep(0.2)
    note.trigger(6)
    os.sleep(0.2)
    note.trigger(8)
end

function main()
    if args[1] == "recipes" then
        for r,_ in pairs(recipes) do
            print(r)
        end
        return
    end

    local succ
    
    local count = args[2] or 1
    for i=1,count do
        succ = craft(args[1])
    end

    if succ
        then
            beepDone()
            print("success!")
        else
            print("failed, invalid recipe name!")
    end

end

-- run
main()