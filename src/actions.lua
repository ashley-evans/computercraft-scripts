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
--             actionType: "digForward"
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

local function doAction(action)
    action.run(action.args)
end

local function collection(args)
    assert(type(args) == "table", "Arguments must be a table")
    assert(args.times, "Must provide the number of times to execute collection")
    assert(tonumber(args.times), "Number of times provided is not a number")
end

return {
    doAction = doAction,
    collection = collection
}
