function require(name) return component.proxy(component.list(name)()) end

local drone = require("drone")

while true do
    
    name, addr, x, y, src = computer.pullSignal()
    if name == "hit" then
        drone.move(0,1,0)
    end

end