local tableUtils = require("table-utils")
local turtleUtils = require("turtle-utils")

local function doCollectionAction(state, action, allRequirementsMet)
    local success = action.run(state, action.args)
    if (action.required and not success) or not allRequirementsMet then
        return false
    else
        return true
    end
end

local function debugCollectionAction(state, action, debugState)
    assert(action)
    local nameOrTable = action.run(state, action.args, true)
    if type(nameOrTable) == "table" then
        table.insert(debugState, nameOrTable)
    else
        table.insert(debugState, {name = nameOrTable , args = action.args})
    end
end

local function collection(state, args, debug, debugState)
    turtleUtils.assertState(state)
    assert(type(args) == "table", "Arguments must be a table")
    assert(args.times, "Must provide the number of times to execute collection")
    assert(tonumber(args.times), "Number of times provided is not a number")
    assert(args.actions, "Must provide actions to execute collection")
    assert(type(args.actions) == "table", "Actions must be a table")
    assert(type(args.actions[1]) == "table", "actions should be a table of action tables")

    if debugState == nil then
        debugState = {}
    end

    local actionCount = tableUtils.tableLength(args.actions)
    local i = 1
    while i <= args.times do
        local allRequirementsMet = true
        for a = 1, actionCount do
            local currentAction = args.actions[a]
            if debug then
                debugCollectionAction(state, currentAction, debugState)
            else
                allRequirementsMet = doCollectionAction(state, currentAction, allRequirementsMet)
            end
        end

        if allRequirementsMet then
            i = i + 1
        end
    end
    if debug then
        return debugState
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
        return "move"
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
        return "place"
    end
    assert(args)
    assert(args.direction, "place direction is required")
    assert(args.block, "place block is required")

    return turtleUtils.placeBlock(state, args.direction, args.block)
end

return {
    collection = collection,
    dig = dig,
    move = move,
    turn = turn,
    place = place
}
