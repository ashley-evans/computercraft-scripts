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

local function dig()
    local state = t.createState()
    local collectionArgs = {
        times = 10,
        actions = {
            {run = "a.collection", args = {times = 10, actions = COLLECTION_ACTIONS.DIG_MOVE_UP_DOWN }},
            {run = "a.turn", args = { direction = t.DIRECTIONS.RIGHT }},
            {run = "a.collection", args = { times = 3, actions = COLLECTION_ACTIONS.DIG_MOVE_UP_DOWN }},
            {run = "a.turn", args = { direction = t.DIRECTIONS.RIGHT }},
            {run = "a.collection", args = { times = 10, actions = COLLECTION_ACTIONS.DIG_MOVE_UP_DOWN}},
            {run = "a.turn", args = { direction = t.DIRECTIONS.LEFT }},
            {run = "a.collection", args = { times = 3, actions = COLLECTION_ACTIONS.DIG_MOVE_UP_DOWN }},
            {run = "a.turn", args = { direction = t.DIRECTIONS.LEFT }},
        }
    }
    
    a.collection(state, collectionArgs)
end

dig()
