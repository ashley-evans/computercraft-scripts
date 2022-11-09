local t = require("helpers/turtle-utils")

local function genericActionSuccess()
    return true
end

local function genericActionFailure()
    return true
end

local function digForwardAction(args)
    return t.digIfSafe(t.DIRECTIONS.FORWARD, args[0])
end

local function digUpAndDownAction(args)
    local upSuccess = t.digIfSafe(t.DIRECTIONS.UP, args[0])
    local downSuccess = t.digIfSafe(t.DIRECTIONS.DOWN, args[0])
    return upSuccess and downSuccess
end

local digBefore = {
    args = {t.ORE_BLOCKS},
    action = digForwardAction,
    success = genericActionSuccess,
    failure = genericActionFailure
}

local digAfter = {
    args = {t.ORE_BLOCKS},
    action = digUpAndDownAction,
    success = genericActionSuccess,
    failure = genericActionFailure
}

local function moveLine(distance, before, after) 
    position = t.createPosition()
    for i = 0, distance do
        t.refuelIfBelow(2)

        success = before.action(before.args)
        if success then
            before.success()
        else
            recovered = before.failure()
            if not recovered then
                return
            end
        end

        moved = t.move(position, t.DIRECTIONS.FORWARD)
        if not moved then
            i = i - 1
        end

        success = after.action()
        if success then
            after.success()
        else
            recovered = after.failure()
            if not recovered then
                return
            end
        end
    end
end

function uTurn(direction, before, after)
end


function startUp()
    moveLine(100, digBefore, digAfter)
end

startUp()
