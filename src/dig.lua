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
            args = {direction = t.DIRECTIONS.FORWARD}
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
    a.collection(state, { times = 10, actions = COLLECTION_ACTIONS.DIG_MOVE_UP_DOWN })
end

dig()
