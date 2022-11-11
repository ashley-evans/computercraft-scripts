package.path = package.path .. ";" .. debug.getinfo(1).short_src:match("(.-)[^\\/]+$") .. "?.lua;"

local actions = require("actions")

describe("actions", function()
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
end)
