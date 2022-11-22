local t = require("turtle-utils")
local a = require("actions")
local c = require("collections")

local forward = 8
local right = 4
local height = 2

local function build()
    local state = t.createState()
    local collectionArgs = {
        times = 1,
        actions = c.floorSection(forward, "deepslate_bricks")
    }
    a.safeCollection(state, collectionArgs)
end

build()
