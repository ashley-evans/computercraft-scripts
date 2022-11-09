local tableUtils = require("helpers/table-utils")
-- digs a 2x1 tunnel 
-- auto refuels
-- keeps track of how much fuel total it has in in inv to determine its "point of no return" and then comes back to start point
-- avoids actually digging anything useful? (e.g. diamonds)
-- for now pauses at this point
    -- later works around the deposit and carries on digging the tunnel
SLOTS = {
    FUEL = 1,
    TORCH = 2
}

DIRECTIONS = {
    FORWARD = "forward",
    UP = "up",
    DOWN = "down",
    BACK = "back"
}


function blockIsResource(blockToCheck)
    local resourceBlocks = {
        "minecraft:diamond_ore",
        "minecraft:redstone_ore",
        "minecraft:gold_ore",
        "minecraft:iron_ore",
        "minecraft:lapis_ore",
        "minecraft:emerald_ore",
        "minecraft:copper_ore",
        "minecraft:deepslate_diamond_ore",
        "minecraft:deepslate_redstone_ore",
        "minecraft:deepslate_gold_ore",
        "minecraft:deepslate_iron_ore",
        "minecraft:deepslate_lapis_ore",
        "minecraft:deepslate_emerald_ore",
        "minecraft:deepslate_copper_ore",
        "minecraft:nether_gold_ore",
        "minecraft:ancientDebris"
    }
    return tableUtils.tableContains(resourceBlocks, blockToCheck)
end

function digIfSafe(direction)
    if direction == DIRECTIONS.FORWARD then
        local hasBlock, data = turtle.inspect()
        if not blockIsResource(data.name) then
            turtle.dig()
            return true
        end
    elseif direction == DIRECTIONS.UP then
        local hasBlock, data = turtle.inspectUp()
        if not blockIsResource(data.name) then
            turtle.digUp()
            return true
        end
    elseif direction == DIRECTIONS.DOWN then
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


function move(currentPosition, directionToMove)
    currentDirection = currentPosition.directionFaced
    moved = false
    if directionToMove == DIRECTIONS.FORWARD then
        moved = turtle.forward()
        if moved then
            currentPosition.x = currentPosition.x + currentDirection.x
            currentPosition.y = currentPosition.y + currentDirection.y
        end
    elseif directionToMove == DIRECTIONS.BACK then
        moved = turtle.back()
        if moved then
            currentPosition.x = currentPosition.x - currentDirection.x
            currentPosition.y = currentPosition.y - currentDirection.y
        end
    else
        print("unexpected direction for movement: " .. directionToMove)
    end
    return moved
end



function dig(torchesAvailable)
    if torchesAvailable == 0 then
        print("invalid block provided in torch slot: " .. SLOTS.TORCH .. " not using torches")
    end
    -- Positive X: Forward
    -- Positive Y: Right
    -- directionFaced: x [-1, 0, 1] y [-1, 0, 1] 
    -- x:1 would mean facing in the starting direction, 
    -- x:-1 would be facing away from the starting direction
    -- y:1 would be facing right
    -- y:-1 would be facing left
    -- if x is not 0 then y MUST be 0
    -- if y is not 0 then x MUST be 0
    local position = {
        x = 0,
        y = 0,
        directionFaced = {
            x = 1,
            y = 0
        }
    }
    local count = 0
    while true do
        if count > 100 then
            break
        end

        refuelIfBelow(2)

        local dug = digIfSafe(DIRECTIONS.FORWARD)
        if not dug then
            return
        end

        moved = move(position, DIRECTIONS.FORWARD)
        if moved then
            count = count + 1
        end

        dug = digIfSafe(DIRECTIONS.UP)
        if not dug then
            return
        end

        -- attempt to place torch every 7th block
        if torchesAvailable > 1 and count % 7 == 0 then
            turtle.select(SLOTS.TORCH)
            placed = turtle.placeDown()
            if placed then
                torchesAvailable = torchesAvailable - 1
            end
        end
        

        dug = digIfSafe(DIRECTIONS.DOWN)
        if not dug then
            return
        end
    end
end

function startUp()
    -- check fuel level
    turtle.select(SLOTS.FUEL)
    fuel = turtle.refuel(0)
    if not fuel then
        print("no fuel found in fuel slot: " .. SLOTS.FUEL)
    end
    -- check torches availability
    detail = turtle.getItemDetail(SLOTS.TORCH)
    torchesAvailable = 0
    if detail and detail.name == "minecraft:torch" then
        torchesAvailable = detail.count
    end
    
    dig(torchesAvailable)
end

startUp()
