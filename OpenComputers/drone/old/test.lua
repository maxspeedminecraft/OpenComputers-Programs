function require(name) return component.proxy(component.list(name)()) end

local drone = require("drone")

while true do
    
    name, addr, x, y, src = computer.pullSignal()
    drone.setStatusText(tostring(name))

end