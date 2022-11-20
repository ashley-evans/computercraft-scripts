local t = require("turtle-utils")
local a = require("actions")
local c = require("collections")

local function dig()
    local state = t.createState()
    local collectionArgs = {
        times = 10,
        actions = c.minePattern(10, 2)
    }
    a.safeCollection(state, collectionArgs)
end

dig()
