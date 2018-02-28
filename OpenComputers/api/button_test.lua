local button = require("button")

function f()
    print("hello world!")
    button.stop()
end

local black, white, red, green, blue = 0x000000, 0xFFFFFF, 0xFF0000, 0x00FF00, 0x0000FF

-- shell input

local shell = require("shell")
local args = shell.parse(...)
local x,y = tonumber(args[1]),tonumber(args[2])

print(x,y)

button.makeButton("stop",f,black,white,x,y)

button.run()