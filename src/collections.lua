local t = require("turtle-utils")
local a = require("actions")

local DIG_MOVE_UP_DOWN = {
    { run = a.dig, args = {direction = t.DIRECTIONS.FORWARD}},
    { run = a.move, args = {direction = t.DIRECTIONS.FORWARD}, required = true},
    { run = a.dig, args = {direction = t.DIRECTIONS.UP}},
    { run = a.dig, args = {direction = t.DIRECTIONS.DOWN}}
}

local U_TURN_RIGHT_2 =  {
    {run = a.turn, args = { direction = t.DIRECTIONS.RIGHT }},
    {run = a.collection, args = { times = 3, actions = DIG_MOVE_UP_DOWN }},
    {run = a.turn, args = { direction = t.DIRECTIONS.RIGHT }}
}

local U_TURN_LEFT_2 =  {
    {run = a.turn, args = { direction = t.DIRECTIONS.LEFT }},
    {run = a.collection, args = { times = 3, actions = DIG_MOVE_UP_DOWN }},
    {run = a.turn, args = { direction = t.DIRECTIONS.LEFT }}
}

local U_TURN_RIGHT_0 =  {
    {run = a.turn, args = { direction = t.DIRECTIONS.RIGHT }},
    {run = a.collection, args = { times = 1, actions = DIG_MOVE_UP_DOWN }},
    {run = a.turn, args = { direction = t.DIRECTIONS.RIGHT }}
}

local U_TURN_LEFT_0 =  {
    {run = a.turn, args = { direction = t.DIRECTIONS.LEFT }},
    {run = a.collection, args = { times = 1, actions = DIG_MOVE_UP_DOWN }},
    {run = a.turn, args = { direction = t.DIRECTIONS.LEFT }}
}

local function UTurn(direction, gap)
    t.assertIsDirection(direction)
    assert(type(gap) == "number")
    return {
        {run = a.turn, args = { direction = direction }},
        {run = a.collection, args = { times = gap + 1, actions = DIG_MOVE_UP_DOWN }},
        {run = a.turn, args = { direction = direction }}
    }
end

return {
    DIG_MOVE_UP_DOWN = DIG_MOVE_UP_DOWN,
    U_TURN_RIGHT_2 = U_TURN_RIGHT_2,
    U_TURN_LEFT_2 = U_TURN_LEFT_2,
    U_TURN_RIGHT_0 = U_TURN_RIGHT_0,
    U_TURN_LEFT_0 = U_TURN_LEFT_0,
    UTurn = UTurn
}
