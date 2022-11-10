package.path = package.path .. ";" .. debug.getinfo(1).short_src:match("(.-)[^\\/]+$") .. "?.lua;"

local turtleUtils = require("turtle-utils")
local turtle = require("turtle-port")
local logger = require("logger")

stub(logger, "debug")

describe("default position creation", function()
    it("creates a default position table", function()
        local actual = turtleUtils.createPosition()

        assert.are_equal(0, actual.x)
        assert.are_equal(0, actual.y)
        assert.are_equal(1, actual.directionFaced.x)
        assert.are_equal(0, actual.directionFaced.y)
    end)
end)

describe("movement", function()
    describe("forward movement", function()
        it("moves the turtle forward", function()
            stub(turtle, "forward")
    
            turtleUtils.move(turtleUtils.createPosition(), turtleUtils.DIRECTIONS.FORWARD)
    
            assert.stub(turtle.forward).was_called()
        end)
    
        it("increments X position when forward movement succeeds when facing in starting direction", function()
            stub(turtle, "forward").returns(true)
            local position = turtleUtils.createPosition()
            
            turtleUtils.move(position, turtleUtils.DIRECTIONS.FORWARD)
        
            assert.are_equal(1, position.x)
            assert.are_equal(0, position.y)
        end)

        it("does not change X position when forward movement fails when facing in starting direction", function()
            stub(turtle, "forward").returns(false)
            local position = turtleUtils.createPosition()
            
            turtleUtils.move(position, turtleUtils.DIRECTIONS.FORWARD)
        
            assert.are_equal(0, position.x)
            assert.are_equal(0, position.y)
        end)
    end)

    describe("backward movement", function()
        it("moves the turtle back", function()
            stub(turtle, "back")
    
            turtleUtils.move(turtleUtils.createPosition(), turtleUtils.DIRECTIONS.BACK)
    
            assert.stub(turtle.back).was_called()
        end)
    
        it("decrements X position when back movement succeeds when facing in starting direction", function()
            stub(turtle, "back").returns(true)
            local position = turtleUtils.createPosition()
            
            turtleUtils.move(position, turtleUtils.DIRECTIONS.BACK)
        
            assert.are_equal(-1, position.x)
            assert.are_equal(0, position.y)
        end)

        it("does not change X position when back movement fails when facing in starting direction", function()
            stub(turtle, "back").returns(false)
            local position = turtleUtils.createPosition()
            
            turtleUtils.move(position, turtleUtils.DIRECTIONS.BACK)
        
            assert.are_equal(0, position.x)
            assert.are_equal(0, position.y)
        end)
    end)
end)

