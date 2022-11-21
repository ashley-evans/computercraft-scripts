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
        {run = a.collection, args = { times = 1, actions = uTurn(t.DIRECTIONS.LEFT, gap)}}
    }
end

local function digPlace(direction, blockToPlace)
    return {
        {run = a.dig, args = {direction = direction, excluded = {}}},
        {run = a.place, args = {direction = direction, block = blockToPlace}},
    }
end

local function dig(direction)
    return {
        {run = a.dig, args = {direction = direction, excluded = {}}},
    }
end
local function digMove(direction)
    return {
        {run = a.dig, args = {direction = direction, excluded = {}}},
        {run = a.move, args = {direction = direction}, required = true}
    }
end

local function move(direction)
    return {
        {run = a.move, args = {direction = direction}, required = true}
    }
end
local function turn(direction)
    return {
        {run = a.turn, args = {direction = direction}},
    }
end

local function wallSection(height, block)
    return {
        {run = a.collection, args = {times = height, actions = {
            {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.UP)}},
            {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, block)}},
        }}},
        {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
        {run = a.collection, args = {times = height, actions = digMove(t.DIRECTIONS.DOWN)}},
    }
end

local function floorSection(length, block)
    return{
        {run = a.collection, args = {times = length -1, actions = {
            {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, block)}},
            {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
        }}},
        {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, block)}},
    }
end

local function floor(forwardLength, rightLength, block)
    local repeatCount = math.floor(rightLength/2)
    return {
        {run = a.collection, args = {times = repeatCount - 1, actions = {
            {run = a.collection, args = {times = 1, actions = floorSection(forwardLength, block)}},
            {run = a.collection, args = {times = 1, actions = uTurn(t.DIRECTIONS.RIGHT, 0)}},
            {run = a.collection, args = {times = 1, actions = floorSection(forwardLength, block)}},
            {run = a.collection, args = {times = 1, actions = uTurn(t.DIRECTIONS.LEFT, 0)}},
        }}},
        {run = a.collection, args = {times = 1, actions = floorSection(forwardLength, block)}},
        {run = a.collection, args = {times = 1, actions = uTurn(t.DIRECTIONS.RIGHT, 0)}},
        {run = a.collection, args = {times = 1, actions = floorSection(forwardLength, block)}},
    }
end
local function wall(length, height, block)
    return {
        {run = a.collection, args = {times = length, actions = wallSection(height, block)}}
    }
end

local function box(forwardLength, rightLength, height, block)
    return {
        {run = a.collection, args = {times = 1, actions = floor(forwardLength, rightLength, block)}},
        {run = a.collection, args = {times = 1, actions = turn(t.DIRECTIONS.RIGHT)}},
        {run = a.collection, args = {times = 1, actions = wall(rightLength-1, height, block)}},
        {run = a.collection, args = {times = 1, actions = turn(t.DIRECTIONS.RIGHT)}},
        {run = a.collection, args = {times = 1, actions = wall(forwardLength-1, height, block)}},
        {run = a.collection, args = {times = 1, actions = turn(t.DIRECTIONS.RIGHT)}},
        {run = a.collection, args = {times = 1, actions = wall(rightLength-1, height, block)}},
        {run = a.collection, args = {times = 1, actions = turn(t.DIRECTIONS.RIGHT)}},
        {run = a.collection, args = {times = 1, actions = wall(forwardLength-1, height, block)}},
    }
end

local fullIceTunnelSection = {
    -- base layer
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.DOWN)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, "deepslate_bricks")}},
    {run = a.collection, args = {times = 1, actions = turn(t.DIRECTIONS.LEFT)}},
    {run = a.collection, args = {times = 1, actions = dig(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 2, actions = turn(t.DIRECTIONS.LEFT)}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, "deepslate_bricks")}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, "deepslate_bricks")}},
    {run = a.collection, args = {times = 1, actions = dig(t.DIRECTIONS.FORWARD)}},

    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.UP)}},
    -- floor
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.FORWARD, "deepslate_bricks")}},
    {run = a.collection, args = {times = 2, actions = turn(t.DIRECTIONS.LEFT)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, "deepslate_brick_slab")}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, "packed_ice")}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, "deepslate_brick_slab")}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.FORWARD, "deepslate_bricks")}},

    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.UP)}},
    -- mid
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.FORWARD, "deepslate_bricks")}},
    {run = a.collection, args = {times = 2, actions = turn(t.DIRECTIONS.LEFT)}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, "stone_button")}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.FORWARD, "deepslate_bricks")}},

    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.UP)}},
    -- top
    {run = a.collection, args = {times = 1, actions = dig(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 2, actions = turn(t.DIRECTIONS.LEFT)}},
    {run = a.collection, args = {times = 2, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 1, actions = dig(t.DIRECTIONS.FORWARD)}},

    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.UP)}},
    -- ceiling
    {run = a.collection, args = {times = 2, actions = turn(t.DIRECTIONS.LEFT)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, "deepslate_brick_slab")}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, "deepslate_brick_slab")}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.DOWN, "deepslate_brick_slab")}},
    -- return
    {run = a.collection, args = {times = 2, actions = move(t.DIRECTIONS.BACK)}},
    {run = a.collection, args = {times = 1, actions = turn(t.DIRECTIONS.LEFT)}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.FORWARD)}},
    {run = a.collection, args = {times = 2, actions = digMove(t.DIRECTIONS.DOWN)}},
    {run = a.collection, args = {times = 1, actions = move(t.DIRECTIONS.BACK)}},
    {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.DOWN)}},
    -- torches every so often
    {run = a.doOnIteration, args = {index = 8, collectionArgs = {
        times = 1, actions = {
            {run = a.collection, args = {times = 1, actions = digMove(t.DIRECTIONS.UP)}},
            {run = a.collection, args = {times = 1, actions = turn(t.DIRECTIONS.RIGHT)}},
            {run = a.collection, args = {times = 1, actions = move(t.DIRECTIONS.FORWARD)}},
            {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.FORWARD, "torch")}},
            {run = a.collection, args = {times = 1, actions = move(t.DIRECTIONS.BACK)}},
            {run = a.collection, args = {times = 1, actions = move(t.DIRECTIONS.DOWN)}},
            {run = a.collection, args = {times = 1, actions = digPlace(t.DIRECTIONS.UP, "torch")}},
            {run = a.collection, args = {times = 1, actions = turn(t.DIRECTIONS.LEFT)}},

        }
    }}},
    {run = a.incrementIteration, args = {}},
}

return {
    box = box,
    floor = floor,
    wall = wall,
    DIG_MOVE_UP_DOWN = DIG_MOVE_UP_DOWN,
    fullIceTunnelSection = fullIceTunnelSection,
    uTurn = uTurn,
    minePattern = minePattern,
}
