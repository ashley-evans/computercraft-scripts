local t = require("turtle-utils")
local a = require("actions")

local DIG_MOVE_UP_DOWN = {
    { run = a.dig, args = {direction = t.DIRECTIONS.FORWARD}},
    { run = a.move, args = {direction = t.DIRECTIONS.FORWARD}, required = true},
    { run = a.dig, args = {direction = t.DIRECTIONS.UP}},
    { run = a.dig, args = {direction = t.DIRECTIONS.DOWN}}
}

local U_TURN_RIGHT_3 =  {
    {run = "a.turn", args = { direction = t.DIRECTIONS.RIGHT }},
    {run = "a.collection", args = { times = 3, actions = DIG_MOVE_UP_DOWN }},
    {run = "a.turn", args = { direction = t.DIRECTIONS.RIGHT }}
}

local U_TURN_LEFT_3 =  {
    {run = "a.turn", args = { direction = t.DIRECTIONS.LEFT }},
    {run = "a.collection", args = { times = 3, actions = DIG_MOVE_UP_DOWN }},
    {run = "a.turn", args = { direction = t.DIRECTIONS.LEFT }}
}

return {
    DIG_MOVE_UP_DOWN = DIG_MOVE_UP_DOWN,
    U_TURN_RIGHT_3 = U_TURN_RIGHT_3,
    U_TURN_LEFT_3 = U_TURN_LEFT_3
}
