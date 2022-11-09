package.path = package.path .. ";" .. debug.getinfo(1).short_src:match("(.-)[^\\/]+$") .. "?.lua;"

local tableUtils = require("table-utils")

describe("helpers", function ()
    it("table Contains works as expected", function ()
        assert.is_true(tableUtils.tableContains({"test", "foo", "bar"}, "test"))
        assert.is_false(tableUtils.tableContains({"test", "foo", "bar"}, "baz"))
        assert.is_true(tableUtils.tableContains({"test", "foo", "bar"}, "bar"))
    end)
end)
