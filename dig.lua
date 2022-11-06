-- digs a 2x1 tunnel 
-- auto refuels
-- keeps track of how much fuel total it has in in inv to determine its "point of no return" and then comes back to start point
-- avoids actually digging anything useful? (e.g. diamonds)
-- for now pauses at this point
    -- later works around the deposit and carries on digging the tunnel
SLOTS = {
    FUEL = 1
    TORCH = 2
}

DIRECTIONS = {
    FORWARD = "forward"
    UP = "up"
    DOWN = "down"
}

function tableContains(table, val)
    for i, v in ipairs(table) do
        if  v == val then
            return true
        end
    end
    return false
end

function blockIsResource(blockToCheck)
    local resourceBlocks = {
        "minecraft:diamond_ore",
        "minecraft:redstone_ore",
        "minecraft:gold_ore",
        "minecraft:iron_ore",
        "minecraft:lapis_ore",
        "minecraft:emerald_ore",
        "minecraft:copper_ore"
    }
    return tableContains(resourceBlocks, blockToCheck)
end

function digIfSafe(direction)
    if direction == DIRECTIONS.FORWARD
        local hasBlock, data = turtle.inspect()
        if not blockIsResource(data.name) then
            turtle.dig()
            return true
        end
    elseif direction == DIRECTIONS.UP
        local hasBlock, data = turtle.inspectUp()
        if not blockIsResource(data.name) then
            turtle.digUp()
            return true
        end
    elseif direction == DIRECTIONS.DOWN
        local hasBlock, data = turtle.inspectDown()
        if not blockIsResource(data.name) then
            turtle.digDown()
            return true
        end
    else
        print("invalid direction given")
    end

    return false
end


function refuelIfBelow(fuelLimit)
    if turtle.getFuelLevel() < fuelLimit then
        print("refueling")
        turtle.select(SLOTS.FUEL)
        success = turtle.refuel()
        if not success then
            print("failed to refuel")
            return
        end
    end
end



function dig()
    local count = 0
    while true do
        if count > 10 then
            break
        end

        refuelIfBelow(2)

        local dug = digIfSafe(DIRECTIONS.FORWARD)
        if not dug then
            return
        end

        turtle.forward()

        dug = digIfSafe(DIRECTIONS.UP)
        if not dug then
            return
        end

        dug = digIfSafe(DIRECTIONS.DOWN)
        if not dug then
            return
        end

        count = count + 1
    end
end

function startUp()
    -- check fuel level
    turtle.select(SLOTS.FUEL)
    fuel = turtle.refuel(0)
    if not fuel then
        print("no fuel found in fuel slot: " .. SLOTS.FUEL)
    end

    dig()
end

startUp()
