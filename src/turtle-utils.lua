local t = require("turtle-port")
local tableUtils = require("table-utils")
local logger = require("logger")

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
local function assertTurnDirection(d)
    assert(d == DIRECTIONS.LEFT or d == DIRECTIONS.RIGHT)
end

local function assertMoveDirection(m)
    assert(m == DIRECTIONS.BACK or m == DIRECTIONS.FORWARD or m == DIRECTIONS.DOWN or m == DIRECTIONS.UP)
end


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

local function createState()
    return {
        position = {
            x = 0,
            y = 0,
            directionFaced = {
                x = 1,
                y = 0
            },
            moveHistory = {{x=0, y=0}} -- array of x y coordinates, e.g. {{x:0,y:0}, {x:1, y:0}}
        }
    }
end

local function assertState(s)
    assert(s.position)
    assert(s.position.x)
    assert(s.position.y)
    assert(s.position.directionFaced)
    assert(s.position.directionFaced.x)
    assert(s.position.directionFaced.y)
    assert(s.position.moveHistory)

    assert(type(s.position.x) == "number")
    assert(type(s.position.y) == "number")
    assert(type(s.position.directionFaced.x) == "number")
    assert(type(s.position.directionFaced.y) == "number")
    assert(type(s.position.moveHistory) == "table")
end

-- returns true if a dig action was performed
local function digIfSafe(direction, excludedBlocks)
    if direction == DIRECTIONS.FORWARD then
        local _, data = t.inspect()
        if not tableUtils.tableContains(excludedBlocks, data.name) then
            t.dig()
            return true
        end
    elseif direction == DIRECTIONS.UP then
        local _, data = t.inspectUp()
        if not tableUtils.tableContains(excludedBlocks, data.name) then
            t.digUp()
            return true
        end
    elseif direction == DIRECTIONS.DOWN then
        local _, data = t.inspectDown()
        if not tableUtils.tableContains(excludedBlocks, data.name) then
            t.digDown()
            return true
        end
    else
        print("invalid direction given")
    end

    return false
end

-- returns true if refueled or if refueling wansn't necessary
local function refuelIfBelow(fuelLimit)
    if t.getFuelLevel() < fuelLimit then
        print("refueling")
        t.select(SLOTS.FUEL)
        local success = t.refuel()
        if not success then
            print("failed to refuel")
        end
        return success
    end
    return true
end

local function move(state, directionToMove)
    assertState(state)
    assertMoveDirection(directionToMove)
    local currentDirection = state.position.directionFaced
    local moved = false
    if directionToMove == DIRECTIONS.FORWARD then
        moved = t.forward()
        if moved then
            state.position.x = state.position.x + currentDirection.x
            state.position.y = state.position.y + currentDirection.y
            table.insert(state.position.moveHistory, {x = state.position.x, y = state.position.y})
        end
    elseif directionToMove == DIRECTIONS.BACK then
        moved = t.back()
        if moved then
            state.position.x = state.position.x - currentDirection.x
            state.position.y = state.position.y - currentDirection.y
            table.insert(state.position.moveHistory, {x = state.position.x, y = state.position.y})
        end
    else
        print("unexpected direction for movement: " .. directionToMove)
    end
    return moved
end

local function compareDirections(directionA, directionB)
    return directionA.x == directionB.x and directionA.y == directionB.y
end

local function turn(state, directionToTurn)
    assertState(state)
    assertTurnDirection(directionToTurn)
    local currentPosition = state.position
    local dir = currentPosition.directionFaced
    local directions = {
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
        local result = t.turnLeft()
        if result ~= true then
            logger.debug(result)
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
        local result = t.turnRight()
        if result ~= true then
            logger.debug(result)
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

return {
    SLOTS = SLOTS,
    DIRECTIONS = DIRECTIONS,
    ORE_BLOCKS = ORE_BLOCKS,
    digIfSafe = digIfSafe,
    refuelIfBelow = refuelIfBelow,
    move = move,
    turn = turn,
    createState = createState
}
