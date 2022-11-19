local t = require("turtle-utils")
local a = require("actions")

local DIG_MOVE_UP_DOWN = {
    { run = a.dig, args = {direction = t.DIRECTIONS.FORWARD}},
    { run = a.move, args = {direction = t.DIRECTIONS.FORWARD}, required = true},
    { run = a.dig, args = {direction = t.DIRECTIONS.UP}},
    { run = a.dig, args = {direction = t.DIRECTIONS.DOWN}}
}

local DIG_U_MOVE_D = {
    { run = a.dig, args = {direction = t.DIRECTIONS.UP}},
    { run = a.move, args = {direction = t.DIRECTIONS.DOWN}, required = true},
}

local DIG_U_MOVE_F = {
    { run = a.dig, args = {direction = t.DIRECTIONS.UP}},
    { run = a.move, args = {direction = t.DIRECTIONS.FORWARD}, required = true},
}

local MOVE_U = {
    {run = a.move, args = {direction = t.DIRECTIONS.UP}, required = true},
}


local function uTurn(direction, gap)
    return {
        {run = a.turn, args = { direction = direction }},
        {run = a.collection, args = { times = gap + 1, actions = DIG_MOVE_UP_DOWN }},
        {run = a.turn, args = { direction = direction }}
    }
end

local function minePattern(dimension, gap)
    return {
        {run = a.collection, args = { times = dimension, actions = DIG_MOVE_UP_DOWN}},
        {run = a.collection, args = { times = 1, actions = uTurn(t.DIRECTIONS.RIGHT, gap)}},
        {run = a.collection, args = { times = dimension, actions = DIG_MOVE_UP_DOWN}},
        {run = a.collection, args = { times = 1, actions = uTurn(t.DIRECTIONS.LEFT, gap)}}
    }
end

local PACKED_ICE_TUNNEL_SECTION = {
    {run = a.collection, args = {times = 1, actions = DIG_MOVE_UP_DOWN}},
    {run = a.place, args = {direction = t.DIRECTIONS.DOWN, block = "deepslate_brick_slab"}},
    {run = a.turn, args = {direction = t.DIRECTIONS.RIGHT}},
    {run = a.collection, args = {times = 1, actions = DIG_MOVE_UP_DOWN}},
    {run = a.place, args = {direction = t.DIRECTIONS.DOWN, block = "packed_ice"}},
    {run = a.collection, args = {times = 1, actions = DIG_MOVE_UP_DOWN}},
    {run = a.place, args = {direction = t.DIRECTIONS.DOWN, block = "deepslate_brick_slab"}},
    {run = a.collection, args = {times = 1, actions = MOVE_U}},
    {run = a.turn, args = {direction = t.DIRECTIONS.LEFT}},
    {run = a.turn, args = {direction = t.DIRECTIONS.LEFT}},
    {run = a.collection, args = {times = 2, actions = DIG_U_MOVE_F}},
    {run = a.collection, args = {times = 1, actions = DIG_U_MOVE_D}},
    {run = a.turn, args = {direction = t.DIRECTIONS.RIGHT}}
}

return {
    DIG_MOVE_UP_DOWN = DIG_MOVE_UP_DOWN,
    PACKED_ICE_TUNNEL_SECTION = PACKED_ICE_TUNNEL_SECTION,
    uTurn = uTurn,
    minePattern = minePattern,
}
