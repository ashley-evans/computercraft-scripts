local function forward()
    return turtle.forward()
end

local function back()
    return turtle.back()
end

return {
    forward = forward,
    back = back
}
