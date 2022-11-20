package.path = package.path .. ";" .. debug.getinfo(1).short_src:match("(.-)[^\\/]+$") .. "?.lua;"

local turtleUtils = require("turtle-utils")
local turtle = require("turtle-port")
local logger = require("logger")

stub(logger, "debug")

before_each(function()
    stub(turtle, "getItemDetail")
end)

describe("default state creation |", function()
    it("creates a default state table", function()
        local actual = turtleUtils.createState().position

        assert.are_equal(0, actual.x)
        assert.are_equal(0, actual.y)
        assert.are_equal(1, actual.directionFaced.x)
        assert.are_equal(0, actual.directionFaced.y)
    end)

    it("returns an empty table if no items stored in inventory", function()
        stub(turtle, "getItemDetail").returns(nil)

        local actual = turtleUtils.createState()

        assert.are_same({}, actual.inv)
    end)

    it("returns item details if items stored in inventory", function()
        stub(turtle, "getItemDetail").returns({ name = "dirt", count = 1 })

        local actual = turtleUtils.createState()

        assert.are_same({ dirt = {
            slots = {
                [1] = 1, [2] = 1, [3] = 1, [4] = 1,
                [5] = 1, [6] = 1, [7] = 1, [8] = 1,
                [9] = 1, [10] = 1, [11] = 1, [12] = 1,
                [13] = 1, [14] = 1, [15] = 1, [16] = 1,
            },
            total = 16
        } }, actual.inv)
    end)

    it("strips minecraft suffix from item details", function()
        stub(turtle, "getItemDetail").returns({ name = "minecraft:stone", count = 1 })

        local actual = turtleUtils.createState()

        assert.are_same({ stone = {
            slots = {
                [1] = 1, [2] = 1, [3] = 1, [4] = 1,
                [5] = 1, [6] = 1, [7] = 1, [8] = 1,
                [9] = 1, [10] = 1, [11] = 1, [12] = 1,
                [13] = 1, [14] = 1, [15] = 1, [16] = 1,
            },
            total = 16
        } }, actual.inv)
    end)
end)

describe("forward movement |", function()
    it("moves the turtle forward", function()
        stub(turtle, "forward")

        turtleUtils.move(turtleUtils.createState(), turtleUtils.DIRECTIONS.FORWARD)

        assert.stub(turtle.forward).was_called()
    end)

    it("increments X position when forward movement succeeds when facing in starting direction", function()
        stub(turtle, "forward").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.move(state, turtleUtils.DIRECTIONS.FORWARD)

        assert.are_equal(1, state.position.x)
        assert.are_equal(0, state.position.y)
    end)

    it("does not change X position when forward movement fails when facing in starting direction", function()
        stub(turtle, "forward").returns(false)
        local state = turtleUtils.createState()

        turtleUtils.move(state, turtleUtils.DIRECTIONS.FORWARD)

        assert.are_equal(0, state.position.x)
        assert.are_equal(0, state.position.y)
    end)
end)

describe("backward movement |", function()
    it("moves the turtle back", function()
        stub(turtle, "back")

        turtleUtils.move(turtleUtils.createState(), turtleUtils.DIRECTIONS.BACK)

        assert.stub(turtle.back).was_called()
    end)

    it("decrements X position when back movement succeeds when facing in starting direction", function()
        stub(turtle, "back").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.move(state, turtleUtils.DIRECTIONS.BACK)

        assert.are_equal(-1, state.position.x)
        assert.are_equal(0, state.position.y)
    end)

    it("does not change X position when back movement fails when facing in starting direction", function()
        stub(turtle, "back").returns(false)
        local state = turtleUtils.createState()

        turtleUtils.move(state, turtleUtils.DIRECTIONS.BACK)

        assert.are_equal(0, state.position.x)
        assert.are_equal(0, state.position.y)
    end)
end)

