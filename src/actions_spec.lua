package.path = package.path .. ";" .. debug.getinfo(1).short_src:match("(.-)[^\\/]+$") .. "?.lua;"

local actions = require("actions")

describe("doAction", function()
    it("calls action executor when provided a single action", function()
        local action = {
            run = function() end
        }
        stub(action, "run")

        actions.doAction(action)

        assert.stub(action.run).was_called()
    end)

    it("calls action executor with arguments when provided", function()
        local action = {
            run = function(_) end,
            args = {"1"}
        }
        stub(action, "run")

        actions.doAction(action)

        assert.stub(action.run).was_called_with(action.args)
    end)
end)


describe("action collection", function()
    it("throws an error if not provided a table of arguments", function()
        local args = "wibble"

        assert.has_error(
            function() actions.collection(args) end,
            "Arguments must be a table"
        )
    end)

    it("throws an error if the number of times to repeat the collection is not provided", function()
        local args = { times = nil }

        assert.has_error(
            function() actions.collection(args) end,
            "Must provide the number of times to execute collection"
        )
    end)

    it("throws an error if the number of times to repeat the collection is not a number", function()
        local args = { times = "wibble" }

        assert.has_error(
            function() actions.collection(args) end,
            "Number of times provided is not a number"
        )
    end)

    it("throws an error if not provided with actions", function()
        local args = { times = 1 }

        assert.has_error(
            function() actions.collection(args) end,
            "Must provide actions to execute collection"
        )
    end)

    it("throws an error if actions are not of type table", function()
        local args = { times = 1, actions = "wibble"}

        assert.has_error(
            function() actions.collection(args) end,
            "Actions must be a table"
        )
    end)

    it("throws no error if provided with valid inputs", function()
        local args = { times = 1, actions = {}}

        assert.has_no_error(
            function() actions.collection(args) end
        )
    end)

    it("runs each action n times", function()
        
        local args = { times = 2, actions = {{
            run = function() end
        }}}
        stub(args.actions[1], "run")

        actions.collection(args)
        assert.stub(args.actions[1].run).was_called(2)
    end)

    it("calls each action with nil, if no args are provided", function()
        
        local args = { times = 1, actions = {{
            run = function() end
        }}}
        stub(args.actions[1], "run")

        actions.collection(args)
        assert.stub(args.actions[1].run).was_called_with(nil)
    end)

    it("calls each action with args, if args are provided", function()
        
        local args = { times = 1, actions = {{
            run = function() end,
            args = "wibble",
        }}}
        stub(args.actions[1], "run")

        actions.collection(args)
        assert.stub(args.actions[1].run).was_called_with(args.actions[1].args)
    end)
    

    it("when actions are required it keeps calling every action until all required actions have succeeded the specified number of times", function()
        -- this is gross
        -- the run function has scope on variables defined in this test so we can use that to set what the function 
        -- returns on subsequent calls. we can use that fact to verify that function calls that return false don't count
        -- toward the "times" count
        local call = 0
        local returns = {true, false, false, true, false, true}
        local args = { times = 3, actions = {{
                run = function() call = call + 1; return returns[call] end,
                args = "wibble",
                required = true
            },
            {
                run = function() return true end,
                args = "wobble",
                required = true
            },
            {
                run = function()return returns[call] end, -- this is double gross - we don't want to modify 'call' in this function because its already been modified in the first one 
                args = "dibble",
                required = false
            }
        }}
        
        spy.on(args.actions[1], "run")
        spy.on(args.actions[2], "run")
        spy.on(args.actions[3], "run")

        actions.collection(args)
        assert.spy(args.actions[1].run).was_called(6)
        assert.spy(args.actions[2].run).was_called(6)
        assert.spy(args.actions[3].run).was_called(6)
    end)

    it("when actions are not required it ignores their return value and loops the expected number of times", function()
        local call = 0
        local returns = {true, false, false, true, false, true}
        local args = { times = 3, actions = {{
            run = function() call = call + 1; return returns[call] end,
            args = "wibble",
            required = false
        }}}

        spy.on(args.actions[1], "run")

        actions.collection(args)
        assert.spy(args.actions[1].run).was_called_with(args.actions[1].args)
        assert.spy(args.actions[1].run).was_called(3)
    end)


end)
