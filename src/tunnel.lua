local t = require("turtle-utils")
local a = require("actions")

local function tunnel()
    local state = t.createState()
    local collectionArgs = {
        times = 1,
        actions = {run = a.place, args = {direction = t.DIRECTIONS.DOWN, block = "deepslate_brick_slab"}}
    }
    a.collection(state, collectionArgs)
end

tunnel()