describe("left turns |", function()
    it("turns the turtle to the left", function()
        stub(turtle, "turnLeft").returns(true)

        turtleUtils.turn(turtleUtils.createState(), turtleUtils.DIRECTIONS.LEFT)

        assert.stub(turtle.turnLeft).was_called()
    end)

    it("updates direction to west when turning left from starting direction", function()
        stub(turtle, "turnLeft").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)

        assert.are_equal(0, state.position.directionFaced.x)
        assert.are_equal(-1, state.position.directionFaced.y)
    end)

    it("updates direction to south when turning left twice from starting direction", function()
        stub(turtle, "turnLeft").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)

        assert.are_equal(-1, state.position.directionFaced.x)
        assert.are_equal(0, state.position.directionFaced.y)
    end)

    it("updates direction to east when turning left thrice from starting direction", function()
        stub(turtle, "turnLeft").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)

        assert.are_equal(0, state.position.directionFaced.x)
        assert.are_equal(1, state.position.directionFaced.y)
    end)

    it("updates direction to starting direction when turning left quarce from starting direction", function()
        stub(turtle, "turnLeft").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)

        assert.are_equal(1, state.position.directionFaced.x)
        assert.are_equal(0, state.position.directionFaced.y)
    end)

    it("does not update direction if turning left fails", function()
        stub(turtle, "turnLeft").returns(false)
        local state = turtleUtils.createState()

        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)

        assert.are_equal(1, state.position.directionFaced.x)
        assert.are_equal(0, state.position.directionFaced.y)
    end)
end)

describe("right turns |", function()
    it("turns the turtle to the right", function()
        stub(turtle, "turnRight").returns(true)

        turtleUtils.turn(turtleUtils.createState(), turtleUtils.DIRECTIONS.RIGHT)

        assert.stub(turtle.turnRight).was_called()
    end)

    it("updates direction to east when turning right from starting direction", function()
        stub(turtle, "turnRight").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)

        assert.are_equal(0, state.position.directionFaced.x)
        assert.are_equal(1, state.position.directionFaced.y)
    end)

    it("updates direction to south when turning right twice from starting direction", function()
        stub(turtle, "turnRight").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)

        assert.are_equal(-1, state.position.directionFaced.x)
        assert.are_equal(0, state.position.directionFaced.y)
    end)

    it("updates direction to west when turning right thrice from starting direction", function()
        stub(turtle, "turnRight").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)

        assert.are_equal(0, state.position.directionFaced.x)
        assert.are_equal(-1, state.position.directionFaced.y)
    end)

    it("updates direction to starting direction when turning right quarce from starting direction", function()
        stub(turtle, "turnRight").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)

        assert.are_equal(1, state.position.directionFaced.x)
        assert.are_equal(0, state.position.directionFaced.y)
    end)

    it("does not update direction if turning right fails", function()
        stub(turtle, "turnRight").returns(false)
        local state = turtleUtils.createState()

        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)

        assert.are_equal(1, state.position.directionFaced.x)
        assert.are_equal(0, state.position.directionFaced.y)
    end)
end)

describe("complex movement |", function()
    it("turtle ends up in the expected place when moving and turning in squence", function()
        stub(turtle, "turnRight").returns(true)
        stub(turtle, "turnLeft").returns(true)
        stub(turtle, "back").returns(true)
        stub(turtle, "forward").returns(true)
        local state = turtleUtils.createState()

        turtleUtils.move(state, turtleUtils.DIRECTIONS.FORWARD)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.RIGHT)
        turtleUtils.move(state, turtleUtils.DIRECTIONS.FORWARD)
        turtleUtils.move(state, turtleUtils.DIRECTIONS.BACK)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)
        turtleUtils.move(state, turtleUtils.DIRECTIONS.FORWARD)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)
        turtleUtils.move(state, turtleUtils.DIRECTIONS.FORWARD)
        turtleUtils.turn(state, turtleUtils.DIRECTIONS.LEFT)
        turtleUtils.move(state, turtleUtils.DIRECTIONS.BACK)

        assert.are_same({
            x = 3, y = -1,
            directionFaced = { x = -1, y = 0 },
            moveHistory={
                {x=0, y=0},
                {x=1, y=0},
                {x=1, y=1},
                {x=1, y=0},
                {x=2, y=0},
                {x=2, y=-1},
                {x=3, y=-1}
            }}, state.position)
    end)
end)

