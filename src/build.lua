local t = require("turtle-utils")
local a = require("actions")
local c = require("collections")

local block = "deepslate_bricks"
local length = 64

local function build()
    local state = t.createState()
    local collectionArgs = {
        times = 1,
        actions = c.floorSection(length, block)
    }
    a.safeCollection(state, collectionArgs)
end

build()
