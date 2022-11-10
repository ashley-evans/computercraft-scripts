package.path = package.path .. ";" .. debug.getinfo(1).short_src:match("(.-)[^\\/]+$") .. "?.lua;"

local turtleUtils = require("turtle-utils")
local turtle = require("turtle-port")

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
    end)
end)