describe("digIfSafe |", function()
    it("digs forward", function()
        stub(turtle, "inspect").returns(true, {name = "someblock"})
        stub(turtle, "dig").returns(true)
        local succeeded = turtleUtils.digIfSafe(turtleUtils.DIRECTIONS.FORWARD, {})
        assert.stub(turtle.dig).was_called()
        assert(succeeded)
    end)

    it("digs up", function()
        stub(turtle, "inspectUp").returns(true, {name = "someblock"})
        stub(turtle, "digUp").returns(true)
        local succeeded = turtleUtils.digIfSafe(turtleUtils.DIRECTIONS.UP, {})
        assert.stub(turtle.digUp).was_called()
        assert(succeeded)
    end)

    it("digs down", function()
        stub(turtle, "inspectDown").returns(true, {name = "someblock"})
        stub(turtle, "digDown").returns(true)
        local succeeded = turtleUtils.digIfSafe(turtleUtils.DIRECTIONS.DOWN, {})
        assert.stub(turtle.digDown).was_called()
        assert(succeeded)
    end)

    it("returns false if it is not safe to dig forward", function()
        stub(turtle, "inspect").returns(true, {name = "someblock"})
        stub(turtle, "dig").returns(true)
        local succeeded = turtleUtils.digIfSafe(turtleUtils.DIRECTIONS.FORWARD, {"someblock"})
        assert.stub(turtle.dig).was_not_called()
        assert(not succeeded)
    end)

    it("returns false if it is not safe to dig up", function()
        stub(turtle, "inspectUp").returns(true, {name = "someblock"})
        stub(turtle, "digUp").returns(true)
        local succeeded = turtleUtils.digIfSafe(turtleUtils.DIRECTIONS.UP, {"someblock"})
        assert.stub(turtle.digUp).was_not_called()
        assert(not succeeded)
    end)

    it("returns false if it is not safe to dig down", function()
        stub(turtle, "inspectDown").returns(true, {name = "someblock"})
        stub(turtle, "digDown").returns(true)
        local succeeded = turtleUtils.digIfSafe(turtleUtils.DIRECTIONS.DOWN, {"someblock"})
        assert.stub(turtle.digDown).was_not_called()
        assert(not succeeded)
    end)
end)

describe("place block |", function()
    it("places given block in front of turtle", function()
        local expectedBlock = "dirt"
        stub(turtle, "select")
        stub(turtle, "place")
        stub(turtle, "getItemDetail").returns({ name = expectedBlock, count = 5})
        local state = turtleUtils.createState()

        turtleUtils.placeBlock(state, turtleUtils.DIRECTIONS.FORWARD, expectedBlock)

        assert.stub(turtle.place).was_called()
        assert.are_equal(4, state.inv[expectedBlock].slots[1])
    end)

    it("places given block above the turtle", function()
        local expectedBlock = "dirt"
        stub(turtle, "select")
        stub(turtle, "placeUp")
        stub(turtle, "getItemDetail").returns({ name = expectedBlock, count = 5})
        local state = turtleUtils.createState()

        turtleUtils.placeBlock(state, turtleUtils.DIRECTIONS.UP, expectedBlock)

        assert.stub(turtle.placeUp).was_called()
        assert.are_equal(4, state.inv[expectedBlock].slots[1])
    end)

    it("places given block below the turtle", function()
        local expectedBlock = "dirt"
        stub(turtle, "select")
        stub(turtle, "placeDown")
        stub(turtle, "getItemDetail").returns({ name = expectedBlock, count = 5})
        local state = turtleUtils.createState()

        turtleUtils.placeBlock(state, turtleUtils.DIRECTIONS.DOWN, expectedBlock)

        assert.stub(turtle.placeDown).was_called()
        assert.are_equal(4, state.inv[expectedBlock].slots[1])
    end)

    it("decrements the inv and removes the slot if empty", function()
        local expectedBlock = "dirt"
        stub(turtle, "select")
        stub(turtle, "placeDown")
        stub(turtle, "getItemDetail").returns({ name = expectedBlock, count = 1})
        local state = turtleUtils.createState()

        turtleUtils.placeBlock(state, turtleUtils.DIRECTIONS.DOWN, expectedBlock)

        assert.are_equal(nil, state.inv[expectedBlock].slots[1])
        assert.equal(15, state.inv[expectedBlock].total)
    end)

    it("removes the item if all slots are empty", function()
        local expectedBlock = "dirt"
        stub(turtle, "select")
        stub(turtle, "placeDown")
        stub(turtle, "getItemDetail").returns({ name = expectedBlock, count = 1})
        local state = turtleUtils.createState()

        for _ = 1, 16 do
            turtleUtils.placeBlock(state, turtleUtils.DIRECTIONS.DOWN, expectedBlock)
        end

        assert.are_equal(nil, state.inv[expectedBlock])
    end)
end)
