local button = {}

-- imports

local os = require("os")
local component = require("component")
local event = require("event")
local term = require("term")
local gpu = component.gpu

-- setup

button.buttons = {}
button.running = false

-- functions

function button.makeButton(name,callback,col_f,col_b,x,y)
    function display()
        local border = button.createBorder(name)
        local label = button.createLabel(name)
        gpu.setForeground(col_f)
        gpu.setBackground(col_b)
        gpu.set(x,y,border)
        gpu.set(x,y+1,label)
        gpu.set(x,y+2,border)
    end
    button.buttons[name] = {
        callback = callback,
        box = { {x,y}, {x+#name+1,y+2} },
        display = display
    }
end

function button.createBorder(s)
    local r = "  "
    for _=1,#s do r = r .." " end
    return r
end

function button.createLabel(s)
    return " " .. s .. " "
end

function boxContains(box,pt)
    local a, b = box[1], box[2]
    local hori = a[1] <= pt[1] and pt[1] <= b[1]
    local vert = a[2] <= pt[2] and pt[2] <= b[2]
    return hori and vert
end

function button.getPressedButton(x,y)
    local pressed = nil
    for n,btn in pairs(button.buttons) do
        if boxContains(btn.box,{x,y}) then
            pressed = btn
            break
        end
    end
    return pressed
end

local beep_tone1 = 200
local beep_tone2 = 300
local beep_duration = 0.05

function button.clickNoise()
    component.computer.beep(beep_tone1,beep_duration)
    component.computer.beep(beep_tone2,beep_duration)
end

function button.waitForButtonPress()
    local _,_,x,y = event.pull("touch")
    local btn = button.getPressedButton(x,y)
    if btn then
        btn.callback()
        button.clickNoise()
    end
end

function button.run()
    button.clear()
    button.running = true
    for n,btn in pairs(button.buttons) do btn.display() end
    while button.running do button.waitForButtonPress() end
end

function button.stop()
    button.running = false
    button.clear()
end

function button.clear()
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
    term.clear()
end

-- module end

return button