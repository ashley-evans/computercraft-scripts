---@diagnostic disable: undefined-global
package.path = package.path .. (";" .. arg[0]:match("(.-)[^\\/]+$") .. "?.lua;")

require("luarocks.loader")
require("busted")
local tableUtils = require("table-utils")

describe("helpers", function ()
    it("table Contains works as expected", function ()
        assert.isTrue(tableUtils.tableContains({"test", "foo", "bar"}, "test"))
        assert.isFalse(tableUtils.tableContains({"test", "foo", "bar"}, "baz"))
        assert.isTrue(tableUtils.tableContains({"test", "foo", "bar"}, "bar"))
    end)
end)


