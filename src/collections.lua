local t = require("turtle-utils")
local a = require("actions")

local DIG_MOVE_UP_DOWN = {
    { run = a.dig, args = {direction = t.DIRECTIONS.FORWARD}},
    { run = a.move, args = {direction = t.DIRECTIONS.FORWARD}, required = true},
    { run = a.dig, args = {direction = t.DIRECTIONS.UP}},
    { run = a.dig, args = {direction = t.DIRECTIONS.DOWN}}
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
        {run = a.collection, args = { times = 1, actions = uTurn(t.DIRECTIONS.LEFT, gap)}},
    }
end

return {
    DIG_MOVE_UP_DOWN = DIG_MOVE_UP_DOWN,
    uTurn = uTurn,
    minePattern = minePattern
}
