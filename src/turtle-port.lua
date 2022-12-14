local function forward()
    return turtle.forward()
end

local function back()
    return turtle.back()
end

local function up()
    return turtle.up()
end

local function down()
    return turtle.down()
end

local function turnLeft()
    return turtle.turnLeft()
end

local function turnRight()
    return turtle.turnRight()
end

local function select(slot)
    return turtle.select(slot)
end

local function dig()
    return turtle.dig()
end

local function digUp()
    return turtle.digUp()
end

local function digDown()
    return turtle.digDown()
end

local function inspect()
    return turtle.inspect()
end

local function inspectUp()
    return turtle.inspectUp()
end

local function inspectDown()
    return turtle.inspectDown()
end

local function getFuelLevel()
    return turtle.getFuelLevel()
end

local function refuel()
    return turtle.refuel()
end

local function getItemDetail(slot, detailed)
    return turtle.getItemDetail(slot, detailed)
end

local function place(text)
    return turtle.place(text)
end

local function placeUp(text)
    return turtle.placeUp(text)
end

local function placeDown(text)
    return turtle.placeDown(text)
end

return {
    forward = forward,
    back = back,
    up = up,
    down = down,
    turnLeft = turnLeft,
    turnRight = turnRight,
    select = select,
    dig = dig,
    digUp = digUp,
    digDown = digDown,
    inspect = inspect,
    inspectUp = inspectUp,
    inspectDown = inspectDown,
    getFuelLevel = getFuelLevel,
    refuel = refuel,
    getItemDetail = getItemDetail,
    place = place,
    placeUp = placeUp,
    placeDown = placeDown
}
