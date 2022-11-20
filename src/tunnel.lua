local t = require("turtle-utils")
local a = require("actions")
local c = require("collections")
local times = 1

local function tunnel()
    local state = t.createState()
    local collectionArgs = {
        times = times,
        actions = c.fullIceTunnelSection
    }
    a.safeCollection(state, collectionArgs)
end

tunnel()
