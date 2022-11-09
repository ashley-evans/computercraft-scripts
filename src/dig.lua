local t = require("turtle-utils")

local function genericActionSuccess()
    return true
end

local function genericActionFailure()
    return true
end

local function digForwardAction(args)
    return t.digIfSafe(t.DIRECTIONS.FORWARD, args[1])
end

local function digUpAndDownAction(args)
    local upSuccess = t.digIfSafe(t.DIRECTIONS.UP, args[1])
    local downSuccess = t.digIfSafe(t.DIRECTIONS.DOWN, args[1])
    return upSuccess and downSuccess
end

local ACTIONS = {
    digForward = {
        args = {t.ORE_BLOCKS},
        action = digForwardAction,
        success = genericActionSuccess,
        failure = genericActionFailure
    },
    digUpAndDown = {
        args = {t.ORE_BLOCKS},
        action = digUpAndDownAction,
        success = genericActionSuccess,
        failure = genericActionFailure
    },
    noOp = {
        args = {},
        action = genericActionSuccess,
        success = genericActionSuccess,
        failure = genericActionSuccess
    }    
}

local function moveLine(distance, currentPosition, before, after)
    for i = 1, distance do
        t.refuelIfBelow(2)

        local success = before.action(before.args)
        if success then
            before.success()
        else
            local recovered = before.failure()
            if not recovered then
                return
            end
        end

        local moved = t.move(currentPosition, t.DIRECTIONS.FORWARD)
        if not moved then
            i = i - 1
        end

        success = after.action(after.args)
        if success then
            after.success()
        else
            local recovered = after.failure()
            if not recovered then
                return
            end
        end
    end
end

local function uTurn(direction, currentPosition, distance)    
    t.turn(currentPosition, direction)
    moveLine(distance, currentPosition, ACTIONS.digForward, ACTIONS.digUpAndDown)
    t.turn(currentPosition, direction)
end

function startUp()
    local position = t.createPosition()
    for i = 1, 20 do
        moveLine(64, position, ACTIONS.digForward, ACTIONS.digUpAndDown)
        uTurn(t.DIRECTIONS.RIGHT, position, 1)
        moveLine(64, position, ACTIONS.digForward, ACTIONS.digUpAndDown)
        uTurn(t.DIRECTIONS.LEFT, position, 1)
    end
end

startUp()
