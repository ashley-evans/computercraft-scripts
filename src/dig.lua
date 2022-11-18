local t = require("turtle-utils")
local a = require("actions")

local COLLECTION_ACTIONS = {
    DIG_MOVE_UP_DOWN = {
        {
            run = a.dig,
            args = {direction = t.DIRECTIONS.FORWARD}
        },
        {
            run = a.move,
            args = {direction = t.DIRECTIONS.FORWARD},
            required = true
        },
        {
            run = a.dig,
            args = {direction = t.DIRECTIONS.UP}
        },
        {
            run = a.dig,
            args = {direction = t.DIRECTIONS.DOWN}
        }
    }
}

local function makeUTurnCollection(direction, gap)
    return {
        {
            run = a.turn,
            args = { direction = direction }
        },
        {
            run = a.collection,
            args = { times = gap, actions = COLLECTION_ACTIONS.DIG_MOVE_UP_DOWN }
        },
        {
            run = a.turn,
            args = { direction = direction }
        }
    }
end

local function dig()
    local state = t.createState()
    local collectionArgs = {
        times = 10,
        actions = {
            {
                run = a.collection,
                args = {
                    times = 10,
                    actions = COLLECTION_ACTIONS.DIG_MOVE_UP_DOWN
                }
            },
            table.unpack(makeUTurnCollection(t.DIRECTIONS.RIGHT, 3)),
            {
                run = a.collection,
                args = {
                    times = 10,
                    actions = COLLECTION_ACTIONS.DIG_MOVE_UP_DOWN
                }
            },
            table.unpack(makeUTurnCollection(t.DIRECTIONS.LEFT, 3))
        }
    }
    a.collection(state, collectionArgs)
end

dig()
