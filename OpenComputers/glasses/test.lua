math = require("math")

function toScientificNot(x)
    decimals = 4
    digits = math.floor(math.log(x,10) - decimals)
    y = x / math.pow(10,digits)
    y = math.floor(y)
    y = y / 100
    return tostring(y) .. "e" .. tostring(digits+decimals)
end

print(toScientificNot(123456))