
local actions = require("actions")
local turtle = require("turtle-port")
local utils = require("turtle-utils")
local collections = require("collections")

describe("complex action", function()
    stub(turtle, "getFuelLevel").returns(3000)
    stub(turtle, "forward").returns(true)
    stub(turtle, "up").returns(true)
    stub(turtle, "down").returns(true)
    stub(turtle, "turnLeft").returns(true)
    stub(turtle, "turnRight").returns(true)
    stub(turtle, "dig").returns(true)
    stub(turtle, "digUp").returns(true)
    stub(turtle, "digDown").returns(true)
    stub(turtle, "placeDown").returns(true)
    stub(turtle, "inspect").returns(true, {name = "someblock"})
    stub(turtle, "inspectDown").returns(true, {name = "someblock"})
    stub(turtle, "inspectUp").returns(true, {name = "someblock"})
    stub(turtle, "getItemDetail").returns(false)
    stub(turtle, "select").returns(true)

    it("floor consumes 'length' x 'width' resources", function()
        local state = utils.createState()
        local length = 8
        local width = 20
        local spareBlock = 1
        local totalBlocks = (length * width) + spareBlock

        state.inv["deepslate_bricks"] = { slots = { [1] = totalBlocks}, total = totalBlocks}
        local args = {times = 1, actions = collections.floor(length, width, "deepslate_bricks") }

        actions.collection(state, args, false)
        assert.equal(spareBlock, state.inv["deepslate_bricks"].slots[1])
        assert.equal(spareBlock, state.inv["deepslate_bricks"].total)
    end)

    it("floor rounds width down to nearest even number", function()
        local state = utils.createState()
        local length = 8
        local width = 9 -- this should produce 8 rows of flooring
        local totalBlocks = (length * width)
        state.inv["deepslate_bricks"] = { slots = { [1] = totalBlocks}, total = totalBlocks}
        local args = {times = 1, actions = collections.floor(length, width, "deepslate_bricks") }

        actions.collection(state, args, false)
        assert.equal(7, state.position.y)
    end)

    it("floor leaves you on same x cordinate as when it started", function()
        local state = utils.createState()
        local length = 3
        local width = 2
        local totalBlocks = (length * width)
        state.inv["deepslate_bricks"] = { slots = { [1] = totalBlocks}, total = totalBlocks}
        local args = {times = 1, actions = collections.floor(length, width, "deepslate_bricks") }

        actions.collection(state, args, false)
        assert.equal(0, state.position.x)
    end)

    it("floor leaves you facing the oposide direction than when it started", function()
        local state = utils.createState()
        local length = 3
        local width = 2
        local totalBlocks = (length * width)
        state.inv["deepslate_bricks"] = { slots = { [1] = totalBlocks}, total = totalBlocks}
        local args = {times = 1, actions = collections.floor(length, width, "deepslate_bricks") }

        actions.collection(state, args, false)
        assert.are_same({x = -1, y = 0}, state.position.directionFaced)
    end)

end)