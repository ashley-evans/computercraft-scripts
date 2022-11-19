local t = require("turtle-utils")
local a = require("actions")
local c = require("collections")

local function tunnel()
    local state = t.createState()
    local collectionArgs = {
        times = 1,
        actions = c.makeTunnel(10)
    }
    a.collection(state, collectionArgs)
end

tunnel()
