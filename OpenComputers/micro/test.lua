function import(name) return component.proxy(component.list(name)()) end

local rs = import("induction_matrix")

computer.beep(1000)
computer.beep(1000)