local tableUtils = require("table-utils")
local turtleUtils = require("turtle-utils")
-- {
--     run: collection,
--     args: {
--         times: 10
--         actions: {
--             run: "refuelifBelow",
--             args: {2, 0}
--             required: true
--         },
--         {
--             run: "dig"
--             args:{direcion = DIRECTIONS.forward, excluded={}}
--         },
--         {
--             actionType: "moveForward",
--             required: true
--         },
--         {
--             actionType: "collection"
--         }
--     }
-- }


-- { run: turtle-utils.move, args: { } }


-- path to start (Record where we were)
-- deposit to chest
-- path to ???????? (Pick up where we were)

-- path to storage (store current location in temp)
-- path to temp (store current location in temp)

local function collection(state, args)
    turtleUtils.assertState(state)
    assert(type(args) == "table", "Arguments must be a table")
    assert(args.times, "Must provide the number of times to execute collection")
    assert(tonumber(args.times), "Number of times provided is not a number")
    assert(args.actions, "Must provide actions to execute collection")
    assert(type(args.actions) == "table", "Actions must be a table")

    local actionCount = tableUtils.tableLength(args.actions)
    local i = 1
    while i <= args.times do
        local allRequirementsMet = true
        for a = 1, actionCount do
            local currentAction = args.actions[a]
            local success = currentAction.run(state, currentAction.args)
            if currentAction.required and not success then
                allRequirementsMet = false
            end
        end

        if allRequirementsMet then
            i = i + 1
        end
    end
end

local function dig(_, args)
    assert(args)
    assert(args.direction, "dig direction is requried")
    return turtleUtils.digIfSafe(args.direction, args.excluded)
end

local function move(state, args)
    assert(args)
    assert(args.direction, "move direction is requried")
    return turtleUtils.move(state, args.direction)
end

local function turn(state, args)
    assert(args)
    assert(args.direction, "turn direction is requried")
    return turtleUtils.turn(state, args.direction)
end

return {
    collection = collection,
    dig = dig,
    move = move,
    turn = turn
}