describe("turning", function()
    describe("left turns", function()
        it("turns the turtle to the left", function()
            stub(turtle, "turnLeft").returns(true)

            turtleUtils.turn(turtleUtils.createPosition(), turtleUtils.DIRECTIONS.LEFT)

            assert.stub(turtle.turnLeft).was_called()
        end)

        it("updates direction to west when turning left from starting direction", function()
            stub(turtle, "turnLeft").returns(true)
            local position = turtleUtils.createPosition()

            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)

            assert.are_equal(0, position.directionFaced.x)
            assert.are_equal(-1, position.directionFaced.y)
        end)
        
        it("updates direction to south when turning left twice from starting direction", function()
            stub(turtle, "turnLeft").returns(true)
            local position = turtleUtils.createPosition()

            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)

            assert.are_equal(-1, position.directionFaced.x)
            assert.are_equal(0, position.directionFaced.y)
        end)

        it("updates direction to east when turning left thrice from starting direction", function()
            stub(turtle, "turnLeft").returns(true)
            local position = turtleUtils.createPosition()

            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)

            assert.are_equal(0, position.directionFaced.x)
            assert.are_equal(1, position.directionFaced.y)
        end)

        it("updates direction to starting direction when turning left quarce from starting direction", function()
            stub(turtle, "turnLeft").returns(true)
            local position = turtleUtils.createPosition()

            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)

            assert.are_equal(1, position.directionFaced.x)
            assert.are_equal(0, position.directionFaced.y)
        end)

        it("does not update direction if turning left fails", function()
            stub(turtle, "turnLeft").returns(false)
            local position = turtleUtils.createPosition()

            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)

            assert.are_equal(1, position.directionFaced.x)
            assert.are_equal(0, position.directionFaced.y)
        end)
    end)

    describe("right turns", function()
        it("turns the turtle to the right", function()
            stub(turtle, "turnRight").returns(true)

            turtleUtils.turn(turtleUtils.createPosition(), turtleUtils.DIRECTIONS.RIGHT)

            assert.stub(turtle.turnRight).was_called()
        end)

        it("updates direction to east when turning right from starting direction", function()
            stub(turtle, "turnRight").returns(true)
            local position = turtleUtils.createPosition()

            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)

            assert.are_equal(0, position.directionFaced.x)
            assert.are_equal(1, position.directionFaced.y)
        end)
        
        it("updates direction to south when turning right twice from starting direction", function()
            stub(turtle, "turnRight").returns(true)
            local position = turtleUtils.createPosition()

            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)

            assert.are_equal(-1, position.directionFaced.x)
            assert.are_equal(0, position.directionFaced.y)
        end)

        it("updates direction to west when turning right thrice from starting direction", function()
            stub(turtle, "turnRight").returns(true)
            local position = turtleUtils.createPosition()

            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)

            assert.are_equal(0, position.directionFaced.x)
            assert.are_equal(-1, position.directionFaced.y)
        end)

        it("updates direction to starting direction when turning right quarce from starting direction", function()
            stub(turtle, "turnRight").returns(true)
            local position = turtleUtils.createPosition()

            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)

            assert.are_equal(1, position.directionFaced.x)
            assert.are_equal(0, position.directionFaced.y)
        end)

        it("does not update direction if turning right fails", function()
            stub(turtle, "turnRight").returns(false)
            local position = turtleUtils.createPosition()

            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)

            assert.are_equal(1, position.directionFaced.x)
            assert.are_equal(0, position.directionFaced.y)
        end)
    end)
end)


describe("combined movement", function()
    describe("move and turn", function()
        it("ends up in the expected place when moving and turning in squence", function()
            stub(turtle, "turnRight").returns(true)
            stub(turtle, "turnLeft").returns(true)
            stub(turtle, "back").returns(true)
            stub(turtle, "forward").returns(true)
            local position = turtleUtils.createPosition()
            
            assert.are_same({ x = 0, y = 0, directionFaced = { x = 1, y = 0 }}, position)
            turtleUtils.move(position, turtleUtils.DIRECTIONS.FORWARD)
            assert.are_same({ x = 1, y = 0, directionFaced = { x = 1, y = 0 }}, position)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.RIGHT)
            assert.are_same({ x = 1, y = 0, directionFaced = { x = 0, y = 1 }}, position)
            turtleUtils.move(position, turtleUtils.DIRECTIONS.FORWARD)
            assert.are_same({ x = 1, y = 1, directionFaced = { x = 0, y = 1 }}, position)
            turtleUtils.move(position, turtleUtils.DIRECTIONS.BACK)
            assert.are_same({ x = 1, y = 0, directionFaced = { x = 0, y = 1 }}, position)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)
            assert.are_same({ x = 1, y = 0, directionFaced = { x = 1, y = 0 }}, position)
            turtleUtils.move(position, turtleUtils.DIRECTIONS.FORWARD)
            assert.are_same({ x = 2, y = 0, directionFaced = { x = 1, y = 0 }}, position)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)
            assert.are_same({ x = 2, y = 0, directionFaced = { x = 0, y = -1 }}, position)
            turtleUtils.move(position, turtleUtils.DIRECTIONS.FORWARD)
            assert.are_same({ x = 2, y = -1, directionFaced = { x = 0, y = -1 }}, position)
            turtleUtils.turn(position, turtleUtils.DIRECTIONS.LEFT)
            assert.are_same({ x = 2, y = -1, directionFaced = { x = -1, y = 0 }}, position)
            turtleUtils.move(position, turtleUtils.DIRECTIONS.BACK)
            assert.are_same({ x = 3, y = -1, directionFaced = { x = -1, y = 0 }}, position)
        end)
    end)
end)
