local tableUtils = require("table-utils")
local turtleUtils = require("turtle-utils")
local logger = require("logger")

local DEBUG_SUMMARY_FUEL_KEY = "fuel"

local function doCollectionAction(state, action, allRequirementsMet)
    local success = action.run(state, action.args)
    if (action.required and not success) or not allRequirementsMet then
        return false
    else
        return true
    end
end

local function debugCollectionAction(state, action)
    assert(action)
    local debugState = state.debug
    local nameOrTable, consumes = action.run(state, action.args, true)
    if type(nameOrTable) ~= "table" then
        if debugState.summary[consumes] then
            debugState.summary[consumes] = debugState.summary[consumes] + 1
        else
            debugState.summary[consumes] = 1
        end

        --switch on name and recored resource use for that. e.g. fuel for move + blocks for placeBlock
        table.insert(debugState.actions, {name = nameOrTable, args = action.args})
    end
end

local function collection(state, args, debug)
    turtleUtils.assertState(state)
    assert(type(args) == "table", "Arguments must be a table")
    assert(args.times, "Must provide the number of times to execute collection")
    assert(tonumber(args.times), "Number of times provided is not a number")
    assert(args.actions, "Must provide actions to execute collection")
    assert(type(args.actions) == "table", "Actions must be a table")
    assert(type(args.actions[1]) == "table", "actions should be a table of action tables")

    local actionCount = tableUtils.tableLength(args.actions)
    local i = 1
    while i <= args.times do
        local allRequirementsMet = true
        for a = 1, actionCount do
            local currentAction = args.actions[a]
            if debug then
                debugCollectionAction(state, currentAction)
            else
                allRequirementsMet = doCollectionAction(state, currentAction, allRequirementsMet)
            end
        end

        if allRequirementsMet then
            i = i + 1
        end
    end
    if debug then
        -- this just distinguishes this action as being special,
        -- all other actions return strings in debug. the fact this is a table
        -- is important
        return {}
    end
end


local function checkCollectionCanBeCompleted(state)
    local result = {success = true, failures = {}}
    for blockName, amountNeeded in pairs(state.debug.summary) do
        if state.inv[blockName] then
            if state.inv[blockName].total < amountNeeded then
                result.success  = false
                table.insert(
                    result.failures,
                    { block  = blockName, available = state.inv[blockName].total, needed =  amountNeeded }
                )
            end
        else
            result.success  = false
                table.insert(
                    result.failures,
                    { block  = blockName, available = 0, needed =  amountNeeded}
                )
        end
    end
    local requiredFuel = state.debug.summary[DEBUG_SUMMARY_FUEL_KEY]
    if requiredFuel then
        local currentFuel = turtle.getFuelLevel()
        if currentFuel < requiredFuel then
            result.success = false
            table.insert(
                    result.failures,
                    { block  = DEBUG_SUMMARY_FUEL_KEY, available = currentFuel, needed =  requiredFuel}
                )
        end
    end
    return result
end

local function safeCollection(state, args)
    collection(state, args, true)
    local result = checkCollectionCanBeCompleted(state)
    if result.success then
        collection(state, args)
    else
        local msg = "not enough resources to compelete task...\n"
        for _, failure in pairs(result.failures) do
            msg = msg .. '{block: '..failure.block..
            ', needed: '..failure.needed..
            ', available: '..failure.available..'}'
        end
        logger.debug(msg)
    end
end



local function dig(_, args, debug)
    if debug then
        return "dig"
    end
    assert(args)
    assert(args.direction, "dig direction is requried")
    return turtleUtils.digIfSafe(args.direction, args.excluded)
end

local function move(state, args, debug)
    if debug then
        return "move", DEBUG_SUMMARY_FUEL_KEY
    end
    assert(args)
    assert(args.direction, "move direction is requried")
    return turtleUtils.move(state, args.direction)
end

local function turn(state, args, debug)
    if debug then
        return "turn"
    end
    assert(args)
    assert(args.direction, "turn direction is requried")
    return turtleUtils.turn(state, args.direction)
end

local function place(state, args, debug)
    if debug then
        return "place", args.block
    end
    assert(args)
    assert(args.direction, "place direction is required")
    assert(args.block, "place block is required")

    return turtleUtils.placeBlock(state, args.direction, args.block)
end

return {
    safeCollection = safeCollection,
    collection = collection,
    dig = dig,
    move = move,
    turn = turn,
    place = place
}
