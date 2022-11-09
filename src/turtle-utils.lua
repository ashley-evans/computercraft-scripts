tableUtils = require("table-utils")

local SLOTS = {
    FUEL = 1,
    TORCH = 2
}

local DIRECTIONS = {
    FORWARD = "forward",
    UP = "up",
    DOWN = "down",
    BACK = "back",
    LEFT = "left",
    RIGHT = "right"
}

local ORE_BLOCKS = {
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

local function digIfSafe(direction, excludedBlocks)
    if direction == DIRECTIONS.FORWARD then
        local hasBlock, data = turtle.inspect()
        if not tableUtils.tableContains(excludedBlocks, data.name) then
            turtle.dig()
            return true
        end
    elseif direction == DIRECTIONS.UP then
        local hasBlock, data = turtle.inspectUp()
        if not tableUtils.tableContains(excludedBlocks, data.name) then
            turtle.digUp()
            return true
        end
    elseif direction == DIRECTIONS.DOWN then
        local hasBlock, data = turtle.inspectDown()
        if not tableUtils.tableContains(excludedBlocks, data.name) then
            turtle.digDown()
            return true
        end
    else
        print("invalid direction given")
    end

    return false
end

local function refuelIfBelow(fuelLimit)
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

local function move(currentPosition, directionToMove)
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

local function compareDirections(directionA, directionB)
    return directionA.x == directionB.x and directionA.y == directionB.y
end

local function turn(currentPosition, directionToTurn)
    local dir = currentPosition.directionFaced
    directions = {
        north = {
            x = 1,
            y = 0
        },
        west = {
            x = 0,
            y = -1
        },
        south = {
            x = -1,
            y = 0
        },
        east = {
            x = 0, 
            y = 1
        }

    }
    if directionToTurn == DIRECTIONS.LEFT then
        result = turtle.turnLeft()
        if not result == true then
            print(result)
            return false
        elseif compareDirections(dir, directions.north) then
            currentPosition.directionFaced = directions.west
        elseif compareDirections(dir, directions.west) then
            currentPosition.directionFaced = directions.south
        elseif compareDirections(dir, directions.south) then
            currentPosition.directionFaced = directions.east
        elseif compareDirections(dir, directions.east) then
            currentPosition.directionFaced = directions.north
        end
    elseif directionToTurn == DIRECTIONS.RIGHT then
        result = turtle.turnRight()
        if not result == true then
            print(result)
            return false
        elseif compareDirections(dir, directions.north) then
            currentPosition.directionFaced = directions.east
        elseif compareDirections(dir, directions.west) then
            currentPosition.directionFaced = directions.north
        elseif compareDirections(dir, directions.south) then
            currentPosition.directionFaced = directions.west
        elseif compareDirections(dir, directions.east) then
            currentPosition.directionFaced = directions.south
        end
    else
        print("unexpected direction for turning: " .. directionToTurn)
    end

end
local function createPosition()
    -- Positive X: Forward
    -- Positive Y: Right
    -- directionFaced: x [-1, 0, 1] y [-1, 0, 1] 
    -- x:1 would mean facing in the starting direction, 
    -- x:-1 would be facing away from the starting direction
    -- y:1 would be facing right
    -- y:-1 would be facing left
    -- if x is not 0 then y MUST be 0
    -- if y is not 0 then x MUST be 0
    return {
        x = 0,
        y = 0,
        directionFaced = {
            x = 1,
            y = 0
        }
    }
end

return {
    SLOTS = SLOTS,
    DIRECTIONS = DIRECTIONS,
    ORE_BLOCKS = ORE_BLOCKS,
    digIfSafe = digIfSafe,
    refuelIfBelow = refuelIfBelow,
    move = move,
    turn = turn,
    createPosition = createPosition
}
