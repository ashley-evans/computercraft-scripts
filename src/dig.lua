local t = require("turtle-utils") local a = require("actions") local c = require("collections")
local length = 10
--local gap = 2
--local halfWidth = 5
local function dig()
    local state = t.createState()
    local collectionArgs = {
        times = length,
        actions = c.DIG_MOVE_UP_DOWN
    }
    a.safeCollection(state, collectionArgs)
end
dig()
