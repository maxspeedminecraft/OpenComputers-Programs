-- imports

local component = require("component")
local sides = require("sides")
local os = require("os")
local shell = require("shell")
local args = shell.parse(...)
local rs = component.redstone
local tr = component.transposer
local special_labels = require("special_labels")

-- petals
local P = special_labels.petals
local R = special_labels.runes

-- recipes
local recipes = {
    puredaisy = { {P.w, 4} },
    endoflame = { {P.br, 2}, {P.r,1}, {P.lg,1} }
}

-- sides

local tr_sides = {
    dispenser = sides.down,
    interface = sides.north,
    output    = sides.west,
    input     = sides.east
}

local rs_sides = {
    dispenser = sides.west
}

-- item transfer

-- returns: slotNumber, stackSize
function getStack(side,label)
    for i=1,tr.getInventorySize(side) do
        local stack = tr.getStackInSlot(side,i)
        if stack and stack.label == label then
            return i, stack.size
        end
    end
    return false
end

-- returns: slotNumber, stackSize
function getInputStack(side,label)
    i, size = getStack(side,label)
    if i then print("- "..label)
    else print("x "..label) end
    return i, stack.size
end

-- special items

function toPetalLabel(label)
    return "Mystical " .. label .. " Petal"
end

function toRuneLabel(label)
    return "Rune of " .. label
end

function parseLabel(label)
    -- petal
    if string.sub(label,1,2) == "p_" then
        return toPetalLabel(string.sub(label,3))
    -- rune
    elseif string.sub(label,1,2) == "r_" then
        return toRuneLabel(string.sub(label,3))
    -- other
    else
        return label
    end
end

-- water

function pulse(s)
    rs.setOutput(s,15)
    os.sleep(0.2)
    rs.setOutput(s,0)
end

function loadWater()
    -- pick up water
    pulse(rs_sides.dispenser)
    -- water bucket : dispenser -> interface
    tr.transferItem(tr_sides.dispenser,tr_sides.interface,1,1)
end

function unloadWater()
    local slot = false
    while not slot do slot = getStack(tr_sides.interface,"Bucket") end
    tr.transferItem(tr_sides.interface,tr_sides.dispenser,1,slot)
end

function loadInput(slot)
    tr.transferItem(tr_sides.input,tr_sides.interface,1,slot)
end

function unloadOutput()
    os.sleep(0.5)
    -- transfer everything else to output
    local first = false
    while not first do first = tr.transferItem(tr_sides.interface,tr_sides.output) end
    while tr.transferItem(tr_sides.interface,tr_sides.output) do end
end

function beepDone()
    note.trigger(5)
    os.sleep(0.1)
    note.trigger(6)
    os.sleep(0.1)
    note.trigger(8)
end

function copyArray(tbl)
    local t = {}
    for _,v in pairs(tbl) do table.insert(t,v) end
    return t
end

function main()

    -- print recipes
    if args[1] == "recipes" then
        for r,_ in pairs(recipes) do print(r) end
        return
    end

    -- get recipe
    local recipe_orig = recipes[args[1]]
    if recipe_orig then

        print("-----------------------------")

        -- amount
        local amount = tonumber(args[2]) or 1
        
        for i=1,amount do
            local recipe = copyArray(recipe_orig)
            -- add seeds of course
            table.insert(recipe,{"Seeds",1})
            -- check that have all ingredients
            print("Checking for ingredients...")
            local slots = {}
            local inv   = tr.getAllStacks(tr_sides.input).getAll()
            -- missing ingredients
            local missing = {}

            for slot,stack in pairs(inv) do
                local stack_label = stack.label
                local stack_size = stack.size
                -- check if in recipe
                for i, ingredient in pairs(recipe) do
                    local ingredient_label = parseLabel(ingredient[1])
                    local ingredient_count = ingredient[2]
                    if ingredient_label == stack_label then
                        if stack_size >= ingredient_count then
                            print("- found: " .. tostring(ingredient_count) .. "x " .. ingredient_label)
                            for i=1,ingredient_count do table.insert(slots,slot) end
                        else
                            table.insert(missing,{ingredient_label, ingredient_count - stack_size})
                        end
                        table.remove(recipe,i)
                        break
                    end
                end
            end

            print("-----------------------------")

            -- append leftover ingredients to missing
            for i,ingredient in pairs(recipe) do
                table.insert(missing,ingredient)
            end

            -- nothing is missing
            if #missing == 0 then
                print("All ingredients found!")
                print("Crafting...")
                -- load water
                loadWater()
                -- load inputs
                for _,slot in pairs(slots) do loadInput(slot) end
                -- unload Water
                unloadWater()
                print("Done!")
                print("-----------------------------")

            -- there are some ingredients missing
            else
                print("Crafting failed")
                print("You're missing:")
                for _,ingredient in pairs(missing) do
                    local label = parseLabel(ingredient[1])
                    print("  "..tostring(ingredient[2]).."x "..label)
                end
            end
        end
        -- unload all outputs
        -- unloadOutput()
    else
        print("[!] Unrecognized recipe.")
    end
end

-- run
main()
