local t = require("turtle-utils")
local a = require("actions")
local c = require("collections")

local function dig()
    local state = t.createState()
    local collectionArgs = {
        times = 10,
        actions = {
            {run = a.collection, args = { times = 10, actions = c.DIG_MOVE_UP_DOWN }},
            {run = a.collection, args = { times = 1, actions = c.U_TURN_RIGHT_3 }},
            {run = a.collection, args = { times = 10, actions = c.DIG_MOVE_UP_DOWN}},
            {run = a.collection, args = { times = 1, actions = c.U_TURN_LEFT_3 }},
        }
    }

    a.collection(state, collectionArgs)
end

dig()
