local t = require("turtle-utils")
local a = require("actions")
local c = require("collections")

local function tunnel()
    local state = t.createState()
    local collectionArgs = {
        times = 10,
        actions = c.PACKED_ICE_TUNNEL_SECTION
    }
    a.collection(state, collectionArgs)
end

tunnel()
